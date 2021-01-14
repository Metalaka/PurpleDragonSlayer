local mod = _G.HalionHelper

mod.modules.slashCommands = {}

function mod.modules.slashCommands:Initialize()

    local _self = self

    mod:RegisterChatCommand("halionhelper", "ChatCommand")

    function mod:ChatCommand(args)

        local arg1, arg2 = self:GetArgs(args, 2)

        if arg1 == "move" and mod.enabled then
            _self:MoveUI()
        elseif arg1 == "texture" and mod.enabled then
            _self:SetTexture(arg2)
        else
            if not mod.enabled then
                mod:Print("Addon is currently disabled! Please go inside The Ruby Sanctum to enable it.")
            end

            mod:Print("Usage:")
            mod:Print("|cffffee00/halionhelper help|r - List available subcommands")
            mod:Print("|cffffee00/halionhelper move|r - Display addon interfaces to customize frames positions")
            mod:Print("|cffffee00/halionhelper texture NAME|r - Set texture of statusbar")
        end
    end

    function self:MoveUI()

        function self:ToggleMovable(frame)

            if not frame:IsMovable() then
                frame:SetMovable(true)
                frame:EnableMouse(true)
                frame:RegisterForDrag("LeftButton")
                frame:SetScript("OnDragStart", frame.StartMoving)
                frame:SetScript("OnDragStop", frame.StopMovingOrSizing)
            else
                frame:SetMovable(false)
                frame:EnableMouse(false)
            end
        end

        self:ToggleMovable(mod.modules.phase2Ui.progressBar)
        self:ToggleMovable(mod.modules.phase3CollectLog.ui.uiFrame)

        if not mod.modules.phase3CollectLog.ui.corporealityBar:IsShown() then
            mod.modules.phase2Ui.progressBar:SetValue(0.666)
            mod.modules.phase3CollectLog.ui.timer:StartTimer(15)
            mod.modules.phase3CollectLog.ui.corporealityBar:Show()

            mod:Print("movable mode enabled. Disable it to save potitions.")
        else
            mod.modules.phase2Ui.progressBar:SetValue(0)
            mod.modules.phase3CollectLog.ui.timer:StartTimer(0)
            mod.modules.phase3CollectLog.ui.corporealityBar:Hide()

            local point, _, _, x, y = mod.modules.phase2Ui.progressBar:GetPoint(1)
            mod.db.profile.P2.point = point
            mod.db.profile.P2.x = x
            mod.db.profile.P2.y = y
            local point, _, _, x, y = mod.modules.phase3CollectLog.ui.uiFrame:GetPoint(1)
            mod.db.profile.P3.point = point
            mod.db.profile.P3.x = x
            mod.db.profile.P3.y = y
        end
    end

    function self:SetTexture(name)

        local LSM = LibStub("LibSharedMedia-3.0", true)

        if not LSM then
            mod:Print("LibSharedMedia not available.")

            return
        end

        if LSM:IsValid(LSM.MediaType.STATUSBAR, name) then
            mod.db.profile.texture = LSM:Fetch(LSM.MediaType.STATUSBAR, name)
            mod:Print("Texture saved! Please reload to apply.")
        else
            mod:Print(name .. " is not available as '" .. LSM.MediaType.STATUSBAR .. "' texture!")
        end
    end
end

-- Initialize chat command
mod.modules.slashCommands:Initialize()
