-- ------------------------- Core ------------------------

LookAtMe = {}
local self = LookAtMe

-- ------------------------- Dev ------------------------

local LuaPath       = GetLuaModsPath()
local DeveloperMode = false
local DevPath       = '' -- Keep this empty
if DeveloperMode then DevPath = [[Dev]] end

-- ------------------------- Info ------------------------

self.Info = {
    Author      = "Zoomy Cat",
    AddonName   = "LookAtMe",
    ClassName   = "LookAtMe",
    Version     = 1,
    StartDate   = "12-10-2022",
    LastUpdate  = "12-14-2022",
    Description = "LookAtMe",
    ChangeLog = {
        [1] = { Version = [[0.0.1]], Description = [[Starting development.]] }
    }
}

-- ------------------------- Paths ------------------------

local LuaPath           = GetLuaModsPath()
self.MinionSettings     = LuaPath                   .. [[ffxivminion\]]
self.ModulePath         = LuaPath                   .. self.Info.ClassName      .. DevPath .. [[\]]
self.ModuleSettingPath  = self.MinionSettings       .. self.Info.ClassName      .. DevPath .. [[\]]

-- ------------------------- States ------------------------

self.Style          = {}
self.Helpers        = {}
self.Misc           = {}
self.SaveLastCheck  = Now()
self.UpdateTimer    = os.clock()
self.BotToggle      = false
self.FirstRun       = true
self.TeleportTo     = false

-- ------------------------- GUI ------------------------

self.GUI = {
    Open    = false,
    Visible = true,
    OnClick = loadstring(self.Info.ClassName .. [[.GUI.Open = not ]] .. self.Info.ClassName .. [[.GUI.Open]]),
    IsOpen  = loadstring([[return ]] .. self.Info.ClassName .. [[.GUI.Open]]),
    ToolTip = self.Info.Description
}

-- ------------------------- Style ------------------------

self.Style.MainWindow = {
    Size        = { Width = 200, Height = 100 },
}

-- ------------------------- Log ------------------------

function LookAtMe.Log(log)
    local content = "==== [" .. self.Info.AddonName .. "] " .. tostring(log)
    d(content)
end

-- ------------------------- Init ------------------------

function LookAtMe.Init()

-- ------------------------- Init Status ------------------------

    LookAtMe.Log([[Addon started]])

-- ------------------------- Dropdown Member ------------------------

    local ModuleTable = self.GUI
    ml_gui.ui_mgr:AddMember({
        id      = self.Info.ClassName,
        name    = self.Info.AddonName,
        onClick = function() ModuleTable.OnClick() end,
        tooltip = ModuleTable.ToolTip,
        texture = [[]]
    }, [[FFXIVMINION##MENU_HEADER]])
end

-- ------------------------- Update ------------------------

function LookAtMe.Update()
    if os.clock() - self.UpdateTimer > 1 or self.FirstRun == true then
        self.UpdateTimer = os.clock()
        if self.BotToggle == true then
            local el = EntityList("targetingme")
            if self.TeleportTo == true then
                for _,v in pairs(el) do
                    Hacks:TeleportToXYZ(v.pos.x, v.pos.y+2, v.pos.z)
                end
            end
        end
    end
end

-- ------------------------- Draw ------------------------

function LookAtMe.MainWindow(event, tickcount)
    if self.GUI.Open then

-- ------------------------- MainWindow ------------------------

        local flags = (GUI.WindowFlags_NoScrollbar + GUI.WindowFlags_NoResize)
        GUI:SetNextWindowSize(self.Style.MainWindow.Size.Width, self.Style.MainWindow.Size.Height, GUI.SetCond_Always)
        self.GUI.Visible, self.GUI.Open = GUI:Begin(self.Info.AddonName, self.GUI.Open, flags)
        GUI:Checkbox('Enable Bot', self.BotToggle)
        if GUI:IsItemClicked() == true then
            self.BotToggle = not self.BotToggle
        end
        GUI:Checkbox('Teleport on target', self.TeleportTo)
        if GUI:IsItemClicked() == true then
            self.TeleportTo = not self.TeleportTo
        end
        GUI:End()
    end
end

-- ------------------------- RegisterEventHandler ------------------------

RegisterEventHandler([[Module.Initalize]], LookAtMe.Init, [[LookAtMe.Init]])
RegisterEventHandler([[Gameloop.Update]], LookAtMe.Update, [[LookAtMe.Update]])
RegisterEventHandler([[Gameloop.Draw]], LookAtMe.MainWindow, [[LookAtMe.MainWindow]])