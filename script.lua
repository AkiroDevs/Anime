-- LocalScript dentro de StarterGui
-- YTDEVS PROJECT v4 - PRODUÇÃO SEGURO MOBILE

local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

-- ========== CONFIGURAÇÕES VISUAIS ==========
local COR_FUNDO = Color3.fromRGB(20, 20, 25)
local COR_BARRA = Color3.fromRGB(28, 28, 35)
local COR_NEON = Color3.fromRGB(255, 0, 50)
local COR_TEXTO = Color3.fromRGB(240, 240, 240)

-- ========== GUI PRINCIPAL ==========
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "YtDevsHub"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 260, 0, 320)
mainFrame.Position = UDim2.new(0.5, -130, 0.5, -160)
mainFrame.BackgroundColor3 = COR_FUNDO
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 8)
mainCorner.Parent = mainFrame

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = COR_NEON
mainStroke.Width = 1.5
mainStroke.Parent = mainFrame

-- Barra de Título (Arraste funcional)
local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, 35)
titleBar.BackgroundColor3 = COR_BARRA
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 8)
titleCorner.Parent = titleBar

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -20, 1, 0)
title.Position = UDim2.new(0, 10, 0, 0)
title.BackgroundTransparency = 1
title.Text = "YTDEVS PROJECT v4"
title.TextColor3 = COR_TEXTO
title.Font = Enum.Font.GothamBold
title.TextSize = 13
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = titleBar

-- ========== SISTEMA DE ABAS (FEED SEPARADO) ==========
local tabContainer = Instance.new("Frame")
tabContainer.Name = "TabContainer"
tabContainer.Size = UDim2.new(1, 0, 0, 30)
tabContainer.Position = UDim2.new(0, 0, 0, 35)
tabContainer.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
tabContainer.BorderSizePixel = 0
tabContainer.Parent = mainFrame

local tabLayout = Instance.new("UIListLayout")
tabLayout.FillDirection = Enum.FillDirection.Horizontal
tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
tabLayout.Parent = tabContainer

local contentContainer = Instance.new("Frame")
contentContainer.Name = "ContentContainer"
contentContainer.Size = UDim2.new(1, 0, 1, -110)
contentContainer.Position = UDim2.new(0, 0, 0, 65)
contentContainer.BackgroundTransparency = 1
contentContainer.Parent = mainFrame

local abas = {}
local abaAtiva = nil

local function criarAba(nome)
	local tabBtn = Instance.new("TextButton")
	tabBtn.Size = UDim2.new(0, 85, 1, 0)
	tabBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
	tabBtn.BorderSizePixel = 0
	tabBtn.Text = nome:upper()
	tabBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
	tabBtn.Font = Enum.Font.GothamBold
	tabBtn.TextSize = 10
	tabBtn.Parent = tabContainer

	local feed = Instance.new("ScrollingFrame")
	feed.Size = UDim2.new(1, -12, 1, -10)
	feed.Position = UDim2.new(0, 6, 0, 5)
	feed.BackgroundTransparency = 1
	feed.BorderSizePixel = 0
	feed.ScrollBarThickness = 2
	feed.ScrollBarImageColor3 = COR_NEON
	feed.CanvasSize = UDim2.new(0, 0, 0, 0)
	feed.AutomaticCanvasSize = Enum.AutomaticSize.Y
	feed.Visible = false
	feed.Parent = contentContainer

	local feedLayout = Instance.new("UIListLayout")
	feedLayout.Padding = UDim.new(0, 6)
	feedLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	feedLayout.SortOrder = Enum.SortOrder.LayoutOrder
	feedLayout.Parent = feed

	tabBtn.MouseButton1Click:Connect(function()
		for _, dados in pairs(abas) do
			dados.Feed.Visible = false
			dados.Button.TextColor3 = Color3.fromRGB(150, 150, 150)
			dados.Button.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
		end
		feed.Visible = true
		tabBtn.TextColor3 = COR_NEON
		tabBtn.BackgroundColor3 = COR_FUNDO
		abaAtiva = nome
	end)

	abas[nome] = { Feed = feed, Button = tabBtn }
	if not abaAtiva then
		feed.Visible = true
		tabBtn.TextColor3 = COR_NEON
		tabBtn.BackgroundColor3 = COR_FUNDO
		abaAtiva = nome
	end

	return feed
end

-- Instanciando as duas abas principais
local feedPrincipal = criarAba("Principal")
local feedAjustes = criarAba("Ajustes")

-- Função para criar botão dentro de uma aba específica
local function criarBotaoFeed(abaFeed, nome, callback)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, -4, 0, 38)
	btn.BackgroundColor3 = Color3.fromRGB(32, 32, 38)
	btn.Text = nome
	btn.TextColor3 = COR_TEXTO
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 12
	btn.Parent = abaFeed

	local btnCorner = Instance.new("UICorner")
	btnCorner.CornerRadius = UDim.new(0, 6)
	btnCorner.Parent = btn

	btn.MouseButton1Click:Connect(callback)
	return btn
end

-- Botoes de Ação Inferiores
local bottomBar = Instance.new("Frame")
bottomBar.Size = UDim2.new(1, 0, 0, 45)
bottomBar.Position = UDim2.new(0, 0, 1, -45)
bottomBar.BackgroundTransparency = 1
bottomBar.Parent = mainFrame

local btnMinimizar = Instance.new("TextButton")
btnMinimizar.Size = UDim2.new(0, 110, 0, 32)
btnMinimizar.Position = UDim2.new(0, 12, 0, 3)
btnMinimizar.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
btnMinimizar.Text = "MINIMIZAR"
btnMinimizar.TextColor3 = COR_TEXTO
btnMinimizar.Font = Enum.Font.GothamBold
btnMinimizar.TextSize = 11
btnMinimizar.Parent = bottomBar
Instance.new("UICorner", btnMinimizar).CornerRadius = UDim.new(0, 6)

local btnFechar = Instance.new("TextButton")
btnFechar.Size = UDim2.new(0, 110, 0, 32)
btnFechar.Position = UDim2.new(1, -122, 0, 3)
btnFechar.BackgroundColor3 = Color3.fromRGB(150, 30, 30)
btnFechar.Text = "FECHAR"
btnFechar.TextColor3 = COR_TEXTO
btnFechar.Font = Enum.Font.GothamBold
btnFechar.TextSize = 11
btnFechar.Parent = bottomBar
Instance.new("UICorner", btnFechar).CornerRadius = UDim.new(0, 6)

-- Ícone de minimizado flutuante (Estilo Redondo Moderno)
local minimizadoIcon = Instance.new("TextButton")
minimizadoIcon.Name = "MinimizadoIcon"
minimizadoIcon.Size = UDim2.new(0, 50, 0, 50)
minimizadoIcon.Position = UDim2.new(0.1, 0, 0.2, 0)
minimizadoIcon.BackgroundColor3 = COR_FUNDO
minimizadoIcon.Text = "YT"
minimizadoIcon.TextColor3 = COR_NEON
minimizadoIcon.Font = Enum.Font.GothamBold
minimizadoIcon.TextSize = 16
minimizadoIcon.Visible = false
minimizadoIcon.Parent = screenGui
minimizadoIcon.Active = true
Instance.new("UICorner", minimizadoIcon).CornerRadius = UDim.new(1, 0)
local iconStroke = Instance.new("UIStroke")
iconStroke.Color = COR_NEON
iconStroke.Width = 2
iconStroke.Parent = minimizadoIcon

-- ========== SISTEMA DRAGGABLE SEGURO (TOUCH/MOUSE) ==========
local function configurarArrasto(guiElement, handle)
	local dragging, dragInput, dragStart, startPos
	handle = handle or guiElement

	handle.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = guiElement.Position

			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)

	handle.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			dragInput = input
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if input == dragInput and dragging then
			local delta = input.Position - dragStart
			guiElement.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		end
	end)
end

configurarArrasto(mainFrame, titleBar)
configurarArrasto(minimizadoIcon, minimizadoIcon)

-- ========== ESTADOS E SCRIPT CONTROLS ==========
local state = {
	freecam = false,
	speed = 2,
	yaw = 0,
	pitch = 0,
	moveDir = Vector3.new(0, 0, 0),
	verticalDir = 0
}

local freecamGui = nil
local joyDragging = false

-- ========== CONTROLES FREECAM (MOBILE DETALHADO) ==========
local function criarFreecamControles()
	if freecamGui then freecamGui:Destroy() end
	freecamGui = Instance.new("ScreenGui")
	freecamGui.Name = "DroneControls"
	freecamGui.Parent = screenGui

	-- Base do Analógico Esquerdo
	local movBase = Instance.new("Frame")
	movBase.Size = UDim2.new(0, 120, 0, 120)
	movBase.Position = UDim2.new(0, 30, 1, -150)
	movBase.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	movBase.BackgroundTransparency = 0.5
	Instance.new("UICorner", movBase).CornerRadius = UDim.new(1, 0)
	movBase.Parent = freecamGui

	local movThumb = Instance.new("Frame")
	movThumb.Size = UDim2.new(0, 46, 0, 46)
	movThumb.Position = UDim2.new(0.5, -23, 0.5, -23)
	movThumb.BackgroundColor3 = COR_NEON
	Instance.new("UICorner", movThumb).CornerRadius = UDim.new(1, 0)
	movThumb.Parent = movBase

	-- Botões Verticais Direita
	local vertFrame = Instance.new("Frame")
	vertFrame.Size = UDim2.new(0, 60, 0, 130)
	vertFrame.Position = UDim2.new(1, -90, 1, -155)
	vertFrame.BackgroundTransparency = 1
	vertFrame.Parent = freecamGui

	local btnSubir = Instance.new("TextButton")
	btnSubir.Size = UDim2.new(1, 0, 0, 58)
	btnSubir.BackgroundColor3 = Color3.fromRGB(30, 35, 30)
	btnSubir.Text = "▲\nSUBIR"
	btnSubir.TextColor3 = Color3.new(1, 1, 1)
	btnSubir.Font = Enum.Font.GothamBold
	btnSubir.TextSize = 11
	btnSubir.Parent = vertFrame
	Instance.new("UICorner", btnSubir).CornerRadius = UDim.new(0, 8)
	Instance.new("UIStroke", btnSubir).Color = Color3.fromRGB(0, 200, 100)

	local btnDescer = Instance.new("TextButton")
	btnDescer.Size = UDim2.new(1, 0, 0, 58)
	btnDescer.Position = UDim2.new(0, 0, 1, -58)
	btnDescer.BackgroundColor3 = Color3.fromRGB(35, 30, 30)
	btnDescer.Text = "▼\nDESCER"
	btnDescer.TextColor3 = Color3.new(1, 1, 1)
	btnDescer.Font = Enum.Font.GothamBold
	btnDescer.TextSize = 11
	btnDescer.Parent = vertFrame
	Instance.new("UICorner", btnDescer).CornerRadius = UDim.new(0, 8)
	Instance.new("UIStroke", btnDescer).Color = Color3.fromRGB(200, 50, 50)

	-- Lógica de Entrada Física do Analógico Touch
	movThumb.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			joyDragging = true
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if joyDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			local center = Vector2.new(movBase.AbsolutePosition.X + 60, movBase.AbsolutePosition.Y + 60)
			local delta = Vector2.new(input.Position.X, input.Position.Y) - center
			local distance = math.min(delta.Magnitude, 42)
			local direction = delta.Magnitude > 0 and delta.Unit or Vector2.zero

			movThumb.Position = UDim2.new(0.5, (direction.X * distance) - 23, 0.5, (direction.Y * distance) - 23)
			state.moveDir = Vector3.new(direction.X, 0, direction.Y)
		end
	end)

	local function resetJoystick()
		joyDragging = false
		movThumb.Position = UDim2.new(0.5, -23, 0.5, -23)
		state.moveDir = Vector3.zero
	end
	movThumb.InputEnded:Connect(resetJoystick)

	-- Conexões Contínuas de Subida / Descida
	btnSubir.InputBegan:Connect(function() state.verticalDir = 1 end)
	btnSubir.InputEnded:Connect(function() state.verticalDir = 0 end)
	btnDescer.InputBegan:Connect(function() state.verticalDir = -1 end)
	btnDescer.InputEnded:Connect(function() state.verticalDir = 0 end)
end

-- ========== LOGICA DE PROCESSAMENTO DO DRONE (360 GRAUS PERFEITO) ==========
UserInputService.InputChanged:Connect(function(input)
	if state.freecam and (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) then
		-- Não rotaciona a câmera se estiver mexendo no analógico ou digitando
		if joyDragging or UserInputService:GetFocusedTextBox() then return end
		
		local sensibilidade = 0.007
		state.yaw = state.yaw - (input.Delta.X * sensibilidade)
		state.pitch = state.pitch - (input.Delta.Y * sensibilidade)
		-- Trava o eixo vertical para não dar "cambalhota" de cabeça para baixo
		state.pitch = math.clamp(state.pitch, -math.rad(89), math.rad(89))
	end
end)

RunService.RenderStepped:Connect(function(dt)
	if state.freecam then
		camera.CameraType = Enum.CameraType.Scriptable
		
		-- Monta a rotação CFrame baseada na leitura do mouse/touch do usuário
		local rotationCF = CFrame.Angles(0, state.yaw, 0) * CFrame.Angles(state.pitch, 0, 0)
		
		-- Projeção de vetores direcionais baseados para onde a câmera está olhando
		local forward = rotationCF.LookVector
		local right = rotationCF.RightVector
		local up = Vector3.new(0, 1, 0)
		
		-- Combina as direções do analógico (X e Z) e botões (Y)
		local finalMove = (right * state.moveDir.X) + (forward * state.moveDir.Z) + (up * state.verticalDir)
		
		if finalMove.Magnitude > 0 then
			camera.CFrame = CFrame.new(camera.CFrame.Position + (finalMove.Unit * state.speed)) * rotationCF
		else
			camera.CFrame = CFrame.new(camera.CFrame.Position) * rotationCF
		end
	end
end)

-- ========== ACOPLAMENTO DAS FUNÇÕES DO HUB ==========

local btnFreecam
local function alternarFreecam()
	state.freecam = not state.freecam
	if state.freecam then
		btnFreecam.BackgroundColor3 = Color3.fromRGB(0, 150, 50)
		btnFreecam.Text = "DESATIVAR DRONE CAM"
		
		-- Sincroniza orientação inicial da câmera para evitar solavanco
		local x, y, z = camera.CFrame:ToEulerAnglesYXZ()
		state.yaw, state.pitch = y, x
		criarFreecamControles()
	else
		btnFreecam.BackgroundColor3 = Color3.fromRGB(32, 32, 38)
		btnFreecam.Text = "ATIVAR DRONE CAM (360°)"
		camera.CameraType = Enum.CameraType.Custom
		if freecamGui then
			freecamGui:Destroy()
			freecamGui = nil
		end
		joyDragging = false
		state.moveDir = Vector3.zero
		state.verticalDir = 0
	end
end

btnFreecam = criarBotaoFeed(feedPrincipal, "ATIVAR DRONE CAM (360°)", alternarFreecam)

-- Opções extras acopladas na aba de Ajustes
criarBotaoFeed(feedAjustes, "VELOCIDADE DO DRONE: +", function()
	state.speed = math.clamp(state.speed + 0.5, 0.5, 5)
end)

criarBotaoFeed(feedAjustes, "VELOCIDADE DO DRONE: -", function()
	state.speed = math.clamp(state.speed - 0.5, 0.5, 5)
end)

-- Controle de gerenciamento da GUI
btnMinimizar.MouseButton1Click:Connect(function()
	mainFrame.Visible = false
	minimizadoIcon.Visible = true
end)

minimizadoIcon.MouseButton1Click:Connect(function()
	minimizadoIcon.Visible = false
	mainFrame.Visible = true
end)

btnFechar.MouseButton1Click:Connect(function()
	state.freecam = false
	camera.CameraType = Enum.CameraType.Custom
	if freecamGui then freecamGui:Destroy() end
	screenGui:Destroy()
end)
