local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local isMoving = false

ActivateKey = "Home"

function Main(animId, key)
	if not key then return
	else ActivateKey = key
	end
	
	local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
	local Humanoid = Character:WaitForChild("Humanoid")
	local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
	
	local animation = Instance.new("Animation")
	animation.AnimationId = `rbxassetid://{animId}`
	local animationTrack = Humanoid:LoadAnimation(animation)
	
	local function stopAllAnimations()
		for _, track in pairs(Humanoid:GetPlayingAnimationTracks()) do
			print(track)
			track:Stop()
		end
	end
	
	UserInputService.InputBegan:Connect(function(input, gameProcessed)
		if gameProcessed then return end

		local success, keyCode = pcall(function()
			return Enum.KeyCode[ActivateKey]
		end)
		
		if success then
			if input.KeyCode == keyCode and not animationTrack.IsPlaying and not isMoving then
				stopAllAnimations()
				animationTrack:Play()
			end
		else
			warn("Invalid key code")
			ActivateKey = "Home"
		end
	end)
	
	RunService.Heartbeat:Connect(function()
		local isCurrentlyMoving = Humanoid.MoveDirection.Magnitude > 0

		if isCurrentlyMoving ~= isMoving then
			isMoving = isCurrentlyMoving

			if isMoving then
				--print("Персонаж Идёт")
				animationTrack:Stop()
			else
				--print("Персонаж Стоит")
			end
		end
	end)
end

return Main
