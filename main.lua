local GlobalAddonName, AIU = ...

local AZPIUInstanceLeadingVersion = 14
local dash = " - "
local name = "InstanceUtility" .. dash .. "InstanceLeading"
local nameFull = ("AzerPUG " .. name)
local promo = (nameFull .. dash ..  AZPIUInstanceLeadingVersion)

local addonMain = LibStub("AceAddon-3.0"):NewAddon("InstanceUtility-InstanceLeading", "AceConsole-3.0")

local ModuleStats = AZP.IU.ModuleStats

function AZP.IU.VersionControl:InstanceLeading()
    return AZPIUInstanceLeadingVersion
end

function AZP.IU.OnLoad:InstanceLeading(self)
    InstanceUtilityAddonFrame:RegisterEvent("CHAT_MSG_WHISPER")
    InstanceUtilityAddonFrame:RegisterEvent("CHAT_MSG_BN_WHISPER")
    InstanceUtilityAddonFrame:RegisterEvent("GROUP_ROSTER_UPDATE")
    InstanceUtilityAddonFrame:RegisterEvent("ENCOUNTER_START")

    ModuleStats["Frames"]["InstanceLeading"]:SetSize(300, 150)

    
    local AZPSavePresenceButton = CreateFrame("Button", nil, ModuleStats["Frames"]["InstanceLeading"], "UIPanelButtonTemplate")
    AZPSavePresenceButton.contentText = AZPSavePresenceButton:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
    AZPSavePresenceButton.contentText:SetText("Save Raid Presence")
    AZPSavePresenceButton:SetWidth("100")
    AZPSavePresenceButton:SetHeight("25")
    AZPSavePresenceButton.contentText:SetWidth("100")
    AZPSavePresenceButton.contentText:SetHeight("15")
    AZPSavePresenceButton:SetPoint("TOPRIGHT", -5, -5)
    AZPSavePresenceButton.contentText:SetPoint("CENTER", 0, -1)
    AZPSavePresenceButton:SetScript("OnClick", function() addonMain:SaveRaidPresence(nil) end )
    
    local AZPExportPresenceButton = CreateFrame("Button", nil, ModuleStats["Frames"]["InstanceLeading"], "UIPanelButtonTemplate")
    AZPExportPresenceButton.contentText = AZPExportPresenceButton:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
    AZPExportPresenceButton.contentText:SetText("Export Raid Presence")
    AZPExportPresenceButton:SetWidth("100")
    AZPExportPresenceButton:SetHeight("25")
    AZPExportPresenceButton.contentText:SetWidth("100")
    AZPExportPresenceButton.contentText:SetHeight("15")
    AZPExportPresenceButton:SetPoint("TOPRIGHT", -5, -30)
    AZPExportPresenceButton.contentText:SetPoint("CENTER", 0, -1)
    AZPExportPresenceButton:SetScript("OnClick", function() addonMain:ExportRaidPresence() end )

    local AZPClearPresenceButton = CreateFrame("Button", nil, ModuleStats["Frames"]["InstanceLeading"], "UIPanelButtonTemplate")
    AZPClearPresenceButton.contentText = AZPClearPresenceButton:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
    AZPClearPresenceButton.contentText:SetText("Clear Raid Presence")
    AZPClearPresenceButton:SetWidth("100")
    AZPClearPresenceButton:SetHeight("25")
    AZPClearPresenceButton.contentText:SetWidth("100")
    AZPClearPresenceButton.contentText:SetHeight("15")
    AZPClearPresenceButton:SetPoint("TOPRIGHT", -5, -55)
    AZPClearPresenceButton.contentText:SetPoint("CENTER", 0, -1)
    AZPClearPresenceButton:SetScript("OnClick", function() addonMain:ClearRaidPresence() end )

    local AZPReadyCheckButton = CreateFrame("Button", nil, ModuleStats["Frames"]["InstanceLeading"], "UIPanelButtonTemplate")
    AZPReadyCheckButton.contentText = AZPReadyCheckButton:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
    AZPReadyCheckButton.contentText:SetText("Ready Check!")
    AZPReadyCheckButton:SetWidth("100")
    AZPReadyCheckButton:SetHeight("25")
    AZPReadyCheckButton.contentText:SetWidth("100")
    AZPReadyCheckButton.contentText:SetHeight("15")
    AZPReadyCheckButton:SetPoint("TOPLEFT", 5, -5)
    AZPReadyCheckButton.contentText:SetPoint("CENTER", 0, -1)
    AZPReadyCheckButton:SetScript("OnClick", function() DoReadyCheck() end )

    local PullButton = CreateFrame("Button", nil, ModuleStats["Frames"]["InstanceLeading"], "UIPanelButtonTemplate")
    PullButton.contentText = PullButton:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
    PullButton.contentText:SetText("Pull!")
    PullButton:SetWidth("100")
    PullButton:SetHeight("25")
    PullButton.contentText:SetWidth("100")
    PullButton.contentText:SetHeight("15")
    PullButton:SetPoint("TOPLEFT", 5, -30)
    PullButton.contentText:SetPoint("CENTER", 0, -1)
    PullButton:SetScript("OnClick", function() C_ChatInfo.SendAddonMessage("D4", ("PT\t%d\t%d"):format(10,-1), "RAID"); end )

    local CancelPullButton = CreateFrame("Button", nil, ModuleStats["Frames"]["InstanceLeading"], "UIPanelButtonTemplate")
    CancelPullButton.contentText = CancelPullButton:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
    CancelPullButton.contentText:SetText("Cancel Pull!")
    CancelPullButton:SetWidth("100")
    CancelPullButton:SetHeight("25")
    CancelPullButton.contentText:SetWidth("100")
    CancelPullButton.contentText:SetHeight("15")
    CancelPullButton:SetPoint("TOPLEFT", 5, -55)
    CancelPullButton.contentText:SetPoint("CENTER", 0, -1)
    CancelPullButton:SetScript("OnClick", 
        function()
            C_ChatInfo.SendAddonMessage("D4", ("PT\t%d\t%d"):format(0,-1), "RAID")
            SendChatMessage("PULL CANCELLED, HAKUNA YOUR TATA'S!" ,"RAID_WARNING")
        end )

    local ShortBreakButton = CreateFrame("Button", nil, ModuleStats["Frames"]["InstanceLeading"], "UIPanelButtonTemplate")
    ShortBreakButton.contentText = ShortBreakButton:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
    ShortBreakButton.contentText:SetText("5m Break!")
    ShortBreakButton:SetWidth("100")
    ShortBreakButton:SetHeight("25")
    ShortBreakButton.contentText:SetWidth("100")
    ShortBreakButton.contentText:SetHeight("15")
    ShortBreakButton:SetPoint("TOPLEFT", 5, -80)
    ShortBreakButton.contentText:SetPoint("CENTER", 0, -1)
    ShortBreakButton:SetScript("OnClick",
        function()
            DBM:CreatePizzaTimer(300, "Break Time!", true)
            SendChatMessage("5 MINUTE BREAK HAS STARTED!" ,"RAID_WARNING")
        end )

    local CombatLoggingButton = CreateFrame("Button", nil, ModuleStats["Frames"]["InstanceLeading"], "UIPanelButtonTemplate")
    CombatLoggingButton.contentText = CombatLoggingButton:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
    CombatLoggingButton.contentText:SetText("Combat Log!")
    CombatLoggingButton:SetWidth("100")
    CombatLoggingButton:SetHeight("25")
    CombatLoggingButton.contentText:SetWidth("100")
    CombatLoggingButton.contentText:SetHeight("15")
    CombatLoggingButton:SetPoint("TOPLEFT", 5, -105)
    CombatLoggingButton.contentText:SetPoint("CENTER", 0, -1)
    CombatLoggingButton:SetScript("OnClick", function() addonMain:ToggleCombatLog() end )

    addonMain:ChangeOptionsText()

    if AutoAssistCommand == nil then AutoAssistCommand = "" end
    if AutoInviteCommand == nil then AutoInviteCommand = "" end

    
    if AIUSavedRaidPresence == nil then
        AIUSavedRaidPresence = {};
    end
end

function AZP.IU.OnEvent:InstanceLeading(event, ...)
    if event == "CHAT_MSG_WHISPER" then
        local msgText, msgSender = ...
        if #AutoInviteCommand > 0 and string.match(string.lower(msgText), string.lower(AutoInviteCommand)) then
            C_PartyInfo.InviteUnit(msgSender)
        end
    elseif event == "CHAT_MSG_BN_WHISPER" then
        local msgText, _, _, _, _, _, _, _, _, _, _, _, friendIndex = ...
        if #AutoInviteCommand > 0 and string.match(string.lower(msgText), string.lower(AutoInviteCommand)) then
            local accountInfo = C_BattleNet.GetAccountInfoByID(friendIndex)
            if accountInfo ~= nil then
                local charName = accountInfo.gameAccountInfo.characterName
                local serverName = accountInfo.gameAccountInfo.realmName
                C_PartyInfo.InviteUnit(charName .. "-" .. serverName)
            end
        end
    elseif event == "GROUP_ROSTER_UPDATE" then
        if UnitIsGroupLeader("player") and IsInRaid() then
            local text = AZPAutoAssistEditBox:GetText()
            local names = addonMain:splitCharacterNames(text)
            table.foreach(names, function(_, name)
                if UnitIsGroupAssistant(name) == false then
                    PromoteToAssistant(name)
                end
            end)
        end
    elseif event == "ENCOUNTER_START" then
        encounterID, encounterName, difficultyID, groupSize = ...

        for i, encounter in ipairs(encounters) do
            if encounterID == encounter.id then
                addonMain:SaveRaidPresence(encounterID)
            end
        end
    end
end

function addonMain:ToggleCombatLog()
    if LoggingCombat() == false then
        LoggingCombat(1)
        print("Starting Combat Logging!")
    elseif LoggingCombat() == true then
        LoggingCombat(nil)
        print("Stopping Combat Logging!")
    end

end

function addonMain:splitCharacterNames(input)
    local names = {}
    local inputLen = #input
    local index = 1
    while index < inputLen do
        local _, matchEnd = string.find(input, ",?([^,]+),?", index)
        local assistName = string.match(input, ",?([^,]+),?", index)
        index = matchEnd + 1
        table.insert(names, assistName)
    end
    return names
end

function addonMain:SaveRaidPresence(encounterID)
    local saveDate = date("%Y/%m/%d %H:%M")
    print("Save Raid Presence on " .. saveDate)
     
    local raidMembers = GetNumGroupMembers()
    print(string.format("Currently in a raid with %d players", raidMembers))

    local newRaidPresence = {}
    newRaidPresence.date = saveDate
    newRaidPresence.encounterID = encounterID
    newRaidPresence.attendees = {}

    for i=1,raidMembers do
        local name, realm = UnitName(string.format("raid%d", i))
        print(name, realm or GetRealmName())
        newRaidPresence.attendees[i] = string.format("%s-%s", name, realm or GetRealmName())
    end

    AIUSavedRaidPresence[#AIUSavedRaidPresence + 1] = newRaidPresence
end

function addonMain:ExportRaidPresence()
    print("Export Raid Presence")

    local exportString = ""
    for i, presence in ipairs(AIUSavedRaidPresence) do
        -- Fetch the name of the encounter.
        local encounterName = "Manual Saved"
        local raidName = "Manual Saved"
        for i,encounter in ipairs(AIU.encounters) do
            if encounter.id == presence.encounterID then
                encounterName = encounter.name
                raidName = encounter.raid
            end
        end
        exportString = exportString .. string.format("\"%s\",\"%s\",\"%s\",%s\n", presence.date, raidName, encounterName, table.concat(presence.attendees, ","))
    end

    if InstanceUtilityPresenceExportFrame ~= nil then
        InstanceUtilityPresenceExportFrame:Hide() 
        InstanceUtilityPresenceExportFrame:SetParent(nil) 
    end

    InstanceUtilityPresenceExportFrame = CreateFrame("FRAME", "InstanceUtilityPresenceExportFrame", UIParent, "BackdropTemplate")
    InstanceUtilityPresenceExportFrame:SetPoint("CENTER", 0, 0)
    InstanceUtilityPresenceExportFrame:SetScript("OnEvent", function(...) addonMain:OnEvent(...) end)
    InstanceUtilityPresenceExportFrame:SetSize(365, 255)
    InstanceUtilityPresenceExportFrame:SetBackdrop({
        bgFile = "Interface/Tooltips/UI-Tooltip-Background",
        edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
        edgeSize = 12,
        insets = { left = 1, right = 1, top = 1, bottom = 1 },
    })
    InstanceUtilityPresenceExportFrame:SetBackdropColor(0.5, 0.5, 0.5, 0.75)

    InstanceUtilityPresenceTitleFrame = CreateFrame("Frame", nil, InstanceUtilityPresenceExportFrame, "BackdropTemplate")
    InstanceUtilityPresenceTitleFrame:SetHeight("20")
    InstanceUtilityPresenceTitleFrame:SetWidth(InstanceUtilityPresenceExportFrame:GetWidth())
    InstanceUtilityPresenceTitleFrame:SetBackdrop({
        bgFile = "Interface/Tooltips/UI-Tooltip-Background",
        edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
        edgeSize = 12,
        insets = { left = 1, right = 1, top = 1, bottom = 1 },
    })
    InstanceUtilityPresenceTitleFrame:SetBackdropColor(0.3, 0.3, 0.3, 1)
    InstanceUtilityPresenceTitleFrame:SetPoint("TOP", "InstanceUtilityPresenceExportFrame", 0, 0)
    InstanceUtilityPresenceTitleFrame.contentText = InstanceUtilityPresenceTitleFrame:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
    InstanceUtilityPresenceTitleFrame.contentText:SetWidth(InstanceUtilityPresenceTitleFrame:GetWidth())
    InstanceUtilityPresenceTitleFrame.contentText:SetHeight(InstanceUtilityPresenceTitleFrame:GetHeight())
    InstanceUtilityPresenceTitleFrame.contentText:SetPoint("CENTER", 0, -1)
    InstanceUtilityPresenceTitleFrame.contentText:SetText("\124cFF00FFFF Select text and copy paste \124r")

    local IUAddonFrameCloseButton = CreateFrame("Button", nil, InstanceUtilityPresenceTitleFrame, "UIPanelCloseButton")
    IUAddonFrameCloseButton:SetWidth(InstanceUtilityPresenceTitleFrame:GetHeight() + 3)
    IUAddonFrameCloseButton:SetHeight(InstanceUtilityPresenceTitleFrame:GetHeight() + 4)
    IUAddonFrameCloseButton:SetPoint("TOPRIGHT", InstanceUtilityPresenceTitleFrame, "TOPRIGHT", 2, 2)
    IUAddonFrameCloseButton:SetScript("OnClick", function() 
        InstanceUtilityPresenceExportFrame:Hide() 
        InstanceUtilityPresenceExportFrame:SetParent(nil) 
    end )

    local textScrollFrame = CreateFrame("ScrollFrame", nil, InstanceUtilityPresenceExportFrame, "UIPanelScrollFrameTemplate")
    textScrollFrame:SetSize(300, 230)
    textScrollFrame:SetPoint("TOPLEFT", 25, -25)

    local editbox = CreateFrame("EditBox", nil, textScrollFrame)
    editbox:SetMultiLine(true)
    editbox:SetFontObject(ChatFontNormal)
    editbox:SetWidth(300)
    editbox:SetText(exportString)
    textScrollFrame:SetScrollChild(editbox)
    editbox:HighlightText()
end

function addonMain:ClearRaidPresence()
    print("Clear Raid Presence")

    AIUSavedRaidPresence = {};
end

function addonMain:ChangeOptionsText()
    InstanceLeadingSubPanelPHTitle:Hide()
    InstanceLeadingSubPanelPHText:Hide()
    InstanceLeadingSubPanelPHTitle:SetParent(nil)
    InstanceLeadingSubPanelPHText:SetParent(nil)

    local InstanceLeadingSubPanelHeader = InstanceLeadingSubPanel:CreateFontString("InstanceLeadingSubPanelHeader", "ARTWORK", "GameFontNormalHuge")
    InstanceLeadingSubPanelHeader:SetText(promo)
    InstanceLeadingSubPanelHeader:SetWidth(InstanceLeadingSubPanel:GetWidth())
    InstanceLeadingSubPanelHeader:SetHeight(InstanceLeadingSubPanel:GetHeight())
    InstanceLeadingSubPanelHeader:SetPoint("TOP", 0, -10)

    local AZPAutoInviteLabel = CreateFrame("Frame", "AZPAutoInviteLabel", InstanceLeadingSubPanel)
    AZPAutoInviteLabel:SetSize(500, 15)
    AZPAutoInviteLabel:SetPoint("TOPLEFT", 25, -50)
    AZPAutoInviteLabel.contentText = AZPAutoInviteLabel:CreateFontString("AZPAutoInviteLabel", "ARTWORK", "GameFontNormalLarge")
    AZPAutoInviteLabel.contentText:SetPoint("TOPLEFT")
    AZPAutoInviteLabel.contentText:SetText("Auto Invite Command")

    local AZPAutoInviteEditBox = CreateFrame("EditBox", "AZPAutoInviteEditBox", InstanceLeadingSubPanel, "InputBoxTemplate")
    AZPAutoInviteEditBox:SetSize(150, 35)
    AZPAutoInviteEditBox:SetWidth(150)
    AZPAutoInviteEditBox:SetPoint("TOPLEFT", 25, -65)
    AZPAutoInviteEditBox:SetAutoFocus(false)
    AZPAutoInviteEditBox:SetScript("OnEditFocusLost", function() AutoInviteCommand = AZPAutoInviteEditBox:GetText() end)
    InstanceLeadingSubPanel:SetScript("OnShow", function()
        AZPAutoInviteEditBox:SetText(AutoInviteCommand)
    end)
    AZPAutoInviteEditBox:SetFrameStrata("DIALOG")
    AZPAutoInviteEditBox:SetMaxLetters(100)
    AZPAutoInviteEditBox:SetFontObject("ChatFontNormal")

    local AZPAutoAssistLabel = CreateFrame("Frame", "AZPAutoAssistLabel", InstanceLeadingSubPanel)
    AZPAutoAssistLabel:SetSize(500, 15)
    AZPAutoAssistLabel:SetPoint("TOPLEFT", 25, -150)
    AZPAutoAssistLabel.contentText = AZPAutoAssistLabel:CreateFontString("AZPAutoAssistLabel", "ARTWORK", "GameFontNormalLarge")
    AZPAutoAssistLabel.contentText:SetPoint("TOPLEFT")
    AZPAutoAssistLabel.contentText:SetText("Auto Promote Assistant (Add characters as: 'CharName-ServerName', split multiple chars by a comma ',' ).")

    local AZPAutoAssistEditBox = CreateFrame("EditBox", "AZPAutoAssistEditBox", InstanceLeadingSubPanel, "InputBoxTemplate")
    AZPAutoAssistEditBox:SetSize(150, 35)
    AZPAutoAssistEditBox:SetWidth(150)
    AZPAutoAssistEditBox:SetPoint("TOPLEFT", 25, -165)
    AZPAutoAssistEditBox:SetAutoFocus(false)
    AZPAutoAssistEditBox:SetScript("OnEditFocusLost", function() AutoAssistCommand = AZPAutoAssistEditBox:GetText() end)
    InstanceLeadingSubPanel:SetScript("OnShow", function()
        AZPAutoAssistEditBox:SetText(AutoAssistCommand)
    end)
    AZPAutoAssistEditBox:SetFrameStrata("DIALOG")
    AZPAutoAssistEditBox:SetMaxLetters(100)
    AZPAutoAssistEditBox:SetFontObject("ChatFontNormal")
end
