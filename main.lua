local GlobalAddonName, AIU = ...

VersionControl = AIU

local OptionsCorePanel
local itemCheckListFrame
local addonLoaded = false
local itemData = AIU.itemData
local initialConfig = AIU.initialConfig
local addonVersions = AIU.addonVersions
local addonOutOfDateMessage = true

AZPIUInstanceLeadingVersion = 0.1
local dash = " - "
local name = "InstanceUtility" .. dash .. "InstanceLeading"
local nameFull = ("AzerPUG " .. name)
local nameShort = "AIU-IL"
local promo = (nameFull .. dash ..  AZPIUInstanceLeadingVersion)

function VersionControl:InstanceLeading()
    return AZPIUCheckListVersion
end

function addonMain:OnLoad(self)
    --[[
        Make Core add a tab to addon main frame, called core. Add reload button to this.    Reload button already added in checklist, remove from there.
        Make CheckList add a new tab to addon main frame called chekclist, add checklist stuff to there.
        Add checkboxes to add buttons to addon main frame core tab, readycheck, pulltimer, cancelPull, break-5, break-10.
        Add saved var to remember these settings and re-set the checkboxes after restart / reload.

        Readycheck button already in CheckList for testing purposes, remove it from there.

        Add auto-invite option. CheckBox if they want it, input field for command.

        Add auto-promote option. CheckBox for wanting it, input field for names, sepperated by a ";", must include server!!
            PromoteToAssistant(unit) - Promotes player to assistant status. Requires raid leadership.
    ]]
end

addonMain:OnLoad()