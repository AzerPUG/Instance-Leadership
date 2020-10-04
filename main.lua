local GlobalAddonName, AIU = ...

AZPIUInstanceLeadingVersion = 0.5
local dash = " - "
local name = "InstanceUtility" .. dash .. "InstanceLeading"
local nameFull = ("AzerPUG " .. name)
local promo = (nameFull .. dash ..  AZPIUInstanceLeadingVersion)

local addonMain = LibStub("AceAddon-3.0"):NewAddon("InstanceUtility-InstanceLeading", "AceConsole-3.0")

function AZP.IU.VersionControl:InstanceLeading()
    return AZPIUInstanceLeadingVersion
end

function AZP.IU.OnLoad:InstanceLeading(self)
    InstanceUtilityAddonFrame:RegisterEvent("CHAT_MSG_WHISPER")
    InstanceUtilityAddonFrame:RegisterEvent("CHAT_MSG_BN_WHISPER")
    InstanceUtilityAddonFrame:RegisterEvent("GROUP_ROSTER_UPDATE")

    local AZPReadyCheckButton = CreateFrame("Button", "AZPReadyCheckButton", InstanceUtilityAddonFrame, "UIPanelButtonTemplate")
    AZPReadyCheckButton.contentText = AZPReadyCheckButton:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
    AZPReadyCheckButton.contentText:SetText("Ready Check!")
    AZPReadyCheckButton:SetWidth("100")
    AZPReadyCheckButton:SetHeight("25")
    AZPReadyCheckButton.contentText:SetWidth("100")
    AZPReadyCheckButton.contentText:SetHeight("15")
    AZPReadyCheckButton:SetPoint("TOPLEFT", 5, -125)
    AZPReadyCheckButton.contentText:SetPoint("CENTER", 0, -1)
    AZPReadyCheckButton:SetScript("OnClick", function() DoReadyCheck() end )

    local PullButton = CreateFrame("Button", "PullButton", InstanceUtilityAddonFrame, "UIPanelButtonTemplate")
    PullButton.contentText = PullButton:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
    PullButton.contentText:SetText("Pull!")
    PullButton:SetWidth("100")
    PullButton:SetHeight("25")
    PullButton.contentText:SetWidth("100")
    PullButton.contentText:SetHeight("15")
    PullButton:SetPoint("TOPLEFT", 5, -150)
    PullButton.contentText:SetPoint("CENTER", 0, -1)
    PullButton:SetScript("OnClick", function() C_ChatInfo.SendAddonMessage("D4", ("PT\t%d\t%d"):format(10,-1), "RAID"); end )

    local CancelPullButton = CreateFrame("Button", "CancelPullButton", InstanceUtilityAddonFrame, "UIPanelButtonTemplate")
    CancelPullButton.contentText = CancelPullButton:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
    CancelPullButton.contentText:SetText("Cancel Pull!")
    CancelPullButton:SetWidth("100")
    CancelPullButton:SetHeight("25")
    CancelPullButton.contentText:SetWidth("100")
    CancelPullButton.contentText:SetHeight("15")
    CancelPullButton:SetPoint("TOPLEFT", 5, -175)
    CancelPullButton.contentText:SetPoint("CENTER", 0, -1)
    CancelPullButton:SetScript("OnClick", 
        function()
            C_ChatInfo.SendAddonMessage("D4", ("PT\t%d\t%d"):format(0,-1), "RAID")
            SendChatMessage("PULL CANCELLED, HAKUNA YOUR TATA'S!" ,"RAID_WARNING")
        end )

    local ShortBreakButton = CreateFrame("Button", "ShortBreakButton", InstanceUtilityAddonFrame, "UIPanelButtonTemplate")
    ShortBreakButton.contentText = ShortBreakButton:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
    ShortBreakButton.contentText:SetText("5m Break!")
    ShortBreakButton:SetWidth("100")
    ShortBreakButton:SetHeight("25")
    ShortBreakButton.contentText:SetWidth("100")
    ShortBreakButton.contentText:SetHeight("15")
    ShortBreakButton:SetPoint("TOPLEFT", 5, -200)
    ShortBreakButton.contentText:SetPoint("CENTER", 0, -1)
    ShortBreakButton:SetScript("OnClick",
        function()
            DBM:CreatePizzaTimer(300, "Break Time!", true)
            SendChatMessage("5 MINUTE BREAK HAS STARTED!" ,"RAID_WARNING")
        end )

    local CombatLoggingButton = CreateFrame("Button", "CombatLoggingButton", InstanceUtilityAddonFrame, "UIPanelButtonTemplate")
    CombatLoggingButton.contentText = CombatLoggingButton:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
    CombatLoggingButton.contentText:SetText("Combat Log!")
    CombatLoggingButton:SetWidth("100")
    CombatLoggingButton:SetHeight("25")
    CombatLoggingButton.contentText:SetWidth("100")
    CombatLoggingButton.contentText:SetHeight("15")
    CombatLoggingButton:SetPoint("TOPLEFT", 5, -225)
    CombatLoggingButton.contentText:SetPoint("CENTER", 0, -1)
    CombatLoggingButton:SetScript("OnClick", function() addonMain:ToggleCombatLog() end )

    addonMain:ChangeOptionsText()

    if AutoAssistCommand == nil then AutoAssistCommand = "" end
    if AutoInviteCommand == nil then AutoInviteCommand = "" end
end

function AZP.IU.OnEvent:InstanceLeading(event, ...)
    if event == "CHAT_MSG_WHISPER" then
        local msgText, msgSender = ...
        if msgText == AutoInviteCommand then
            InviteUnit(msgSender)
        end
    elseif event == "CHAT_MSG_BN_WHISPER" then
        local msgText, _, _, _, _, _, _, _, _, _, _, v12, friendIndex = ...
        if msgText == AutoInviteCommand then
            local accountInfo = C_BattleNet.GetAccountInfoByID(friendIndex)
            if accountInfo ~= nil then
                local charName = accountInfo.gameAccountInfo.characterName
                local serverName = accountInfo.gameAccountInfo.realmName
                InviteUnit(charName .. "-" .. serverName)
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
        local name = string.match(input, ",?([^,]+),?", index)
        index = matchEnd + 1
        table.insert(names, name)
    end
    return names
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
