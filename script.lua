-- [[
--    YTDEVS PROJECT V4 - REESTRUTURADO (FASE 1: BOTÕES INICIAIS & CONTROLES MOBILE)
--    - Correção Absoluta de Renderização e Posicionamento Mobile
--    - Abas (Feed), Sistema de Minimizar Flutuante, Drone com Analógicos In-Game
-- ]]

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local Camera = workspace.CurrentCamera

-- Limpeza de execuções anteriores
pcall(function()
    if PlayerGui:FindFirstChild("YtDevsNovo") then PlayerGui.YtDevsNovo:Destroy() end
end)

local state = {
    freecam = false,
    speed = 1.5,
    yaw = 0,
    pitch = 0,
    moveDir = Vector3.new(0, 0, 0),
    verticalDir = 0,
    currentTab = "Principal"
}

-- Construtor Auxiliar
local function create(className, properties)
    local instance = Instance.new(className)
    local parent = properties.Parent
    properties.Parent = nil
    for prop, val in pairs(properties) do instance[prop] = val end
    if parent then instance.Parent = parent end
    return instance
end

-- Sistema de Arrastar Avançado (Suporta Mobile e não interfere em cliques de botões)
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

-- UI Principal
local Screen = create("ScreenGui", { Name = "YtDevsNovo", ResetOnSpawn = false, Parent = PlayerGui })

local Main = create("Frame", {
    Size = UDim2.new(0, 260, 0, 220),
    Position = UDim2.new(0.5, -130, 0.3, 0),
    BackgroundColor3 = Color3.fromRGB(24, 24, 28),
    Visible = true,
    Parent = Screen
})
create("UICorner", { CornerRadius = UDim.new(0, 8), Parent = Main })
create("UIStroke", { Color = Color3.fromRGB(255, 0, 50), Width = 1.5, Parent = Main })

local Title = create("TextLabel", {
    Size = UDim2.new(1, -60, 0, 35),
    Position = UDim2.new(0, 10, 0, 0),
    Text = "YTDEVS PROJECT v4",
    TextColor3 = Color3.new(1, 1, 1),
    Font = Enum.Font.GothamBold,
    TextSize = 12,
    TextXAlignment = Enum.TextXAlignment.Left,
    BackgroundTransparency = 1,
    Parent = Main
})
makeDraggable(Main, Main) -- Arraste pela estrutura superior

-- Botão de Minimizar na barra superior
local MinimizeBtn = create("TextButton", {
    Size = UDim2.new(0, 25, 0, 25),
    Position = UDim2.new(1, -55, 0, 5),
    Text = "-",
    TextColor3 = Color3.new(1, 1, 1),
    Font = Enum.Font.GothamBold,
    TextSize = 16,
    BackgroundColor3 = Color3.fromRGB(35, 35, 40),
    Parent = Main
})
create("UICorner", { CornerRadius = UDim.new(0, 4), Parent = MinimizeBtn })

-- Botão de Fechar Completo
local CloseBtn = create("TextButton", {
    Size = UDim2.new(0, 25, 0, 25),
    Position = UDim2.new(1, -28, 0, 5),
    Text = "X",
    TextColor3 = Color3.new(1, 1, 1),
    Font = Enum.Font.GothamBold,
    TextSize = 12,
    BackgroundColor3 = Color3.fromRGB(150, 30, 30),
    Parent = Main
})
create("UICorner", { CornerRadius = UDim.new(0, 4), Parent = CloseBtn })

-- Botão Flutuante (Aparece quando a GUI é minimizada)
local FloatingBtn = create("TextButton", {
    Size = UDim2.new(0, 50, 0, 50),
    Position = UDim2.new(0.1, 0, 0.2, 0),
    Text = "YT",
    TextColor3 = Color3.new(1, 1, 1),
    Font = Enum.Font.GothamBold,
    TextSize = 16,
    BackgroundColor3 = Color3.fromRGB(24, 24, 28),
    Visible = false,
    Parent = Screen
})
create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = FloatingBtn })
create("UIStroke", { Color = Color3.fromRGB(255, 0, 50), Width = 2, Parent = FloatingBtn })
makeDraggable(FloatingBtn)

-- ==========================================
-- SISTEMA DE ABAS (FEED)
-- ==========================================
local TabBar = create("Frame", {
    Size = UDim2.new(1, 0, 0, 30),
    Position = UDim2.new(0, 0, 0, 35),
    BackgroundColor3 = Color3.fromRGB(18, 18, 22),
    Parent = Main
})

local ContentContainer = create("Frame", {
    Size = UDim2.new(1, 0, 1, -65),
    Position = UDim2.new(0, 0, 0, 65),
    BackgroundTransparency = 1,
    Parent = Main
})

local tabs = {}
local function createTab(name)
    local tabFrame = create("ScrollingFrame", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 2,
        ScrollBarImageColor3 = Color3.fromRGB(255, 0, 50),
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        Visible = false,
        Parent = ContentContainer
    })
    create("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 6),
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        Parent = tabFrame
    })
    
    tabs[name] = tabFrame
    
    -- Botão da aba na barra superior
    local tabBtn = create("TextButton", {
        Size = UDim2.new(0, 80, 1, 0),
        Text = name:upper(),
        BackgroundColor3 = Color3.fromRGB(28, 28, 34),
        TextColor3 = Color3.fromRGB(180, 180, 180),
        Font = Enum.Font.GothamBold,
        TextSize = 10,
        Parent = TabBar
    })
    
    tabBtn.MouseButton1Click:Connect(function()
        for _, f in pairs(tabs) do f.Visible = false end
        tabFrame.Visible = true
        state.currentTab = name
    end)
    
    return tabFrame
end

create("UIListLayout", {
    FillDirection = Enum.FillDirection.Horizontal,
    SortOrder = Enum.SortOrder.LayoutOrder,
    Parent = TabBar
})

-- Criando as Abas de Exemplo / Feed
local TabPrincipal = createTab("Principal")
local TabConfig = createTab("Ajustes")
tabs["Principal"].Visible = true -- Define a padrão

-- Função adaptada para injetar botões em abas específicas
local function addMenuButton(tabFrame, text, color, callback)
    local btn = create("TextButton", {
        Size = UDim2.new(0, 230, 0, 38),
        Text = text,
        BackgroundColor3 = color,
        TextColor3 = Color3.new(1, 1, 1),
        Font = Enum.Font.GothamBold,
        TextSize = 11,
        Parent = tabFrame
    })
    create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = btn })
    btn.MouseButton1Click:Connect(callback)
    return btn
end

-- ==========================================
-- ESTRUTURA DOS CONTROLES DO DRONE (MOBILE)
-- ==========================================
local DroneControls = create("Frame", {
    Size = UDim2.new(1, 0, 1, 0),
    BackgroundTransparency = 1,
    Visible = false,
    Parent = Screen
})

-- Analógico Esquerdo (Movimentação Horizontal: Frente, Trás, Esquerda, Direita)
local JoystickFrame = create("Frame", {
    Size = UDim2.new(0, 110, 0, 110),
    Position = UDim2.new(0, 30, 1, -140),
    BackgroundColor3 = Color3.fromRGB(0, 0, 0),
    BackgroundTransparency = 0.5,
    Parent = DroneControls
})
create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = JoystickFrame })

local JoystickStick = create("TextButton", {
    Size = UDim2.new(0, 45, 0, 45),
    Position = UDim2.new(0.5, -22, 0.5, -22),
    BackgroundColor3 = Color3.fromRGB(255, 0, 50),
    Text = "",
    Parent = JoystickFrame
})
create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = JoystickStick })

-- Botões Direcionais Verticais (Subir e Descer) à Direita
local VerticalControls = create("Frame", {
    Size = UDim2.new(0, 60, 0, 130),
    Position = UDim2.new(1, -90, 1, -150),
    BackgroundTransparency = 1,
    Parent = DroneControls
})

local BtnUp = create("TextButton", {
    Size = UDim2.new(1, 0, 0, 55),
    Position = UDim2.new(0, 0, 0, 0),
    Text = "▲\nSUBIR",
    BackgroundColor3 = Color3.fromRGB(30, 30, 35),
    TextColor3 = Color3.new(1, 1, 1),
    Font = Enum.Font.GothamBold,
    TextSize = 11,
    Parent = VerticalControls
})
create("UICorner", { CornerRadius = UDim.new(0, 8), Parent = BtnUp })

local BtnDown = create("TextButton", {
    Size = UDim2.new(1, 0, 0, 55),
    Position = UDim2.new(0, 0, 1, -55),
    Text = "▼\nDESCER",
    BackgroundColor3 = Color3.fromRGB(30, 30, 35),
    TextColor3 = Color3.new(1, 1, 1),
    Font = Enum.Font.GothamBold,
    TextSize = 11,
    Parent = VerticalControls
})
create("UICorner", { CornerRadius = UDim.new(0, 8), Parent = BtnDown })

-- Lógica Física do Analógico Touch
local joyDragging = false
local joyInputStart
JoystickStick.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        joyDragging = true
        joyInputStart = input.Position
    end
end)

UIS.InputChanged:Connect(function(input)
    if joyDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local center = Vector2.new(JoystickFrame.AbsolutePosition.X + 55, JoystickFrame.AbsolutePosition.Y + 55)
        local delta = Vector2.new(input.Position.X, input.Position.Y) - center
        local distance = math.min(delta.Magnitude, 40)
        local direction = delta.Magnitude > 0 and delta.Unit or Vector2.new(0,0)
        
        JoystickStick.Position = UDim2.new(0.5, direction.X * distance - 22, 0.5, direction.Y * distance - 22)
        state.moveDir = Vector3.new(direction.X, 0, direction.Y)
    end
end)

local function resetJoystick()
    joyDragging = false
    JoystickStick.Position = UDim2.new(0.5, -22, 0.5, -22)
    state.moveDir = Vector3.new(0, 0, 0)
end
JoystickStick.InputEnded:Connect(resetJoystick)

-- Lógica de Subida e Descida
BtnUp.InputBegan:Connect(function() state.verticalDir = 1 end)
BtnUp.InputEnded:Connect(function() state.verticalDir = 0 end)
BtnDown.InputBegan:Connect(function() state.verticalDir = -1 end)
BtnDown.InputEnded:Connect(function() state.verticalDir = 0 end)

-- ==========================================
-- COMPONENTES DA ABA PRINCIPAL & AJUSTES
-- ==========================================

local CamBtn
CamBtn = addMenuButton(TabPrincipal, "ATIVAR DRONE CAM (360°)", Color3.fromRGB(40, 40, 45), function()
    state.freecam = not state.freecam
    if state.freecam then
        CamBtn.Text = "DESATIVAR DRONE CAM"
        CamBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 50)
        DroneControls.Visible = true
        
        local x, y, z = Camera.CFrame:ToEulerAnglesYXZ()
        state.yaw, state.pitch = y, x
    else
        CamBtn.Text = "ATIVAR DRONE CAM (360°)"
        CamBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
        DroneControls.Visible = false
        Camera.CameraType = Enum.CameraType.Custom
        resetJoystick()
    end
end)

-- Botões de Ajuste de Velocidade dentro da Aba "Ajustes"
addMenuButton(TabConfig, "VELOCIDADE DO DRONE: +", Color3.fromRGB(40, 45, 60), function()
    state.speed = math.clamp(state.speed + 0.5, 0.5, 5)
end)

addMenuButton(TabConfig, "VELOCIDADE DO DRONE: -", Color3.fromRGB(40, 45, 60), function()
    state.speed = math.clamp(state.speed - 0.5, 0.5, 5)
end)

-- ==========================================
-- LOGICA DE INTERAÇÃO DA INTERFACE (MINIMIZAR/FECHAR)
-- ==========================================

MinimizeBtn.MouseButton1Click:Connect(function()
    Main.Visible = false
    FloatingBtn.Visible = true
    FloatingBtn.Position = UDim2.new(0, Main.AbsolutePosition.X + 105, 0, Main.AbsolutePosition.Y + 85)
end)

FloatingBtn.MouseButton1Click:Connect(function()
    FloatingBtn.Visible = false
    Main.Visible = true
end)

local function shutdownScript()
    state.freecam = false
    Camera.CameraType = Enum.CameraType.Custom
    Screen:Destroy()
end
CloseBtn.MouseButton1Click:Connect(shutdownScript)

-- ==========================================
-- PROCESSAMENTO RENDERSTEPPED (MOVIMENTO DO DRONE 360°)
-- ==========================================

-- Arrastar em áreas livres da tela altera o ângulo de visão em 360 graus
UIS.InputChanged:Connect(function(input)
    if state.freecam and (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) then
        -- Filtra para evitar que mexer no analógico gire a câmera indesejadamente
        if joyDragging or UIS:GetFocusedTextBox() then return end
        
        state.yaw = state.yaw - (input.Delta.X * 0.007)
        state.pitch = state.pitch - (input.Delta.Y * 0.007)
        state.pitch = math.clamp(state.pitch, -math.rad(89), math.rad(89))
    end
end)

RS.RenderStepped:Connect(function(dt)
    if state.freecam then
        Camera.CameraType = Enum.CameraType.Scriptable
        
        -- Aplica rotação de câmera baseada nos eixos Yaw (360 Horiz.) e Pitch (Vert.)
        local rotationCF = CFrame.Angles(0, state.yaw, 0) * CFrame.Angles(state.pitch, 0, 0)
        
        -- Calcula os vetores de movimento local relativos para onde a câmera está apontada
        local forwardVector = rotationCF.LookVector
        local rightVector = rotationCF.RightVector
        local upVector = Vector3.new(0, 1, 0)
        
        -- Mescla movimento do analógico e os botões Subir/Descer atravessando colisões
        local moveDirection = (rightVector * state.moveDir.X) + (forwardVector * state.moveDir.Z) + (upVector * state.verticalDir)
        
        if moveDirection.Magnitude > 0 then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position + (moveDirection.Unit * state.speed)) * rotationCF
        else
            Camera.CFrame = CFrame.new(Camera.CFrame.Position) * rotationCF
        end
    end
end)
