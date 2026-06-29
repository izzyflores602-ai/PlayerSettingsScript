local NovaUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/isaacflo602-hash/NovaUILibrary/main/Nova.lua"))()

local Window = NovaUI:CreateWindow("Player Settings - Nova UI Library")

local MainTab = Window:CreateTab("Player")
local VisualTab = Window:CreateTab("Visuals")
local UtilityTab = Window:CreateTab("Utility")

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TeleportService = game:GetService("TeleportService")
local Lighting = game:GetService("Lighting")

local lp = Players.LocalPlayer

--// VALUES
local targetSpeed = 16
local targetJump = 50
local infiniteJump = false
local fullBright = false

--// CHARACTER HANDLER (fix respawn reset)
local function applyCharacter(char)
	local hum = char:WaitForChild("Humanoid")

	task.spawn(function()
		while hum and hum.Parent do
			task.wait(0.1)

			hum.WalkSpeed = targetSpeed

			if hum.UseJumpPower then
				hum.JumpPower = targetJump
			else
				hum.JumpHeight = (targetJump^2)/(2*workspace.Gravity)
			end
		end
	end)
end

lp.CharacterAdded:Connect(applyCharacter)
if lp.Character then applyCharacter(lp.Character) end

--// INFINITE JUMP
UserInputService.JumpRequest:Connect(function()
	if infiniteJump then
		local hum = lp.Character and lp.Character:FindFirstChildWhichIsA("Humanoid")
		if hum then
			hum:ChangeState(Enum.HumanoidStateType.Jumping)
		end
	end
end)

--// FULLBRIGHT SAFE SYSTEM
local savedLighting = {
	Ambient = Lighting.Ambient,
	Brightness = Lighting.Brightness,
	ClockTime = Lighting.ClockTime
}

local function enableFullBright()
	Lighting.Ambient = Color3.new(1,1,1)
	Lighting.Brightness = 3
	Lighting.ClockTime = 14
end

local function disableFullBright()
	Lighting.Ambient = savedLighting.Ambient
	Lighting.Brightness = savedLighting.Brightness
	Lighting.ClockTime = savedLighting.ClockTime
end

--// PLAYER TAB
MainTab:CreateSlider("WalkSpeed", 16, 250, 16, function(v)
	targetSpeed = v
end)

MainTab:CreateSlider("JumpPower", 50, 300, 50, function(v)
	targetJump = v
end)

MainTab:CreateSlider("Gravity", 0, 300, workspace.Gravity, function(v)
	workspace.Gravity = v
end)

MainTab:CreateSlider("HipHeight", 0, 10, 0, function(v)
	local hum = lp.Character and lp.Character:FindFirstChildWhichIsA("Humanoid")
	if hum then
		hum.HipHeight = v
	end
end)

--// VISUAL TAB
VisualTab:CreateSlider("FOV", 70, 120, 70, function(v)
	workspace.CurrentCamera.FieldOfView = v
end)

VisualTab:CreateToggle("Infinite Jump", false, function(state)
	infiniteJump = state
end)

VisualTab:CreateToggle("Full Bright", false, function(state)
	fullBright = state
	if state then
		enableFullBright()
	else
		disableFullBright()
	end
end)

--// UTILITY TAB
UtilityTab:CreateButton("Enable Anti AFK", function()
	local vu = game:GetService("VirtualUser")
	lp.Idled:Connect(function()
		vu:Button2Down(Vector2.new(0,0))
		task.wait(1)
		vu:Button2Up(Vector2.new(0,0))
	end)
end)

UtilityTab:CreateButton("Rejoin Server", function()
	TeleportService:Teleport(game.PlaceId, lp)
end)

UtilityTab:CreateButton("Reset Character", function()
	if lp.Character then
		lp.Character:BreakJoints()
	end
end)

UtilityTab:CreateSlider("FPS Cap", 30, 240, 60, function(v)
	if setfpscap then
		setfpscap(v)
	end
end)
