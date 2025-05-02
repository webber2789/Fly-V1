local pl=game.Players.LocalPlayer
local g=Instance.new("ScreenGui",pl:WaitForChild("PlayerGui"));g.ResetOnSpawn=false

local fr=Instance.new("Frame") fr.Parent=g fr.Size=UDim2.new(0,200,0,110) fr.Position=UDim2.new(1,-10,1,-10) fr.AnchorPoint=Vector2.new(1,1) fr.BackgroundColor3=Color3.fromRGB(40,36,28)

local hd=Instance.new("Frame",fr) hd.Size=UDim2.new(1,0,0,25) hd.BackgroundColor3=Color3.fromRGB(171,18,7)

local tx=Instance.new("TextLabel",hd) tx.Size=UDim2.new(0,60,1,0) tx.Position=UDim2.new(0,5,0,0) tx.Text="FLY" tx.Font=Enum.Font.SourceSans tx.TextSize=20 tx.TextXAlignment=Enum.TextXAlignment.Left tx.BackgroundTransparency=1 tx.TextColor3=Color3.new(1,1,1)

local bb2=Instance.new("TextButton",hd) bb2.Size=UDim2.new(0,25,0,25) bb2.Position=UDim2.new(1,-25,0,0) bb2.Text="X" bb2.BackgroundColor3=Color3.fromRGB(120,4,4) bb2.TextColor3=Color3.new(1,1,1) bb2.Font=Enum.Font.SourceSans bb2.TextSize=18 bb2.BorderSizePixel=0

local bb1=Instance.new("TextButton",hd) bb1.Position=UDim2.new(1,-50,0,0) bb1.Size=UDim2.new(0,25,0,25) bb1.Text="-" bb1.BackgroundColor3=Color3.fromRGB(120,4,4) bb1.TextColor3=Color3.new(1,1,1) bb1.Font=Enum.Font.SourceSans bb1.TextSize=18 bb1.BorderSizePixel=0

local lbl=Instance.new("TextLabel") lbl.Parent=fr lbl.Size=UDim2.new(0,100,0,20) lbl.Position=UDim2.new(0.5,-80,0,30) lbl.Text="Status:" lbl.TextColor3=Color3.new(1,1,1) lbl.TextSize=20 lbl.Font=Enum.Font.SourceSans lbl.BackgroundTransparency=1

local bt=Instance.new("TextButton") bt.Size=UDim2.new(0,160,0,30) bt.Parent=fr bt.Text="DISABLED" bt.Position=UDim2.new(0.5,-80,0,55) bt.BackgroundColor3=Color3.fromRGB(171,18,7) bt.TextColor3=Color3.new(1,1,1) bt.Font=Enum.Font.SourceSansBold bt.TextSize=22 bt.BorderSizePixel=0

local u=game:GetService("UserInputService")
local r=game:GetService("RunService")
local fly=false local v=nil local rt=nil local e=false local spd=50

bt.MouseButton1Click:Connect(function()
e=not e fly=e
bt.Text=e and"ENABLED"or"DISABLED"
lbl.Text=e and"Status: On"or"Status: Off"
if e then
rt=pl.Character and pl.Character:FindFirstChild("HumanoidRootPart")if not rt then return end
if not v then v=Instance.new("BodyVelocity")v.MaxForce=Vector3.new(9e9,9e9,9e9)v.P=9000 v.Parent=rt end
for _,z in pairs(pl.Character:GetDescendants())do if z:IsA("BasePart")then z.CanCollide=false end end
r:BindToRenderStep("fly",Enum.RenderPriority.Input.Value,function()
local c=workspace.CurrentCamera local m=Vector3.zero
if u:IsKeyDown(Enum.KeyCode.W)then m+=c.CFrame.LookVector end
if u:IsKeyDown(Enum.KeyCode.S)then m-=c.CFrame.LookVector end
if u:IsKeyDown(Enum.KeyCode.A)then m-=c.CFrame.RightVector end
if u:IsKeyDown(Enum.KeyCode.D)then m+=c.CFrame.RightVector end
if u:IsKeyDown(Enum.KeyCode.E)then m+=Vector3.new(0,1,0)end
if u:IsKeyDown(Enum.KeyCode.Q)then m-=Vector3.new(0,1,0)end
v.Velocity=m.Magnitude>0 and m.Unit*spd or Vector3.zero
end)
else
r:UnbindFromRenderStep("fly")
if v then v:Destroy()v=nil end
if pl.Character then for _,z in pairs(pl.Character:GetDescendants())do if z:IsA("BasePart")then z.CanCollide=true end end end
end
end)

bb2.MouseButton1Click:Connect(function()g:Destroy()end)
bb1.MouseButton1Click:Connect(function()fr.Visible=false end)

pl.CharacterAdded:Connect(function()
fly=false e=false
r:UnbindFromRenderStep("fly")
if v then v:Destroy()v=nil end
bt.Text="DISABLED"
lbl.Text="Status: Off"
end)
