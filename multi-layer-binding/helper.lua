local MULTI_LAYER_BINDING_HELPER = {}

function MULTI_LAYER_BINDING_HELPER.splitString(str, delimiter)
    MULTI_LAYER_BINDING_LOGGER.write_log("Splitting string: " .. str .. " with delimiter: " .. delimiter)
    local result = {}
    for match in (str .. delimiter):gmatch("(.-)" .. delimiter) do
        table.insert(result, match)
    end
    return result
end

function MULTI_LAYER_BINDING_HELPER.parseCSV(filePath)
    MULTI_LAYER_BINDING_LOGGER.write_log("Parsing CSV file: " .. filePath)
    local file = io.open(filePath, "r") -- Open the file for reading
    if not file then return nil, "File not found" end

    local header = MULTI_LAYER_BINDING_HELPER.splitString(file:read(), ",") -- Read the header line
    local data = {}

    for line in file:lines() do -- Iterate over each line in the file
        local values = MULTI_LAYER_BINDING_HELPER.splitString(line, ",")
        -- Ensure that data[values[1]] is initialized as a table
        if not data[values[1]] then
            data[values[1]] = {}
        end
        btn_content = {}
        table.insert(btn_content, values[2])
        table.insert(btn_content, values[3])
        table.insert(data[values[1]], btn_content)
    end

    file:close() -- Always remember to close the file
    return data
end

return MULTI_LAYER_BINDING_HELPER
