local _, ns = ...

local addon = LibStub('AceAddon-3.0'):GetAddon('AdiBags')
local L = setmetatable({}, {__index = addon.L})

local mod = addon:NewModule("UnusableItemOverlay", 'ABEvent-1.0')
mod.uiName = L['Unusable Item Overlay']
mod.uiDesc = L["Adds a red overlay to items that are unusable for you (by searching for red text in the tooltip)"]

function mod:OnInitialize()
end

function mod:OnEnable()
	self:RegisterMessage('AdiBags_UpdateButton', 'UpdateButton')
	self:SendMessage('AdiBags_UpdateAllButtons')
end

function mod:OnDisable()
end

function mod:GetOptions()
end

function mod:UpdateButton(event, button)
    local texture = button.UnusableInidicatorTexture

    if mod:ScanTooltipOfBagItemForRedText(button.bag, button.slot) then
        if not texture then
            texture = button:CreateTexture(nil,"OVERLAY")
            texture:SetPoint("TOPLEFT", 1, -1)
            texture:SetPoint("BOTTOMRIGHT", -1, 1)
            texture:SetColorTexture(1, 0, 0, 0.5)
            button.UnusableInidicatorTexture = texture
        else
            texture:SetAlpha(1)
        end
    else
        if texture then
            texture:SetAlpha(0)
        end
    end
end

local function roundRGB(r, g, b)
    return floor(r * 100 + 0.5) / 100, floor(g * 100 + 0.5) / 100, floor(b * 100 + 0.5) / 100
end

local function isTextColorRed(textTable)
    if not textTable then
        return false
    end

    local text = textTable:GetText()
    if not text or text == "" then
        return false
    end

    local r, g, b = roundRGB(textTable:GetTextColor())
    return r == 1 and g == 0.13 and b == 0.13
end

function mod:ScanTooltipOfBagItemForRedText(bag, slot)
    local tooltipName = "AdibagsUnusableItemOverlayScanningTooltip"
    local tooltip = _G[tooltipName]
    tooltip:ClearLines()
    tooltip:SetBagItem(bag, slot)
    for i=1, tooltip:NumLines() do
        if isTextColorRed(_G[tooltipName .. "TextLeft" .. i]) or isTextColorRed(_G[tooltipName .. "TextRight" .. i]) then
            return true
        end
    end

    return false
end
