-- messy but works lol
local plr = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui", plr:WaitForChild("PlayerGui"))
gui.ResetOnSpawn = false

-- main ui stuff
local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 200, 0, 110)
main.Position = UDim2.new(1, -10, 1, -10)
main.AnchorPoint = Vector2.new(1, 1)
main.BackgroundColor3 = Color3.fromHex("#28241c") -- dark theme ftw
main.BorderSizePixel = 0

-- top bar looks kinda ugly but whatever
local top = Instance.new("Frame", main)
top.Size = UDim2.new(1, 0, 0, 25)
top.BackgroundColor3 = Color3.fromHex("#ab1207")
top.BorderSizePixel = 0

-- TODO: make this look better later
local title = Instance.new("TextLabel", top)
title.Size = UDim2.new(0, 60, 1, 0)
title.Position = UDim2.new(0, 5, 0, 0)
title.BackgroundTransparency = 1
title.Text = "FLY"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.SourceSansSemibold
title.TextSize = 20
title.TextXAlignment = Enum.TextXAlignment.Left

-- buttons
local min = Instance.new("TextButton", top)
min.Size = UDim2.new(0, 25, 0, 25)
min.Position = UDim2.new(1, -50, 0, 0)
min.BackgroundColor3 = Color3.fromHex("#780404")
min.Text = "−"
min.TextColor3 = Color3.new(1, 1, 1)
min.Font = Enum.Font.SourceSans
min.TextSize = 18
min.BorderSizePixel = 0

local close = Instance.new("TextButton", top)
close.Size = UDim2.new(0, 25, 0, 25)
close.Position = UDim2.new(1, -25, 0, 0)
close.BackgroundColor3 = Color3.fromHex("#780404")
close.Text = "X"
close.TextColor3 = Color3.new(1, 1, 1)
close.Font = Enum.Font.SourceSans
close.TextSize = 18
close.BorderSizePixel = 0

-- status stuff
local status = Instance.new("TextLabel", main)
status.Size = UDim2.new(0, 100, 0, 20)
status.Position = UDim2.new(0.5, -80, 0, 30)
status.BackgroundTransparency = 1
status.Text = "Status:"
status.TextColor3 = Color3.new(1, 1, 1)
status.Font = Enum.Font.SourceSansSemibold
status.TextSize = 20
status.TextXAlignment = Enum.TextXAlignment.Left

local toggle = Instance.new("TextButton", main)
toggle.Size = UDim2.new(0, 160, 0, 30)
toggle.Position = UDim2.new(0.5, -80, 0, 55)
toggle.BackgroundColor3 = Color3.fromHex("#ab1207")
toggle.Text = "DISABLED"
toggle.TextColor3 = Color3.new(1, 1, 1)
toggle.Font = Enum.Font.SourceSansBold
toggle.TextSize = 22
toggle.BorderSizePixel = 0

-- speed bar (not implemented yet)
local sbar = Instance.new("Frame", main)
sbar.Size = UDim2.new(0, 160, 0, 10)
sbar.Position = UDim2.new(0.5, -80, 0, 90)
sbar.BackgroundColor3 = Color3.fromHex("#403434")
sbar.BorderSizePixel = 0

local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")

-- flying logic
local speed = 50  -- change this if too slow
local flying, bv, root = false, nil, nil

-- handles the actual flying
local function fly()
    root = plr.Character.HumanoidRootPart
    if not bv then
        bv = Instance.new("BodyVelocity")
        bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bv.P = 9000  -- makes it smoother
        bv.Parent = root
    end
    
    -- noclip
    for _,p in pairs(plr.Character:GetDescendants()) do
        if p:IsA("BasePart") then p.CanCollide = false end
    end
end

-- cleanup flying stuff
local function stopfly()
    RS:UnbindFromRenderStep("flyloop")
    if bv then bv:Destroy() bv = nil end
    
    -- restore collisions
    if plr.Character then
        for _,p in pairs(plr.Character:GetDescendants()) do
            if p:IsA("BasePart") then p.CanCollide = true end
        end
    end
end

-- toggle functionality
local enabled = false
toggle.MouseButton1Click:Connect(function()
    enabled = not enabled
    toggle.Text = enabled and "ENABLED" or "DISABLED"
    flying = enabled
    
    if flying then
        fly()
        status.RichText = true
        status.Text = 'Status: <font color="rgb(0,255,0)">On</font>'
        
        -- fly loop
        RS:BindToRenderStep("flyloop", Enum.RenderPriority.Input.Value, function()
            local cam = workspace.CurrentCamera
            local move = Vector3.new()
            
            -- movement keys
            if UIS:IsKeyDown(Enum.KeyCode.W) then move = move + cam.CFrame.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.S) then move = move - cam.CFrame.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.A) then move = move - cam.CFrame.RightVector end
            if UIS:IsKeyDown(Enum.KeyCode.D) then move = move + cam.CFrame.RightVector end
            if UIS:IsKeyDown(Enum.KeyCode.E) then move = move + Vector3.new(0,1,0) end
            if UIS:IsKeyDown(Enum.KeyCode.Q) then move = move - Vector3.new(0,1,0) end
            
            -- update velocity
            if move.Magnitude > 0 then
                bv.Velocity = move.Unit * speed
            else
                bv.Velocity = Vector3.zero
            end
        end)
    else
        stopfly()
        status.RichText = true
        status.Text = 'Status: <font color="rgb(255,0,0)">Off</font>'
    end
end)

-- ui buttons
close.MouseButton1Click:Connect(function() gui:Destroy() end)
min.MouseButton1Click:Connect(function() main.Visible = false end)

-- handle respawn
plr.CharacterAdded:Connect(function()
    flying = false
    stopfly()
    status.Text = 'Status: <font color="rgb(255,0,0)">Off</font>'
    toggle.Text = "DISABLED"
    enabled = false
end)
