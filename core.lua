local frame = CreateFrame("FRAME")
frame:RegisterEvent("GROUP_ROSTER_UPDATE")

local sentMessage = false

local function OnEvent(self, event, ...)
  if not sentMessage and IsInGroup() then
    if IsInRaid() then
      C_Timer.After(3, function()
        if not sentMessage then
          SendChatMessage("yo", "RAID")
          sentMessage = true
          frame:UnregisterEvent("GROUP_ROSTER_UPDATE")
        end
      end)
    else -- not in raid, but in a group
      C_Timer.After(3, function()
        if not sentMessage then
          SendChatMessage("yo", "PARTY")
          sentMessage = true
          frame:UnregisterEvent("GROUP_ROSTER_UPDATE")
        end
      end)
    end
  end
end

frame:SetScript("OnEvent", OnEvent)

local function OnPlayerLeavingGroup(self, event, ...)
  sentMessage = false
  frame:RegisterEvent("GROUP_ROSTER_UPDATE")
end

local leaveGroupFrame = CreateFrame("FRAME")
leaveGroupFrame:RegisterEvent("GROUP_LEFT")
leaveGroupFrame:SetScript("OnEvent", OnPlayerLeavingGroup)
