local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local uis = game:GetService("UserInputService")
local ts = game:GetService("TweenService")
local runService = game:GetService("RunService")

-- ==== ScreenGui ====
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "Slapper"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- ==== Frame central ====
local frame = Instance.new("Frame")
frame.Name = "CentralFrame"
frame.Size = UDim2.new(0.25, 0, 0.6, 0)
frame.Position = UDim2.new(0.5, 0, 0.5, 0)
frame.AnchorPoint = Vector2.new(0.5, 0.5)
frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
frame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0.1, 0)
corner.Parent = frame

local stroke = Instance.new("UIStroke")
stroke.Thickness = 2
stroke.Color = Color3.fromRGB(75, 75, 75)
stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
stroke.Parent = frame

-- ==== Gradiente arco-íris do frame ====
local gradientFrame = Instance.new("UIGradient")
gradientFrame.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(255,0,0)),
	ColorSequenceKeypoint.new(0.2, Color3.fromRGB(255,127,0)),
	ColorSequenceKeypoint.new(0.4, Color3.fromRGB(255,255,0)),
	ColorSequenceKeypoint.new(0.6, Color3.fromRGB(0,255,0)),
	ColorSequenceKeypoint.new(0.8, Color3.fromRGB(0,0,255)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(139,0,255))
}
gradientFrame.Rotation = 0
gradientFrame.Parent = frame

-- ==== Título ====
local title = Instance.new("TextLabel")
title.Name = "Title"
title.Size = UDim2.new(0, 350, 0.15, 0)
title.Position = UDim2.new(0.5, 0, 0, 0)
title.AnchorPoint = Vector2.new(0.5, 0)
title.BackgroundTransparency = 1
title.Text = "The Strongest Slapper Hub"
title.TextColor3 = Color3.fromRGB(170, 0, 255)
title.Font = Enum.Font.GothamBold
title.TextScaled = true
title.Parent = frame

-- ==== ScrollingFrame ====
local scroll = Instance.new("ScrollingFrame")
scroll.Name = "MainScroll"
scroll.Size = UDim2.new(0.9, 0, 0.7, 0)
scroll.Position = UDim2.new(0.5, 0, 0.55, 0)
scroll.AnchorPoint = Vector2.new(0.5, 0.5)
scroll.BackgroundTransparency = 1
scroll.ScrollBarThickness = 6
scroll.ScrollBarImageTransparency = 1
scroll.Parent = frame

local listLayout = Instance.new("UIListLayout")
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.Padding = UDim.new(0, 5)
listLayout.Parent = scroll

-- ==== Arrastar Frame ====
local dragging = false
local dragStart, startPos

local function smoothMove(newPos)
	ts:Create(frame, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = newPos}):Play()
end

frame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = frame.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

uis.InputChanged:Connect(function(input)
	if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
		local delta = input.Position - dragStart
		local newPos = UDim2.new(
			startPos.X.Scale,
			startPos.X.Offset + delta.X,
			startPos.Y.Scale,
			startPos.Y.Offset + delta.Y
		)
		smoothMove(newPos)
	end
end)

-- ==== Toggle Button ====
local toggleButton = Instance.new("TextButton")
toggleButton.Name = "ToggleButton"
toggleButton.Size = UDim2.new(0, 120, 0, 40)
toggleButton.Position = UDim2.new(0, 20, 0.5, 0)
toggleButton.AnchorPoint = Vector2.new(0, 0.5)
toggleButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.Text = "Menu"
toggleButton.TextColor3 = Color3.fromRGB(0, 0, 0)
toggleButton.Font = Enum.Font.GothamBold
toggleButton.TextScaled = true
toggleButton.Parent = screenGui

local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(0.3, 0)
btnCorner.Parent = toggleButton

local btnStroke = Instance.new("UIStroke")
btnStroke.Thickness = 2
btnStroke.Color = Color3.fromRGB(100, 100, 100)
btnStroke.Parent = toggleButton

local gradientButton = Instance.new("UIGradient")
gradientButton.Color = gradientFrame.Color
gradientButton.Rotation = 0
gradientButton.Parent = toggleButton

local frameVisible = true
toggleButton.MouseButton1Click:Connect(function()
	frameVisible = not frameVisible
	frame.Visible = frameVisible
end)

-- ==== Gradiente animado ====
runService.RenderStepped:Connect(function()
	local t = tick() * 50
	gradientFrame.Rotation = t % 360
	gradientButton.Rotation = t % 360
end)

-- ==== Função criar botão ====
local function createDoubleTextButton(titleText, descriptionText, parent, callback)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, 0, 0, 50)
	btn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	btn.Text = ""
	btn.Parent = parent

	local btnCorner = Instance.new("UICorner")
	btnCorner.CornerRadius = UDim.new(0.2, 0)
	btnCorner.Parent = btn

	local btnStroke = Instance.new("UIStroke")
	btnStroke.Thickness = 1
	btnStroke.Color = Color3.fromRGB(100, 100, 100)
	btnStroke.Parent = btn

	local gradient = Instance.new("UIGradient")
	gradient.Color = gradientFrame.Color
	gradient.Rotation = 0
	gradient.Parent = btn

	local titleLabel = Instance.new("TextLabel")
	titleLabel.Size = UDim2.new(1, -10, 0.5, 0)
	titleLabel.Position = UDim2.new(0, 5, 0, 0)
	titleLabel.BackgroundTransparency = 1
	titleLabel.Text = titleText
	titleLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
	titleLabel.Font = Enum.Font.GothamBold
	titleLabel.TextScaled = true
	titleLabel.TextXAlignment = Enum.TextXAlignment.Left
	titleLabel.Parent = btn

	local descLabel = Instance.new("TextLabel")
	descLabel.Size = UDim2.new(1, -10, 0.5, 0)
	descLabel.Position = UDim2.new(0, 5, 0.5, 0)
	descLabel.BackgroundTransparency = 1
	descLabel.Text = descriptionText
	descLabel.TextColor3 = Color3.fromRGB(50, 50, 50)
	descLabel.Font = Enum.Font.Gotham
	descLabel.TextScaled = true
	descLabel.TextXAlignment = Enum.TextXAlignment.Left
	descLabel.Parent = btn

	-- Hover e click
	local normalSize = btn.Size
	local hoverSize = UDim2.new(normalSize.X.Scale, normalSize.X.Offset + 5, normalSize.Y.Scale, normalSize.Y.Offset + 3)
	local clickSize = UDim2.new(normalSize.X.Scale, normalSize.X.Offset - 3, normalSize.Y.Scale, normalSize.Y.Offset - 2)

	btn.MouseEnter:Connect(function()
		ts:Create(btn, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = hoverSize}):Play()
	end)
	btn.MouseLeave:Connect(function()
		ts:Create(btn, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = normalSize}):Play()
	end)

	btn.MouseButton1Click:Connect(function()
		ts:Create(btn, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = clickSize}):Play()
		wait(0.1)
		local targetSize = btn:IsMouseOver() and hoverSize or normalSize
		ts:Create(btn, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = targetSize}):Play()
		callback()
	end)

	runService.RenderStepped:Connect(function()
		gradient.Rotation = (tick() * 50) % 360
	end)

	return btn
end

-- ==== 2 PRIMEIROS BOTÕES (Equip) ====
createDoubleTextButton("God's Hand", "Equip the God's Hand", scroll, function()
	local args = {"God's Hand"}
	game:GetService("ReplicatedStorage"):WaitForChild("EquipSlapEvent"):FireServer(unpack(args))
	print("✅ Equipou God's Hand")
end)

createDoubleTextButton("Error Hand", "Equip the Error Hand", scroll, function()
	local args = {"Error"}
	game:GetService("ReplicatedStorage"):WaitForChild("EquipSlapEvent"):FireServer(unpack(args))
	print("✅ Equipou Error Hand")
end)

-- Variáveis de controle
local slapFarmToggle = false
local slapFarmToggleError = false

-- Função loop Slap Farm normal (God's Hand)
local function runSlapFarm()
	while slapFarmToggle do
		task.wait(0.0001)
		local char = game.Players.LocalPlayer.Character
		if char and char:FindFirstChild("God's Hand") and char["God's Hand"]:FindFirstChild("Event") then
			for _,v in pairs(game.Players:GetPlayers()) do
				if v ~= game.Players.LocalPlayer and v.Character then
					local args = {
						"slash",
						v.Character,
						Vector3.new(43.244930267333984, -19.55959129333496, 15.725724220275879)
					}
					pcall(function()
						char["God's Hand"].Event:FireServer(unpack(args))
					end)
				end
			end
		end
	end
end

-- Função loop Slap Farm Error (Error Hand)
local function runSlapFarmError()
	while slapFarmToggleError do
		task.wait(0.0001)
		local char = game.Players.LocalPlayer.Character
		if char and char:FindFirstChild("Error") and char.Error:FindFirstChild("Event") then
			for _,v in pairs(game.Players:GetPlayers()) do
				if v ~= game.Players.LocalPlayer and v.Character then
					local args = {
						"slash",
						v.Character,
						Vector3.new(43.244930267333984, -19.55959129333496, 15.725724220275879)
					}
					pcall(function()
						char.Error.Event:FireServer(unpack(args))
					end)
				end
			end
		end
	end
end

-- Botão 3: Slap Farm normal
createDoubleTextButton("Slap Farm or Spam", "Slaps everyone on the map", scroll, function()
	slapFarmToggle = not slapFarmToggle
	if slapFarmToggle then
		task.spawn(runSlapFarm)
		print("Slap Farm ativado")
	else
		print("Slap Farm desativado")
	end
end)

-- Botão 4: Slap Farm Error
createDoubleTextButton("Slap Farm or Spam with Error", "Slaps everyone with Error Glove", scroll, function()
	slapFarmToggleError = not slapFarmToggleError
	if slapFarmToggleError then
		task.spawn(runSlapFarmError)
		print("Slap Farm Error ativado")
	else
		print("Slap Farm Error desativado")
	end
end)
