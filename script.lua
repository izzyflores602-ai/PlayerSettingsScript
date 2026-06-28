local NovaUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/isaacflo602-hash/NovaUILibrary/main/Nova.lua"))()

local Window = NovaUI:CreateWindow("Player Settings - Nova UI Library ")
local MainTab = Window:CreateTab("Player")
local VisualTab = Window:CreateTab("Visuals")
local UtilityTab = Window:CreateTab("Utility")

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TeleportService = game:GetService("TeleportService")
local Lighting = game:GetService("Lighting")

local lp = Players.LocalPlayer

local targetSpeed = 16
local targetJump = 50
local infiniteJump = false

task.spawn(function()
	while task.wait(.1) do
		local character = lp.Character
		if character then
			local hum = character:FindFirstChildWhichIsA("Humanoid")
			if hum then
				hum.WalkSpeed = targetSpeed

				if hum.UseJumpPower then
					hum.JumpPower = targetJump
				else
					hum.JumpHeight = (targetJump^2)/(2*workspace.Gravity)
				end
			end
		end
	end
end)


MainTab:CreateSlider("WalkSpeed",16,250,16,function(v)
	targetSpeed = v
end)


MainTab:CreateSlider("JumpPower",50,300,50,function(v)
	targetJump = v
end)


MainTab:CreateSlider("Gravity",0,300,workspace.Gravity,function(v)
	workspace.Gravity = v
end)


MainTab:CreateSlider("HipHeight",0,10,0,function(v)
	local hum = lp.Character and lp.Character:FindFirstChildWhichIsA("Humanoid")
	if hum then
		hum.HipHeight = v
	end
end)

-- FOV
VisualTab:CreateSlider("FOV",70,120,70,function(v)
	workspace.CurrentCamera.FieldOfView = v
end)

-- Infinite Jump
VisualTab:CreateToggle("Infinite Jump",false,function(state)
	infiniteJump = state
end)

UserInputService.JumpRequest:Connect(function()
	if infiniteJump then
		local hum = lp.Character and lp.Character:FindFirstChildWhichIsA("Humanoid")
		if hum then
			hum:ChangeState(Enum.HumanoidStateType.Jumping)
		end
	end
end)

-- FullBright
local oldAmbient = Lighting.Ambient
local oldBrightness = Lighting.Brightness
local oldClock = Lighting.ClockTime

VisualTab:CreateToggle("Full Bright",false,function(state)
	if state then
		Lighting.Ambient = Color3.new(1,1,1)
		Lighting.Brightness = 3
		Lighting.ClockTime = 14
	else
		Lighting.Ambient = oldAmbient
		Lighting.Brightness = oldBrightness
		Lighting.ClockTime = oldClock
	end
end)

-- Anti AFK
UtilityTab:CreateButton("Enable Anti AFK",function()
	local vu = game:GetService("VirtualUser")
	lp.Idled:Connect(function()
		vu:Button2Down(Vector2.new())
		task.wait(1)
		vu:Button2Up(Vector2.new())
	end)
end)

-- Rejoin
UtilityTab:CreateButton("Rejoin Server",function()
	TeleportService:Teleport(game.PlaceId,lp)
end)

-- Reset Character
UtilityTab:CreateButton("Reset Character",function()
	if lp.Character then
		lp.Character:BreakJoints()
	end
end)

-- FPS Cap (executor dependent)
UtilityTab:CreateSlider("FPS Cap",30,240,60,function(v)
	if setfpscap then
		setfpscap(v)
	end
end)
