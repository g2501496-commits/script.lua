local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "gkzz_DeltaSafeUI"
ScreenGui.ResetOnSpawn = false
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 260, 0, 240)
MainFrame.Position = UDim2.new(0.4, 0, 0.4, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.Active = true
local UIStroke = Instance.new("UIStroke")
UIStroke.Thickness = 3
UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke.Parent = MainFrame
local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, 0, 0.15, 0)
TitleLabel.Text = "gkzz__ MULTIFARM"
TitleLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
TitleLabel.TextSize = 22
TitleLabel.Font = Enum.Font.SourceSansBold
TitleLabel.BackgroundTransparency = 1
TitleLabel.Parent = MainFrame
local ToggleButton = Instance.new("TextButton")
ToggleButton.Size = UDim2.new(0.9, 0, 0.18, 0)
ToggleButton.Position = UDim2.new(0.05, 0, 0.18, 0)
ToggleButton.Text = "FARM: DESATIVADO"
ToggleButton.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.Font = Enum.Font.SourceSansBold
ToggleButton.TextSize = 16
ToggleButton.ZIndex = 5
ToggleButton.Parent = MainFrame
local FlingButton = Instance.new("TextButton")
FlingButton.Size = UDim2.new(0.9, 0, 0.18, 0)
FlingButton.Position = UDim2.new(0.05, 0, 0.38, 0)
FlingButton.Text = "FLING MURDERER: DESATIVADO"
FlingButton.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
FlingButton.TextColor3 = Color3.fromRGB(255, 255, 255)
FlingButton.Font = Enum.Font.SourceSansBold
FlingButton.TextSize = 14
FlingButton.ZIndex = 5
FlingButton.Parent = MainFrame
local RolesLabel = Instance.new("TextLabel")
RolesLabel.Size = UDim2.new(1, 0, 0.15, 0)
RolesLabel.Position = UDim2.new(0, 0, 0.60, 0)
RolesLabel.Text = "Procurando Faca..."
RolesLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
RolesLabel.TextSize = 14
RolesLabel.Font = Enum.Font.SourceSansItalic
RolesLabel.BackgroundTransparency = 1
RolesLabel.Parent = MainFrame
local FlyInfoLabel = Instance.new("TextLabel")
FlyInfoLabel.Size = UDim2.new(1, 0, 0.12, 0)
FlyInfoLabel.Position = UDim2.new(0, 0, 0.82, 0)
FlyInfoLabel.Text = "Pressione [E] para VOAR"
FlyInfoLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
FlyInfoLabel.TextSize = 14
FlyInfoLabel.BackgroundTransparency = 1
FlyInfoLabel.Parent = MainFrame
MainFrame.Parent = ScreenGui
ScreenGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
task.spawn(function()
while true do
for i = 0, 1, 0.005 do
local corRGB = Color3.fromHSV(i, 1, 1)
if UIStroke and UIStroke.Parent then UIStroke.Color = corRGB end
if TitleLabel and TitleLabel.Parent then TitleLabel.TextColor3 = corRGB end
task.wait(0.02)
end
end
end)
local murderObj = nil
task.spawn(function()
while true do
task.wait(0.2)
local murderName = "Nenhum"
murderObj = nil
for _, p in ipairs(Players:GetPlayers()) do
if p.Character and p ~= Players.LocalPlayer then
if p.Backpack:FindFirstChild("Knife") or p.Character:FindFirstChild("Knife") then
murderName = p.Name
murderObj = p.Character
end
end
end
RolesLabel.Text = string.format("Murderer: %s", murderName)
end
end)
local voando = false
local flySpeed = 50
local flyConnection
UserInputService.InputBegan:Connect(function(input, processed)
if processed then return end
if input.KeyCode == Enum.KeyCode.E then
local character = Players.LocalPlayer.Character
local root = character and character:FindFirstChild("HumanoidRootPart")
local humanoid = character and character:FindFirstChildOfClass("Humanoid")
if not root or not humanoid then return end
voando = not voando
if voando then
FlyInfoLabel.Text = "FLY (VOAR): LIGADO"
FlyInfoLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
local bv = Instance.new("BodyVelocity")
bv.Name = "FlyVelocity"
bv.MaxForce = Vector3.new(1e5, 1e5, 1e5)
bv.Velocity = Vector3.zero
bv.Parent = root
humanoid.PlatformStand = true
flyConnection = RunService.Heartbeat:Connect(function()
if not root or not bv.Parent then return end
local cameraCFrame = workspace.CurrentCamera.CFrame
local direcao = Vector3.zero
if UserInputService:IsKeyDown(Enum.KeyCode.W) then direcao = direcao + cameraCFrame.LookVector end
if UserInputService:IsKeyDown(Enum.KeyCode.S) then direcao = direcao - cameraCFrame.LookVector end
if UserInputService:IsKeyDown(Enum.KeyCode.A) then direcao = direcao - cameraCFrame.RightVector end
if UserInputService:IsKeyDown(Enum.KeyCode.D) then direcao = direcao + cameraCFrame.RightVector end
bv.Velocity = direcao * flySpeed
root.CFrame = CFrame.new(root.Position, root.Position + cameraCFrame.LookVector)
end)
else
FlyInfoLabel.Text = "Pressione [E] para VOAR"
FlyInfoLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
if flyConnection then flyConnection:Disconnect() end
local bv = root:FindFirstChild("FlyVelocity")
if bv then bv:Destroy() end
humanoid.PlatformStand = false
end
end
end)
local dragging, dragInput, dragStart, startPos
local function update(input)
local delta = input.Position - dragStart
MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end
MainFrame.InputBegan:Connect(function(input)
if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
dragging = true
dragStart = input.Position
startPos = MainFrame.Position
input.Changed:Connect(function()
if input.UserInputState == Enum.UserInputState.End then dragging = false end
end)
end
end)
MainFrame.InputChanged:Connect(function(input)
if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
dragInput = input
end
end)
UserInputService.InputChanged:Connect(function(input)
if input == dragInput and dragging then update(input) end
end)
local executando = false
local LocalPlayer = Players.LocalPlayer
local vooAtual = nil
local function iniciarAutofarm()
task.spawn(function()
local VELOCIDADE_VOO = 35
while executando do
task.wait(0.05)
if not executando then break end
local character = LocalPlayer.Character
local rootPart = character and character:FindFirstChild("HumanoidRootPart")
if rootPart then
local moedaMaisProxima = nil
local menorDistancia = math.huge
for _, objeto in ipairs(workspace:GetDescendants()) do
if objeto:IsA("BasePart") and (objeto.Name:find("Coin") or objeto.Name:find("Moeda") or objeto.Name:find("Cupcake")) then
if objeto.Parent and objeto.Transparency < 1 then
local distancia = (rootPart.Position - objeto.Position).Magnitude
if distancia < menorDistancia then
menorDistancia = distancia
moedaMaisProxima = objeto
end
end
end
end
if moedaMaisProxima and executando then
local targetCoin = moedaMaisProxima
local distanciaAtual = (rootPart.Position - targetCoin.Position).Magnitude
local tempoVoo = distanciaAtual / VELOCIDADE_VOO
local infoTween = TweenInfo.new(tempoVoo, Enum.EasingStyle.Linear)
local posicaoAlvo = targetCoin.CFrame * CFrame.new(0, -0.2, 0) * CFrame.Angles(math.rad(-90), 0, 0)
vooAtual = TweenService:Create(rootPart, infoTween, {CFrame = posicaoAlvo})
local verificadorMoeda
local vooInterrompido = false
verificadorMoeda = RunService.RenderStepped:Connect(function()
if rootPart then rootPart.AssemblyLinearVelocity = Vector3.zero end
if not executando or not targetCoin or not targetCoin:IsDescendantOf(workspace) or targetCoin.Transparency >= 1 then
if vooAtual then vooAtual:Cancel() end
vooInterrompido = true
verificadorMoeda:Disconnect()
end
end)
if vooAtual then vooAtual:Play() end
vooAtual.Completed:Wait()
if not vooInterrompido and verificadorMoeda.Connected then
verificadorMoeda:Disconnect()
end
if executando and not vooInterrompido and rootPart and targetCoin and targetCoin:IsDescendantOf(workspace) then
rootPart.CFrame = targetCoin.CFrame * CFrame.Angles(math.rad(-90), 0, 0)
task.wait(0.02)
end
end
end
end
end)
end
local flingAtivo = false
local function iniciarAutoFlingAlvos()
task.spawn(function()
local FlingForceConnection
while flingAtivo do
task.wait(0.01)
local character = LocalPlayer.Character
local rootPart = character and character:FindFirstChild("HumanoidRootPart")
local humanoid = character and character:FindFirstChildOfClass("Humanoid")
if rootPart and humanoid and humanoid.Health > 0 then
local inimigo = murderObj and murderObj:FindFirstChild("HumanoidRootPart")
if inimigo and inimigo.Parent:FindFirstChildOfClass("Humanoid") and inimigo.Parent:FindFirstChildOfClass("Humanoid").Health > 0 then
if not rootPart:FindFirstChild("DeltaFling") then
local pFling = Instance.new("BodyAngularVelocity")
pFling.Name = "DeltaFling"
pFling.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
pFling.AngularVelocity = Vector3.new(0, 9999999, 0)
pFling.Parent = rootPart
end
if not FlingForceConnection then
FlingForceConnection = RunService.Heartbeat:Connect(function()
if flingAtivo and rootPart then
rootPart.AssemblyLinearVelocity = Vector3.new(999999, 999999, 999999)
rootPart.AssemblyAngularVelocity = Vector3.new(999999, 999999, 999999)
end
end)
end
humanoid.PlatformStand = true
for r = 1, 8 do
if not flingAtivo or not inimigo or not inimigo.Parent then break end
rootPart.CFrame = inimigo.CFrame * CFrame.new(math.sin(r)*1.5, 0, math.cos(r)*1.5)
RunService.Heartbeat:Wait()
end
if FlingForceConnection then
FlingForceConnection:Disconnect()
FlingForceConnection = nil
end
local pFling = rootPart:FindFirstChild("DeltaFling")
if pFling then pFling:Destroy() end
humanoid.PlatformStand = false
rootPart.AssemblyLinearVelocity = Vector3.zero
rootPart.AssemblyAngularVelocity = Vector3.zero
task.wait(0.02)
end
end
end
if FlingForceConnection then FlingForceConnection:Disconnect() end
local pFling = rootPart and rootPart:FindFirstChild("DeltaFling")
if pFling then pFling:Destroy() end
end)
end
ToggleButton.Activated:Connect(function()
executando = not executando
if executando then
ToggleButton.Text = "FARM: ATIVADO"
ToggleButton.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
iniciarAutofarm()
else
ToggleButton.Text = "FARM: DESATIVADO"
ToggleButton.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
if vooAtual then vooAtual:Cancel() end
local character = LocalPlayer.Character
local rootPart = character and character:FindFirstChild("HumanoidRootPart")
if rootPart then rootPart.AssemblyLinearVelocity = Vector3.zero end
end
end)
FlingButton.Activated:Connect(function()
flingAtivo = not flingAtivo
if flingAtivo then
FlingButton.Text = "FLING MURDERER: ATIVADO"
FlingButton.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
iniciarAutoFlingAlvos()
else
FlingButton.Text = "FLING MURDERER: DESATIVADO"
FlingButton.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
local character = LocalPlayer.Character
local rootPart = character and character:FindFirstChild("HumanoidRootPart")
local humanoid = character and character:FindFirstChildOfClass("Humanoid")
if rootPart then
rootPart.AssemblyLinearVelocity = Vector3.zero
rootPart.AssemblyAngularVelocity = Vector3.zero
local pFling = rootPart:FindFirstChild("DeltaFling")
if pFling then pFling:Destroy() end
end
if humanoid then humanoid.PlatformStand = false end
end
end)
LocalPlayer.CharacterRemoving:Connect(function()
executando = false
flingAtivo = false
voando = false
ToggleButton.Text = "FARM: DESATIVADO"
ToggleButton.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
FlingButton.Text = "FLING MURDERER: DESATIVADO"
FlingButton.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
end)
