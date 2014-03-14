--[[
 ~ Copyright (c) 2014 by Adam Hellberg <sharparam@sharparam.com>.
 ~
 ~ Permission is hereby granted, free of charge, to any person obtaining a copy
 ~ of this software and associated documentation files (the "Software"), to deal
 ~ in the Software without restriction, including without limitation the rights
 ~ to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 ~ copies of the Software, and to permit persons to whom the Software is
 ~ furnished to do so, subject to the following conditions:
 ~
 ~ The above copyright notice and this permission notice shall be included in
 ~ all copies or substantial portions of the Software.
 ~
 ~ THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 ~ IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 ~ FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 ~ AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 ~ LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 ~ OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 ~ THE SOFTWARE.
--]]

local NAME, T = ...

T.Log = {}

Log = T.Log

Log.Levels = {
    DEBUG = 0,
    INFO = 1,
    WARN = 2,
    ERROR = 3,
    FATAL = 4
}

local function printf(...)
    DEFAULT_CHAT_FRAME:AddMessage("Spamalicious: " .. string.format(...))
end

local function lprintf(level, ...)
    if not T.Saved.Debug and level < T.Saved.LogLevel then return end
    printf("%s %s", prefix, string.format(...))
end

function Log:Log(level, ...)
    lprintf(level, ...)
end

function Log:Debug(...)
    lprintf(self.Levels.DEBUG, ...)
end

function Log:Info(...)
    lprintf(self.Levels.INFO, ...)
end

function Log:Warn(...)
    lprintf(self.Levels.WARN, ...)
end

function Log:Error(...)
    lprintf(self.Levels.ERROR, ...)
end

function Log:Fatal(...)
    lprintf(self.Levels.FATAL, ...)
end

local mt = {
    __call = function(t, level, ...)
        if type(level) ~= "number" then
            t:Info(level, ...) -- "level" here is actually just the format string
        else
            t:Log(level, ...)
        end
    end
}

setmetatable(Log, mt)
