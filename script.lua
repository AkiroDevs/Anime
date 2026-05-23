-- LocalScript dentro de StarterGui

local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

-- ========== GUI PRINCIPAL ==========
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MainMenu"
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Frame principal
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 220, 0, 300)
mainFrame.Position = UDim2.new(0.5, -110, 0.5, -150)
mainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = false  -- será arrastável apenas quando minimizado
mainFrame.Parent = screenGui

-- Título
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
title.Text = "HUB - Funções"
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.Parent = mainFrame

-- Sistema de Feed (ScrollingFrame)
local feed = Instance.new("ScrollingFrame")
feed.Size = UDim2.new(1, -10, 0, 180)
feed.Position = UDim2.new(0, 5, 0, 35)
feed.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
feed.BorderSizePixel = 0
feed.ScrollBarThickness = 4
feed.CanvasSize = UDim2.new(0, 0, 0, 50) -- será ajustado
feed.Parent = mainFrame

local feedLayout = Instance.new("UIListLayout")
feedLayout.Padding = UDim.new(0, 4)
feedLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
feedLayout.SortOrder = Enum.SortOrder.LayoutOrder
feedLayout.Parent = feed

-- Função para criar botão do feed
local function criarBotaoFeed(nome, callback)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, -10, 0, 40)
	btn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
	btn.Text = nome
	btn.TextColor3 = Color3.new(1,1,1)
	btn.Font = Enum.Font.Gotham
	btn.TextSize = 14
	btn.Parent = feed
	btn.MouseButton1Click:Connect(callback)
	-- atualiza tamanho do canvas
	btn:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
		feed.CanvasSize = UDim2.new(0,0,0,feedLayout.AbsoluteContentSize.Y + 10)
	end)
	return btn
end

-- Botões Minimizar / Fechar
local btnMinimizar = Instance.new("TextButton")
btnMinimizar.Size = UDim2.new(0, 90, 0, 35)
btnMinimizar.Position = UDim2.new(0, 15, 0, 255)
btnMinimizar.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
btnMinimizar.Text = "Minimizar"
btnMinimizar.TextColor3 = Color3.new(1,1,1)
btnMinimizar.Font = Enum.Font.Gotham
btnMinimizar.TextSize = 13
btnMinimizar.Parent = mainFrame

local btnFechar = Instance.new("TextButton")
btnFechar.Size = UDim2.new(0, 90, 0, 35)
btnFechar.Position = UDim2.new(0, 115, 0, 255)
btnFechar.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
btnFechar.Text = "Fechar"
btnFechar.TextColor3 = Color3.new(1,1,1)
btnFechar.Font = Enum.Font.Gotham
btnFechar.TextSize = 13
btnFechar.Parent = mainFrame

-- Ícone de minimizado (arrastável)
local minimizadoIcon = Instance.new("TextButton")
minimizadoIcon.Name = "MinimizadoIcon"
minimizadoIcon.Size = UDim2.new(0, 50, 0, 50)
minimizadoIcon.Position = UDim2.new(0.5, -25, 0.5, -25)
minimizadoIcon.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
minimizadoIcon.Text = "☰"
minimizadoIcon.TextColor3 = Color3.new(1,1,1)
minimizadoIcon.Font = Enum.Font.GothamBold
minimizadoIcon.TextSize = 24
minimizadoIcon.BorderSizePixel = 0
minimizadoIcon.Visible = false
minimizadoIcon.Parent = screenGui
minimizadoIcon.Active = true
minimizadoIcon.Draggable = true  -- arrastável livremente

-- ========== ESTADOS ==========
local minimizado = false
local freecamAtivo = false
local freecamGui = nil  -- ScreenGui dos controles do freecam

-- ========== CONTROLES FREECAM (MOBILE) ==========
local function criarFreecamControles()
	if freecamGui then freecamGui:Destroy() end
	freecamGui = Instance.new("ScreenGui")
	freecamGui.Name = "FreecamControls"
	freecamGui.Parent = player.PlayerGui
	freecamGui.ResetOnSpawn = false

	-- Joystick de movimento (esquerda)
	local movBase = Instance.new("ImageButton")
	movBase.Size = UDim2.new(0, 120, 0, 120)
	movBase.Position = UDim2.new(0, 30, 1, -160)
	movBase.BackgroundColor3 = Color3.fromRGB(255,255,255)
	movBase.BackgroundTransparency = 0.8
	movBase.Image = "rbxassetid://0"
	movBase.Visible = true
	movBase.Active = false
	movBase.Parent = freecamGui

	local movThumb = Instance.new("ImageButton")
	movThumb.Size = UDim2.new(0, 50, 0, 50)
	movThumb.Position = UDim2.new(0.5, -25, 0.5, -25)
	movThumb.BackgroundColor3 = Color3.fromRGB(255,255,255)
	movThumb.BackgroundTransparency = 0.5
	movThumb.Image = "rbxassetid://0"
	movThumb.Parent = movBase

	-- Joystick de visão (direita)
	local lookBase = Instance.new("ImageButton")
	lookBase.Size = UDim2.new(0, 120, 0, 120)
	lookBase.Position = UDim2.new(1, -150, 1, -160)
	lookBase.BackgroundColor3 = Color3.fromRGB(255,255,255)
	lookBase.BackgroundTransparency = 0.8
	lookBase.Image = "rbxassetid://0"
	lookBase.Active = false
	lookBase.Parent = freecamGui

	local lookThumb = Instance.new("ImageButton")
	lookThumb.Size = UDim2.new(0, 50, 0, 50)
	lookThumb.Position = UDim2.new(0.5, -25, 0.5, -25)
	lookThumb.BackgroundColor3 = Color3.fromRGB(255,255,255)
	lookThumb.BackgroundTransparency = 0.5
	lookThumb.Image = "rbxassetid://0"
	lookThumb.Parent = lookBase

	-- Botões Subir / Descer (posicionados no canto direito superior)
	local btnSubir = Instance.new("TextButton")
	btnSubir.Size = UDim2.new(0, 60, 0, 60)
	btnSubir.Position = UDim2.new(1, -70, 0, 200)
	btnSubir.BackgroundColor3 = Color3.fromRGB(70, 130, 70)
	btnSubir.Text = "▲"
	btnSubir.TextColor3 = Color3.new(1,1,1)
	btnSubir.Font = Enum.Font.GothamBold
	btnSubir.TextSize = 28
	btnSubir.Parent = freecamGui

	local btnDescer = Instance.new("TextButton")
	btnDescer.Size = UDim2.new(0, 60, 0, 60)
	btnDescer.Position = UDim2.new(1, -70, 0, 270)
	btnDescer.BackgroundColor3 = Color3.fromRGB(130, 70, 70)
	btnDescer.Text = "▼"
	btnDescer.TextColor3 = Color3.new(1,1,1)
	btnDescer.Font = Enum.Font.GothamBold
	btnDescer.TextSize = 28
	btnDescer.Parent = freecamGui

	-- Variáveis de entrada
	local movInput = Vector2.zero
	local lookInput = Vector2.zero
	local ascendendo = false
	local descendendo = false
	local movTouch = nil
	local lookTouch = nil

	-- Atualiza movimento do thumb
	local function updateMovThumb(input)
		local maxDist = 35
		if input.Magnitude > maxDist then
			input = input.Unit * maxDist
		end
		movThumb.Position = UDim2.new(0.5, input.X - 25, 0.5, input.Y - 25)
		movInput = input / maxDist
	end

	local function updateLookThumb(input)
		local maxDist = 35
		if input.Magnitude > maxDist then
			input = input.Unit * maxDist
		end
		lookThumb.Position = UDim2.new(0.5, input.X - 25, 0.5, input.Y - 25)
		lookInput = input / maxDist
	end

	-- Conexões de toque
	UserInputService.TouchStarted:Connect(function(touch, gameProcessed)
		if not freecamAtivo then return end
		local pos = touch.Position
		-- Verifica se toque está na região do joystick de movimento (esquerda 40% da tela)
		if pos.X < camera.ViewportSize.X * 0.4 and not movTouch then
			movTouch = touch
			local basePos = movBase.AbsolutePosition
			local baseSize = movBase.AbsoluteSize
			local rel = pos - basePos
			updateMovThumb(rel)
		-- Joystick de visão (direita 40% da tela)
		elseif pos.X > camera.ViewportSize.X * 0.6 and not lookTouch then
			lookTouch = touch
			local basePos = lookBase.AbsolutePosition
			local baseSize = lookBase.AbsoluteSize
			local rel = pos - basePos
			updateLookThumb(rel)
		end
	end)

	UserInputService.TouchMoved:Connect(function(touch, gameProcessed)
		if not freecamAtivo then return end
		if touch == movTouch then
			local basePos = movBase.AbsolutePosition
			local rel = touch.Position - basePos
			updateMovThumb(rel)
		elseif touch == lookTouch then
			local basePos = lookBase.AbsolutePosition
			local rel = touch.Position - basePos
			updateLookThumb(rel)
		end
	end)

	UserInputService.TouchEnded:Connect(function(touch, gameProcessed)
		if not freecamAtivo then return end
		if touch == movTouch then
			movTouch = nil
			movThumb.Position = UDim2.new(0.5, -25, 0.5, -25)
			movInput = Vector2.zero
		elseif touch == lookTouch then
			lookTouch = nil
			lookThumb.Position = UDim2.new(0.5, -25, 0.5, -25)
			lookInput = Vector2.zero
		end
	end)

	-- Botões Subir/Descer com toque
	btnSubir.MouseButton1Click:Connect(function() end) -- evita propagação
	btnSubir.TouchTap:Connect(function()
		ascendendo = not ascendendo
		btnSubir.BackgroundColor3 = ascendendo and Color3.fromRGB(100, 200, 100) or Color3.fromRGB(70, 130, 70)
	end)
	btnSubir.TouchLongPress:Connect(function()
		-- já tratado pelo toque contínuo na renderização
	end)
	-- Para manter pressionado, usamos o evento de toque contínuo
	local subirTocado = false
	btnSubir.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.Touch then
			ascendendo = true
			btnSubir.BackgroundColor3 = Color3.fromRGB(100, 200, 100)
		end
	end)
	btnSubir.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.Touch then
			ascendendo = false
			btnSubir.BackgroundColor3 = Color3.fromRGB(70, 130, 70)
		end
	end)

	btnDescer.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.Touch then
			descendendo = true
			btnDescer.BackgroundColor3 = Color3.fromRGB(200, 100, 100)
		end
	end)
	btnDescer.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.Touch then
			descendendo = false
			btnDescer.BackgroundColor3 = Color3.fromRGB(130, 70, 70)
		end
	end)

	-- Loop de atualização da câmera freecam
	local lookSensitivity = 0.04
	local moveSpeed = 40
	local ascendSpeed = 30

	RunService.RenderStepped:Connect(function(deltaTime)
		if not freecamAtivo then return end
		-- Rotacionar câmera com o joystick de visão
		if lookInput ~= Vector2.zero then
			local yaw = -lookInput.X * lookSensitivity * 10
			local pitch = lookInput.Y * lookSensitivity * 10
			local cf = camera.CFrame
			local rot = CFrame.Angles(0, yaw, 0) * CFrame.Angles(pitch, 0, 0)
			camera.CFrame = cf * rot
		end

		-- Mover câmera com o joystick de movimento (baseado na direção da câmera)
		local moveDir = Vector3.zero
		if movInput ~= Vector2.zero then
			local camCF = camera.CFrame
			local forward = camCF.LookVector
			local right = camCF.RightVector
			moveDir = (forward * -movInput.Y) + (right * movInput.X)
		end
		-- Ascend/Descend
		local vertical = Vector3.zero
		if ascendendo then vertical = Vector3.new(0, 1, 0) end
		if descendendo then vertical = vertical + Vector3.new(0, -1, 0) end

		-- Aplica movimento
		local totalMove = (moveDir * moveSpeed + vertical * ascendSpeed) * deltaTime
		camera.CFrame = camera.CFrame + totalMove
	end)
end

-- ========== FUNÇÕES DO MENU ==========
local function alternarFreecam()
	freecamAtivo = not freecamAtivo
	local btnFreecam = feed:FindFirstChild("FreecamBtn")
	if btnFreecam then
		btnFreecam.BackgroundColor3 = freecamAtivo and Color3.fromRGB(100, 180, 100) or Color3.fromRGB(70, 70, 70)
	end

	if freecamAtivo then
		camera.CameraType = Enum.CameraType.Scriptable
		criarFreecamControles()
	else
		camera.CameraType = Enum.CameraType.Custom
		if freecamGui then
			freecamGui:Destroy()
			freecamGui = nil
		end
	end
end

local function minimizarGUI()
	minimizado = true
	mainFrame.Visible = false
	minimizadoIcon.Visible = true
	minimizadoIcon.Draggable = true
end

local function restaurarGUI()
	minimizado = false
	mainFrame.Visible = true
	minimizadoIcon.Visible = false
	minimizadoIcon.Draggable = false
end

-- Clique no ícone minimizado restaura
minimizadoIcon.MouseButton1Click:Connect(function()
	if minimizado then restaurarGUI() end
end)

-- Botão minimizar
btnMinimizar.MouseButton1Click:Connect(minimizarGUI)

-- Botão fechar (destrói tudo, inclusive freecam)
btnFechar.MouseButton1Click:Connect(function()
	if freecamAtivo then
		freecamAtivo = false
		camera.CameraType = Enum.CameraType.Custom
		if freecamGui then freecamGui:Destroy() end
	end
	screenGui:Destroy()
end)

-- Criar botão do Freecam no feed
local btnFreecam = criarBotaoFeed("Freecam", alternarFreecam)
btnFreecam.Name = "FreecamBtn"

-- Ajustar tamanho inicial do feed
feed.CanvasSize = UDim2.new(0,0,0,feedLayout.AbsoluteContentSize.Y + 10)

-- ========== ARRASTAR QUANDO NÃO MINIMIZADO (opcional, caso queira mover o menu aberto) ==========
-- Aqui deixamos o menu fixo quando aberto. Se quiser mover também, basta ativar Draggable.
-- mainFrame.Draggable = true  -- descomente se desejar mover mesmo aberto
