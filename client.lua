local Cam = nil
local StartingFov = 0.0
local ShowHud = true
local Speed = Config.Speed

function EnableFreeCam()
	FreezeEntityPosition(PlayerPedId(), true)
	local x, y, z = table.unpack(GetGameplayCamCoord())
	local pitch, roll, yaw = table.unpack(GetGameplayCamRot(2))
	local fov = GetGameplayCamFov()
	Cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
	SetCamCoord(Cam, x, y, z)
	SetCamRot(Cam, pitch, roll, yaw, 2)
	SetCamFov(Cam, fov)
	RenderScriptCams(true, true, 500, true, true)
	StartingFov = fov
end

function DisableFreeCam()
	FreezeEntityPosition(PlayerPedId(), false)
	RenderScriptCams(false, true, 500, true, true)
	SetCamActive(Cam, false)
	DetachCam(Cam)
	DestroyCam(Cam, true)
	Cam = nil
end

function ToggleFreeCam()
	if Cam then
		DisableFreeCam()
	else
		EnableFreeCam()
	end
end

RegisterCommand('freecam', ToggleFreeCam)

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

	while true do
		Wait(0)

		if Cam then
			local x, y, z = table.unpack(GetCamCoord(Cam))
			local pitch, roll, yaw = table.unpack(GetCamRot(Cam, 2))
			local fov = GetCamFov(Cam)

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

			-- Show controls or hide HUD
			if ShowHud then
				DrawText(string.format('FreeCam Speed: %.1f', Speed), 0.5, 0.90, true)
				DrawText(string.format('Coordinates:\nX: %.2f\nY: %.2f\nZ: %.2f\nPitch: %.2f\nRoll: %.2f\nYaw: %.2f\nFOV: %.0f', x, y, z, pitch, roll, yaw, fov), 0.01, 0.3, false)
				DrawText('W/A/S/D - Move, Spacebar/Shift - Up/Down, Page Up/Page Down - Change speed, Z/X - Zoom, C/V - Roll, B - Reset, Q - Hide HUD', 0.5, 0.95, true)
			else
				HideHudAndRadarThisFrame()
			end

			-- Toggle HUD
			if IsControlJustPressed(0, Config.ToggleHudControl) then
				ShowHud = not ShowHud
			end

			-- Reset camera
			if IsControlJustPressed(0, Config.ResetCamControl) then
				SetCamRot(Cam, 0.0, 0.0, 0.0, 2)
				SetCamFov(Cam, StartingFov)
			end

			-- Increase movement speed
			if IsControlPressed(0, Config.IncreaseSpeedControl) then
				Speed = Speed + Config.SpeedIncrement
			end

			-- Decrease movement speed
			if IsControlPressed(0, Config.DecreaseSpeedControl) then
				Speed = Speed - Config.SpeedIncrement
			end

			-- Move up
			if IsControlPressed(0, Config.UpControl) then
				SetCamCoord(Cam, x, y, z + Speed)
			end

			-- Move down
			if IsControlPressed(0, Config.DownControl) then
				SetCamCoord(Cam, x, y, z - Speed)
			end

			-- Rotate camera using the mouse/analog stick
			local axisX = GetDisabledControlNormal(0, 0xA987235F)
			local axisY = GetDisabledControlNormal(0, 0xD2047988)

			if axisX ~= 0.0 or axisY ~= 0.0 then
				local newZ = yaw + axisX * -1.0 * Config.SpeedUd * 1.0
				local newX = math.max(math.min(89.9, pitch + axisY * -1.0 * Config.SpeedLr * 1.0), -89.9)
				SetCamRot(Cam, newX, roll, newZ, 2)
			end

			-- Roll left
			if IsControlPressed(0, Config.RollLeftControl) then
				SetCamRot(Cam, pitch, roll - Config.RollSpeed, yaw, 2)
			end

			-- Roll right
			if IsControlPressed(0, Config.RollRightControl) then
				SetCamRot(Cam, pitch, roll + Config.RollSpeed, yaw, 2)
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
			if IsControlPressed(0, Config.ForwardControl) then
				SetCamCoord(Cam, x + dx1, y + dy1, z)
			end

			-- Move backward
			if IsControlPressed(0, Config.BackwardControl) then
				SetCamCoord(Cam, x - dx1, y - dy1, z)
			end

			-- Move left
			if IsControlPressed(0, Config.LeftControl) then
				SetCamCoord(Cam, x + dx2, y + dy2, z)
			end

			-- Move right
			if IsControlPressed(0, Config.RightControl) then
				SetCamCoord(Cam, x - dx2, y - dy2, z)
			end

			-- Increase FOV
			if IsControlPressed(0, Config.IncreaseFovControl) then
				SetCamFov(Cam, fov + Config.ZoomSpeed)
			end

			-- Decrease FOV
			if IsControlPressed(0, Config.DecreaseFovControl) then
				SetCamFov(Cam, fov - Config.ZoomSpeed)
			end
		end
	end
end)
