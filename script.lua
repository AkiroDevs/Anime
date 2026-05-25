--[[
    KRONOS PREMIUM HUB - UNIFIED & FIXED EDITION
    REPOSITÓRIO: AkiroDevs/Anime
]]

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local Lighting = game:GetService("Lighting")

local player = Players.LocalPlayer

local targetGui = (RunService:IsStudio() and player.PlayerGui) or CoreGui
for _, v in pairs(targetGui:GetChildren()) do
    if v.Name == "KronosInterfaceCore" then v:Destroy() end
end

local COLORS = {
    Main = Color3.fromRGB(33, 24, 19), sidebar = Color3.fromRGB(24, 17, 13),
    Accent = Color3.fromRGB(254, 144, 18), Card = Color3.fromRGB(43, 31, 24),
    Text = Color3.fromRGB(245, 245, 245), DarkText = Color3.fromRGB(154, 140, 132),
    WindowBtns = Color3.fromRGB(185, 102, 14)
}

local gui = Instance.new("ScreenGui")
gui.Name = "KronosInterfaceCore"
gui.Parent = targetGui
gui.ResetOnSpawn = false

-- ==========================================
-- INTRODUÇÃO (BLINDADA)
-- ==========================================
local introFrame = Instance.new("Frame", gui)
introFrame.Size = UDim2.new(1, 0, 1, 0)
introFrame.BackgroundColor3 = Color3.fromRGB(10, 8, 7)
introFrame.ZIndex = 1000

local introText = Instance.new("TextLabel", introFrame)
introText.Size = UDim2.new(1, 0, 1, 0)
introText.BackgroundTransparency = 1
introText.Text = "K R O N O S"
introText.Font = Enum.Font.GothamBold
introText.TextSize = 54
introText.TextColor3 = COLORS.Accent
introText.TextTransparency = 1
introText.ZIndex = 1001

-- ==========================================
-- PAINEL PRINCIPAL
-- ==========================================
local main = Instance.new("Frame", gui)
main.Name = "MainFrame"
main.Size = UDim2.new(0, 560, 0, 360)
main.Position = UDim2.new(0.5, -280, 0.5, -180)
main.BackgroundColor3 = COLORS.Main
main.BackgroundTransparency = 0.05
main.ClipsDescendants = true
main.Visible = false
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 10)

local shortcutIcon = Instance.new("TextButton", gui)
shortcutIcon.Size = UDim2.new(0, 45, 0, 45)
shortcutIcon.Position = UDim2.new(0.02, 0, 0.15, 0)
shortcutIcon.BackgroundColor3 = COLORS.sidebar
shortcutIcon.Text = "K"
shortcutIcon.Font = Enum.Font.GothamBold
shortcutIcon.TextColor3 = COLORS.Accent
shortcutIcon.TextSize = 18
shortcutIcon.Visible = false
Instance.new("UICorner", shortcutIcon).CornerRadius = UDim.new(0, 8)

-- CONTROLE DE EXIBIÇÃO DA INTRO
task.spawn(function()
    task.wait(0.2)
    TweenService:Create(introText, TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 0}):Play()
    task.wait(1.2)
    TweenService:Create(introText, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {TextTransparency = 1}):Play()
    task.wait(0.2)
    main.Visible = true
    main.Size = UDim2.new(0, 560, 0, 0)
    TweenService:Create(main, TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, 560, 0, 360)}):Play()
    TweenService:Create(introFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quad), {BackgroundTransparency = 1}):Play()
    task.wait(0.4)
    introFrame:Destroy()
end)

-- ==========================================
-- ESTRUTURA LATERAL & PERFIL
-- ==========================================
local sidebar = Instance.new("Frame", main)
sidebar.Size = UDim2.new(0, 165, 1, 0)
sidebar.BackgroundColor3 = COLORS.sidebar
sidebar.BorderSizePixel = 0

local logo = Instance.new("TextLabel", sidebar)
logo.Size = UDim2.new(1, 0, 0, 45)
logo.Position = UDim2.new(0, 0, 0, 10)
logo.Text = "KRONOS HUB" 
logo.Font = Enum.Font.GothamBold
logo.TextSize = 14
logo.TextColor3 = COLORS.Text
logo.BackgroundTransparency = 1

local profileFrame = Instance.new("Frame", sidebar)
profileFrame.Size = UDim2.new(0.88, 0, 0, 45)
profileFrame.Position = UDim2.new(0.06, 0, 1, -55) 
profileFrame.BackgroundColor3 = Color3.fromRGB(18, 13, 10)
Instance.new("UICorner", profileFrame).CornerRadius = UDim.new(0, 8)

local avatarImg = Instance.new("ImageLabel", profileFrame)
avatarImg.Size = UDim2.new(0, 30, 0, 30)
avatarImg.Position = UDim2.new(0, 8, 0.5, -15)
avatarImg.BackgroundColor3 = COLORS.Card
avatarImg.Image = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. player.UserId .. "&width=150&height=150&format=png"
Instance.new("UICorner", avatarImg).CornerRadius = UDim.new(1, 0)

local userLabel = Instance.new("TextLabel", profileFrame)
userLabel.Size = UDim2.new(1, -48, 0, 14)
userLabel.Position = UDim2.new(0, 44, 0, 8)
userLabel.BackgroundTransparency = 1
userLabel.Text = player.DisplayName
userLabel.Font = Enum.Font.GothamBold
userLabel.TextSize = 11
userLabel.TextColor3 = COLORS.Text
userLabel.TextXAlignment = Enum.TextXAlignment.Left

local subLabel = Instance.new("TextLabel", profileFrame)
subLabel.Size = UDim2.new(1, -48, 0, 12)
subLabel.Position = UDim2.new(0, 44, 0, 24)
subLabel.BackgroundTransparency = 1
subLabel.Text = "@" .. player.Name
subLabel.Font = Enum.Font.Gotham
subLabel.TextSize = 9
subLabel.TextColor3 = COLORS.DarkText
subLabel.TextXAlignment = Enum.TextXAlignment.Left

local scrollTabs = Instance.new("ScrollingFrame", sidebar)
scrollTabs.Size = UDim2.new(1, 0, 1, -130) 
scrollTabs.Position = UDim2.new(0, 0, 0, 65)
scrollTabs.BackgroundTransparency = 1
scrollTabs.BorderSizePixel = 0
scrollTabs.ScrollBarThickness = 0
local sideLayout = Instance.new("UIListLayout", scrollTabs)
sideLayout.Padding = UDim.new(0, 5)
sideLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

local contentContainer = Instance.new("Frame", main)
contentContainer.Size = UDim2.new(1, -180, 1, -60)
contentContainer.Position = UDim2.new(0, 175, 0, 50)
contentContainer.BackgroundTransparency = 1

local abasAtivas = {}
local function registrarCategoria(nome)
    local btn = Instance.new("TextButton", scrollTabs)
    btn.Size = UDim2.new(0.92, 0, 0, 32)
    btn.BackgroundTransparency = 1
    btn.Text = "   " .. nome
    btn.TextColor3 = COLORS.DarkText
    btn.Font = Enum.Font.GothamMedium
    btn.TextSize = 13
    btn.TextXAlignment = Enum.TextXAlignment.Left
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 5)

    local page = Instance.new("ScrollingFrame", contentContainer)
    page.Size = UDim2.new(1, 0, 1, 0)
    page.Visible = false
    page.BackgroundTransparency = 1
    page.BorderSizePixel = 0
    page.ScrollBarThickness = 2
    page.ScrollBarImageColor3 = COLORS.Accent
    local pageLayout = Instance.new("UIListLayout", page)
    pageLayout.Padding = UDim.new(0, 8)

    btn.MouseButton1Click:Connect(function()
        for _, obj in pairs(abasAtivas) do
            obj.Page.Visible = false
            obj.Button.TextColor3 = COLORS.DarkText
            obj.Button.BackgroundTransparency = 1
        end
        page.Visible = true
        btn.TextColor3 = COLORS.Text
        btn.BackgroundColor3 = COLORS.Card
        btn.BackgroundTransparency = 0
    end)

    abasAtivas[nome] = {Page = page, Button = btn}
    return page
end

local pCharacter = registrarCategoria("Character")
local pTeleport  = registrarCategoria("Teleport")
local pCombat    = registrarCategoria("Combat")
local pESP       = registrarCategoria("ESP")
local pVisual    = registrarCategoria("Visual")
local pTrolling  = registrarCategoria("Trolling")
local pOther     = registrarCategoria("Other")

-- ==========================================
-- FÁBRICA DE COMPONENTES INTERNOS
-- ==========================================
local function criarToggle(aba, titulo, padrao, callback)
    local card = Instance.new("Frame", aba)
    card.Size = UDim2.new(0.96, 0, 0, 45)
    card.BackgroundColor3 = COLORS.Card
    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 6)
    
    local tLabel = Instance.new("TextLabel", card)
    tLabel.Size = UDim2.new(0.7, 0, 1, 0)
    tLabel.Position = UDim2.new(0, 12, 0, 0)
    tLabel.Text = titulo
    tLabel.Font = Enum.Font.GothamBold
    tLabel.TextSize = 13
    tLabel.TextColor3 = COLORS.Text
    tLabel.BackgroundTransparency = 1
    tLabel.TextXAlignment = Enum.TextXAlignment.Left

    local switch = Instance.new("TextButton", card)
    switch.Size = UDim2.new(0, 40, 0, 20)
    switch.Position = UDim2.new(1, -52, 0.5, -10)
    switch.BackgroundColor3 = padrao and COLORS.Accent or Color3.fromRGB(20, 15, 12)
    switch.Text = ""
    Instance.new("UICorner", switch).CornerRadius = UDim.new(1, 0)

    local indicator = Instance.new("Frame", switch)
    indicator.Size = UDim2.new(0, 14, 0, 14)
    indicator.Position = padrao and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7)
    indicator.BackgroundColor3 = COLORS.Text
    Instance.new("UICorner", indicator).CornerRadius = UDim.new(1, 0)

    local estado = padrao
    switch.MouseButton1Click:Connect(function()
        estado = not estado
        local tPos = estado and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7)
        local tColor = estado and COLORS.Accent or Color3.fromRGB(20, 15, 12)
        TweenService:Create(indicator, TweenInfo.new(0.2), {Position = tPos}):Play()
        TweenService:Create(switch, TweenInfo.new(0.2), {BackgroundColor3 = tColor}):Play()
        task.spawn(callback, estado)
    end)
end

local function criarSlider(aba, titulo, min, max, padrao, callback)
    local card = Instance.new("Frame", aba)
    card.Size = UDim2.new(0.96, 0, 0, 55)
    card.BackgroundColor3 = COLORS.Card
    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 6)

    local tLabel = Instance.new("TextLabel", card)
    tLabel.Size = UDim2.new(0.5, 0, 0.5, 0)
    tLabel.Position = UDim2.new(0, 12, 0.1, 0)
    tLabel.Text = titulo
    tLabel.Font = Enum.Font.GothamBold
    tLabel.TextSize = 13
    tLabel.TextColor3 = COLORS.Text
    tLabel.BackgroundTransparency = 1
    tLabel.TextXAlignment = Enum.TextXAlignment.Left

    local valLabel = Instance.new("TextLabel", card)
    valLabel.Size = UDim2.new(0.3, 0, 0.5, 0)
    valLabel.Position = UDim2.new(1, -112, 0.1, 0)
    valLabel.Text = tostring(padrao)
    valLabel.Font = Enum.Font.GothamBold
    valLabel.TextSize = 12
    valLabel.TextColor3 = COLORS.Accent
    valLabel.BackgroundTransparency = 1
    valLabel.TextXAlignment = Enum.TextXAlignment.Right

    local track = Instance.new("Frame", card)
    track.Size = UDim2.new(0.92, 0, 0, 4)
    track.Position = UDim2.new(0.04, 0, 0.7, 0)
    track.BackgroundColor3 = Color3.fromRGB(20, 15, 12)
    track.BorderSizePixel = 0

    local fill = Instance.new("Frame", track)
    local percPadrao = (padrao - min) / (max - min)
    fill.Size = UDim2.new(percPadrao, 0, 1, 0)
    fill.BackgroundColor3 = COLORS.Accent
    fill.BorderSizePixel = 0

    local knob = Instance.new("TextButton", track)
    knob.Size = UDim2.new(0, 10, 0, 10)
    knob.Position = UDim2.new(percPadrao, -5, 0.5, -5)
    knob.BackgroundColor3 = COLORS.Text
    knob.Text = ""
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

    local arrastando = false
    knob.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then arrastando = true end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if arrastando and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local posX = math.clamp((input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
            fill.Size = UDim2.new(posX, 0, 1, 0)
            knob.Position = UDim2.new(posX, -5, 0.5, -5)
            local valor = math.floor(min + (posX * (max - min)))
            valLabel.Text = tostring(valor)
            task.spawn(callback, valor)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then arrastando = false end
    end)
end

local function criarBotao(aba, titulo, callback)
    local btn = Instance.new("TextButton", aba)
    btn.Size = UDim2.new(0.96, 0, 0, 40)
    btn.BackgroundColor3 = COLORS.Card
    btn.Text = titulo
    btn.Font = Enum.Font.GothamBold
    btn.TextColor3 = COLORS.Text
    btn.TextSize = 13
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    btn.MouseButton1Click:Connect(callback)
    return btn
end

-- ==========================================
-- ABA: CHARACTER (FÍSICA & FLY AUTOMÁTICO)
-- ==========================================
local VARS = { Speed = 16, Jump = 50, Spider = false, Noclip = false, InfJump = false }

UserInputService.JumpRequest:Connect(function()
    local char = player.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if hum and root then
        if VARS.InfJump then
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
            root.AssemblyLinearVelocity = Vector3.new(root.AssemblyLinearVelocity.X, VARS.Jump * 0.85, root.AssemblyLinearVelocity.Z)
        elseif VARS.Jump > 50 and hum.FloorMaterial ~= Enum.Material.Air then
            root.AssemblyLinearVelocity = Vector3.new(root.AssemblyLinearVelocity.X, VARS.Jump * 0.85, root.AssemblyLinearVelocity.Z)
        end
    end
end)

RunService.Heartbeat:Connect(function()
    local char = player.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if hum and root then
        if VARS.Speed > 16 and hum.MoveDirection.Magnitude > 0 then
            root.AssemblyLinearVelocity = Vector3.new(hum.MoveDirection.X * VARS.Speed, root.AssemblyLinearVelocity.Y, hum.MoveDirection.Z * VARS.Speed)
        end
        if VARS.Spider then
            local params = RaycastParams.new()
            params.FilterDescendantsInstances = {char}
            params.FilterType = Enum.RaycastFilterType.Exclude
            local hit = workspace:Raycast(root.Position, root.CFrame.LookVector * 2.5, params)
            if hit and hit.Instance.CanCollide then
                hum:ChangeState(Enum.HumanoidStateType.Climbing)
                root.AssemblyLinearVelocity = Vector3.new(root.AssemblyLinearVelocity.X, VARS.Speed * 0.8, root.AssemblyLinearVelocity.Z)
            end
        end
    end
end)

criarSlider(pCharacter, "WalkSpeed", 16, 150, 16, function(v) VARS.Speed = v end)
criarSlider(pCharacter, "JumpPower", 50, 200, 50, function(v) VARS.Jump = v end)
criarToggle(pCharacter, "Infinite Jump", false, function(v) VARS.InfJump = v end)
criarToggle(pCharacter, "Spider Mode", false, function(v) VARS.Spider = v end)

-- BOTÃO FLY DO USUÁRIO INTEGRADO
criarBotao(pCharacter, "🚀 Executar Fly (FlyGuiV3)", function()
    task.spawn(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/XNEOFF/FlyGuiV3/main/FlyGuiV3.txt"))()
    end)
end)

criarToggle(pCharacter, "Noclip", false, function(estado)
    VARS.Noclip = estado
    if estado then
        RunService:BindToRenderStep("NoclipK", 1, function()
            if player.Character then
                for _, p in pairs(player.Character:GetChildren()) do
                    if p:IsA("BasePart") then p.CanCollide = false end
                end
            end
        end)
    else RunService:UnbindFromRenderStep("NoclipK") end
end)

-- ==========================================
-- ABA: TELEPORT
-- ==========================================
local function addTP(nome, cf)
    criarBotao(pTeleport, "✈️ " .. nome, function()
        local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        if root then root.CFrame = cf end
    end)
end
addTP("Banco (Cofre)", CFrame.new(-1.39, 17.75, 254.11))
addTP("Praça Central", CFrame.new(-54.05, 3.30, 18.26))
addTP("Placa da Montanha", CFrame.new(-248.25, 88.50, -553.43))

-- ==========================================
-- ABA: VISUAL (LISTA SPECTATE REAL & CÂMERAS)
-- ==========================================
local specContainer = Instance.new("Frame", pVisual)
specContainer.Size = UDim2.new(0.96, 0, 0, 130)
specContainer.BackgroundColor3 = Color3.fromRGB(24, 18, 14)
Instance.new("UICorner", specContainer).CornerRadius = UDim.new(0, 6)

local specTitle = Instance.new("TextLabel", specContainer)
specTitle.Size = UDim2.new(1, 0, 0, 25)
specTitle.Position = UDim2.new(0, 10, 0, 2)
specTitle.Text = "SELECIONE UM JOGADOR PARA ESPIAR:"
specTitle.Font = Enum.Font.GothamBold
specTitle.TextSize = 11
specTitle.TextColor3 = COLORS.Accent
specTitle.BackgroundTransparency = 1
specTitle.TextXAlignment = Enum.TextXAlignment.Left

local specScroll = Instance.new("ScrollingFrame", specContainer)
specScroll.Size = UDim2.new(1, -16, 1, -32)
specScroll.Position = UDim2.new(0, 8, 0, 27)
specScroll.BackgroundTransparency = 1
specScroll.ScrollBarThickness = 3
specScroll.ScrollBarImageColor3 = COLORS.Accent
local specLayout = Instance.new("UIListLayout", specScroll)
specLayout.Padding = UDim.new(0, 4)

local function atualizarListaSpectate()
    for _, child in pairs(specScroll:GetChildren()) do
        if child:IsA("TextButton") then child:Destroy() end
    end
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= player then
            local pBtn = Instance.new("TextButton", specScroll)
            pBtn.Size = UDim2.new(0.96, 0, 0, 25)
            pBtn.BackgroundColor3 = COLORS.Card
            pBtn.Text = "   " .. plr.DisplayName .. " (@" .. plr.Name .. ")"
            pBtn.Font = Enum.Font.GothamMedium
            pBtn.TextSize = 11
            pBtn.TextColor3 = COLORS.Text
            pBtn.TextXAlignment = Enum.TextXAlignment.Left
            Instance.new("UICorner", pBtn).CornerRadius = UDim.new(0, 4)
            
            pBtn.MouseButton1Click:Connect(function()
                if plr.Character and plr.Character:FindFirstChild("Humanoid") then
                    workspace.CurrentCamera.CameraSubject = plr.Character.Humanoid
                    specTitle.Text = "ESPIANDO: " .. plr.DisplayName
                end
            end)
        end
    end
    specScroll.CanvasSize = UDim2.new(0, 0, 0, specLayout.AbsoluteContentSize.Y)
end
Players.PlayerAdded:Connect(atualizarListaSpectate)
Players.PlayerRemoving:Connect(atualizarListaSpectate)
task.spawn(atualizarListaSpectate)

criarBotao(pVisual, "🔄 Atualizar Lista de Players", atualizarListaSpectate)
criarBotao(pVisual, "↩️ Voltar Câmera para o Meu Boneco", function()
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        workspace.CurrentCamera.CameraSubject = player.Character.Humanoid
        specTitle.Text = "SELECIONE UM JOGADOR PARA ESPIAR:"
    end
end)

criarToggle(pVisual, "Freeze Cam (Congelar Câmera)", false, function(estado)
    workspace.CurrentCamera.CameraType = estado and Enum.CameraType.Scriptable or Enum.CameraType.Custom
end)

criarToggle(pVisual, "Night Vision & Sem Neblina", false, function(estado)
    if estado then
        Lighting.Ambient = Color3.new(1, 1, 1)
        Lighting.FogEnd = 100000
    else
        Lighting.Ambient = Color3.fromRGB(128, 128, 128)
        Lighting.FogEnd = 10000
    end
end)

criarSlider(pVisual, "Field of View (FOV)", 70, 120, 70, function(v) workspace.CurrentCamera.FieldOfView = v end)

-- ==========================================
-- ABAS ADICIONAIS (ESP, COMBAT, TROLLING, OTHER)
-- ==========================================
local espAtivo = false
criarToggle(pESP, "Player ESP (Highlight)", false, function(estado)
    espAtivo = estado
    while espAtivo do
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= player and plr.Character and not plr.Character:FindFirstChild("KronosESP") then
                local h = Instance.new("Highlight", plr.Character)
                h.Name = "KronosESP" h.FillColor = COLORS.Accent h.OutlineColor = Color3.new(1,1,1) h.FillTransparency = 0.5
            end
        end
        task.wait(1)
    end
    if not espAtivo then
        for _, plr in pairs(Players:GetPlayers()) do
            if plr.Character and plr.Character:FindFirstChild("KronosESP") then plr.Character.KronosESP:Destroy() end
        end
    end
end)

local hitboxesAtivas = false
criarSlider(pCombat, "Expandir Hitbox", 2, 20, 2, function(v)
    hitboxesAtivas = (v > 2)
    while hitboxesAtivas do
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                local hrp = plr.Character.HumanoidRootPart
                hrp.Size = Vector3.new(v, v, v)
                hrp.Transparency = 0.6
                hrp.BrickColor = BrickColor.new("Bright red")
                hrp.CanCollide = false
            end
        end
        task.wait(1)
    end
end)

local spinAtivo = false
criarToggle(pTrolling, "Spin Bot", false, function(estado)
    spinAtivo = estado
    if estado then
        RunService:BindToRenderStep("KronosSpin", 1, function()
            local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
            if root then root.CFrame = root.CFrame * CFrame.Angles(0, math.rad(50), 0) end
        end)
    else RunService:UnbindFromRenderStep("KronosSpin") end
end)

criarBotao(pOther, "🛠️ Dar BTools (Local)", function()
    Instance.new("HopperBin", player.Backpack).BinType = Enum.BinType.Clone
    Instance.new("HopperBin", player.Backpack).BinType = Enum.BinType.Hammer
    Instance.new("HopperBin", player.Backpack).BinType = Enum.BinType.Grab
end)

-- ==========================================
-- CONTROLES DE JANELA & CONEXÃO DE ARRASTO
-- ==========================================
local windowControls = Instance.new("Frame", main)
windowControls.Size = UDim2.new(0, 100, 0, 30)
windowControls.Position = UDim2.new(1, -110, 0, 10)
windowControls.BackgroundTransparency = 1
local controlLayout = Instance.new("UIListLayout", windowControls)
controlLayout.FillDirection = Enum.FillDirection.Horizontal
controlLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
controlLayout.Padding = UDim.new(0, 15)

local function criarTopBtn(simb, size, acao)
    local b = Instance.new("TextButton", windowControls)
    b.Size = UDim2.new(0, 16, 0, 16)
    b.BackgroundTransparency = 1
    b.Text = simb
    b.Font = Enum.Font.GothamBold
    b.TextSize = size
    b.TextColor3 = COLORS.WindowBtns
    b.MouseButton1Click:Connect(acao)
end

criarTopBtn("—", 13, function() main.Visible = false shortcutIcon.Visible = true end)

local estadoExpandido = false
criarTopBtn("🗖", 11, function()
    estadoExpandido = not estadoExpandido
    if estadoExpandido then
        main.Size = UDim2.new(0, 680, 0, 430)
        main.Position = UDim2.new(0.5, -340, 0.5, -215)
    else
        main.Size = UDim2.new(0, 560, 0, 360)
        main.Position = UDim2.new(0.5, -280, 0.5, -180)
    end
end)

criarTopBtn("✕", 13, function() gui:Destroy() end)
shortcutIcon.MouseButton1Click:Connect(function() shortcutIcon.Visible = false main.Visible = true end)

local function vincularArrasto(instancia)
    local drag, startPos, pos
    instancia.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            drag = true startPos = input.Position pos = instancia.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if drag and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - startPos
            instancia.Position = UDim2.new(pos.X.Scale, pos.X.Offset + delta.X, pos.Y.Scale, pos.Y.Offset + delta.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then drag = false end
    end)
end
vincularArrasto(main)
vincularArrasto(shortcutIcon)

-- Estado Inicial Padrão
abasAtivas["Character"].Page.Visible = true
abasAtivas["Character"].Button.TextColor3 = COLORS.Text
abasAtivas["Character"].Button.BackgroundColor3 = COLORS.Card
abasAtivas["Character"].Button.BackgroundTransparency = 0
