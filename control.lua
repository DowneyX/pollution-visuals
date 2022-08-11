-------------------------------------------------------------------------
--MAIN FUNCTIONS
-------------------------------------------------------------------------

-- function that triggers every tick
function on_tick()
    if global.polluted_chunks == nil and global.all_chunks == nil then
        setup()
    elseif not (global.check_all) and not (global.polluted_chunks == {}) then
        check_polluted_chunks()
        
    elseif global.check_all or (global.polluted_chunks == {}) then
        check_all_chunks()
    end
end

--sets up all the variables and populates them with initial values
function setup()
    log("setup")
    --clearing all visuals juist incase there are some left from a previous version 
    rendering.clear("pollution-visuals")

    --defining the overworld. i will probably have to loop through all the surfaces. but i'll do that later
    local surface=game.surfaces[1]

    -- defining chunk tables
    global.polluted_chunks = {}
    global.polluted_chunks_i = nil
    global.all_chunks = {}
    global.all_chunks_i = nil

    --bool for if we need to check all_chunks or just polluted_chunks
    global.check_all = false

    --looping through all the chunks on surface
    for chunk in surface.get_chunks() do
        local x = chunk.area.left_top.x
        local y = chunk.area.left_top.y

        -- inserting chunk in all_chunks
        global.all_chunks[x.." "..y] = {position = {x=x,y=y}, r_id=-1, surface=surface.index}

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

            global.polluted_chunks[x.." "..y] = {position = {x=x,y=y}, r_id=-1, surface=surface.index}
            if surface.get_pollution(N) == 0 then 
                global.polluted_chunks[x.." "..(y-32)] = {position = {x=x, y=y-32}, r_id=-1, surface=surface.index} 
            end
            if surface.get_pollution(E) == 0 then 
                global.polluted_chunks[(x+32).." "..y] = {position = {x=x+32, y=y}, r_id=-1, surface=surface.index} 
            end
            if surface.get_pollution(S) == 0 then 
                global.polluted_chunks[x.." "..(y+32)] = {position = {x=x, y=y+32}, r_id=-1, surface=surface.index} 
            end
            if surface.get_pollution(W) == 0 then 
                global.polluted_chunks[(x-32).." "..y] = {position = {x=x-32, y=y}, r_id=-1, surface=surface.index} 
            end
            if surface.get_pollution(NE) == 0 then 
                global.polluted_chunks[(x+32).." "..(y-32)] = {position = {x=x+32,y=y-32}, r_id=-1, surface=surface.index} 
            end
            if surface.get_pollution(SE) == 0 then 
                global.polluted_chunks[(x+32).." "..(y+32)] = {position = {x=x+32, y=y+32}, r_id=-1, surface=surface.index} 
            end
            if surface.get_pollution(SW) == 0 then 
                global.polluted_chunks[(x-32).." "..(y+32)] = {position = {x=x-32, y=y+32}, r_id=-1, surface=surface.index} 
            end
            if surface.get_pollution(NW) == 0 then 
                global.polluted_chunks[(x-32).." "..(y-32)] = {position = {x=x-32, y=y-32}, r_id=-1, surface=surface.index} 
            end
        end
    end
end

-- will check every polluted chunk and draw visuals
function check_polluted_chunks()
    for i = 1, 20 do 
        local index ,chunk_data = next(global.polluted_chunks, global.polluted_chunks_i)
        if index == nil then global.polluted_chunks_i = nil global.check_all = true break 
        else global.polluted_chunks_i = index end

        draw_chunk_visuals(chunk_data)           
    end
end

-- will check if chunks are polluted and put them in polluted_chunks if they are
function check_all_chunks()
    for i = 1, 20 do 
        local index ,chunk_data = next(global.all_chunks, global.all_chunks_i)
        if index == nil then global.all_chunks_i = nil global.check_all = false break 
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

            global.polluted_chunks[x.." "..y] = {position = {x=x,y=y}, r_id=r_id, surface=surface.index}
            if surface.get_pollution(N) == 0 and not (global.polluted_chunks[x.." "..(y-32)] == nil) then 
                global.polluted_chunks[x.." "..(y-32)] = {position = {x=x, y=y-32}, r_id=global.all_chunks[x.." "..(y-32)].r_id, surface=surface.index} end
            if surface.get_pollution(E) == 0 and not (global.polluted_chunks[(x+32).." "..y] == nil) then 
                global.polluted_chunks[(x+32).." "..y] = {position = {x=x+32, y=y}, r_id=global.all_chunks[(x+32).." "..y].r_id, surface=surface.index} end
            if surface.get_pollution(S) == 0 and not (global.polluted_chunks[x.." "..(y+32)] == nil) then 
                global.polluted_chunks[x.." "..(y+32)] = {position = {x=x, y=y+32}, r_id=global.all_chunks[x.." "..(y+32)].r_id, surface=surface.index} end
            if surface.get_pollution(W) == 0 and not (global.polluted_chunks[(x-32).." "..y] == nil) then 
                global.polluted_chunks[(x-32).." "..y] = {position = {x=x-32, y=y}, r_id=global.all_chunks[(x-32).." "..y].r_id, surface=surface.index} end
            if surface.get_pollution(NE) == 0 and not (global.polluted_chunks[(x+32).." "..(y-32)] == nil) then
                global.polluted_chunks[(x+32).." "..(y-32)] = {position = {x=x+32,y=y-32}, r_id=global.all_chunks[(x+32).." "..(y-32)].r_id, surface=surface.index} end
            if surface.get_pollution(SE) == 0 and not (global.polluted_chunks[(x+32).." "..(y+32)] == nil) then
                global.polluted_chunks[(x+32).." "..(y+32)] = {position = {x=x+32, y=y+32}, r_id=global.all_chunks[(x+32).." "..(y+32)].r_id, surface=surface.index} end
            if surface.get_pollution(SW) == 0 and not (global.polluted_chunks[(x-32).." "..(y+32)] == nil) then 
                global.polluted_chunks[(x-32).." "..(y+32)] = {position = {x=x-32, y=y+32}, r_id=global.all_chunks[(x-32).." "..(y+32)].r_id, surface=surface.index} end
            if surface.get_pollution(NW) == 0 and not (global.polluted_chunks[(x-32).." "..(y-32)] == nil) then 
                global.polluted_chunks[(x-32).." "..(y-32)] = {position = {x=x-32, y=y-32}, r_id=global.all_chunks[(x-32).." "..(y-32)].r_id, surface=surface.index} end
        end
    end
end

-- draws an animation for a specifeid chunk
function draw_chunk_visuals(chunk_data)
    --chunk information
    local surface = game.surfaces[chunk_data.surface]
    local x = chunk_data.position.x
    local y = chunk_data.position.y
    local r_id = chunk_data.r_id
    local chunk_pollution_level = surface.get_pollution({x,y})

    --animation target location
    local anim_target = {x+16, y-16}

    -- deleting animation that is pressent in this chunk
    if not(r_id == nil) then rendering.destroy(r_id) end
    
    -- drawing animation depending on pollution levels
    if chunk_pollution_level > 50 then
        r_id = rendering.draw_animation{animation="smog_middle", surface=surface,target=anim_target, y_scale=2, x_scale=2 }
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

        -- checking what type of animation to draw depending on the neighboring chunks
        if N > 50 and S > 50 then
            r_id = rendering.draw_animation{animation="smog_middle", surface=surface,target=anim_target, y_scale=2, x_scale=2}
        elseif W > 50 and E > 50 then
            r_id = rendering.draw_animation{animation="smog_middle", surface=surface,target=anim_target, y_scale=2, x_scale=2}
        elseif S > 50 and W <= 50 and E <= 50 then 
            r_id = rendering.draw_animation{animation="smog_top", surface=surface,target=anim_target, y_scale=2, x_scale=2}
        elseif N > 50 and W <= 50 and E <= 50 then
            r_id = rendering.draw_animation{animation="smog_bottom", surface=surface,target=anim_target, y_scale=2, x_scale=2}
        elseif (W > 50 or (NW > 50 and SW > 50)) and (N <= 50 and S <= 50 and NE <= 50 and NE <= 50) then
            r_id = rendering.draw_animation{animation="smog_left", surface=surface,target=anim_target, y_scale=2, x_scale=2}
        elseif (E > 50 or (NE > 50 and SE > 50)) and (N <= 50 and S <= 50 and NW <= 50 and NW <= 50) then 
            r_id = rendering.draw_animation{animation="smog_right", surface=surface,target=anim_target, y_scale=2, x_scale=2}
        elseif SW > 50 and N <= 50 and NE <= 50 and E <= 50 and SE <= 50 and S <= 50 and W <= 50 and NW <= 50 then
            r_id = rendering.draw_animation{animation="smog_corner_left_top", surface=surface,target=anim_target, y_scale=2, x_scale=2}
        elseif SE > 50 and N <= 50 and NE <= 50 and E <= 50 and SW <= 50 and S <= 50 and W <= 50 and NW <= 50 then
            r_id = rendering.draw_animation{animation="smog_corner_right_top", surface=surface,target=anim_target, y_scale=2, x_scale=2}
        elseif S > 50 and E > 50 and W <= 50 and N <= 50 and NW <= 50 then 
            r_id = rendering.draw_animation{animation="smog_corner_inv_left_top", surface=surface,target=anim_target, y_scale=2, x_scale=2}
        elseif S > 50 and W > 50 and E <= 50 and N <= 50 and NE <= 50 then 
            r_id = rendering.draw_animation{animation="smog_corner_inv_right_top", surface=surface,target=anim_target, y_scale=2, x_scale=2}
        elseif NW > 50 and N <= 50 and NE <= 50 and E <= 50 and SW <= 50 and S <= 50 and W <= 50 and SE <= 50 then
            r_id = rendering.draw_animation{animation="smog_corner_left_bottom", surface=surface,target=anim_target, y_scale=2, x_scale=2}
        elseif NE > 50 and E <= 50 and SE <= 50 and S <= 50 and SW <= 50 and W <= 50 and NW <= 50 and N <= 50 then
            r_id = rendering.draw_animation{animation="smog_corner_right_bottom", surface=surface,target=anim_target, y_scale=2, x_scale=2}
        elseif N > 50 and E > 50 and W <= 50 and S <= 50 and SW <= 50 then 
            r_id = rendering.draw_animation{animation="smog_corner_inv_left_bottom", surface=surface,target=anim_target, y_scale=2, x_scale=2}
        elseif N > 50 and W > 50 and E <= 50 and S <= 50 and SE <= 50 then 
            r_id = rendering.draw_animation{animation="smog_corner_inv_right_bottom", surface=surface,target=anim_target, y_scale=2, x_scale=2}
        end
    end
    global.all_chunks[(x).." "..(y)].r_id = r_id
    global.polluted_chunks[(x).." "..(y)].r_id = r_id
end

function add_chunk(chunk)
    local x = chunk.area.left_top.x
    local y = chunk.area.left_top.y
    local surface = chunk.surface

    global.all_chunks[x.." "..y] = {position = {x=x,y=y}, r_id=-1, surface=surface.index}

end

function delete_chunk(chunk)
    local x = chunk.area.left_top.x
    local y = chunk.area.left_top.y
    local chunk_data = global.all_chunks[x.." "..y]
    local r_id = chunk_data.r_id

    rendering.destroy()

    global.all_chunks[x.." "..y] = nil
    global.polluted_chunks[x.." "..y] = nil
end

-------------------------------------------------------------------------
--DEBUG FUNCTIONS
-------------------------------------------------------------------------

-- counts the length of a table and returns it
function length(table)
    local count = 0
    for k,v in pairs(table) do
        count = count + 1
    end
    return count
end

-------------------------------------------------------------------------
--EVENTS
-------------------------------------------------------------------------
script.on_event(defines.events.on_chunk_deleted, delete_chunk)
script.on_event(defines.events.on_chunk_generated, add_chunk)
script.on_event(defines.events.on_tick, on_tick)
