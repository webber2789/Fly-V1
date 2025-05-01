local player = game.Players.LocalPlayer
local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
screenGui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame", screenGui)
mainFrame.Size = UDim2.new(0, 200, 0, 110)
mainFrame.AnchorPoint = Vector2.new(1, 1)
mainFrame.Position = UDim2.new(1, -10, 1, -10)
mainFrame.BackgroundColor3 = Color3.fromHex("#28241c")
mainFrame.BorderSizePixel = 0

local topBar = Instance.new("Frame", mainFrame)
topBar.Size = UDim2.new(1, 0, 0, 25)
topBar.Position = UDim2.new(0, 0, 0, 0)
topBar.BackgroundColor3 = Color3.fromHex("#ab1207")
topBar.BorderSizePixel = 0

local title = Instance.new("TextLabel", topBar)
title.Size = UDim2.new(0, 60, 0, 25)
title.Position = UDim2.new(0, 5, 0, 0)
title.BackgroundTransparency = 1
title.Text = "FLY"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.SourceSansSemibold
title.TextSize = 20
title.TextXAlignment = Enum.TextXAlignment.Left

local minBtn = Instance.new("TextButton", topBar)
minBtn.Size = UDim2.new(0, 25, 0, 25)
minBtn.Position = UDim2.new(1, -50, 0, 0)
minBtn.BackgroundColor3 = Color3.fromHex("#780404")
minBtn.Text = "−"
minBtn.TextColor3 = Color3.new(1, 1, 1)
minBtn.Font = Enum.Font.SourceSans
minBtn.TextSize = 18
minBtn.BorderSizePixel = 0

local closeBtn = Instance.new("TextButton", topBar)
closeBtn.Size = UDim2.new(0, 25, 0, 25)
closeBtn.Position = UDim2.new(1, -25, 0, 0)
closeBtn.BackgroundColor3 = Color3.fromHex("#780404")
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.new(1, 1, 1)
closeBtn.Font = Enum.Font.SourceSans
closeBtn.TextSize = 18
closeBtn.BorderSizePixel = 0

local statusLabel = Instance.new("TextLabel", mainFrame)
statusLabel.Size = UDim2.new(0, 100, 0, 20)
statusLabel.Position = UDim2.new(0.5, -80, 0, 30)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Status:"
statusLabel.TextColor3 = Color3.new(1, 1, 1)
statusLabel.Font = Enum.Font.SourceSansSemibold
statusLabel.TextSize = 20
statusLabel.TextXAlignment = Enum.TextXAlignment.Left

local toggleBtn = Instance.new("TextButton", mainFrame)
toggleBtn.Size = UDim2.new(0, 160, 0, 30)
toggleBtn.Position = UDim2.new(0.5, -80, 0, 55)
toggleBtn.BackgroundColor3 = Color3.fromHex("#ab1207")
toggleBtn.Text = "DISABLED"
toggleBtn.TextColor3 = Color3.new(1, 1, 1)
toggleBtn.Font = Enum.Font.SourceSansBold
toggleBtn.TextSize = 22
toggleBtn.BorderSizePixel = 0

local speedBar = Instance.new("Frame", mainFrame)
speedBar.Size = UDim2.new(0, 160, 0, 10)
speedBar.Position = UDim2.new(0.5, -80, 0, 90)
speedBar.BackgroundColor3 = Color3.fromHex("#403434")
speedBar.BorderSizePixel = 0

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local flying = false
local flySpeed = 50
local bodyVel
local rootPart = nil

local function getRoot()
	local char = player.Character or player.CharacterAdded:Wait()
	return char:WaitForChild("HumanoidRootPart")
end

local function setNoClip(state)
	local character = player.Character
	if not character then return end

	for _, part in ipairs(character:GetDescendants()) do
		if part:IsA("BasePart") then
			part.CanCollide = not state
		end
	end

	local humanoid = character:FindFirstChildOfClass("Humanoid")
	if humanoid then
		humanoid:ChangeState(state and Enum.HumanoidStateType.Physics or Enum.HumanoidStateType.GettingUp)
	end
end

local function startFly()
	rootPart = getRoot()
	if not bodyVel then
		bodyVel = Instance.new("BodyVelocity")
		bodyVel.Velocity = Vector3.zero
		bodyVel.MaxForce = Vector3.new(1e6, 1e6, 1e6)
		bodyVel.Parent = rootPart
	end
	setNoClip(true)
	RunService:BindToRenderStep("ServerFly", Enum.RenderPriority.Input.Value, function()
		local cam = workspace.CurrentCamera
		local move = Vector3.zero
		if UIS:IsKeyDown(Enum.KeyCode.W) then move += cam.CFrame.LookVector end
		if UIS:IsKeyDown(Enum.KeyCode.S) then move -= cam.CFrame.LookVector end
		if UIS:IsKeyDown(Enum.KeyCode.A) then move -= cam.CFrame.RightVector end
		if UIS:IsKeyDown(Enum.KeyCode.D) then move += cam.CFrame.RightVector end
		if UIS:IsKeyDown(Enum.KeyCode.E) then move += Vector3.new(0, 1, 0) end
		if UIS:IsKeyDown(Enum.KeyCode.Q) then move -= Vector3.new(0, 1, 0) end
		if move.Magnitude > 0 then
			bodyVel.Velocity = move.Unit * flySpeed
		else
			bodyVel.Velocity = Vector3.zero
		end
	end)
end

local function stopFly()
	RunService:UnbindFromRenderStep("ServerFly")
	if bodyVel then
		bodyVel:Destroy()
		bodyVel = nil
	end
	setNoClip(false)
end

local enabled = false
toggleBtn.MouseButton1Click:Connect(function()
	enabled = not enabled
	toggleBtn.Text = enabled and "ENABLED" or "DISABLED"
	flying = enabled
	if flying then
		startFly()
		statusLabel.RichText = true
		statusLabel.Text = 'Status: <font color="rgb(0,255,0)">On</font>'
	else
		stopFly()
		statusLabel.RichText = true
		statusLabel.Text = 'Status: <font color="rgb(255,0,0)">Off</font>'
	end
end)

closeBtn.MouseButton1Click:Connect(function()
	screenGui:Destroy()
end)

minBtn.MouseButton1Click:Connect(function()
	mainFrame.Visible = false
end)

player.CharacterAdded:Connect(function()
	flying = false
	stopFly()
	statusLabel.Text = 'Status: <font color="rgb(255,0,0)">Off</font>'
	toggleBtn.Text = "DISABLED"
	enabled = false
end)
