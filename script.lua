-- [[
--    YTDEVS PROJECT V4 - REESTRUTURADO (FASE 1: BOTÕES INICIAIS)
--    - Correção Absoluta de Renderização: Layout fixado em Offset (Pixels)
--    - Elementos inclusos: Botão de Câmera Livre (Drone) + Botão de Sair
-- ]]

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local Camera = workspace.CurrentCamera

-- Evita acumular interfaces duplicadas na tela ao executar várias vezes
pcall(function()
    if PlayerGui:FindFirstChild("YtDevsNovo") then PlayerGui.YtDevsNovo:Destroy() end
end)

local state = {
    freecam = false,
    speed = 20,
    yaw = 0,
    pitch = 0
}

-- ==========================================
-- CONSTRUTOR DE INSTÂNCIAS (PARENT NO FINAL)
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

-- Sistema de arrastar adaptado para telas Touch (Mobile)
local function makeDraggable(frame, handle)
    handle = handle or frame
    local dragging, dragStart, startPos

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
-- ESTRUTURA VISUAL DA INTERFACE (MÓDULO BASE)
-- ==========================================
local Screen = create("ScreenGui", { Name = "YtDevsNovo", ResetOnSpawn = false, Parent = PlayerGui })

local Main = create("Frame", {
    Size = UDim2.new(0, 240, 0, 180), -- Reduzido para ficar compacto nesta fase inicial
    Position = UDim2.new(0.5, -120, 0.3, 0),
    BackgroundColor3 = Color3.fromRGB(24, 24, 28),
    Parent = Screen
})
create("UICorner", { CornerRadius = UDim.new(0, 8), Parent = Main })
create("UIStroke", { Color = Color3.fromRGB(255, 0, 50), Width = 1.5, Parent = Main })

local Title = create("TextLabel", {
    Size = UDim2.new(0, 240, 0, 35),
    Text = "YTDEVS PROJECT v4",
    TextColor3 = Color3.new(1, 1, 1),
    Font = Enum.Font.GothamBold,
    TextSize = 12,
    BackgroundColor3 = Color3.fromRGB(32, 32, 38),
    Parent = Main
})
create("UICorner", { CornerRadius = UDim.new(0, 8), Parent = Title })
makeDraggable(Main, Title)

-- Container interno onde os botões obrigatoriamente são injetados
local Container = create("ScrollingFrame", {
    Size = UDim2.new(0, 240, 0, 135),
    Position = UDim2.new(0, 0, 0, 40),
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    ScrollBarThickness = 2,
    ScrollBarImageColor3 = Color3.fromRGB(255, 0, 50),
    CanvasSize = UDim2.new(0, 0, 0, 0),
    AutomaticCanvasSize = Enum.AutomaticSize.Y,
    Parent = Main
})

create("UIListLayout", {
    SortOrder = Enum.SortOrder.LayoutOrder,
    Padding = UDim.new(0, 6),
    HorizontalAlignment = Enum.HorizontalAlignment.Center,
    Parent = Container
})

-- ==========================================
-- FUNÇÃO PARA CRIAR BOTÕES DENTRO DA LISTA
-- ==========================================
local function addMenuButton(text, color, callback)
    local btn = create("TextButton", {
        Size = UDim2.new(0, 210, 0, 38), -- Tamanho fixo em pixels para nunca encolher
        Text = text,
        BackgroundColor3 = color,
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
-- INJEÇÃO DOS COMPONENTES E LÓGICA INICIAL
-- ==========================================

-- Botão 1: Ativar/Desativar Drone de Câmera Livre
local CamBtn
CamBtn = addMenuButton("ATIVAR FREE CAM", Color3.fromRGB(40, 40, 45), function()
    state.freecam = not state.freecam
    if state.freecam then
        CamBtn.Text = "DESATIVAR FREE CAM"
        CamBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 50)
        
        -- Sincroniza os ângulos iniciais da câmera para não dar trancos ao ativar
        local x, y, z = Camera.CFrame:ToEulerAnglesYXZ()
        state.yaw, state.pitch = y, x
    else
        CamBtn.Text = "ATIVAR FREE CAM"
        CamBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
        Camera.CameraType = Enum.CameraType.Custom
    end
end)

-- Botão 2: Fechar e Descarregar o Script completamente
addMenuButton("FECHAR INTERFACE", Color3.fromRGB(150, 30, 30), function()
    Camera.CameraType = Enum.CameraType.Custom
    Screen:Destroy()
end)

-- ==========================================
-- CONTROLE COMPACTO DE MOVIMENTAÇÃO (TOUCH)
-- ==========================================
UIS.InputChanged:Connect(function(input)
    if state.freecam and (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) then
        -- Permite olhar para os lados arrastando os dedos em qualquer parte livre da tela
        state.yaw = state.yaw - (input.Delta.X * 0.008)
        state.pitch = state.pitch - (input.Delta.Y * 0.008)
        state.pitch = math.clamp(state.pitch, -math.rad(89), math.rad(89))
    end
end)

RS.RenderStepped:Connect(function(dt)
    if state.freecam then
        Camera.CameraType = Enum.CameraType.Scriptable
        
        -- Gera a rotação com base no arrastar de dedos monitorado
        local rotationCF = CFrame.Angles(0, state.yaw, 0) * CFrame.Angles(state.pitch, 0, 0)
        Camera.CFrame = CFrame.new(Camera.CFrame.Position) * rotationCF
    end
end)
