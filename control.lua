-------------------------------------------------------------------------
-- TO DO
-------------------------------------------------------------------------

-- MAKE AMOUNT OF CHUNKS PER TICK CONFIGURABLE
-- OPTIMISE FADING IN/OUT OF ANIMATIONS
-- MAKE IT SO YOU CAN TURN THE VISUALS OFF/ON INGAME
-- MAKE IT POSSIBLE TO HAVE POLLUTION ON OTHER SURFACES

-------------------------------------------------------------------------
-- MAIN FUNCTIONS
-------------------------------------------------------------------------

-- function that triggers every tick
function on_tick()
    if global.is_setup == false then
        --log("setup")
        setup()
    elseif not(global.is_checking) and not(global.is_fading) then
        --log("check polluted chunks")
        check_polluted_chunks()
    elseif global.is_checking then
        --log("check all chunks")
        check_all_chunks()
    elseif global.is_fading then
        --log("fade animations")
        fade()
    end
end

-- sets up all the variables and populates them with initial values
function setup()
    -- clearing all visuals juist incase there are some left from a previous version
    rendering.clear("pollution-visuals")

    -- defining the overworld. i will probably have to loop through all the surfaces. for right now this is fine
    local surface=game.surfaces[1]

    -- defining chunk tables
    global.polluted_chunks = {}
    global.polluted_chunks_i = nil
    global.all_chunks = {}
    global.all_chunks_i = nil

    -- defining fading animation tables
    global.animations_fading_in = {}
    global.animations_fading_in_i = nil
    global.animations_fading_out = {}
    global.animations_fading_out_i = nil

    --bool for if we need to check all_chunks or just polluted_chunks
    global.is_checking = false

    --bool for if we need to start fading the animations
    global.is_fading = false
    
    -- bool for checking if the game is setup or not
    global.is_setup = true

    --looping through all the chunks on surface
    for chunk in surface.get_chunks() do
        local x = chunk.area.left_top.x
        local y = chunk.area.left_top.y

        -- inserting chunk in all_chunks
        global.all_chunks[x.." "..y] = {position = {x=x,y=y}, r_id={}, surface=surface.index}

        -- inserting chunk in polluted_chunks 
        local chunk_pollution_level = surface.get_pollution(chunk.area.left_top)
        if chunk_pollution_level > 0 then 
            local N = {x, y-32}
            local E = {x+32, y}
            local S = {x, y+32}
            local W = {x-32, y}
            local NE = {x+32,y-32}
            local SE = {x+32, y+32}
            local SW = {x-32, y+32}
            local NW = {x-32, y-32}

            -- if a neighboring chunk has 0 pollution add it to the polluted_chunk table anyway.
            global.polluted_chunks[x.." "..y] = {position = {x=x,y=y}, r_id={}, surface=surface.index}
            if surface.get_pollution(N) == 0 then 
                global.polluted_chunks[x.." "..(y-32)] = {position = {x=x, y=y-32}, r_id={}, surface=surface.index} 
            end
            if surface.get_pollution(E) == 0 then 
                global.polluted_chunks[(x+32).." "..y] = {position = {x=x+32, y=y}, r_id={}, surface=surface.index} 
            end
            if surface.get_pollution(S) == 0 then 
                global.polluted_chunks[x.." "..(y+32)] = {position = {x=x, y=y+32}, r_id={}, surface=surface.index} 
            end
            if surface.get_pollution(W) == 0 then 
                global.polluted_chunks[(x-32).." "..y] = {position = {x=x-32, y=y}, r_id={}, surface=surface.index} 
            end
            if surface.get_pollution(NE) == 0 then 
                global.polluted_chunks[(x+32).." "..(y-32)] = {position = {x=x+32,y=y-32}, r_id={}, surface=surface.index} 
            end
            if surface.get_pollution(SE) == 0 then 
                global.polluted_chunks[(x+32).." "..(y+32)] = {position = {x=x+32, y=y+32}, r_id={}, surface=surface.index} 
            end
            if surface.get_pollution(SW) == 0 then 
                global.polluted_chunks[(x-32).." "..(y+32)] = {position = {x=x-32, y=y+32}, r_id={}, surface=surface.index} 
            end
            if surface.get_pollution(NW) == 0 then 
                global.polluted_chunks[(x-32).." "..(y-32)] = {position = {x=x-32, y=y-32}, r_id={}, surface=surface.index} 
            end
        end
    end
end



-- will check if chunks are polluted and put them in polluted_chunks if they are
function check_all_chunks()
    for i = 1, 20 do
        local index ,chunk_data = next(global.all_chunks, global.all_chunks_i)
        if index == nil then global.all_chunks_i = nil global.is_checking = false break 
        else global.all_chunks_i = index end

        local surface = game.surfaces[chunk_data.surface]
        local x = chunk_data.position.x
        local y = chunk_data.position.y
        local r_id = chunk_data.r_id
        local chunk_pollution_level = surface.get_pollution({x,y})

        
        --inserting chunk into polluted_chunks
        if chunk_pollution_level > 0 then
            local N = {x, y-32}
            local E = {x+32, y}
            local S = {x, y+32}
            local W = {x-32, y}
            local NE = {x+32,y-32}
            local SE = {x+32, y+32}
            local SW = {x-32, y+32}
            local NW = {x-32, y-32}

            --adding chunk or neighboring chunks to the polluted_chunks table
            if global.polluted_chunks[x.." "..y] == nil then
                global.polluted_chunks[x.." "..y] = {position = {x=x,y=y}, r_id=r_id, surface=surface.index} end
            if surface.get_pollution(N) == 0 and global.polluted_chunks[x.." "..(y-32)] == nil and global.all_chunks[x.." "..(y-32)] ~= nil then
                global.polluted_chunks[x.." "..(y-32)] = {position = {x=x, y=y-32}, r_id=global.all_chunks[x.." "..(y-32)].r_id, surface=surface.index} end
            if surface.get_pollution(E) == 0 and global.polluted_chunks[(x+32).." "..y] == nil and global.all_chunks[(x+32).." "..y] ~= nil then
                global.polluted_chunks[(x+32).." "..y] = {position = {x=x+32, y=y}, r_id=global.all_chunks[(x+32).." "..y].r_id, surface=surface.index} end
            if surface.get_pollution(S) == 0 and global.polluted_chunks[x.." "..(y+32)] == nil and global.all_chunks[x.." "..(y+32)] ~= nil then
                global.polluted_chunks[x.." "..(y+32)] = {position = {x=x, y=y+32}, r_id=global.all_chunks[x.." "..(y+32)].r_id, surface=surface.index} end
            if surface.get_pollution(W) == 0 and global.polluted_chunks[(x-32).." "..y] == nil and global.all_chunks[(x-32).." "..y] ~= nil then
                global.polluted_chunks[(x-32).." "..y] = {position = {x=x-32, y=y}, r_id=global.all_chunks[(x-32).." "..y].r_id, surface=surface.index} end
            if surface.get_pollution(NE) == 0 and global.polluted_chunks[(x+32).." "..(y-32)] == nil and global.all_chunks[(x+32).." "..(y-32)] ~= nil then
                global.polluted_chunks[(x+32).." "..(y-32)] = {position = {x=x+32,y=y-32}, r_id=global.all_chunks[(x+32).." "..(y-32)].r_id, surface=surface.index} end
            if surface.get_pollution(SE) == 0 and global.polluted_chunks[(x+32).." "..(y+32)] == nil and global.all_chunks[(x+32).." "..(y+32)] ~= nil then
                global.polluted_chunks[(x+32).." "..(y+32)] = {position = {x=x+32, y=y+32}, r_id=global.all_chunks[(x+32).." "..(y+32)].r_id, surface=surface.index} end
            if surface.get_pollution(SW) == 0 and global.polluted_chunks[(x-32).." "..(y+32)] == nil and global.all_chunks[(x-32).." "..(y+32)] ~= nil then
                global.polluted_chunks[(x-32).." "..(y+32)] = {position = {x=x-32, y=y+32}, r_id=global.all_chunks[(x-32).." "..(y+32)].r_id, surface=surface.index} end
            if surface.get_pollution(NW) == 0 and global.polluted_chunks[(x-32).." "..(y-32)] == nil and global.all_chunks[(x-32).." "..(y-32)] ~= nil then
                global.polluted_chunks[(x-32).." "..(y-32)] = {position = {x=x-32, y=y-32}, r_id=global.all_chunks[(x-32).." "..(y-32)].r_id, surface=surface.index} end
        end
    end
end

-- will check every polluted chunk and draw visuals
function check_polluted_chunks()
    for i = 1, 20 do 
        local index ,chunk_data = next(global.polluted_chunks, global.polluted_chunks_i)
        if index == nil then global.polluted_chunks_i = nil global.is_fading = true break
        else global.polluted_chunks_i = index end
        check_polluted_chunk(chunk_data)
    end
end

-- draws an animation for a specified chunk
function check_polluted_chunk(chunk_data)
    --defining variables that i will need
    local surface = game.surfaces[chunk_data.surface]
    local x = chunk_data.position.x
    local y = chunk_data.position.y
    local chunk_pollution_level = surface.get_pollution({x,y})
    local anim_target = {x+16, y+16}
    local remove_chunk = false
    local density_levels = {50,100,150}
    local players = get_players_to_render_for()

    for i ,level in pairs(density_levels) do
        -- more variables that will be needed
        local r_id = chunk_data.r_id
        local current_anim = ""
        local next_anim = ""

        -- setting the current animation
        if r_id[i] ~= nil then current_anim = rendering.get_animation(r_id[i]) end

        -- setting the next animation
        if chunk_pollution_level > level then
            next_anim = "smog_middle"
        else
            -- variables of neighboring chunks
            local N = surface.get_pollution({x, y-32})
            local E = surface.get_pollution({x+32, y})
            local S = surface.get_pollution({x, y+32})
            local W = surface.get_pollution({x-32, y})
            local NE = surface.get_pollution({x+32, y-32})
            local SE = surface.get_pollution({x+32, y+32})
            local SW = surface.get_pollution({x-32, y+32})
            local NW = surface.get_pollution({x-32, y-32})

            --selecting the right animation depending on neighboring chunks pollution values
            if (N > level and S > level) or (W > level and E > level) then next_anim="smog_middle"
            elseif S > level and W <= level and E <= level then next_anim="smog_top"
            elseif N > level and W <= level and E <= level then next_anim="smog_bottom"
            elseif (W > level or (NW > level and SW > level)) and (N <= level and S <= level and NE <= level and SE <= level) then next_anim="smog_left"
            elseif (E > level or (NE > level and SE > level)) and (N <= level and S <= level and NW <= level and SW <= level) then next_anim="smog_right"
            elseif SW > level and N <= level and NE <= level and E <= level and SE <= level and S <= level and W <= level and NW <= level then next_anim="smog_corner_left_top"
            elseif SE > level and N <= level and NE <= level and E <= level and SW <= level and S <= level and W <= level and NW <= level then next_anim="smog_corner_right_top"
            elseif NW > level and N <= level and NE <= level and E <= level and SW <= level and S <= level and W <= level and SE <= level then next_anim="smog_corner_left_bottom"
            elseif NE > level and E <= level and SE <= level and S <= level and SW <= level and W <= level and NW <= level and N <= level then next_anim="smog_corner_right_bottom"
            elseif S > level and E > level and W <= level and N <= level and NW <= level then next_anim="smog_corner_inv_left_top"
            elseif S > level and W > level and E <= level and N <= level and NE <= level then next_anim="smog_corner_inv_right_top"
            elseif N > level and E > level and W <= level and S <= level and SW <= level then next_anim="smog_corner_inv_left_bottom"
            elseif N > level and W > level and E <= level and S <= level and SE <= level then next_anim="smog_corner_inv_right_bottom"
            elseif N == 0 and E == 0 and S == 0 and W == 0 and NE == 0 and NW == 0 and SE == 0 and SW == 0 and chunk_pollution_level == 0 then
                remove_chunk = true
            end
        end

        -- marking animations for fade in/out
        if r_id[i] ~= nil then
            if next_anim == "" then
                --mark for fade out
                global.animations_fading_out[r_id[i]] = {tint = {r=1, g=1, b=1, a=1}, position={x=x,y=y}}
                r_id[i] = nil
            elseif next_anim ~= current_anim then
                --mark for fade out
                global.animations_fading_out[r_id[i]] = {tint = {r=1, g=1, b=1, a=1}, position={x=x,y=y}}
                --mark for fade in 
                r_id[i] = rendering.draw_animation{animation=next_anim, surface=surface,target=anim_target, y_scale=2, x_scale=2, tint={r=0, g=0, b=0, a=0}, players=players}
                if #players == 0 then 
                    rendering.set_visible(r_id[i], false)
                end
                global.animations_fading_in[r_id[i]] = {tint = {r=0, g=0, b=0, a=0}, position={x=x,y=y}}
            end
        elseif next_anim ~= "" then
            --mark for fade in
            r_id[i] = rendering.draw_animation{animation=next_anim, surface=surface,target=anim_target, y_scale=2, x_scale=2, tint={r=0, g=0,b=0, a=0}, players=players}
            if #players == 0 then rendering.set_visible(r_id[i], false) end
            global.animations_fading_in[r_id[i]] = {tint = {r=0, g=0, b=0, a=0}, position={x=x,y=y}}
        end

        --update global tables with new values
        global.all_chunks[x.." "..y].r_id[i] = r_id[i]
        global.polluted_chunks[x.." "..y].r_id[i] = r_id[i]
    end

    -- delete chunk from polluted_chunks
    if remove_chunk then global.polluted_chunks[x.." "..y] = nil end
end

-- fade in/out animations
function fade()
    local is_fading_in = true
    local is_fading_out = true

    while is_fading_in or is_fading_out do
        --fading in
        if is_fading_in and next(global.animations_fading_in, global.animations_fading_in_i) ~= nil then
            local r_id, value = next(global.animations_fading_in, global.animations_fading_in_i)
            local r = value.tint.r + 0.01
            local g = value.tint.g + 0.01
            local b = value.tint.b + 0.01
            local a = value.tint.a + 0.01

            local x = value.position.x
            local y = value.position.y
            
            if a >= 1 then
                rendering.set_color(r_id, {r=1, g=1,b=1, a=1})
                global.animations_fading_in[r_id] = nil
            else
                rendering.set_color(r_id, {r=b, g=g,b=b, a=a})
                global.animations_fading_in[r_id].tint = {r=b, g=g,b=b, a=a}
            end
            global.animations_fading_in_i = r_id
        else
            is_fading_in = false
        end
        
        --fading out
        if is_fading_out and next(global.animations_fading_out, global.animations_fading_out_i) ~= nil then
            local r_id, value = next(global.animations_fading_out, global.animations_fading_out_i)
            
            local r = value.tint.r - 0.01
            local g = value.tint.g - 0.01
            local b = value.tint.b - 0.01
            local a = value.tint.a - 0.01

            local x = value.position.x
            local y = value.position.y

            if a <= 0 then
                rendering.set_color(r_id, {r=0, g=0,b=0, a=0})
                global.animations_fading_out[r_id] = nil
                rendering.destroy(r_id)
            else
                rendering.set_color(r_id, {r=b, g=g,b=b, a=a})
                global.animations_fading_out[r_id].tint = {r=b, g=g,b=b, a=a}
            end
            global.animations_fading_out_i = r_id
        else
            is_fading_out = false
        end
    end

    global.animations_fading_in_i = nil
    global.animations_fading_out_i = nil

    if next(global.animations_fading_in, nil) == nil and next(global.animations_fading_out, nil) == nil then
        global.is_fading = false
        global.is_checking = true
    end
end

-- adds chunk to all_chunks
function add_chunk(chunk)
    local x = chunk.area.left_top.x
    local y = chunk.area.left_top.y
    local surface = chunk.surface

    global.all_chunks[x.." "..y] = {position = {x=x,y=y}, r_id={}, surface=surface.index}

end

--deletes chunk from all_chunks and polluted_chunks
function delete_chunk(chunk)
    local x = chunk.area.left_top.x
    local y = chunk.area.left_top.y
    local chunk_data = global.all_chunks[x.." "..y]
    local r_id = chunk_data.r_id

    if r_id ~= {} then
        for i ,v in pairs(r_id) do
            global.animations_fading_in[r_id[i]] = nil
            global.animations_fading_out[r_id[i]] = nil
            rendering.destroy(r_id[i])
        end
    end
    global.all_chunks[x.." "..y] = nil
    global.polluted_chunks[x.." "..y] = nil
end

-- wil set is_setup to false
function set_is_setup()
    global.is_setup = false
end

-- returns a table with all the players that have the "show-pollution-visuals" option on
function get_players_to_render_for()
	local result = {}

	for i, player in pairs(game.players) do
		local show_pollution_visuals = player.mod_settings["show-pollution-visuals"].value
        if show_pollution_visuals then
            table.insert(result, player)
        end
	end

	return result
end


function setting_changed(data)
    if data.setting == "show-pollution-visuals" then
        local players = get_players_to_render_for()
        for i, chunk_data in pairs(global.polluted_chunks) do        
            for x, r_id in pairs(chunk_data.r_id) do
                if #players == 0 then
                    rendering.set_visible(r_id, false)
                else
                    rendering.set_visible(r_id, true)
                    rendering.set_players(r_id, players)
                end
            end
        end
    end
end

-------------------------------------------------------------------------
-- EVENTS
-------------------------------------------------------------------------
script.on_event(defines.events.on_chunk_deleted, delete_chunk)
script.on_event(defines.events.on_chunk_generated, add_chunk)
script.on_event(defines.events.on_tick, on_tick)
script.on_event(defines.events.on_runtime_mod_setting_changed, setting_changed)
script.on_configuration_changed(set_is_setup)
script.on_init(set_is_setup)