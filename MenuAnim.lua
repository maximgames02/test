local function PlayAnim(dummy, animId)
	local Humanoid = dummy:WaitForChild("Humanoid")

	local animation = Instance.new("Animation")
	animation.AnimationId = `rbxassetid://{animId}`
	local animationTrack = Humanoid:LoadAnimation(animation)

	local function stopAllAnimations()
		for _, track in pairs(Humanoid:GetPlayingAnimationTracks()) do
			print(track)
			track:Stop()
		end
	end
	stopAllAnimations()
	animationTrack:Play()
end

function Main(animId)
	for _, dummy in ipairs(workspace.MainMenuDummies:GetChildren()) do
		PlayAnim(dummy, animId)
	end
	for _, dummy in ipairs(workspace.Lobby_Holder:GetChildren()) do
		PlayAnim(dummy, animId)
	end
end

return Main
