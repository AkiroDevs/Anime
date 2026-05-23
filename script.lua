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

	-- Joystick de movimento (esquerda) - formato circular
	local movBase = Instance.new("Frame")
	movBase.Size = UDim2.new(0, 130, 0, 130)
	movBase.Position = UDim2.new(0, 30, 1, -170)
	movBase.BackgroundColor3 = Color3.fromRGB(255,255,255)
	movBase.BackgroundTransparency = 0.85
	movBase.BorderSizePixel = 0
	-- Tornar redondo
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(1, 0)  -- totalmente circular
	corner.Parent = movBase
	movBase.Parent = freecamGui

	local movThumb = Instance.new("Frame")
	movThumb.Size = UDim2.new(0, 50, 0, 50)
	movThumb.Position = UDim2.new(0.5, -25, 0.5, -25)
	movThumb.BackgroundColor3 = Color3.fromRGB(255,255,255)
	movThumb.BackgroundTransparency = 0.5
	movThumb.BorderSizePixel = 0
	local cornerThumb = Instance.new("UICorner")
	cornerThumb.CornerRadius = UDim.new(1, 0)
	cornerThumb.Parent = movThumb
	movThumb.Parent = movBase

	-- Botões Subir / Descer (canto direito inferior)
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
	local ascendendo = false
	local descendendo = false
	local movTouch = nil
	local lookTouch = nil
	local lastLookPos = nil  -- para arrasto de visão

	-- Atualiza posição do thumb do movimento
	local function updateMovThumb(input)
		local maxDist = 40  -- raio máximo dentro do círculo (130/2 = 65, mas limitamos um pouco menor)
		local clamped = input
		if clamped.Magnitude > maxDist then
			clamped = clamped.Unit * maxDist
		end
		movThumb.Position = UDim2.new(0.5, clamped.X - 25, 0.5, clamped.Y - 25)
		movInput = clamped / maxDist  -- normalizado entre -1 e 1
	end

	-- Conexões de toque
	UserInputService.TouchStarted:Connect(function(touch, gameProcessed)
		if not freecamAtivo then return end
		local pos = touch.Position
		-- Verifica se o toque está na região do joystick de movimento (lado esquerdo)
		local movAbsPos = movBase.AbsolutePosition
		local movAbsSize = movBase.AbsoluteSize
		local isInMov = pos.X >= movAbsPos.X and pos.X <= movAbsPos.X + movAbsSize.X
			and pos.Y >= movAbsPos.Y and pos.Y <= movAbsPos.Y + movAbsSize.Y

		-- Verifica se está nos botões de subir/descer (para ignorar)
		local subirAbsPos = btnSubir.AbsolutePosition
		local subirAbsSize = btnSubir.AbsoluteSize
		local descerAbsPos = btnDescer.AbsolutePosition
		local descerAbsSize = btnDescer.AbsoluteSize
		local isOnButton = (pos.X >= subirAbsPos.X and pos.X <= subirAbsPos.X + subirAbsSize.X and pos.Y >= subirAbsPos.Y and pos.Y <= subirAbsPos.Y + subirAbsSize.Y)
			or (pos.X >= descerAbsPos.X and pos.X <= descerAbsPos.X + descerAbsSize.X and pos.Y >= descerAbsPos.Y and pos.Y <= descerAbsPos.Y + descerAbsSize.Y)

		if isInMov and not movTouch then
			movTouch = touch
			local rel = pos - movAbsPos
			updateMovThumb(rel)
		elseif not isOnButton and not lookTouch then
			-- Qualquer outro lugar da tela vira controle de visão
			lookTouch = touch
			lastLookPos = pos
		end
	end)

	UserInputService.TouchMoved:Connect(function(touch, gameProcessed)
		if not freecamAtivo then return end
		if touch == movTouch then
			local movAbsPos = movBase.AbsolutePosition
			local rel = touch.Position - movAbsPos
			updateMovThumb(rel)
		elseif touch == lookTouch then
			if lastLookPos then
				local delta = touch.Position - lastLookPos
				-- Sensibilidade da rotação
				local sens = 0.2
				local yaw = -delta.X * sens
				local pitch = delta.Y * sens
				camera.CFrame = camera.CFrame * CFrame.Angles(0, math.rad(yaw), 0) * CFrame.Angles(math.rad(pitch), 0, 0)
				lastLookPos = touch.Position
			end
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
			lastLookPos = nil
		end
	end)

	-- Botões Subir/Descer (comportamento de pressionar contínuo)
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
	local moveSpeed = 40
	local ascendSpeed = 30

	RunService.RenderStepped:Connect(function(deltaTime)
		if not freecamAtivo then return end
		-- Movimento baseado no analógico
		local moveDir = Vector3.zero
		if movInput ~= Vector2.zero then
			local camCF = camera.CFrame
			local forward = camCF.LookVector
			local right = camCF.RightVector
			-- movInput.Y positivo = frente (cima no analógico)
			moveDir = (forward * -movInput.Y) + (right * movInput.X)
		end
		-- Vertical
		local vertical = Vector3.zero
		if ascendendo then vertical = Vector3.new(0, 1, 0) end
		if descendendo then vertical = vertical + Vector3.new(0, -1, 0) end

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
