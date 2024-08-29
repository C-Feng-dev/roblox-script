local Players = game:GetService("Players")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

-- Ensure that the character's humanoid contains an "Animator" object
local humanoid = character:WaitForChild("Humanoid")
local Animation = "rbxassetid://17374784439"--14783001346//17374784439
local animator = humanoid:WaitForChild("Animator")

-- Create a new "Animation" instance and assign an animation asset ID
local kickAnimation = Instance.new("Animation")
kickAnimation.AnimationId = Animation

-- Load the animation onto the animator
local kickAnimationTrack = animator:LoadAnimation(kickAnimation)

-- Play the animation track
kickAnimationTrack:Play()

-- If a named event was defined for the animation, connect it to "GetMarkerReachedSignal()"
kickAnimationTrack:GetMarkerReachedSignal("KickEnd"):Connect(function(paramString)
	print(paramString)
end)