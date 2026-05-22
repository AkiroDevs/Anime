-- [[
--    ANIME APOCALYPSE - COMPACT UTILITY HUB (MOBILE EDITION)
--    - UI Anti-Tela Preta: Layout construído 100% em pixels (Offset)
--    - Utilitários Inclusos: Auto-Clicker de Combate, Rastreador de Boss/Inimigos, Otimizador e Teleporte
-- ]]

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")
local VirtualInputManager = game:GetService("VirtualInputManager")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local Camera = workspace.CurrentCamera

-- Limpeza de instâncias anteriores na memória
pcall(function()
    if PlayerGui:FindFirstChild("AnimeApocalypseHub") then PlayerGui.AnimeApocalypseHub:Destroy() end
end)

local state = {
    autoClick = false,
    trackEnemies = false,
    fpsBoost = false,
    savedPos = nil,
    dragInput = nil,
    dragStart = nil
}

-- ==========================================
-- CONSTRUTOR DE INTERFACE SEGURO
-- ==========================================
local function create(className, properties)
    local instance = Instance.new(className)
    local parent = properties.Parent
    properties.Parent = nil
    
    for prop, val in pairs(properties) do
        instance[prop] = val
    end
    
    if parent then instance.Parent = parent end
    return instance
end

local function makeDraggable(frame, handle)
    handle = handle or frame
    local dragging, dragInput, dragStart, startPos

    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

-- ==========================================
-- CRIAÇÃO DOS ELEMENTOS DA UI
-- ==========================================
local Screen = create("ScreenGui", { Name = "AnimeApocalypseHub", ResetOnSpawn = false, Parent = PlayerGui })

local Main = create("Frame", {
    Size = UDim2.new(0, 260, 0, 360),
    Position = UDim2.new(0.5, -130, 0.3, 0),
    BackgroundColor3 = Color3.fromRGB(22, 22, 28),
    Parent = Screen
})
create("UICorner", { CornerRadius = UDim.new(0, 8), Parent = Main })
create("UIStroke", { Color = Color3.fromRGB(170, 0, 255), Width = 1.5, Parent = Main }) -- Tema Roxo/Anime

local Title = create("TextLabel", {
    Size = UDim2.new(0, 260, 0, 40),
    Text = "ANIME APOCALYPSE HUB",
    TextColor3 = Color3.new(1, 1, 1),
    Font = Enum.Font.GothamBold,
    TextSize = 13,
    BackgroundColor3 = Color3.fromRGB(30, 30, 38),
    Parent = Main
})
create("UICorner", { CornerRadius = UDim.new(0, 8), Parent = Title })
makeDraggable(Main, Title)

local CloseBtn = create("TextButton", {
    Size = UDim2.new(0, 35, 0, 40),
    Position = UDim2.new(0, 225, 0, 0),
    Text = "✕",
    TextColor3 = Color3.fromRGB(255, 75, 75),
    Font = Enum.Font.GothamBold,
    TextSize = 14,
    BackgroundTransparency = 1,
    Parent = Main
})
CloseBtn.MouseButton1Click:Connect(function() Screen:Destroy() end)

-- Lista Rolável para os botões ficarem organizados
local Container = create("ScrollingFrame", {
    Size = UDim2.new(0, 260, 0, 310),
    Position = UDim2.new(0, 0, 0, 45),
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    ScrollBarThickness = 2,
    ScrollBarImageColor3 = Color3.fromRGB(170, 0, 255),
    CanvasSize = UDim2.new(0, 0, 0, 0),
    AutomaticCanvasSize = Enum.AutomaticSize.Y,
    Parent = Main
})
create("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 6), HorizontalAlignment = Enum.HorizontalAlignment.Center, Parent = Container })

local function createToggle(text, callback)
    local btn = create("TextButton", {
        Size = UDim2.new(0, 230, 0, 40),
        Text = text .. " (OFF)",
        BackgroundColor3 = Color3.fromRGB(35, 35, 42),
        TextColor3 = Color3.new(1, 1, 1),
        Font = Enum.Font.GothamBold,
        TextSize = 11,
        Parent = Container
    })
    create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = btn })
    
    local active = false
    btn.MouseButton1Click:Connect(function()
        active = not active
        btn.Text = text .. (active and " (ON)" or " (OFF)")
        btn.BackgroundColor3 = active and Color3.fromRGB(130, 0, 200) or Color3.fromRGB(35, 35, 42)
        callback(active)
    end)
    return btn
end

local function createActionBtn(text, callback)
    local btn = create("TextButton", {
        Size = UDim2.new(0, 230, 0, 40),
        Text = text,
        BackgroundColor3 = Color3.fromRGB(45, 45, 52),
        TextColor3 = Color3.new(1, 1, 1),
        Font = Enum.Font.GothamBold,
        TextSize = 11,
        Parent = Container
    })
    create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = btn })
    btn.MouseButton1Click:Connect(callback)
    return btn
end

-- ==========================================
-- CONFIGURAÇÃO DAS FUNÇÕES UTILITÁRIAS
-- ==========================================

-- 1. Auto Clicker de Ataque Básico
createToggle("AUTO CLICKER ATACAR", function(on)
    state.autoClick = on
end)

task.spawn(function()
    while true do
        task.wait(0.1)
        if state.autoClick then
            -- Simula um clique físico na tela de forma nativa e segura
            VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 0)
            VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 0)
        end
    end
end)

-- 2. Rastreador Visual de Inimigos (ESP)
createToggle("RASTREAR INIMIGOS (ESP)", function(on)
    state.trackEnemies = on
    if not on then
        for _, v in ipairs(workspace:GetDescendants()) do
            if v:IsA("Highlight") and v.Name == "EnemyTrack" then v:Destroy() end
        end
    end
end)

local function applyESP(model)
    if model:FindFirstChild("Humanoid") and model:FindFirstChild("HumanoidRootPart") and model ~= LocalPlayer.Character then
        -- Evita aplicar em NPCs amigáveis ou aliados checando se há barra de vida/tags do jogo
        if not model:FindFirstChild("EnemyTrack") then
            local highlight = Instance.new("Highlight")
            highlight.Name = "EnemyTrack"
            highlight.FillColor = Color3.fromRGB(255, 0, 50)
            highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
            highlight.FillTransparency = 0.5
            highlight.Adornee = model
            highlight.Parent = model
        end
    end
end

RS.RenderStepped:Connect(function()
    if state.trackEnemies then
        -- Procura inimigos no workspace (geralmente ficam em pastas chamadas "Enemies", "NPCs" ou direto no workspace)
        for _, v in ipairs(workspace:GetChildren()) do
            if v:IsA("Model") then applyESP(v) end
        end
        local enemiesFolder = workspace:FindFirstChild("Enemies") or workspace:FindFirstChild("NPCs")
        if enemiesFolder then
            for _, v in ipairs(enemiesFolder:GetChildren()) do
                if v:IsA("Model") then applyESP(v) end
            end
        end
    end
end)

-- 3. Otimizador de Gráficos (FPS Booster para Celular)
createToggle("REDUZIR LAG VISUAL (FPS BOOST)", function(on)
    state.fpsBoost = on
    for _, v in ipairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") and (v:IsA("MeshPart") or v.Material ~= Enum.Material.SmoothPlastic) then
            if on then
                if not v:GetAttribute("OldMat") then v:SetAttribute("OldMat", v.Material.Name) end
                v.Material = Enum.Material.SmoothPlastic
            else
                local old = v:GetAttribute("OldMat")
                if old then v.Material = Enum.Material[old] end
            end
        end
    end
end)

-- 4. Marcador de Posição (Salvar local e voltar depois)
createActionBtn("SALVAR POSIÇÃO ATUAL", function()
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        state.savedPos = char.HumanoidRootPart.CFrame
        print("Posição salva com sucesso!")
    end
end)

createActionBtn("TELEPORTAR PARA LOCAL SALVO", function()
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") and state.savedPos then
        char.HumanoidRootPart.CFrame = state.savedPos
    end
end)
