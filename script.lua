-- LocalScript dentro de StarterGui
-- YTDEVS PROJECT v4 - CALIBRAÇÃO E REPARO COMPLETO MOBILE

local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

-- Limpeza de segurança para não duplicar telas ao reexecutar
pcall(function()
	if player.PlayerGui:FindFirstChild("YtDevsHub") then
		player.PlayerGui.YtDevsHub:Destroy()
	end
end)

-- ========== GUI PRINCIPAL ==========
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "YtDevsHub"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 240, 0, 300)
mainFrame.Position = UDim2.new(0.5, -120, 0.5, -150)
mainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Parent = screenGui

-- Título (Barra superior)
local titleBar = Instance.new("TextLabel")
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, 35)
titleBar.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
titleBar.Text = "  YTDEVS HUB v4"
titleBar.TextColor3 = Color3.new(1, 1, 1)
titleBar.Font = Enum.Font.GothamBold
titleBar.TextSize = 14
titleBar.TextXAlignment = Enum.TextXAlignment.Left
titleBar.Parent = mainFrame

-- ========== NAVEGAÇÃO DE ABAS (FEED) ==========
local tabSelectionFrame = Instance.new("Frame")
tabSelectionFrame.Size = UDim2.new(1, 0, 0, 30)
tabSelectionFrame.Position = UDim2.new(0, 0, 0, 35)
tabSelectionFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
tabSelectionFrame.BorderSizePixel = 0
tabSelectionFrame.Parent = mainFrame

local tabLayout = Instance.new("UIListLayout")
tabLayout.FillDirection = Enum.FillDirection.Horizontal
tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
tabLayout.Parent = tabSelectionFrame

local containerAbas = Instance.new("Frame")
containerAbas.Size = UDim2.new(1, 0, 0, 185)
containerAbas.Position = UDim2.new(0, 0, 0, 65)
containerAbas.BackgroundTransparency = 1
containerAbas.Parent = mainFrame

local abas = {}
local primeiraAba = true

local function novaAba(nome)
	local btnTab = Instance.new("TextButton")
	btnTab.Size = UDim2.new(0, 120, 1, 0)
	btnTab.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
	btnTab.Text = nome
	btnTab.TextColor3 = Color3.new(1, 1, 1)
	btnTab.Font = Enum.Font.GothamBold
	btnTab.TextSize = 12
	btnTab.Parent = tabSelectionFrame

	local scroll = Instance.new("ScrollingFrame")
	scroll.Size = UDim2.new(1, -10, 1, -10)
	scroll.Position = UDim2.new(0, 5, 0, 5)
	scroll.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
	scroll.BorderSizePixel = 0
	scroll.ScrollBarThickness = 4
	scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
	scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
	scroll.Visible = primeiraAba
	scroll.Parent = containerAbas

	local listLayout = Instance.new("UIListLayout")
	listLayout.Padding = UDim.new(0, 5)
	listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	listLayout.SortOrder = Enum.SortOrder.LayoutOrder
	listLayout.Parent = scroll

	if primeiraAba then
		btnTab.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
		primeiraAba = false
	end

	btnTab.MouseButton1Click:Connect(function()
		for _, o in pairs(abas) do
			o.Scroll.Visible = false
			o.Btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
		end
		scroll.Visible = true
		btnTab.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
	end)

	abas[nome] = { Scroll = scroll, Btn = btnTab }
	return scroll
end

local abaPrincipal = novaAba("Principal")
local abaAjustes = novaAba("Ajustes")

local function criarBotaoFeed(abaScroll, nome, callback)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, -10, 0, 40)
	btn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
	btn.Text = nome
	btn.TextColor3 = Color3.new(1, 1, 1)
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 13
	btn.Parent = abaScroll
	btn.MouseButton1Click:Connect(callback)
	return btn
end

-- ========== BOTÕES INFERIORES ==========
local btnMinimizar = Instance.new("TextButton")
btnMinimizar.Size = UDim2.new(0, 100, 0, 35)
btnMinimizar.Position = UDim2.new(0, 15, 0, 255)
btnMinimizar.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
btnMinimizar.Text = "Minimizar"
btnMinimizar.TextColor3 = Color3.new(1, 1, 1)
btnMinimizar.Font = Enum.Font.Gotham
btnMinimizar.TextSize = 13
btnMinimizar.Parent = mainFrame

local btnFechar = Instance.new("TextButton")
btnFechar.Size = UDim2.new(0, 100, 0, 35)
btnFechar.Position = UDim2.new(0, 125, 0, 255)
btnFechar.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
btnFechar.Text = "Fechar"
btnFechar.TextColor3 = Color3.new(1, 1, 1)
btnFechar.Font = Enum.Font.Gotham
btnFechar.TextSize = 13
btnFechar.Parent = mainFrame

local minimizadoIcon = Instance.new("TextButton")
minimizadoIcon.Name = "MinimizadoIcon"
minimizadoIcon.Size = UDim2.new(0, 50, 0, 50)
minimizadoIcon.Position = UDim2.new(0.1, 0, 0.2, 0)
minimizadoIcon.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
minimizadoIcon.Text = "☰"
minimizadoIcon.TextColor3 = Color3.new(1, 1, 1)
minimizadoIcon.Font = Enum.Font.GothamBold
minimizadoIcon.TextSize = 24
minimizadoIcon.BorderSizePixel = 0
minimizadoIcon.Visible = false
minimizadoIcon.Parent = screenGui
minimizadoIcon.Active = true

local iconCorner = Instance.new("UICorner")
iconCorner.CornerRadius = UDim.new(1, 0)
iconCorner.Parent = minimizadoIcon

-- ========== SISTEMA ARRASTE MULTI-TOUCH MIGRADO ==========
local function aplicarArrasto(alvo, ativador)
	ativador = ativador or alvo
	local dragging, dragStart, startPos, dragInput

	ativador.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = alvo.Position
			
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then dragging = false end
			end)
		end
	end)

	ativador.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			dragInput = input
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if input == dragInput and dragging then
			local delta = input.Position - dragStart
			alvo.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		end
	end)
end

aplicarArrasto(mainFrame, titleBar)
aplicarArrasto(minimizadoIcon, minimizadoIcon)

-- ========== ESTADOS GERAIS ==========
local state = {
	freecam = false,
	esp = false,
	speed = 2,
	yaw = 0,
	pitch = 0,
	moveDir = Vector3.new(0, 0, 0),
	verticalDir = 0
}

local freecamGui = nil
local joyDragging = false
local currentTouch = nil

-- ========== CONTROLES DO DRONE COMPATÍVEIS MOBILE ==========
local function criarFreecamControles()
	if freecamGui then freecamGui:Destroy() end
	freecamGui = Instance.new("ScreenGui")
	freecamGui.Name = "FreecamControls"
	freecamGui.Parent = screenGui
	freecamGui.ResetOnSpawn = false

	local movBase = Instance.new("Frame")
	movBase.Size = UDim2.new(0, 130, 0, 130)
	movBase.Position = UDim2.new(0, 30, 1, -170)
	movBase.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	movBase.BackgroundTransparency = 0.6
	Instance.new("UICorner", movBase).CornerRadius = UDim.new(1, 0)
	movBase.Parent = freecamGui

	local movThumb = Instance.new("Frame")
	movThumb.Size = UDim2.new(0, 50, 0, 50)
	movThumb.Position = UDim2.new(0.5, -25, 0.5, -25)
	movThumb.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	movThumb.BackgroundTransparency = 0.4
	Instance.new("UICorner", movThumb).CornerRadius = UDim.new(1, 0)
	movThumb.Parent = movBase

	local btnSubir = Instance.new("TextButton")
	btnSubir.Size = UDim2.new(0, 65, 0, 60)
	btnSubir.Position = UDim2.new(1, -95, 1, -165)
	btnSubir.BackgroundColor3 = Color3.fromRGB(70, 130, 70)
	btnSubir.Text = "▲\nSUBIR"
	btnSubir.TextColor3 = Color3.new(1, 1, 1)
	btnSubir.Font = Enum.Font.GothamBold
	btnSubir.TextSize = 12
	btnSubir.Parent = freecamGui
	Instance.new("UICorner", btnSubir).CornerRadius = UDim.new(0, 8)

	local btnDescer = Instance.new("TextButton")
	btnDescer.Size = UDim2.new(0, 65, 0, 60)
	btnDescer.Position = UDim2.new(1, -95, 1, -95)
	btnDescer.BackgroundColor3 = Color3.fromRGB(130, 70, 70)
	btnDescer.Text = "▼\nDESCER"
	btnDescer.TextColor3 = Color3.new(1, 1, 1)
	btnDescer.Font = Enum.Font.GothamBold
	btnDescer.TextSize = 12
	btnDescer.Parent = freecamGui
	Instance.new("UICorner", btnDescer).CornerRadius = UDim.new(0, 8)

	-- Lógica Corrigida Nível API Touch do Analógico
	movBase.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.Touch and not joyDragging then
			joyDragging = true
			currentTouch = input
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if joyDragging and input == currentTouch then
			local centro = Vector2.new(movBase.AbsolutePosition.X + 65, movBase.AbsolutePosition.Y + 65)
			local delta = Vector2.new(input.Position.X, input.Position.Y) - centro
			local distancia = math.min(delta.Magnitude, 45)
			local direcao = delta.Magnitude > 0 and delta.Unit or Vector2.zero

			movThumb.Position = UDim2.new(0.5, (direcao.X * distancia) - 25, 0.5, (direcao.Y * distancia) - 25)
			-- Correção de vetores: empurrar analógico para cima move o Drone para frente (-LookVector)
			state.moveDir = Vector3.new(direcao.X, 0, -direcao.Y)
		end
	end)

	local function resetAnalogico(input)
		if input == currentTouch or input.UserInputState == Enum.UserInputState.End then
			joyDragging = false
			currentTouch = nil
			movThumb.Position = UDim2.new(0.5, -25, 0.5, -25)
			state.moveDir = Vector3.zero
		end
	end
	
	UserInputService.InputEnded:Connect(resetAnalogico)

	btnSubir.InputBegan:Connect(function() state.verticalDir = 1 end)
	btnSubir.InputEnded:Connect(function() state.verticalDir = 0 end)
	btnDescer.InputBegan:Connect(function() state.verticalDir = -1 end)
	btnDescer.InputEnded:Connect(function() state.verticalDir = 0 end)
end

-- ========== TOQUE E ARRASTO DA CÂMERA LIVRE (360 GRAUS SEM CONFLITOS) ==========
UserInputService.TouchMoved:Connect(function(touch, gameProcessed)
	if not state.freecam or gameProcessed then return end
	-- Bloqueia rotação se o toque atual for o mesmo do analógico
	if joyDragging and touch == currentTouch then return end

	local sensibilidade = 0.009
	state.yaw = state.yaw - (touch.Delta.X * sensibilidade)
	state.pitch = state.pitch - (touch.Delta.Y * sensibilidade)
	state.pitch = math.clamp(state.pitch, -math.rad(89), math.rad(89))
end)

RunService.RenderStepped:Connect(function(dt)
	if state.freecam then
		camera.CameraType = Enum.CameraType.Scriptable

		local rotationCF = CFrame.Angles(0, state.yaw, 0) * CFrame.Angles(state.pitch, 0, 0)
		
		local forward = rotationCF.LookVector
		local right = rotationCF.RightVector
		local up = Vector3.new(0, 1, 0)

		-- União linear de movimento multiplicada pelo deltaTime
		local finalMove = (right * state.moveDir.X) + (forward * state.moveDir.Z) + (up * state.verticalDir)

		if finalMove.Magnitude > 0 then
			camera.CFrame = CFrame.new(camera.CFrame.Position + (finalMove.Unit * (state.speed * 35 * dt))) * rotationCF
		else
			camera.CFrame = CFrame.new(camera.CFrame.Position) * rotationCF
		end
	end
end)

-- ========== ENGENHARIA DE ATUALIZAÇÃO CONTÍNUA DO ESP ==========
local espFolder = Instance.new("Folder", screenGui)
espFolder.Name = "ESP_Container"

local function aplicarESP()
	espFolder:ClearAllChildren()
	if not state.esp then return end

	for _, p in pairs(Players:GetPlayers()) do
		if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character:FindFirstChild("Humanoid") then
			local root = p.Character.HumanoidRootPart
			local hum = p.Character.Humanoid

			if hum.Health > 0 then
				-- Cria Caixa Vermelha
				local box = Instance.new("BoxHandleAdornment")
				box.Size = Vector3.new(4, 5.5, 1)
				box.Color3 = Color3.fromRGB(255, 0, 50)
				box.AlwaysOnTop = true
				box.ZIndex = 5
				box.Adornee = root
				box.Transparency = 0.6
				box.Parent = espFolder

				-- Cria Texto do Nome
				local billboard = Instance.new("BillboardGui")
				billboard.Size = UDim2.new(0, 100, 0, 30)
				billboard.Position = UDim2.new(0, 0, 0, -3.5)
				billboard.AlwaysOnTop = true
				billboard.Adornee = root
				billboard.Parent = espFolder

				local label = Instance.new("TextLabel")
				label.Size = UDim2.new(1, 0, 1, 0)
				label.BackgroundTransparency = 1
				label.Text = p.Name
				label.TextColor3 = Color3.new(1, 1, 1)
				label.Font = Enum.Font.GothamBold
				label.TextSize = 10
				label.Parent = billboard
			end
		end
	end
end

-- Thread infinita de atualização (Verifica mapa a cada 2 segundos)
task.spawn(function()
	while task.wait(2) do
		if state.esp then
			aplicarESP()
		end
	end
end)

-- ========== ACOPLAMENTO DAS FUNÇÕES DO HUB ==========

local btnFreecam
local function alternarFreecam()
	state.freecam = not state.freecam
	if state.freecam then
		btnFreecam.BackgroundColor3 = Color3.fromRGB(100, 180, 100)
		btnFreecam.Text = "Desativar Freecam"
		local x, y, z = camera.CFrame:ToEulerAnglesYXZ()
		state.yaw, state.pitch = y, x
		criarFreecamControles()
	else
		btnFreecam.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
		btnFreecam.Text = "Freecam"
		camera.CameraType = Enum.CameraType.Custom
		if freecamGui then freecamGui:Destroy(); freecamGui = nil end
		joyDragging = false
		currentTouch = nil
		state.moveDir = Vector3.zero
		state.verticalDir = 0
	end
end

local btnESP
local function alternarESP()
	state.esp = not state.esp
	if state.esp then
		btnESP.BackgroundColor3 = Color3.fromRGB(100, 180, 100)
		btnESP.Text = "Desativar ESP"
		aplicarESP()
	else
		btnESP.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
		btnESP.Text = "Ativar ESP"
		espFolder:ClearAllChildren()
	end
end

btnFreecam = criarBotaoFeed(abaPrincipal, "Freecam", alternarFreecam)
btnESP = criarBotaoFeed(abaPrincipal, "Ativar ESP", alternarESP)

-- Opções na aba de Ajustes
criarBotaoFeed(abaAjustes, "Velocidade Drone: +", function()
	state.speed = math.clamp(state.speed + 0.5, 0.5, 6)
end)

criarBotaoFeed(abaAjustes, "Velocidade Drone: -", function()
	state.speed = math.clamp(state.speed - 0.5, 0.5, 6)
end)

-- ========== CONTROLES DE INTERFACE ==========
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
	state.esp = false
	espFolder:ClearAllChildren()
	camera.CameraType = Enum.CameraType.Custom
	if freecamGui then freecamGui:Destroy() end
	screenGui:Destroy()
end)
