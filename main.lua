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

local Log = T.Log

T.Name = Name
T.Version = GetAddOnMetadata(Name, "Version")

T.MasterPatterns = {
    "%s.*loaded", -- "ADDON_NAME loaded!"
    "/%s.*help"   -- "/ADDON_NAME for help"
}

function T.FormatPattern(pattern, addon) return pattern:format(addon) end

T.LoadedAddons = {}

--T.HookedFunctions = {}
local orig_ChatFrame1_AddMessage = nil

function T:OnLoad()
    self:LoadSavedVariables()
    if self.Saved.Debug then _G["Spamalicious"] = T end
    Log:Debug("%s loaded, creating hooks...", self.Name)
    self:CreateHooks()
end

function T:LoadSavedVariables()
    if type(SPAMALICIOUS) ~= "table" then SPAMALICIOUS = {} end
    self.Saved = SPAMALICIOUS
    if type(self.Saved.Enabled) ~= "boolean" then self.Saved.Enabled = true end
    if type(self.Saved.Debug) ~= "boolean" then self.Saved.Debug = false end
    if type(self.Saved.Patterns) ~= "table" then self.Saved.Patterns = {} end
    if type(self.Saved.LogLevel) ~= "number" then self.Saved.LogLevel = self.Log.Levels.INFO end
end

function T:CreateHooks()
    -- Hook ChatFrame1
    Log:Debug("Hooking CharFrame1")
    orig_ChatFrame1_AddMessage = ChatFrame1.AddMessage
    ChatFrame1.AddMessage = function(obj, text, r, g, b, id, ...)
        if self.Saved.Enabled and self:IsLoadMessage(text) then
            Log:Debug("Catched addon spam message, id %d", tonumber(id) or -1)
            return nil
        end
        return orig_ChatFrame1_AddMessage(obj, text, r, g, b, id, ...)
    end
end

function T:SanitizeAddonName(name)
    return name:lower():gsub("%s", "")
end

function T:IsLoadMessage(message)
    message = message:lower()
    for _, pattern in pairs(self.MasterPatterns) do
        for addonsIndex = 1, #self.LoadedAddons do
            local addon = self.LoadedAddons[addonsIndex]
            local formattedPattern = self:FormatPattern(pattern, addon)
            if message:match(formattedPattern) then return true end
        end
    end
    for _, pattern in pairs(self.Saved.Patterns) do
        if message:match(pattern) then return true end
    end
    return false
end

function T:PrintState()
    Log("%s!", self.Saved.Enabled and "Enabled" or "Disabled")
end

function T:Toggle(silent)
    self.Saved.Enabled = not self.Saved.Enabled
    if not silent then self:PrintState() end
end

T.Frame = CreateFrame("Frame")

function T:ADDON_LOADED(name)
    self.LoadedAddons[self:SanitizeAddonName(name)] = true

    if name == self.Name then self:OnLoad() end
end

T.OnEvent = function(frame, event, ...)
    if T[event] then T[event](T, ...) end
end

T.Frame:SetScript("OnEvent", T.OnEvent)

T.Frame:RegisterEvent("ADDON_LOADED")
