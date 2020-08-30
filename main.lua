local GlobalAddonName, AIU = ...

AZPIUInstanceLeadingVersion = 0.1
local dash = " - "
local name = "InstanceUtility" .. dash .. "InstanceLeading"
local nameFull = ("AzerPUG " .. name)
local promo = (nameFull .. dash ..  AZPIUInstanceLeadingVersion)

local addonMain = LibStub("AceAddon-3.0"):NewAddon("InstanceUtility-InstanceLeading", "AceConsole-3.0")

function VersionControl:InstanceLeadingVC()
    return AZPIUInstanceLeadingVersion
end

function OnLoad:InstanceLeadingOL(self)
    InstanceUtilityAddonFrame:RegisterEvent("CHAT_MSG_WHISPER")
    InstanceUtilityAddonFrame:RegisterEvent("CHAT_MSG_BN_WHISPER")

    local AZPReadyCheckButton = CreateFrame("Button", "AZPReadyCheckButton", InstanceUtilityAddonFrame, "UIPanelButtonTemplate")
    AZPReadyCheckButton.contentText = AZPReadyCheckButton:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
    AZPReadyCheckButton.contentText:SetText("Ready Check!")
    AZPReadyCheckButton:SetWidth("100")
    AZPReadyCheckButton:SetHeight("25")
    AZPReadyCheckButton.contentText:SetWidth("100")
    AZPReadyCheckButton.contentText:SetHeight("15")
    AZPReadyCheckButton:SetPoint("TOP", 125, -125)
    AZPReadyCheckButton.contentText:SetPoint("CENTER", 0, -1)
    AZPReadyCheckButton:SetScript("OnClick", function() DoReadyCheck() end )

    local PullButton = CreateFrame("Button", "PullButton", InstanceUtilityAddonFrame, "UIPanelButtonTemplate")
    PullButton.contentText = PullButton:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
    PullButton.contentText:SetText("Pull!")
    PullButton:SetWidth("100")
    PullButton:SetHeight("25")
    PullButton.contentText:SetWidth("100")
    PullButton.contentText:SetHeight("15")
    PullButton:SetPoint("TOP", 125, -150)
    PullButton.contentText:SetPoint("CENTER", 0, -1)
    PullButton:SetScript("OnClick", function() C_ChatInfo.SendAddonMessage("D4", ("PT\t%d\t%d"):format(10,-1), "RAID"); end )

    local CancelPullButton = CreateFrame("Button", "CancelPullButton", InstanceUtilityAddonFrame, "UIPanelButtonTemplate")
    CancelPullButton.contentText = CancelPullButton:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
    CancelPullButton.contentText:SetText("Cancel Pull!")
    CancelPullButton:SetWidth("100")
    CancelPullButton:SetHeight("25")
    CancelPullButton.contentText:SetWidth("100")
    CancelPullButton.contentText:SetHeight("15")
    CancelPullButton:SetPoint("TOP", 125, -175)
    CancelPullButton.contentText:SetPoint("CENTER", 0, -1)
    CancelPullButton:SetScript("OnClick", 
        function()
            C_ChatInfo.SendAddonMessage("D4", ("PT\t%d\t%d"):format(0,-1), "RAID")
            SendChatMessage("PULL CANCELLED, HAKUNA YOUR TATA'S!" ,"RAID_WARNING")
        end )

    local ShortBreakButton = CreateFrame("Button", "ShortBreakButton", InstanceUtilityAddonFrame, "UIPanelButtonTemplate")
    ShortBreakButton.contentText = ShortBreakButton:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
    ShortBreakButton.contentText:SetText("Break 5!")
    ShortBreakButton:SetWidth("100")
    ShortBreakButton:SetHeight("25")
    ShortBreakButton.contentText:SetWidth("100")
    ShortBreakButton.contentText:SetHeight("15")
    ShortBreakButton:SetPoint("TOP", 125, -200)
    ShortBreakButton.contentText:SetPoint("CENTER", 0, -1)
    ShortBreakButton:SetScript("OnClick",
        function()
            DBM:CreatePizzaTimer(300, "Break Time!", true)
            SendChatMessage("5 MINUTE BREAK HAS STARTED!" ,"RAID_WARNING")
        end )

    local LongBreakButton = CreateFrame("Button", "LongBreakButton", InstanceUtilityAddonFrame, "UIPanelButtonTemplate")
    LongBreakButton.contentText = LongBreakButton:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
    LongBreakButton.contentText:SetText("Break 10!")
    LongBreakButton:SetWidth("100")
    LongBreakButton:SetHeight("25")
    LongBreakButton.contentText:SetWidth("100")
    LongBreakButton.contentText:SetHeight("15")
    LongBreakButton:SetPoint("TOP", 125, -225)
    LongBreakButton.contentText:SetPoint("CENTER", 0, -1)
    LongBreakButton:SetScript("OnClick",
    function()
        DBM:CreatePizzaTimer(600, "Break Time!", true)
        SendChatMessage("10 MINUTE BREAK HAS STARTED!" ,"RAID_WARNING")
    end )

    local CombatLoggingButton = CreateFrame("Button", "CombatLoggingButton", InstanceUtilityAddonFrame, "UIPanelButtonTemplate")
    CombatLoggingButton.contentText = CombatLoggingButton:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
    CombatLoggingButton.contentText:SetText("Combat Log!")
    CombatLoggingButton:SetWidth("100")
    CombatLoggingButton:SetHeight("25")
    CombatLoggingButton.contentText:SetWidth("100")
    CombatLoggingButton.contentText:SetHeight("15")
    CombatLoggingButton:SetPoint("TOP", 125, -250)
    CombatLoggingButton.contentText:SetPoint("CENTER", 0, -1)
    CombatLoggingButton:SetScript("OnClick", function() addonMain:ToggleCombatLog() end )

    addonMain:ChangeOptionsText()
end

function OnEvent:InstanceLeadingOE(event, ...)
    if event == "CHAT_MSG_WHISPER" then
        local msgText, msgSender = ...
        if msgText == AutoInviteCommand then
            InviteUnit(msgSender)
        end
    elseif event == "CHAT_MSG_BN_WHISPER" then
        print("test1")
        local msgText, _, _, _, _, _, _, _, _, _, _, v12, friendIndex = ...
        if msgText == AutoInviteCommand then
            print("test2 - ")
            local accountInfo = C_BattleNet.GetAccountInfoByID(friendIndex)
            local charName = accountInfo.gameAccountInfo.characterName
            local serverName = accountInfo.gameAccountInfo.realmName
            print(charName .. "-" .. serverName)
            InviteUnit(charName .. "-" .. serverName)
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
    AZPAutoInviteLabel.contentText:SetText("Auto Intive Command")

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
end
