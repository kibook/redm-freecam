Config = {}

-- Configurable controls
Config.IncreaseSpeedControl = {`INPUT_CREATOR_LT`, `INPUT_PREV_WEAPON`}    -- Page Up, Mouse Wheel Up
Config.DecreaseSpeedControl = {`INPUT_CREATOR_RT`, `INPUT_NEXT_WEAPON`}    -- Page Down, Mouse Wheel Down
Config.UpControl            = `INPUT_JUMP`                                 -- Spacebar
Config.DownControl          = `INPUT_SPRINT`                               -- Shift
Config.ForwardControl       = `INPUT_MOVE_UP_ONLY`                         -- W
Config.BackwardControl      = `INPUT_MOVE_DOWN_ONLY`                       -- S
Config.LeftControl          = `INPUT_MOVE_LEFT_ONLY`                       -- A
Config.RightControl         = `INPUT_MOVE_RIGHT_ONLY`                      -- D
Config.IncreaseFovControl   = `INPUT_GAME_MENU_TAB_RIGHT_SECONDARY`        -- Z
Config.DecreaseFovControl   = `INPUT_GAME_MENU_TAB_LEFT_SECONDARY`         -- X
Config.RollLeftControl      = `INPUT_LOOK_BEHIND`                          -- C
Config.RollRightControl     = `INPUT_NEXT_CAMERA`                          -- V
Config.ToggleHudControl     = `INPUT_COVER`                                -- Q
Config.ResetCamControl      = `INPUT_OPEN_SATCHEL_MENU`                    -- B
Config.PrevFilterControl    = `INPUT_CONTEXT_B`                            -- F
Config.NextFilterControl    = `INPUT_INTERACT_ANIMAL`                      -- G
Config.ToggleFilterControl  = {`INPUT_WHISTLE`, `INPUT_WHISTLE_HORSEBACK`} -- H
Config.ToggleGridControl    = `INPUT_OPEN_JOURNAL`                         -- J
Config.ExitLockedCamControl = `INPUT_NEXT_CAMERA`                          -- V

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
