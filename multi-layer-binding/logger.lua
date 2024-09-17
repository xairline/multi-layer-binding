local MULTI_LAYER_BINDING_LOGGER = {}
function MULTI_LAYER_BINDING_LOGGER.write_log(message)
    logMsg(os.date('%H:%M:%S ') .. '[Multi Layer Binding ' .. MULTI_LAYER_BINDING_VERSION .. ']: ' .. message)
end

function MULTI_LAYER_BINDING_LOGGER.dumpTable(tbl, indent)
    if not indent then
        indent = 0
    end
    for k, v in pairs(tbl) do
        formatting = string.rep("  ", indent) .. k .. ": "
        if type(v) == "table" then
            MULTI_LAYER_BINDING_LOGGER.write_log(formatting)
            MULTI_LAYER_BINDING_LOGGER.dumpTable(v, indent + 1)
        else
            MULTI_LAYER_BINDING_LOGGER.write_log(formatting .. tostring(v))
        end
    end
end

return MULTI_LAYER_BINDING_LOGGER
