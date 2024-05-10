local frame = CreateFrame("FRAME")
frame:RegisterEvent("GROUP_ROSTER_UPDATE")

local sentMessage = false
local delayBeforeSending = 3

local function OnEvent(self, event, ...)
  if not sentMessage then
    local sendFunction, chatType

    if IsInRaid() then
      sendFunction = SendChatMessage
      chatType = "RAID"
    else
      sendFunction = SendChatMessage
      chatType = "PARTY"
    end

    if GetNumGroupMembers() > 1 then
      C_Timer.After(delayBeforeSending, function()
        if not sentMessage then
          sendFunction("yo", chatType)
          sentMessage = true
		  frame:UnRegisterEvent("GROUP_ROSTER_UPDATE")
        end
      end)
    end
  end
end

frame:SetScript("OnEvent", OnEvent)

local function OnPlayerLeavingGroup(self, event, ...)
  if not IsInGroup() or IsInRaid() then
    sentMessage = false
    frame:RegisterEvent("GROUP_ROSTER_UPDATE")
  end
end

local leaveGroupFrame = CreateFrame("FRAME")
leaveGroupFrame:RegisterEvent("GROUP_LEFT")
leaveGroupFrame:SetScript("OnEvent", OnPlayerLeavingGroup)