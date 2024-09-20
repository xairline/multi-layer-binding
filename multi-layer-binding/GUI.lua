local socket = require "socket"
local http = require "socket.http"

multi_layer_binding_draw_main_wnd = false
multi_layer_binding_main_wnd = nil
main_multi_layer_binding_wnd_pox_y = 200
main_multi_layer_binding_x_pos = 0
main_multi_layer_binding_y_pos = 0
multi_layer_binding_main_wnd_width = 800
multi_layer_binding_main_wnd_height = 600


local title_size = 1.5
local sub_title_size = 1.3
local text_size = 1
function multi_layer_binding_on_draw()
    if multi_layer_binding_draw_main_wnd and multi_layer_binding_main_wnd == nil then
        multi_layer_binding_main_wnd = float_wnd_create(multi_layer_binding_main_wnd_width,
            multi_layer_binding_main_wnd_height, 1, true)
        float_wnd_set_title(multi_layer_binding_main_wnd, "XA Passenger Report " .. MULTI_LAYER_BINDING_VERSION)
        imgui.PushStyleColor(imgui.constant.Col.WindowBg, 0xFF101112)
        float_wnd_set_imgui_builder(multi_layer_binding_main_wnd, "multi_layer_binding_main_wnd_build")
        float_wnd_set_position(multi_layer_binding_main_wnd, multi_layer_binding_float_wnd_width + 30, 200)
        float_wnd_set_resizing_limits(multi_layer_binding_main_wnd, multi_layer_binding_main_wnd_width,
            multi_layer_binding_main_wnd_height, multi_layer_binding_main_wnd_width, multi_layer_binding_main_wnd_height)
        multi_layer_binding_draw_main_wnd = false
    end
end

function multi_layer_binding_hide_main_wd()
    if multi_layer_binding_main_wnd then
        float_wnd_destroy(multi_layer_binding_main_wnd)
        multi_layer_binding_main_wnd = nil
        multi_layer_binding_draw_main_wnd = false
    end
end

function multi_layer_binding_main_wnd_build()

end

function multi_layer_binding_float_wnd_content()
    imgui.PushStyleColor(imgui.constant.Col.ChildBg, 0x8f101112)
    if imgui.BeginChild("multi_layer_binding_content", multi_layer_binding_float_wnd_width, multi_layer_binding_float_wnd_height - 20, true) then
        imgui.SetWindowFontScale(title_size)
        if MULTI_LAYER_BINDING_ACTIVE_LAYER then
            imgui.TextUnformatted(MULTI_LAYER_BINDING_LAYERS[MULTI_LAYER_BINDING_ACTIVE_LAYER])
        end
        imgui.SetWindowFontScale(text_size)
        local cx, cy = imgui.GetCursorScreenPos()
        imgui.SetCursorScreenPos(cx, cy + 10)

        local btns = MULTI_LAYER_BINDING_RAW_LAYERS[MULTI_LAYER_BINDING_LAYERS[MULTI_LAYER_BINDING_ACTIVE_LAYER]]
        local num_of_btns = #btns
        local num_of_max_btns = 7
        local btn_width = (multi_layer_binding_float_wnd_width - 5) / num_of_max_btns - 12

        for i = 1, num_of_btns do
            if i ~= 1 then
                imgui.SameLine(0, 0)
            end
            cx, cy = imgui.GetCursorScreenPos()
            imgui.SetCursorScreenPos(cx + 10, cy)
            imgui.PushStyleColor(imgui.constant.Col.ChildBg, 0x88330607)
            if imgui.BeginChild("bt" .. i, btn_width, 70, true) then
                imgui.PushTextWrapPos(btn_width * 0.9)
                local btn_content = btns[i]
                imgui.TextUnformatted(btn_content[1])
                imgui.PopTextWrapPos()
            end
            imgui.EndChild()
            imgui.PopStyleColor()
        end
    end
    imgui.EndChild()
    imgui.PopStyleColor()
end

function getColorAtY(y)
    y = 1 - y
    -- Start and end color components
    local startR, startG, startB = 0, 255, 0
    local endR, endG, endB = 13, 13, 200

    -- Calculate the color components at position Y
    local r = startR + y * (endR - startR)
    local g = startG + y * (endG - startG)
    local b = startB + y * (endB - startB)

    -- Convert float to integer if necessary
    r = math.floor(r + 0.5)
    g = math.floor(g + 0.5)
    b = math.floor(b + 0.5)

    -- Convert RGB components back to hex format for output
    local hexColor = string.format("%02X%02X%02X", r, g, b)
    return hexColor
end

function multi_layer_binding_draw_horizontal_bars(cx, cy, score)
    start_color = getColorAtY(score)
    start_color1 = tonumber("0xFF" .. start_color, 16)
    start_color2 = tonumber("0xB9" .. start_color, 16)
    imgui.DrawList_AddRectFilledMultiColor(cx + 5, cy + 10, cx + multi_layer_binding_main_wnd_width * 0.66, cy + 30,
        0xB90D0DC8, start_color2, start_color1, 0xFF0D0DC8)
    imgui.SetCursorScreenPos(cx + multi_layer_binding_main_wnd_width * 0.33, cy + 40 / 6 + 6)
    if score < 0.1 then
        imgui.TextUnformatted(" " .. score * 100 .. "%")
    else
        imgui.TextUnformatted(score * 100 .. "%")
    end
    imgui.SetCursorScreenPos(cx, cy)
end

function multi_layer_binding_draw_horizontal_bars_without_text(cx, cy, width, height)
    start_color = getColorAtY(1)
    start_color1 = 0xFF00FF00
    start_color2 = 0xB900FF00
    imgui.DrawList_AddRectFilledMultiColor(cx, cy, cx + width, cy + height, start_color2, 0xB90D0D08, 0xFF0D0D08,
        start_color1)
end
