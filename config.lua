Config = {}

-- Configurable controls
Config.IncreaseSpeedControl = 0x446258B6 -- Page Up
Config.DecreaseSpeedControl = 0x3C3DD371 -- Page Down
Config.UpControl            = 0xD9D0E1C0 -- Spacebar
Config.DownControl          = 0x8FFC75D6 -- Shift
Config.ForwardControl       = 0x8FD015D8 -- W
Config.BackwardControl      = 0xD27782E3 -- S
Config.LeftControl          = 0x7065027D -- A
Config.RightControl         = 0xB4E465B4 -- D
Config.IncreaseFovControl   = 0x8CC9CD42 -- Z
Config.DecreaseFovControl   = 0x26E9DC00 -- X
Config.RollLeftControl      = 0x9959A6F0 -- C
Config.RollRightControl     = 0x7F8D09B8 -- V
Config.ToggleHudControl     = 0xDE794E3E -- Q
Config.ResetCamControl      = 0x4CC0E2FE -- B
Config.PrevFilterControl    = 0x3B24C470 -- F
Config.NextFilterControl    = 0x760A9C6F -- G
Config.ToggleFilterControl  = 0x24978A28 -- H
Config.ToggleGridControl    = 0xF3830D8E -- J

-- Maximum movement speed
Config.MaxSpeed = 1.00

-- Minimum movement speed
Config.MinSpeed = 0.001

-- How much the speed increases/decreases by when the speed up/down controls are pressed
Config.SpeedIncrement = 0.001

-- Default movement speed
Config.Speed = 0.05

-- Maximum FOV
Config.MaxFov = 120.0

-- Minimum FOV
Config.MinFov = 20.0

-- How much the FOV increases/decreases by
Config.ZoomSpeed = 1.0

-- Camera rotation X-axis speed
Config.SpeedLr = 8.0

-- Camera rotation Y-axis speed
Config.SpeedUd = 8.0

-- Camera roll speed
Config.RollSpeed = 1.0

-- Model for the dummy object that controls the camera movement
Config.ControllerModel = `scriptedball`
