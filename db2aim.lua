local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera

aimbotActive = false
aimbotActivateKey = Enum.KeyCode.Home

function Main(key)
	if not key then return end
	aimbotActivateKey = key
	print(aimbotActivateKey)
end

UserInputService.InputBegan:Connect(function(input)
	if input.KeyCode == aimbotActivateKey then
		aimbotActive = not aimbotActive
	end
end)

local SurvivorTeamName = "Survivors"
local KillerTeamName = "Killer"

local InSurvivorTeam = nil
local teamName = nil

local function findNearestPlayer()
	local closestDistance = 512
	local closestPlayer = nil
	
	InSurvivorTeam = (game.Players.LocalPlayer.Team.Name == SurvivorTeamName)
	for _, player in ipairs(Players:GetPlayers()) do
		if not InSurvivorTeam then teamName = SurvivorTeamName
		else teamName = KillerTeamName
		end
		if player.Team and player.Team.Name == teamName then
			if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
				local targetRoot = player.Character.HumanoidRootPart
				local localRoot = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
	
				if localRoot then
					local distance = (localRoot.Position - targetRoot.Position).Magnitude
					if distance < closestDistance then
						closestDistance = distance
						closestPlayer = player
					end
				end
			end
		end
	end
	return closestPlayer
end

game:GetService("RunService").PreRender:Connect(function()
	if aimbotActive then
		local success, result = pcall(function()
			return findNearestPlayer()
		end)
		if success and result then
			local nearestPlayer = result
			local target = nearestPlayer.Character:FindFirstChild("HumanoidRootPart")
			if not target then return end
			local cameraPosition = Camera.CFrame.Position
			local targetPosition = target.Position
			Camera.CFrame = CFrame.lookAt(cameraPosition, targetPosition)
		elseif success == false then
			warn("Error:", result)
		end
	end
end)
return Main
