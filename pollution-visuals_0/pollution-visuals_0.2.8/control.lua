local MOD_NAME = "pollution-visuals"
local CHUNK_SIZE = 32
local FADE_STEP = 0.01
local MAX_FADE_UPDATES_PER_TICK = 1000

local NEIGHBORS = {
    { dx = 0, dy = -1 },
    { dx = 1, dy = 0 },
    { dx = 0, dy = 1 },
    { dx = -1, dy = 0 },
    { dx = 1, dy = -1 },
    { dx = 1, dy = 1 },
    { dx = -1, dy = 1 },
    { dx = -1, dy = -1 },
}

local function key_for(surface_index, x, y)
    return surface_index .. ":" .. x .. ":" .. y
end

local function chunk_origin(x, y)
    return { x * CHUNK_SIZE, y * CHUNK_SIZE }
end

local function chunk_center(x, y)
    return { x * CHUNK_SIZE + 16, y * CHUNK_SIZE + 16 }
end

local function ensure_state()
    if storage.all_chunks == nil then storage.all_chunks = {} end
    if storage.polluted_chunks == nil then storage.polluted_chunks = {} end
    if storage.sprites_fading_in == nil then storage.sprites_fading_in = {} end
    if storage.sprites_fading_out == nil then storage.sprites_fading_out = {} end
    if storage.is_setup == nil then storage.is_setup = false end
    if storage.is_checking == nil then storage.is_checking = false end
    if storage.is_fading == nil then storage.is_fading = false end
end

local function get_setting(name)
    return settings.global[name].value
end

local function get_players_to_render_for()
    local result = {}
    for _, player in pairs(game.players) do
        if player.mod_settings["show-pollution-visuals"].value then
            result[#result + 1] = player
        end
    end
    return result
end

local function set_is_setup()
    ensure_state()
    storage.is_setup = false
end

local function register_chunk(surface_index, x, y)
    storage.all_chunks[key_for(surface_index, x, y)] = {
        position = { x = x, y = y },
        surface = surface_index,
    }
end

local function ensure_polluted_chunk(surface_index, x, y)
    local key = key_for(surface_index, x, y)
    if storage.all_chunks[key] == nil then return end
    if storage.polluted_chunks[key] == nil then
        storage.polluted_chunks[key] = {
            position = { x = x, y = y },
            surface = surface_index,
            r_id = {},
        }
    end
end

local function sample_pollution(surface, x, y)
    return surface.get_pollution(chunk_origin(x, y))
end

local function mark_chunk_and_border(surface_index, x, y)
    local surface = game.surfaces[surface_index]
    if not surface then return end

    if sample_pollution(surface, x, y) <= 0 then return end

    ensure_polluted_chunk(surface_index, x, y)
    for _, n in pairs(NEIGHBORS) do
        local nx = x + n.dx
        local ny = y + n.dy
        if sample_pollution(surface, nx, ny) == 0 then
            ensure_polluted_chunk(surface_index, nx, ny)
        end
    end
end

local function setup()
    ensure_state()
    rendering.clear(MOD_NAME)

    storage.polluted_chunks = {}
    storage.polluted_chunks_i = nil
    storage.all_chunks = {}
    storage.all_chunks_i = nil

    storage.sprites_fading_in = {}
    storage.sprites_fading_in_i = nil
    storage.sprites_fading_out = {}
    storage.sprites_fading_out_i = nil

    storage.is_checking = false
    storage.is_fading = false
    storage.is_setup = true

    for _, surface in pairs(game.surfaces) do
        for chunk in surface.get_chunks() do
            register_chunk(surface.index, chunk.x, chunk.y)
            mark_chunk_and_border(surface.index, chunk.x, chunk.y)
        end
    end
end

local function check_all_chunks()
    local chunks_per_tick = get_setting("chunks-per-tick-pollution-visuals")

    for _ = 1, chunks_per_tick do
        local index, chunk_data = next(storage.all_chunks, storage.all_chunks_i)
        if index == nil then
            storage.all_chunks_i = nil
            storage.is_checking = false
            break
        end

        storage.all_chunks_i = index
        mark_chunk_and_border(chunk_data.surface, chunk_data.position.x, chunk_data.position.y)
    end
end

local function compute_sprite(surface, x, y, level, chunk_pollution)
    if chunk_pollution > level then return "smog_middle" end

    local n = sample_pollution(surface, x, y - 1) > level
    local e = sample_pollution(surface, x + 1, y) > level
    local s = sample_pollution(surface, x, y + 1) > level
    local w = sample_pollution(surface, x - 1, y) > level
    local ne = sample_pollution(surface, x + 1, y - 1) > level
    local se = sample_pollution(surface, x + 1, y + 1) > level
    local sw = sample_pollution(surface, x - 1, y + 1) > level
    local nw = sample_pollution(surface, x - 1, y - 1) > level

    if (n and s) or (w and e) then return "smog_middle" end
    if s and not w and not e then return "smog_top" end
    if n and not w and not e then return "smog_bottom" end
    if (w or (nw and sw)) and (not n and not s and not ne and not se) then return "smog_left" end
    if (e or (ne and se)) and (not n and not s and not nw and not sw) then return "smog_right" end

    if sw and not n and not ne and not e and not se and not s and not w and not nw then return "smog_corner_left_top" end
    if se and not n and not ne and not e and not sw and not s and not w and not nw then return "smog_corner_right_top" end
    if nw and not n and not ne and not e and not sw and not s and not w and not se then return "smog_corner_left_bottom" end
    if ne and not e and not se and not s and not sw and not w and not nw and not n then return "smog_corner_right_bottom" end

    if s and e and not w and not n and not nw then return "smog_corner_inv_left_top" end
    if s and w and not e and not n and not ne then return "smog_corner_inv_right_top" end
    if n and e and not w and not s and not sw then return "smog_corner_inv_left_bottom" end
    if n and w and not e and not s and not se then return "smog_corner_inv_right_bottom" end

    return nil
end

local function has_neighbor_pollution(surface, x, y)
    for _, n in pairs(NEIGHBORS) do
        if sample_pollution(surface, x + n.dx, y + n.dy) > 0 then return true end
    end
    return false
end

local function fade_in_entry(id, x, y)
    storage.sprites_fading_in[id] = { tint = { r = 0, g = 0, b = 0, a = 0 }, position = { x = x, y = y } }
end

local function fade_out_entry(id, x, y)
    storage.sprites_fading_out[id] = { tint = { r = 1, g = 1, b = 1, a = 1 }, position = { x = x, y = y } }
end

local function get_render_object(id)
    if id == nil then return nil end
    local object = rendering.get_object_by_id(id)
    if object and object.valid then return object end
    return nil
end

local function create_sprite(surface, sprite_name, x, y, players)
    local object = rendering.draw_sprite {
        sprite = sprite_name,
        surface = surface,
        target = chunk_center(x, y),
        y_scale = 2,
        x_scale = 2,
        tint = { r = 0, g = 0, b = 0, a = 0 },
        players = players,
        visible = (#players > 0),
    }

    return object.id
end

local function check_polluted_chunk(chunk_data)
    local surface = game.surfaces[chunk_data.surface]
    if not surface then return end

    local x = chunk_data.position.x
    local y = chunk_data.position.y
    local chunk_pollution = sample_pollution(surface, x, y)
    local max_layers = get_setting("layers-pollution-visuals")
    local offset = get_setting("x-offset-pollution-visuals")
    local a = get_setting("y-intercept-pollution-visuals")
    local b = get_setting("base-pollution-visuals")
    local players = get_players_to_render_for()
    local r_id = chunk_data.r_id

    for i = 1, max_layers do
        local level = a * (b ^ i) + offset
        local next_sprite = compute_sprite(surface, x, y, level, chunk_pollution)

        local current_id = r_id[i]
        local current_sprite = nil
        local current_object = get_render_object(current_id)
        if current_object ~= nil then
            current_sprite = current_object.sprite
        else
            r_id[i] = nil
            current_id = nil
        end

        if current_id ~= nil then
            if next_sprite == nil then
                fade_out_entry(current_id, x, y)
                r_id[i] = nil
            elseif next_sprite ~= current_sprite then
                fade_out_entry(current_id, x, y)
                local new_id = create_sprite(surface, next_sprite, x, y, players)
                r_id[i] = new_id
                fade_in_entry(new_id, x, y)
            end
        elseif next_sprite ~= nil then
            local new_id = create_sprite(surface, next_sprite, x, y, players)
            r_id[i] = new_id
            fade_in_entry(new_id, x, y)
        end
    end

    if chunk_pollution <= 0 and not has_neighbor_pollution(surface, x, y) and next(r_id) == nil then
        storage.polluted_chunks[key_for(chunk_data.surface, x, y)] = nil
    end
end

local function check_polluted_chunks()
    local chunks_per_tick = get_setting("chunks-per-tick-pollution-visuals")

    for _ = 1, chunks_per_tick do
        local index, chunk_data = next(storage.polluted_chunks, storage.polluted_chunks_i)
        if index == nil then
            storage.polluted_chunks_i = nil
            storage.is_fading = true
            break
        end

        storage.polluted_chunks_i = index
        check_polluted_chunk(chunk_data)
    end
end

local function fade_map_entry(fade_map, iterator_key, delta, destroy_when_done)
    local id, value = next(fade_map, iterator_key)
    if id == nil then return nil, false end

    local render_object = get_render_object(id)
    if render_object == nil then
        fade_map[id] = nil
        return id, true
    end

    local tint = value.tint
    local next_a = math.max(0, math.min(1, tint.a + delta))
    local next_tint = { r = next_a, g = next_a, b = next_a, a = next_a }
    render_object.color = next_tint

    if (delta > 0 and next_a >= 1) or (delta < 0 and next_a <= 0) then
        fade_map[id] = nil
        if destroy_when_done then render_object.destroy() end
    else
        value.tint = next_tint
    end

    return id, true
end

local function fade()
    local any_in = true
    local any_out = true

    for _ = 1, MAX_FADE_UPDATES_PER_TICK do
        if any_in then
            local id, had = fade_map_entry(storage.sprites_fading_in, storage.sprites_fading_in_i, FADE_STEP, false)
            storage.sprites_fading_in_i = id
            any_in = had
        end

        if any_out then
            local id, had = fade_map_entry(storage.sprites_fading_out, storage.sprites_fading_out_i, -FADE_STEP, true)
            storage.sprites_fading_out_i = id
            any_out = had
        end

        if not any_in and not any_out then break end
    end

    if next(storage.sprites_fading_in, storage.sprites_fading_in_i) == nil then storage.sprites_fading_in_i = nil end
    if next(storage.sprites_fading_out, storage.sprites_fading_out_i) == nil then storage.sprites_fading_out_i = nil end

    if next(storage.sprites_fading_in) == nil and next(storage.sprites_fading_out) == nil then
        storage.is_fading = false
        storage.is_checking = true
    end
end

local function add_generated_chunk(event)
    ensure_state()
    if storage.is_setup == false then
        setup()
        return
    end

    local surface_index = event.surface.index
    local x = event.position.x
    local y = event.position.y
    register_chunk(surface_index, x, y)
    mark_chunk_and_border(surface_index, x, y)
end

local function remove_chunks(data)
    ensure_state()

    for _, position in pairs(data.positions) do
        local x = position.x
        local y = position.y
        local key = key_for(data.surface_index, x, y)
        local chunk_data = storage.polluted_chunks[key]

        if chunk_data and chunk_data.r_id then
            for _, id in pairs(chunk_data.r_id) do
                storage.sprites_fading_in[id] = nil
                storage.sprites_fading_out[id] = nil
                local render_object = get_render_object(id)
                if render_object then render_object.destroy() end
            end
        end

        storage.all_chunks[key] = nil
        storage.polluted_chunks[key] = nil
    end
end

local function setting_changed(event)
    ensure_state()

    if event.setting ~= "show-pollution-visuals" then
        set_is_setup()
        return
    end

    local players = get_players_to_render_for()
    for _, chunk_data in pairs(storage.polluted_chunks) do
        for layer, id in pairs(chunk_data.r_id) do
            local render_object = get_render_object(id)
            if render_object then
                if #players == 0 then
                    render_object.visible = false
                else
                    render_object.visible = true
                    render_object.players = players
                end
            else
                chunk_data.r_id[layer] = nil
            end
        end
    end
end

local function on_tick()
    ensure_state()

    if storage.is_setup == false then
        setup()
    elseif (not storage.is_checking) and (not storage.is_fading) then
        check_polluted_chunks()
    elseif storage.is_checking then
        check_all_chunks()
    elseif storage.is_fading then
        fade()
    end
end

local function remove_surface(event)
    ensure_state()

    local positions = {}
    for _, chunk_data in pairs(storage.all_chunks) do
        if chunk_data.surface == event.surface_index then
            positions[#positions + 1] = chunk_data.position
        end
    end

    if #positions > 0 then
        remove_chunks { positions = positions, surface_index = event.surface_index }
    end
end

script.on_event(defines.events.on_chunk_deleted, remove_chunks)
script.on_event(defines.events.on_chunk_generated, add_generated_chunk)
script.on_event(defines.events.on_tick, on_tick)
script.on_event(defines.events.on_runtime_mod_setting_changed, setting_changed)
script.on_event(defines.events.on_surface_deleted, remove_surface)
script.on_configuration_changed(set_is_setup)
script.on_init(set_is_setup)
