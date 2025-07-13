--[[
    Ball Landing Predictor by @yourname
    Usage: loadstring(game:HttpGet("https://raw.githubusercontent.com/YOURUSERNAME/YOURREPO/main/YOURFILE.lua"))()
--]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Ball = workspace:WaitForChild("SoccerBall") -- Change if your ball has a different name

-- Ghost Ball Setup
local ghostBall = Instance.new("Part")
ghostBall.Anchored = true
ghostBall.CanCollide = false
ghostBall.Transparency = 0.6
ghostBall.Shape = Enum.PartType.Ball
ghostBall.Size = Ball.Size
ghostBall.Color = Color3.fromRGB(0, 255, 255) -- Cyan glow
ghostBall.Material = Enum.Material.ForceField
ghostBall.Name = "PredictedBall"
ghostBall.Parent = workspace

-- Prediction Settings
local gravity = workspace.Gravity

local function predictLandingPosition(ball)
	local pos = ball.Position
	local vel = ball.AssemblyLinearVelocity

	-- Estimate time until the ball hits the ground (Y = 0)
	local time = (-vel.Y - math.sqrt(vel.Y^2 + 2 * gravity * pos.Y)) / -gravity
	if time < 0 then return pos end

	-- Predict X and Z position at that time
	local predictedX = pos.X + vel.X * time
	local predictedZ = pos.Z + vel.Z * time

	return Vector3.new(predictedX, 0, predictedZ)
end

RunService.RenderStepped:Connect(function()
	local predictedPos = predictLandingPosition(Ball)
	if predictedPos then
		ghostBall.Position = predictedPos + Vector3.new(0, Ball.Size.Y / 2, 0)
	end
end)
