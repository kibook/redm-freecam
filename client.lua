local Cam = nil
local Controller = nil
local StartingFov = 0.0
local ShowHud = true
local Speed = Config.Speed
local CameraLocked = false
local Timecycle = 1
local FilterEnabled = false
local GridEnabled = false

RegisterNetEvent('freecam:toggle')
RegisterNetEvent('freecam:toggleLock')

function LoadModel(model)
	if IsModelInCdimage(model) then
		RequestModel(model)

		while not HasModelLoaded(model) do
			Wait(0)
		end

		return true
	else
		return false
	end
end

function EnableFreeCam()
	local x, y, z = table.unpack(GetGameplayCamCoord())
	local pitch, roll, yaw = table.unpack(GetGameplayCamRot(2))
	local fov = GetGameplayCamFov()

	-- Moving the camera with SetCamCoord/SetCamRot disables the game's
	-- anti-aliasing while the camera is moving. Attaching the camera to an
	-- entity and moving that entity instead functions as a workaround for
	-- positioning (but not rotating) the camera.
	LoadModel(Config.ControllerModel)
	Controller = CreateObjectNoOffset(Config.ControllerModel, x, y, z, false, false, false, false)
	FreezeEntityPosition(Controller, true)
	SetEntityVisible(Controller, false)

	Cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
	SetCamRot(Cam, pitch, roll, yaw, 2)
	SetCamFov(Cam, fov)
	RenderScriptCams(true, true, 500, true, true)
	StartingFov = fov

	AttachCamToEntity(Cam, Controller, 0.0, 0.0, 0.0, true)

	if FilterEnabled then
		SetTimecycleModifier(Timecycles[Timecycle])
	end

	if GridEnabled then
		AnimpostfxPlay("CameraViewFinder")
	end
end

function DisableFreeCam()
	RenderScriptCams(false, true, 500, true, true)
	SetCamActive(Cam, false)
	DetachCam(Cam)
	DestroyCam(Cam, true)
	Cam = nil

	DeleteObject(Controller)

	if FilterEnabled then
		ClearTimecycleModifier()
	end

	if GridEnabled then
		AnimpostfxStop("CameraViewFinder")
	end
end

function ToggleFreeCam()
	if Cam then
		DisableFreeCam()
	else
		EnableFreeCam()
	end
end

function ToggleFreeCamLock()
	CameraLocked = not CameraLocked
end

function NextFilter()
	Timecycle = Timecycle == #Timecycles and 1 or Timecycle + 1
	SetTimecycleModifier(Timecycles[Timecycle])
	FilterEnabled = true
end

function PrevFilter()
	Timecycle = Timecycle == 1 and #Timecycles or Timecycle - 1
	SetTimecycleModifier(Timecycles[Timecycle])
	FilterEnabled = true
end

function ToggleFilter()
	if FilterEnabled then
		ClearTimecycleModifier()
		FilterEnabled = false
	else
		SetTimecycleModifier(Timecycles[Timecycle])
		FilterEnabled = true
	end
end

function ToggleGrid()
	if GridEnabled then
		AnimpostfxStop('CameraViewFinder')
		GridEnabled = false
	else
		AnimpostfxPlay('CameraViewFinder')
		GridEnabled = true
	end
end

function CheckControls(func, pad, controls)
	if type(controls) == 'number' then
		return func(pad, controls)
	end

	for _, control in ipairs(controls) do
		if func(pad, control) then
			return true
		end
	end

	return false
end

RegisterCommand('freecam', ToggleFreeCam)
RegisterCommand('freecamLock', ToggleFreeCamLock)

AddEventHandler('freecam:toggle', ToggleFreeCam)
AddEventHandler('freecam:toggleLock', ToggleFreeCamLock)

function DrawText(text, x, y, centred)
	SetTextScale(0.35, 0.35)
	SetTextColor(255, 255, 255, 255)
	SetTextCentre(centred)
	SetTextDropshadow(1, 0, 0, 0, 200)
	SetTextFontForCurrentCommand(0)
	DisplayText(CreateVarString(10, "LITERAL_STRING", text), x, y)
end

AddEventHandler('onResourceStop', function(resourceName)
	if GetCurrentResourceName() == resourceName and Cam then
		DisableFreeCam()
	end
end)

CreateThread(function()
	TriggerEvent('chat:addSuggestion', '/freecam', 'Toggle freecam mode', {})

	TriggerEvent('chat:addSuggestion', '/freecamLock', 'Lock/unlock the freecam', {})

	while true do
		Wait(0)

		if Cam then
			local x, y, z = table.unpack(GetCamCoord(Cam))
			local pitch, roll, yaw = table.unpack(GetCamRot(Cam, 2))
			local fov = GetCamFov(Cam)

			-- Show controls or hide HUD
			if ShowHud then
				DrawText(string.format('Coordinates:\nX: %.2f\nY: %.2f\nZ: %.2f\nPitch: %.2f\nRoll: %.2f\nYaw: %.2f\nFOV: %.0f\nFilter: %s', x, y, z, pitch, roll, yaw, fov, FilterEnabled and Timecycles[Timecycle] or 'None'), 0.01, 0.3, false)

				if not CameraLocked then
					DrawText(string.format('FreeCam Speed: %.3f', Speed), 0.5, 0.90, true)
					DrawText('W/A/S/D - Move, Spacebar/Shift - Up/Down, Page Up/Page Down - Change speed, Z/X - Zoom, C/V - Roll, B - Reset, Q - Hide HUD', 0.5, 0.93, true)
					DrawText('F/G - Cycle Filter, H - Toggle Filter, J - Toggle Grid', 0.5, 0.96, true)
				end
			else
				HideHudAndRadarThisFrame()
			end

			if not CameraLocked then
				-- Disable all controls except a few while in freecam mode
				DisableAllControlActions(0)
				EnableControlAction(0, 0x4A903C11) -- FrontendPauseAlternate
				EnableControlAction(0, 0x9720fcee) -- MpTextChatAll

				-- Ensure speed is within the specified range
				if Speed < Config.MinSpeed then
					Speed = Config.MinSpeed
				end
				if Speed > Config.MaxSpeed then
					Speed = Config.MaxSpeed
				end

				-- Ensure FOV is within the specified range
				if fov < Config.MinFov then
					fov = Config.MinFov
				end
				if fov > Config.MaxFov then
					fov = Config.MaxFov
				end

				-- Toggle HUD
				if CheckControls(IsDisabledControlJustPressed, 0, Config.ToggleHudControl) then
					ShowHud = not ShowHud
				end

				-- Reset camera
				if CheckControls(IsDisabledControlJustPressed, 0, Config.ResetCamControl) then
					roll = 0.0
					fov = StartingFov
				end

				-- Increase movement speed
				if CheckControls(IsDisabledControlPressed, 0, Config.IncreaseSpeedControl) then
					Speed = Speed + Config.SpeedIncrement
				end

				-- Decrease movement speed
				if CheckControls(IsDisabledControlPressed, 0, Config.DecreaseSpeedControl) then
					Speed = Speed - Config.SpeedIncrement
				end

				-- Move up
				if CheckControls(IsDisabledControlPressed, 0, Config.UpControl) then
					z = z + Speed
				end

				-- Move down
				if CheckControls(IsDisabledControlPressed, 0, Config.DownControl) then
					z = z - Speed
				end

				-- Rotate camera using the mouse/analog stick
				local axisX = GetDisabledControlNormal(0, 0xA987235F)
				local axisY = GetDisabledControlNormal(0, 0xD2047988)

				if axisX ~= 0.0 or axisY ~= 0.0 then
					yaw = yaw + axisX * -1.0 * Config.SpeedUd * 1.0
					pitch = math.max(math.min(89.9, pitch + axisY * -1.0 * Config.SpeedLr * 1.0), -89.9)
				end

				-- Roll left
				if CheckControls(IsDisabledControlPressed, 0, Config.RollLeftControl) then
					roll = roll - Config.RollSpeed
				end

				-- Roll right
				if CheckControls(IsDisabledControlPressed, 0, Config.RollRightControl) then
					roll = roll + Config.RollSpeed
				end

				-- Determine change in forward/backward movement
				local r1 = -yaw * math.pi / 180
				local dx1 = Speed * math.sin(r1)
				local dy1 = Speed * math.cos(r1)

				-- Determine change in left/right movement
				local r2 = math.floor(yaw + 90.0) % 360 * -1.0 * math.pi / 180
				local dx2 = Speed * math.sin(r2)
				local dy2 = Speed * math.cos(r2)

				-- Move forward
				if CheckControls(IsDisabledControlPressed, 0, Config.ForwardControl) then
					x = x + dx1
					y = y + dy1
				end

				-- Move backward
				if CheckControls(IsDisabledControlPressed, 0, Config.BackwardControl) then
					x = x - dx1
					y = y - dy1
				end

				-- Move left
				if CheckControls(IsDisabledControlPressed, 0, Config.LeftControl) then
					x = x + dx2
					y = y + dy2
				end

				-- Move right
				if CheckControls(IsDisabledControlPressed, 0, Config.RightControl) then
					x = x - dx2
					y = y - dy2
				end

				-- Increase FOV
				if CheckControls(IsDisabledControlPressed, 0, Config.IncreaseFovControl) then
					fov = fov + Config.ZoomSpeed
				end

				-- Decrease FOV
				if CheckControls(IsDisabledControlPressed, 0, Config.DecreaseFovControl) then
					fov = fov - Config.ZoomSpeed
				end

				-- Next filter
				if CheckControls(IsDisabledControlJustPressed, 0, Config.NextFilterControl) then
					NextFilter()
				end

				-- Previous filter
				if CheckControls(IsDisabledControlJustPressed, 0, Config.PrevFilterControl) then
					PrevFilter()
				end

				-- Reset filter
				if CheckControls(IsDisabledControlJustPressed, 0, Config.ToggleFilterControl) then
					ToggleFilter()
				end

				-- Toggle grid
				if CheckControls(IsDisabledControlJustPressed, 0, Config.ToggleGridControl) then
					ToggleGrid()
				end

				SetEntityCoordsNoOffset(Controller, x, y, z)
				SetCamRot(Cam, pitch, roll, yaw, 2)
				SetCamFov(Cam, fov)
			end
		end
	end
end)
