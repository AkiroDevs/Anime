-- [[
--    YTDEVS - NOVO PROJETO REESTRUTURADO
--    - Fase 1: Base de Interface Estável para Mobile
-- ]]

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Limpa interfaces antigas com o mesmo nome para não acumular na tela
pcall(function()
    if PlayerGui:FindFirstChild("YtDevsNovo") then PlayerGui.YtDevsNovo:Destroy() end
end)

-- ==========================================
-- CONSTRUTOR SEGURO DE INSTÂNCIAS
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

-- Sistema de arrastar o menu adaptado para touch de celular
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
-- ESTRUTURA PRINCIPAL DA UI (TAMANHOS FIXOS)
-- ==========================================
local Screen = create("ScreenGui", { Name = "YtDevsNovo", ResetOnSpawn = false, Parent = PlayerGui })

-- Frame principal usando Pixels (Offset) para não quebrar no mobile
local Main = create("Frame", {
    Size = UDim2.new(0, 250, 0, 300),
    Position = UDim2.new(0.5, -125, 0.3, 0),
    BackgroundColor3 = Color3.fromRGB(25, 25, 30),
    Parent = Screen
})
create("UICorner", { CornerRadius = UDim.new(0, 8), Parent = Main })
create("UIStroke", { Color = Color3.fromRGB(255, 0, 0), Width = 1.5, Parent = Main })

-- Barra de Título (onde você clica para arrastar)
local Title = create("TextLabel", {
    Size = UDim2.new(0, 250, 0, 40),
    Text = "YTDEVS PROJECT V4",
    TextColor3 = Color3.new(1, 1, 1),
    Font = Enum.Font.GothamBold,
    TextSize = 13,
    BackgroundColor3 = Color3.fromRGB(35, 35, 40),
    Parent = Main
})
create("UICorner", { CornerRadius = UDim.new(0, 8), Parent = Title })
makeDraggable(Main, Title)

-- Botão de Fechar
local CloseBtn = create("TextButton", {
    Size = UDim2.new(0, 35, 0, 40),
    Position = UDim2.new(0, 215, 0, 0),
    Text = "✕",
    TextColor3 = Color3.fromRGB(255, 75, 75),
    Font = Enum.Font.GothamBold,
    TextSize = 14,
    BackgroundTransparency = 1,
    Parent = Main
})
CloseBtn.MouseButton1Click:Connect(function() Screen:Destroy() end)

-- Lista Rolável para os botões que vamos colocar depois
local Container = create("ScrollingFrame", {
    Size = UDim2.new(0, 250, 0, 250),
    Position = UDim2.new(0, 0, 0, 45),
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    ScrollBarThickness = 2,
    ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255),
    CanvasSize = UDim2.new(0, 0, 0, 0),
    AutomaticCanvasSize = Enum.AutomaticSize.Y,
    Parent = Main
})
create("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 6), HorizontalAlignment = Enum.HorizontalAlignment.Center, Parent = Container })
