if AZP == nil then AZP = {} end
if AZP.VersionControl == nil then AZP.VersionControl = {} end
if AZP.OnLoad == nil then AZP.OnLoad = {} end
if AZP.OnEvent == nil then AZP.OnEvent = {} end
if AZP.OnEvent == nil then AZP.OnEvent = {} end

AZP.VersionControl.InstanceLeadership = 18
if AZP.InstanceLeadership == nil then AZP.InstanceLeadership = {} end

local dash = " - "
local name = "Instance Leadership"
local nameFull = ("AzerPUG " .. name)
local promo = (nameFull .. dash ..  AZP.VersionControl.InstanceLeadership)

local AZPIUPresenceEditBox
local AZPIUPresenceScrollFrame
local AZPIUVersionRequestEditBox
local AZPIUVersionRequestScrollFrame

local AZPILSelfOptionPanel = nil
InstanceLeadingSelfFrame = nil

local optionHeader = "|cFF00FFFFInstance Leadership|r"


function AZP.InstanceLeadership:OnLoadBoth(inputFrame)
    C_ChatInfo.RegisterAddonMessagePrefix("AZPRESPONSE")

    local AZPReadyCheckButton = CreateFrame("Button", nil, inputFrame, "UIPanelButtonTemplate")
    AZPReadyCheckButton.contentText = AZPReadyCheckButton:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
    AZPReadyCheckButton.contentText:SetText("Ready Check!")
    AZPReadyCheckButton:SetWidth("100")
    AZPReadyCheckButton:SetHeight("25")
    AZPReadyCheckButton.contentText:SetWidth("100")
    AZPReadyCheckButton.contentText:SetHeight("15")
    AZPReadyCheckButton:SetPoint("TOPLEFT", 5, -5)
    AZPReadyCheckButton.contentText:SetPoint("CENTER", 0, -1)
    AZPReadyCheckButton:SetScript("OnClick", function() DoReadyCheck() end )

    local PullButton = CreateFrame("Button", nil, inputFrame, "UIPanelButtonTemplate")
    PullButton.contentText = PullButton:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
    PullButton.contentText:SetText("Pull!")
    PullButton:SetWidth("100")
    PullButton:SetHeight("25")
    PullButton.contentText:SetWidth("100")
    PullButton.contentText:SetHeight("15")
    PullButton:SetPoint("TOPLEFT", 5, -30)
    PullButton.contentText:SetPoint("CENTER", 0, -1)
    PullButton:SetScript("OnClick", function() C_ChatInfo.SendAddonMessage("D4", ("PT\t%d\t%d"):format(10,-1), "RAID"); end )

    local CancelPullButton = CreateFrame("Button", nil, inputFrame, "UIPanelButtonTemplate")
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

    local ShortBreakButton = CreateFrame("Button", nil, inputFrame, "UIPanelButtonTemplate")
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

    local CombatLoggingButton = CreateFrame("Button", nil, inputFrame, "UIPanelButtonTemplate")
    CombatLoggingButton.contentText = CombatLoggingButton:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
    CombatLoggingButton.contentText:SetText("Combat Log!")
    CombatLoggingButton:SetWidth("100")
    CombatLoggingButton:SetHeight("25")
    CombatLoggingButton.contentText:SetWidth("100")
    CombatLoggingButton.contentText:SetHeight("15")
    CombatLoggingButton:SetPoint("TOPLEFT", 5, -105)
    CombatLoggingButton.contentText:SetPoint("CENTER", 0, -1)
    CombatLoggingButton:SetScript("OnClick", function() AZP.InstanceLeadership:ToggleCombatLog() end )

    local AZPSavePresenceButton = CreateFrame("Button", nil, inputFrame, "UIPanelButtonTemplate")
    AZPSavePresenceButton.contentText = AZPSavePresenceButton:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
    AZPSavePresenceButton.contentText:SetText("Save Raid Presence")
    AZPSavePresenceButton:SetWidth("100")
    AZPSavePresenceButton:SetHeight("25")
    AZPSavePresenceButton.contentText:SetWidth("100")
    AZPSavePresenceButton.contentText:SetHeight("15")
    AZPSavePresenceButton:SetPoint("TOPLEFT", 5, -130)
    AZPSavePresenceButton.contentText:SetPoint("CENTER", 0, -1)
    AZPSavePresenceButton:SetScript("OnClick", function() AZP.InstanceLeadership:SaveRaidPresence(nil, GetRaidDifficultyID()) end )

    local AZPExportPresenceButton = CreateFrame("Button", nil, inputFrame, "UIPanelButtonTemplate")
    AZPExportPresenceButton.contentText = AZPExportPresenceButton:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
    AZPExportPresenceButton.contentText:SetText("Raid Presence")
    AZPExportPresenceButton:SetWidth("100")
    AZPExportPresenceButton:SetHeight("25")
    AZPExportPresenceButton.contentText:SetWidth("100")
    AZPExportPresenceButton.contentText:SetHeight("15")
    AZPExportPresenceButton:SetPoint("TOPLEFT", 5, -155)
    AZPExportPresenceButton.contentText:SetPoint("CENTER", 0, -1)
    AZPExportPresenceButton:SetScript(
        "OnClick", function()
            if InstanceUtilityPresenceExportFrame:IsShown() then
                InstanceUtilityPresenceExportFrame:Hide()
            else
                InstanceUtilityPresenceExportFrame:Show()
                AZP.InstanceLeadership:ExportRaidPresence()
            end
        end )

    local AZPRequestAddonVersions = CreateFrame("Button", nil, inputFrame, "UIPanelButtonTemplate")
    AZPRequestAddonVersions.contentText = AZPRequestAddonVersions:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
    AZPRequestAddonVersions.contentText:SetText("Request Versions")
    AZPRequestAddonVersions:SetWidth("100")
    AZPRequestAddonVersions:SetHeight("25")
    AZPRequestAddonVersions.contentText:SetWidth("100")
    AZPRequestAddonVersions.contentText:SetHeight("15")
    AZPRequestAddonVersions:SetPoint("TOPLEFT", 5, -180)
    AZPRequestAddonVersions.contentText:SetPoint("CENTER", 0, -1)
    AZPRequestAddonVersions:SetScript(
        "OnClick", function()
            InstanceUtilityVersionRequestFrame:Show()
            AZPIUVersionRequestEditBox:SetText("CharacterName - Checklist - Readycheck - InstanceLeadership - GreatVault - ManaGement\n")
            C_ChatInfo.SendAddonMessage("AZPREQUEST", "RequestAddonVersions" ,"RAID", 1)
        end )

    local InstanceUtilityPresenceExportFrame = CreateFrame("FRAME", "InstanceUtilityPresenceExportFrame", UIParent, "BackdropTemplate")
    InstanceUtilityPresenceExportFrame:SetPoint("CENTER", 0, 0)
    InstanceUtilityPresenceExportFrame:SetScript("OnEvent", function(...) AZP.InstanceLeadership:OnEvent(...) end)
    InstanceUtilityPresenceExportFrame:SetSize(400, 300)
    InstanceUtilityPresenceExportFrame:SetBackdrop({
        bgFile = "Interface/Tooltips/UI-Tooltip-Background",
        edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
        edgeSize = 12,
        insets = { left = 1, right = 1, top = 1, bottom = 1 },
    })
    InstanceUtilityPresenceExportFrame:SetBackdropColor(0.5, 0.5, 0.5, 0.75)
    InstanceUtilityPresenceExportFrame:Hide()

    local InstanceUtilityPresenceTitleFrame = CreateFrame("Frame", nil, InstanceUtilityPresenceExportFrame, "BackdropTemplate")
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
    IUAddonFrameCloseButton:SetScript("OnClick", function() InstanceUtilityPresenceExportFrame:Hide() end )

    AZPIUPresenceScrollFrame = CreateFrame("ScrollFrame", nil, InstanceUtilityPresenceExportFrame, "UIPanelScrollFrameTemplate")
    AZPIUPresenceScrollFrame:SetSize(300, 230)
    AZPIUPresenceScrollFrame:SetPoint("TOPLEFT", 25, -25)

    AZPIUPresenceEditBox = CreateFrame("EditBox", AZPIUPresenceScrollFrame)
    AZPIUPresenceEditBox:SetMultiLine(true)
    AZPIUPresenceEditBox:SetFontObject(ChatFontNormal)
    AZPIUPresenceEditBox:SetWidth(300)
    AZPIUPresenceScrollFrame:SetScrollChild(AZPIUPresenceEditBox)


    local InstanceUtilityVersionRequestFrame = CreateFrame("FRAME", "InstanceUtilityVersionRequestFrame", UIParent, "BackdropTemplate")
    InstanceUtilityVersionRequestFrame:SetPoint("CENTER", 0, 0)
    InstanceUtilityVersionRequestFrame:SetScript("OnEvent", function(...) AZP.InstanceLeadership:OnEvent(...) end)
    InstanceUtilityVersionRequestFrame:SetSize(700, 300)
    InstanceUtilityVersionRequestFrame:SetBackdrop({
        bgFile = "Interface/Tooltips/UI-Tooltip-Background",
        edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
        edgeSize = 12,
        insets = { left = 1, right = 1, top = 1, bottom = 1 },
    })
    InstanceUtilityVersionRequestFrame:SetBackdropColor(0.5, 0.5, 0.5, 0.75)
    InstanceUtilityVersionRequestFrame:Hide()

    local CloseButton = CreateFrame("Button", nil, InstanceUtilityVersionRequestFrame, "UIPanelCloseButton")
    CloseButton:SetWidth(InstanceUtilityPresenceTitleFrame:GetHeight() + 3)
    CloseButton:SetHeight(InstanceUtilityPresenceTitleFrame:GetHeight() + 4)
    CloseButton:SetPoint("TOPRIGHT", InstanceUtilityPresenceTitleFrame, "TOPRIGHT", 2, 2)
    CloseButton:SetScript("OnClick", function() InstanceUtilityVersionRequestFrame:Hide() end )

    AZPIUVersionRequestScrollFrame = CreateFrame("ScrollFrame", nil, InstanceUtilityVersionRequestFrame, "UIPanelScrollFrameTemplate")
    AZPIUVersionRequestScrollFrame:SetSize(600, 230)
    AZPIUVersionRequestScrollFrame:SetPoint("TOPLEFT", 25, -25)

    AZPIUVersionRequestEditBox = CreateFrame("EditBox", nil, AZPIUPresenceScrollFrame)
    AZPIUVersionRequestEditBox:SetMultiLine(true)
    AZPIUVersionRequestEditBox:SetFontObject(ChatFontNormal)
    AZPIUVersionRequestEditBox:SetWidth(600)
    AZPIUVersionRequestScrollFrame:SetScrollChild(AZPIUVersionRequestEditBox)


    local AZPClearPresenceButton = CreateFrame("Button", nil, InstanceUtilityPresenceExportFrame, "UIPanelButtonTemplate")
    AZPClearPresenceButton.contentText = AZPClearPresenceButton:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
    AZPClearPresenceButton.contentText:SetText("Clear Raid Presence")
    AZPClearPresenceButton:SetWidth("100")
    AZPClearPresenceButton:SetHeight("25")
    AZPClearPresenceButton.contentText:SetWidth("100")
    AZPClearPresenceButton.contentText:SetHeight("15")
    AZPClearPresenceButton:SetPoint("TOPLEFT", 5, -250)
    AZPClearPresenceButton.contentText:SetPoint("CENTER", 0, -1)
    AZPClearPresenceButton:SetScript("OnClick", function() AZP.InstanceLeadership:ClearRaidPresence() end )

    if AutoAssistCommand == nil then AutoAssistCommand = "" end
    if AutoInviteCommand == nil then AutoInviteCommand = "" end

    if AZPILSavedRaidPresence == nil then
        AZPILSavedRaidPresence = {};
    end
end

function AZP.InstanceLeadership:OnLoadCore()
    AZP.Core:RegisterEvents("CHAT_MSG_WHISPER", function(...) AZP.InstanceLeadership:eventChatMsgWhisper(...) end)
    AZP.Core:RegisterEvents("CHAT_MSG_BN_WHISPER", function(...) AZP.InstanceLeadership:eventChatMsgBnWhisper(...) end)
    AZP.Core:RegisterEvents("GROUP_ROSTER_UPDATE", function(...) AZP.InstanceLeadership:eventGroupRosterUpdate(...) end)
    AZP.Core:RegisterEvents("ENCOUNTER_START", function(...) AZP.InstanceLeadership:eventEncounterStart(...) end)
    AZP.Core:RegisterEvents("ENCOUNTER_END", function(...) AZP.InstanceLeadership:eventEncounterEnd(...) end)
    AZP.Core:RegisterEvents("CHAT_MSG_ADDON", function(...) AZP.InstanceLeadership:eventChatMsgAddon(...) end)

    AZP.InstanceLeadership:OnLoadBoth(AZP.Core.AddOns.IL.MainFrame)

    AZP.OptionsPanels:Generic("Instance Leadership", optionHeader, function(frame) AZP.InstanceLeadership:FillOptionsPanel(frame) end)
end

function AZP.InstanceLeadership:OnLoadSelf()
    print("OnLoadSelf")
    C_ChatInfo.RegisterAddonMessagePrefix("AZPRESPONSE")

    InstanceLeadingSelfFrame = CreateFrame("Button", nil, UIParent, "BackdropTemplate")
    InstanceLeadingSelfFrame:SetSize(110, 220)
    InstanceLeadingSelfFrame:SetPoint("CENTER", 0, 0)
    InstanceLeadingSelfFrame:SetScript("OnDragStart", InstanceLeadingSelfFrame.StartMoving)
    InstanceLeadingSelfFrame:SetScript("OnDragStop", InstanceLeadingSelfFrame.StopMovingOrSizing)
    InstanceLeadingSelfFrame:RegisterForDrag("LeftButton")
    InstanceLeadingSelfFrame:EnableMouse(true)
    InstanceLeadingSelfFrame:SetMovable(true)
    InstanceLeadingSelfFrame:SetBackdrop({
        bgFile = "Interface/Tooltips/UI-Tooltip-Background",
        edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
        edgeSize = 12,
        insets = { left = 1, right = 1, top = 1, bottom = 1 },
    })
    InstanceLeadingSelfFrame:SetBackdropColor(0.5, 0.5, 0.5, 0.75)

    local IUAddonFrameCloseButton = CreateFrame("Button", nil, InstanceLeadingSelfFrame, "UIPanelCloseButton")
    IUAddonFrameCloseButton:SetSize(20, 21)
    IUAddonFrameCloseButton:SetPoint("TOPRIGHT", InstanceLeadingSelfFrame, "TOPRIGHT", 2, 2)
    IUAddonFrameCloseButton:SetScript("OnClick", function() InstanceLeadingSelfFrame:Hide() end )

    InstanceLeadingSelfFrame:RegisterEvent("CHAT_MSG_WHISPER")
    InstanceLeadingSelfFrame:RegisterEvent("CHAT_MSG_BN_WHISPER")
    InstanceLeadingSelfFrame:RegisterEvent("GROUP_ROSTER_UPDATE")
    InstanceLeadingSelfFrame:RegisterEvent("ENCOUNTER_START")
    InstanceLeadingSelfFrame:RegisterEvent("ENCOUNTER_END")
    InstanceLeadingSelfFrame:RegisterEvent("CHAT_MSG_ADDON")

    AZPILSelfOptionPanel = CreateFrame("FRAME", nil)
    AZPILSelfOptionPanel.name = optionHeader
    InterfaceOptions_AddCategory(AZPILSelfOptionPanel)
    AZPILSelfOptionPanel.header = AZPILSelfOptionPanel:CreateFontString(nil, "ARTWORK", "GameFontNormalHuge")
    AZPILSelfOptionPanel.header:SetPoint("TOP", 0, -10)
    AZPILSelfOptionPanel.header:SetText("|cFF00FFFFAzerPUG's Instance Leadership Options!|r")

    AZPILSelfOptionPanel.footer = AZPILSelfOptionPanel:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
    AZPILSelfOptionPanel.footer:SetPoint("TOP", 0, -300)
    AZPILSelfOptionPanel.footer:SetText(
        "|cFF00FFFFAzerPUG Links:\n" ..
        "Website: www.azerpug.com\n" ..
        "Discord: www.azerpug.com/discord\n" ..
        "Twitch: www.twitch.tv/azerpug\n|r"
    )

    AZP.InstanceLeadership:FillOptionsPanel(AZPILSelfOptionPanel)
    AZP.InstanceLeadership:OnLoadBoth(InstanceLeadingSelfFrame)
    --AZP.InstanceLeadership:ShareVersion()
end

function AZP.InstanceLeadership:FillOptionsPanel(frameToFill)
    local AZPAutoInviteLabel = CreateFrame("Frame", "AZPAutoInviteLabel", frameToFill)
    AZPAutoInviteLabel:SetSize(500, 15)
    AZPAutoInviteLabel:SetPoint("TOPLEFT", 25, -50)
    AZPAutoInviteLabel.contentText = AZPAutoInviteLabel:CreateFontString("AZPAutoInviteLabel", "ARTWORK", "GameFontNormalLarge")
    AZPAutoInviteLabel.contentText:SetPoint("TOPLEFT")
    AZPAutoInviteLabel.contentText:SetText("Auto Invite Command")

    local AZPAutoInviteEditBox = CreateFrame("EditBox", "AZPAutoInviteEditBox", frameToFill, "InputBoxTemplate")
    AZPAutoInviteEditBox:SetSize(150, 35)
    AZPAutoInviteEditBox:SetWidth(150)
    AZPAutoInviteEditBox:SetPoint("TOPLEFT", 25, -65)
    AZPAutoInviteEditBox:SetAutoFocus(false)
    AZPAutoInviteEditBox:SetScript("OnEditFocusLost", function() AutoInviteCommand = AZPAutoInviteEditBox:GetText() end)
    AZPAutoInviteEditBox:SetFrameStrata("DIALOG")
    AZPAutoInviteEditBox:SetMaxLetters(100)
    AZPAutoInviteEditBox:SetFontObject("ChatFontNormal")

    local AZPAutoAssistLabel = CreateFrame("Frame", "AZPAutoAssistLabel", frameToFill)
    AZPAutoAssistLabel:SetSize(500, 15)
    AZPAutoAssistLabel:SetPoint("TOPLEFT", 25, -150)
    AZPAutoAssistLabel.contentText = AZPAutoAssistLabel:CreateFontString("AZPAutoAssistLabel", "ARTWORK", "GameFontNormalLarge")
    AZPAutoAssistLabel.contentText:SetPoint("TOPLEFT")
    AZPAutoAssistLabel.contentText:SetText("Auto Promote Assistant (Add characters as: 'CharName-ServerName', split multiple chars by a comma ',' ).")

    local AZPAutoAssistEditBox = CreateFrame("EditBox", "AZPAutoAssistEditBox", frameToFill, "InputBoxTemplate")
    AZPAutoAssistEditBox:SetSize(150, 35)
    AZPAutoAssistEditBox:SetWidth(150)
    AZPAutoAssistEditBox:SetPoint("TOPLEFT", 25, -165)
    AZPAutoAssistEditBox:SetAutoFocus(false)
    AZPAutoAssistEditBox:SetScript("OnEditFocusLost", function() AutoAssistCommand = AZPAutoAssistEditBox:GetText() end)
    AZPAutoAssistEditBox:SetFrameStrata("DIALOG")
    AZPAutoAssistEditBox:SetMaxLetters(100)
    AZPAutoAssistEditBox:SetFontObject("ChatFontNormal")

    frameToFill:SetScript("OnShow", function()
        AZPAutoInviteEditBox:SetText(AutoInviteCommand)
        AZPAutoAssistEditBox:SetText(AutoAssistCommand)
    end)
    frameToFill:Hide()
end

function AZP.InstanceLeadership:eventChatMsgWhisper(...)
    local msgText, msgSender = ...
    if #AutoInviteCommand > 0 and string.match(string.lower(msgText), string.lower(AutoInviteCommand)) then
        C_PartyInfo.InviteUnit(msgSender)
    end
end

function AZP.InstanceLeadership:eventChatMsgBnWhisper(...)
    local msgText, _, _, _, _, _, _, _, _, _, _, _, friendIndex = ...
    if #AutoInviteCommand > 0 and string.match(string.lower(msgText), string.lower(AutoInviteCommand)) then
        local accountInfo = C_BattleNet.GetAccountInfoByID(friendIndex)
        if accountInfo ~= nil then
            local charName = accountInfo.gameAccountInfo.characterName
            local serverName = accountInfo.gameAccountInfo.realmName
            C_PartyInfo.InviteUnit(charName .. "-" .. serverName)
        end
    end
end

function AZP.InstanceLeadership:eventGroupRosterUpdate(...)
    local encounterID, encounterName, difficultyID, groupSize = ...
    for i, encounter in ipairs(AZP.InstanceLeadership.Encounters) do
        if encounterID == encounter.id then
            AZP.InstanceLeadership:SaveRaidPresence(encounterID, difficultyID)
        end
    end
end

function AZP.InstanceLeadership:eventEncounterStart(...)
    local encounterID, encounterName, difficultyID, groupSize = ...
    for i, encounter in ipairs(AZP.InstanceLeadership.Encounters) do
        if encounterID == encounter.id then
            AZP.InstanceLeadership:SaveRaidPresence(encounterID, difficultyID)
        end
    end
end

function AZP.InstanceLeadership:eventEncounterEnd(...)
    local encounterID, encounterName, difficultyID, groupSize, success = ...
    for i, encounter in ipairs(AZP.InstanceLeadership.Encounters) do
        if encounterID == encounter.id then
            AZP.InstanceLeadership:FinishRaidPresense(encounterID, success)
        end
    end
end

function AZP.InstanceLeadership:eventChatMsgAddon(...)
    local prefix, payload, _, sender = ...
    if prefix == "AZPRESPONSE" then
        local text = AZPIUVersionRequestEditBox:GetText()
        local pattern = "|([A-Z]+):([0-9]+)|"
        local index = 1
        local versions = {-1, -1, -1, -1, -1}
        while index < #payload do
            local _, endPos = string.find(payload, pattern, index)
            local addon, version = string.match(payload, pattern, index)
            index = endPos + 1
            versions[AZP.InstanceLeadership.VersionRequest[addon].Position] = version
        end
        text = text .. string.format("%s: %s\n", sender, table.concat(versions, " - "))
        AZPIUVersionRequestEditBox:SetText(text)
    end
end

function AZP.OnEvent:InstanceLeadership(event, ...)
    if event == "CHAT_MSG_WHISPER" then
        AZP.InstanceLeadership:eventChatMsgWhisper(...)
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
            local text = AutoAssistCommand
            local names = AZP.InstanceLeadership:splitCharacterNames(text)
            for _, promoteName in ipairs(names) do
                promoteName = strsplit("-", promoteName)
                if UnitIsGroupAssistant(promoteName) == false then
                    PromoteToAssistant(promoteName)
                end
            end
        end
    elseif event == "ENCOUNTER_START" then
        local encounterID, encounterName, difficultyID, groupSize = ...
        for i, encounter in ipairs(AZP.InstanceLeadership.Encounters) do
            if encounterID == encounter.id then
                AZP.InstanceLeadership:SaveRaidPresence(encounterID, difficultyID)
            end
        end
    elseif event == "ENCOUNTER_END" then
        local encounterID, encounterName, difficultyID, groupSize, success = ...
        for i, encounter in ipairs(AZP.InstanceLeadership.Encounters) do
            if encounterID == encounter.id then
                AZP.InstanceLeadership:FinishRaidPresense(encounterID, success)
            end
        end
    elseif event == "CHAT_MSG_ADDON" then
        local prefix, payload, _, sender = ...
        if prefix == "AZPRESPONSE" then
            local text = AZPIUVersionRequestEditBox:GetText()
            local pattern = "|([A-Z]+):([0-9]+)|"
            local index = 1
            local versions = {-1, -1, -1, -1, -1}
            while index < #payload do
                local _, endPos = string.find(payload, pattern, index)
                local addon, version = string.match(payload, pattern, index)
                index = endPos + 1
                versions[AZP.InstanceLeadership.VersionRequest[addon].Position] = version
            end
            text = text .. string.format("%s: %s\n", sender, table.concat(versions, " - "))
            AZPIUVersionRequestEditBox:SetText(text)
        end
    end
end

function AZP.InstanceLeadership:ToggleCombatLog()
    if LoggingCombat() == false then
        LoggingCombat(1)
        print("Starting Combat Logging!")
    elseif LoggingCombat() == true then
        LoggingCombat(nil)
        print("Stopping Combat Logging!")
    end

end

function AZP.InstanceLeadership:splitCharacterNames(input)
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

function AZP.InstanceLeadership:SaveRaidPresence(encounterID, difficultyID)
    local saveDate = date("%Y/%m/%d %H:%M")
    print("Save Raid Presence on " .. saveDate)

    local raidMembers = GetNumGroupMembers()
    print(string.format("Currently in a raid with %d players", raidMembers))

    local difficulty = "Normal"
    local _, _, _, _, displayHeroic, displayMythic = GetDifficultyInfo(difficultyID)
    if displayHeroic then
        difficulty = "Heroic"
    elseif displayMythic then
        difficulty = "Mythic"
    elseif AZP.InstanceLeadership:isLookingForRaidDifficulty() then
        difficulty = "LFR"
    end
    local newRaidPresence = {}
    newRaidPresence.date = saveDate
    newRaidPresence.encounterID = encounterID
    newRaidPresence.succes = nil
    newRaidPresence.difficulty = difficulty
    newRaidPresence.attendees = {}

    for i=1,raidMembers do
        local name, realm = UnitName(string.format("raid%d", i))
        --print(name, realm or GetRealmName())
        newRaidPresence.attendees[i] = string.format("%s-%s", name, realm or GetRealmName())
    end

    AZPILSavedRaidPresence[#AZPILSavedRaidPresence + 1] = newRaidPresence
end

function AZP.InstanceLeadership:isLookingForRaidDifficulty(difficultyID)
    return difficultyID == 17
end

function AZP.InstanceLeadership:FinishRaidPresense(encounterID, succes)
    if AZPILSavedRaidPresence[#AZPILSavedRaidPresence].encounterID == encounterID then
        AZPILSavedRaidPresence[#AZPILSavedRaidPresence].succes = succes
    end
end

function AZP.InstanceLeadership:ExportRaidPresence()
    local exportString = ""
    for i, presence in ipairs(AZPILSavedRaidPresence) do
        local encounterName = "Manual Saved"
        local raidName = "Manual Saved"
        local wipeOrKill = "Wipe"
        local difficulty = presence.difficulty
        for _, encounter in ipairs(AZP.InstanceLeadership.Encounters) do
            if encounter.id == presence.encounterID then
                encounterName = encounter.name
                raidName = encounter.raid
            end
        end
        if presence.succes == 1 then
            wipeOrKill = "Kill"
        end
        if difficulty == nil then
            difficulty = "Unknown difficulty"
        end
        exportString = exportString .. string.format("\"%s\",\"%s\",\"%s\",\"%s\",\"%s\",%s\n", presence.date, raidName, encounterName, difficulty, wipeOrKill, table.concat(presence.attendees, ","))
    end

    AZPIUPresenceEditBox:SetText(exportString)
    AZPIUPresenceEditBox:HighlightText()
end

function AZP.InstanceLeadership:ClearRaidPresence()
    AZPILSavedRaidPresence = {}
    AZPIUPresenceEditBox:SetText("Cleared!")
end

if not IsAddOnLoaded("AzerPUG's Core") then
    AZP.InstanceLeadership:OnLoadSelf()
end