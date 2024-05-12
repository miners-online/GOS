--- Managing and creating window objects.
-- @moudle windowlib
windowlib = {}

local mainFrame
local basalt

--- Gives this windowing API access to the basalt API.
--- @param _basalt table An instance of the basalt API.
function windowlib.basalt(_basalt)
    basalt = _basalt
    mainFrame = basalt.getMainFrame()
end

--- @class Window A class used to represent the sate of a Window
--- @field _windowFrame any
--- @field _childFrame any
--- @field _windowTitle any
local Window = {
    _windowFrame = nil,
    _childFrame = nil,
    _windowTitle = nil
}

function Window:new(o)
    o = o or {}   -- create object if user does not provide one
    setmetatable(o, self)
    self.__index = self
    return o
end

--- Opens the window.
function Window:open()
    w, h = mainFrame:getSize()
    self._windowFrame:show()
    self._windowFrame:animatePosition(
        w/2-self._windowFrame:getWidth()/2,
        h/2-self._windowFrame:getHeight()/2, 0.5
    )
end

--- Closes the window.
function Window:close()
    self._windowFrame:animatePosition(
        -w, h/2-self._windowFrame:getHeight()/2,
        0.5
    )
end

--- Gets the child pane of the window.
--- @return table childFrame The child frame.
function Window:getChildPane()
    return self._childFrame
end

--- Sets the window title.
--- @param newTitle string The new title for the window.
function Window:setWindowTitle(newTitle)
    return self._windowTitle:setText(newTitle)
end

--- Creates a new window frame with the specified title.
--- @param title string The title of the window.
--- @return table window A table containing functions to interact with the created window.
local function createFrame(title)
    local windowFrame
    local childFrame
    local windowTitle

    local minW = 16
    local minH = 6
    local maxW = 99
    local maxH = 99
    local w, h = mainFrame:getSize()

    -- Create the main window frame
    windowFrame = mainFrame:addMovableFrame():setSize(w-20, h-10):setBackground(colors.black):setForeground(colors.white):setZIndex(100):hide()
    windowFrame:addPane():setSize("parent.w", 1):setPosition(1, 1):setBackground(colors.gray):setForeground(colors.white)
    windowFrame:setPosition(-w, h/2-windowFrame:getHeight()/2):setBorder(colors.gray)

    -- Create a resize button for the window
    local resizeButton = windowFrame:addButton()
        :setPosition("parent.w", "parent.h")
        :setSize(1, 1)
        :setText("/")
        :setForeground(colors.white)
        :setBackground(colors.gray)
        :onClick(function() end)
        :onDrag(function(self, event, btn, xOffset, yOffset)
            w, h = windowFrame:getSize()
            local wOff, hOff = w, h
            if (w + xOffset - 1 >= minW) and (w + xOffset - 1 <= maxW) then
                wOff = w + xOffset - 1
            end
            if (h + yOffset - 1 >= minH) and (h + yOffset - 1 <= maxH) then
                hOff = h + yOffset - 1
            end
            windowFrame:setSize(wOff, hOff)
        end)

    -- Create an exit button for the window
    debugExitButton = windowFrame:addButton():setText("X"):setPosition("parent.w - 1", 1):setSize(1, 1):setBackground(colors.red):setForeground(colors.white):onClick(function() 
        windowFrame:animatePosition(-w, h/2-windowFrame:getHeight()/2, 0.5)
    end)

    -- Create a label for the window title
    windowTitle = windowFrame:addLabel()
                :setSize("parent.w - 3", "1")
                :setText(title)
                :setPosition(2, 1)
                :setBackground(colors.gray)
                :setForeground(colors.white)

    -- Create a child frame for the window content
    childFrame = windowFrame:addFrame()
                :setSize("parent.w - 2", "parent.h - 2")
                :setPosition(2, 2)
                :setBackground(colors.gray)
                :setForeground(colors.white)

    return Window:new{
        _windowFrame = windowFrame,
        _childFrame = childFrame,
        _windowTitle = windowTitle
    }
end



--- Creates a new window with the specified title.
--- @param title string The title of the window.
--- @return Window window A table containing functions to interact with the created window.
function windowlib.newWindow(title)
    return createFrame(title)
end


return windowlib
