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

T.Commands = {}

local C = T.Commands
local Log = T.Log

C.Slash = {"spamalicious", "sharpspam"}

function C:Trim(str)
    return (s:gsub("^%s*(.-)%s*$", "%1"))
end

for i = 1, #C.Slash do
    _G["SLASH_" .. T.Name:upper() .. i] = "/" .. C.Slash[i]
end

SlashCmdList[T.Name:upper()] = function(msg, editBox)
    -- Just support addon toggling for now
    T:Toggle()
end
