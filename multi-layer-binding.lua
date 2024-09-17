MULTI_LAYER_BINDING_VERSION = "0.1.0"
MULTI_LAYER_BINDING_LOGGER = dofile(SCRIPT_DIRECTORY .. "/multi-layer-binding/logger.lua")
dofile(SCRIPT_DIRECTORY .. "/multi-layer-binding/GUI.lua")
MULTI_LAYER_BINDING_HELPER = dofile(SCRIPT_DIRECTORY .. "/multi-layer-binding/helper.lua")

if not SUPPORTS_FLOATING_WINDOWS then
    -- to make sure the script doesn't stop with old FlyWithLua versions
    logMsg("imgui not supported by your FlyWithLua version")
    return
end

function layer_change(param)
    if param == "down" then
        if MULTI_LAYER_BINDING_ACTIVE_LAYER == 1 then
            MULTI_LAYER_BINDING_ACTIVE_LAYER = MULTI_LAYER_BINDING_NUM_OF_LAYERS
        else
            MULTI_LAYER_BINDING_ACTIVE_LAYER = MULTI_LAYER_BINDING_ACTIVE_LAYER - 1
        end
    end
    if param == "up" then
        if MULTI_LAYER_BINDING_ACTIVE_LAYER == MULTI_LAYER_BINDING_NUM_OF_LAYERS then
            MULTI_LAYER_BINDING_ACTIVE_LAYER = 1
        else
            MULTI_LAYER_BINDING_ACTIVE_LAYER = MULTI_LAYER_BINDING_ACTIVE_LAYER + 1
        end
    end
end

create_command(
    'MultiLayerBinding/layer_down',
    'Switch to the next layer',
    'layer_change("down")',
    '',
    ''
)

create_command(
    'MultiLayerBinding/layer_up',
    'Switch to the previous layer',
    'layer_change("up")',
    '',
    ''
)

local number_of_btns = 7
function btn_toggle(btn)
    MULTI_LAYER_BINDING_LOGGER.write_log('Button ' .. btn .. ' toggled')
    local btns = MULTI_LAYER_BINDING_RAW_LAYERS[MULTI_LAYER_BINDING_LAYERS[MULTI_LAYER_BINDING_ACTIVE_LAYER]]
    local cmd = btns[btn]
    MULTI_LAYER_BINDING_LOGGER.write_log('Command: ' .. cmd[2])
    -- check cmd contains semi-colon
    if string.find(cmd[2], ':') then
        MULTI_LAYER_BINDING_LOGGER.write_log('Command contains semi-colon')
        local parsedCmd = MULTI_LAYER_BINDING_HELPER.splitString(cmd[2], '?')
        local condition = MULTI_LAYER_BINDING_HELPER.splitString(parsedCmd[1], ':')
        local commands = MULTI_LAYER_BINDING_HELPER.splitString(parsedCmd[2], ':')
        MULTI_LAYER_BINDING_LOGGER.write_log('Parsed command: ' .. parsedCmd[1] .. ' ' .. parsedCmd[2])
        MULTI_LAYER_BINDING_LOGGER.write_log('Condition: ' .. condition[1] .. ' ' .. condition[2])
        MULTI_LAYER_BINDING_LOGGER.write_log('Commands: ' .. commands[1] .. ' ' .. commands[2])
        local dataref_value = dataref_table(condition[1])[1]
        if dataref_value < tonumber(condition[2]) then
            command_once(commands[1])
        else
            command_once(commands[2])
        end
    else
        command_once(cmd[2])
    end
end

for i = 1, number_of_btns do
    create_command(
        'MultiLayerBinding/button_' .. i,
        'Button ' .. i,
        'btn_toggle(' .. i .. ')',
        '',
        ''
    )
end

MULTI_LAYER_BINDING_RAW_LAYERS = MULTI_LAYER_BINDING_HELPER.parseCSV(SCRIPT_DIRECTORY ..
    'multi-layer-binding/profiles/' .. PLANE_ICAO .. '.csv')
MULTI_LAYER_BINDING_LOGGER.dumpTable(MULTI_LAYER_BINDING_RAW_LAYERS, 2)
MULTI_LAYER_BINDING_LAYERS = {}
for key in pairs(MULTI_LAYER_BINDING_RAW_LAYERS) do
    table.insert(MULTI_LAYER_BINDING_LAYERS, key)
end
MULTI_LAYER_BINDING_NUM_OF_LAYERS = #MULTI_LAYER_BINDING_LAYERS
MULTI_LAYER_BINDING_ACTIVE_LAYER = 0
if #MULTI_LAYER_BINDING_LAYERS > 0 then
    MULTI_LAYER_BINDING_ACTIVE_LAYER = 1
end
-----------------------------------Variables go here--------------------------------------------
--Set you variables here, datarefs, etc...

multi_layer_binding_float_wnd_height = 150
multi_layer_binding_float_wnd_width = 520

multi_layer_binding_drawer_pox_x = -1 * multi_layer_binding_float_wnd_width
multi_layer_binding_wnd_pox_x = multi_layer_binding_drawer_pox_x
multi_layer_binding_wnd_pox_y = 400

multi_layer_binding_ideal_x = multi_layer_binding_drawer_pox_x
multi_layer_binding_ideal_y = 400

multi_layer_binding_x_pos = 0
multi_layer_binding_y_pos = 0

multi_layer_binding_report = nil
multi_layer_bindings = nil


-------------------------------------Build Your GUI Here----------------------------------------

function multi_layer_binding_on_build(multi_layer_binding_wnd, x, y)
    -- Set style to dark
    -- Create a window
    -- Window content here
    imgui.PushStyleColor(imgui.constant.Col.FrameBg, 0x00101112)
    imgui.PushStyleColor(imgui.constant.Col.Border, 0x00101112)

    if imgui.IsMouseDragging(0) then
        x_d = MOUSE_X
        y_d = MOUSE_Y
        --multi_layer_binding_wnd_pox_x = multi_layer_binding_wnd_pox_x + x_d - multi_layer_binding_x_pos
        multi_layer_binding_wnd_pox_y = multi_layer_binding_wnd_pox_y + y_d - multi_layer_binding_y_pos
        if multi_layer_binding_wnd_pox_y < 0 then
            multi_layer_binding_wnd_pox_y = 0
        end

        if multi_layer_binding_wnd_pox_y > SCREEN_HIGHT - 100 then
            multi_layer_binding_wnd_pox_y = SCREEN_HIGHT - 100
        end

        float_wnd_set_position(multi_layer_binding_wnd, multi_layer_binding_wnd_pox_x, multi_layer_binding_wnd_pox_y)
        multi_layer_binding_x_pos = x_d
        multi_layer_binding_y_pos = y_d
    else
        multi_layer_binding_x_pos = MOUSE_X
        multi_layer_binding_y_pos = MOUSE_Y
    end

    if multi_layer_binding_ideal_x > -30 then
        if imgui.Button("<", 20, multi_layer_binding_float_wnd_height - 20) then
            multi_layer_binding_ideal_x = multi_layer_binding_drawer_pox_x - 10
        end
        imgui.SameLine(0, 0.0)
    end

    multi_layer_binding_float_wnd_content()

    imgui.SameLine(0, 0.0)

    if multi_layer_binding_wnd_pox_x < -280 then
        if imgui.Button(">", 20, multi_layer_binding_float_wnd_height - 20) then
            multi_layer_binding_ideal_x = -10
        end
    end

    imgui.PopStyleColor()
    imgui.PopStyleColor()

    drawer_speed = SCREEN_WIDTH / 50
    if multi_layer_binding_ideal_x ~= multi_layer_binding_wnd_pox_x then
        if multi_layer_binding_ideal_x > multi_layer_binding_wnd_pox_x then
            multi_layer_binding_wnd_pox_x = multi_layer_binding_wnd_pox_x + drawer_speed
            if multi_layer_binding_wnd_pox_x > multi_layer_binding_ideal_x then
                multi_layer_binding_wnd_pox_x = multi_layer_binding_ideal_x
            end
        else
            multi_layer_binding_wnd_pox_x = multi_layer_binding_wnd_pox_x - drawer_speed
            if multi_layer_binding_wnd_pox_x < multi_layer_binding_ideal_x then
                multi_layer_binding_wnd_pox_x = multi_layer_binding_ideal_x
            end
        end
        float_wnd_set_position(multi_layer_binding_wnd, multi_layer_binding_wnd_pox_x, multi_layer_binding_wnd_pox_y)
    end


    -- Reset style to default after creating the window
end -- function multi_layer_binding_on_build

-------------------------------------------------------------------------------------------------







-------------------Show Hide Window Section with Toggle functionaility---------------------------

multi_layer_binding_wnd = nil -- flag for the show_wnd set to nil so that creation below can happen - float_wnd_create
-- version number
function multi_layer_binding_show_wnd()
    -- This is called when user toggles window on/off, if the next toggle is for ON
    multi_layer_binding_wnd = float_wnd_create(multi_layer_binding_float_wnd_width + 50,
        multi_layer_binding_float_wnd_height, 3, true)
    float_wnd_set_title(multi_layer_binding_wnd, "Multi Layer Binding " .. MULTI_LAYER_BINDING_VERSION)
    imgui.PushStyleColor(imgui.constant.Col.Border, 0x00101112)
    imgui.PushStyleColor(imgui.constant.Col.WindowBg, 0x00101112)
    float_wnd_set_imgui_builder(multi_layer_binding_wnd, "multi_layer_binding_on_build")
    float_wnd_set_position(multi_layer_binding_wnd, multi_layer_binding_wnd_pox_x - 10, multi_layer_binding_wnd_pox_y)
    float_wnd_set_ondraw(multi_layer_binding_wnd, "multi_layer_binding_on_draw")
end

function multi_layer_binding_hide_wnd()
    -- This is called when user toggles window on/off, if the next toggle is for OFF
    if multi_layer_binding_wnd then
        float_wnd_destroy(multi_layer_binding_wnd)
        multi_layer_binding_wnd = nil
    end
end

function toggle_multi_layer_binding_window()
    MULTI_LAYER_BINDING_LOGGER.write_log("toggle_multi_layer_binding_window")
    if multi_layer_binding_wnd then
        multi_layer_binding_hide_wnd()
    else
        multi_layer_binding_show_wnd()
    end
end

------------------------------------------------------------------------------------------------


----"add_macro" - adds the option to the FWL macro menu in X-Plane
----"create command" - creates a show/hide toggle command that calls the toggle_multi_layer_binding_window()
add_macro("Multi Layer Binding", "multi_layer_binding_show_wnd()",
    "multi_layer_binding_hide_wnd()", "activate")
