currentVersion = "2.0"
local function downloadFiles(url, path)
    for i = 1, 3 do
        local response = http.get(url)
        if response then
            local data = response.readAll()
            if path then
                local f = io.open(path, "w")
                f:write(data)
                f:close()
            end
            return true
        end
    end
    return false
end

function checkForUpdates(updateUrl)
    for i = 1, 3 do
        local response = http.get(updateUrl)
        if response then
            local data = response.readAll()
            if data ~= currentVersion then
                print("There's an update!!!")
                sleep(1)
                if not fs.exists("/tmp/installer") then
                    downloadFiles("https://raw.githubusercontent.com/miners-online/GOS/main/installer.lua", "/tmp/installer")
                end
                shell.run("/tmp/installer")
            end
        end
    end
end
checkForUpdates("https://raw.githubusercontent.com/miners-online/GOS/main/version")
shell.run("/gos/src/main.lua")