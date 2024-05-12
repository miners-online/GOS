package.path = "../libs/?/init.lua;" .. package.path
local basalt = require("basalt")
local main = basalt.createFrame():setBackground(colors.cyan)
local windowlib = require("libs.window")
windowlib.basalt(basalt)

local button = main:addButton()
button:setPosition(4, 4)
button:setSize(16, 3)
button:setText("Shell")

local function buttonClick()
    local w = windowlib.newWindow("Shell")
    w:open()
    local f = w:getChildPane()
    f:addProgram()
    :setSize("parent.w", "parent.h")
    :setPosition(1, 1)
    :execute("/rom/programs/shell.lua")
end

button:onClick(buttonClick)

basalt.autoUpdate()