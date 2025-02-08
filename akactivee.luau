------------------------------
-- SECTION 1: Commands GUI
------------------------------
-- Services
local AES = game:GetService("AvatarEditorService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local TeleportService = game:GetService("TeleportService")

-- Local Player
local localPlayer = Players.LocalPlayer
local mouse = localPlayer:GetMouse()

-- Color Palette
local COLORS = {
    main = Color3.fromRGB(200, 230, 255), -- light baby blue
    secondary = Color3.fromRGB(50, 50, 50),
    accent = Color3.fromRGB(40, 40, 40),
    hover = Color3.fromRGB(55, 55, 55),
    selection = Color3.fromRGB(70, 100, 150),
    text = Color3.fromRGB(220, 220, 230),
    textDim = Color3.fromRGB(120, 120, 140),
    babyblue = Color3.fromRGB(137, 207, 240)
}

-- Tween Information
local TWEEN_INFO = {
    fast = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    medium = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    slow = TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
}

-- Create the Commands ScreenGui (hidden by default)
local commandsGui = Instance.new("ScreenGui")
commandsGui.Name = "CustomGui"
commandsGui.ResetOnSpawn = false
commandsGui.Enabled = false  -- Hidden initially; toggled on via the admin panel.
commandsGui.Parent = localPlayer:WaitForChild("PlayerGui")

-- Main Frame
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 250, 0, 400)
frame.BackgroundColor3 = COLORS.main
frame.Position = UDim2.new(0.3, 0, 0.3, 0)
frame.Parent = commandsGui
frame.ClipsDescendants = true
local frameCorner = Instance.new("UICorner")
frameCorner.CornerRadius = UDim.new(0, 8)
frameCorner.Parent = frame
local shadow = Instance.new("ImageLabel")
shadow.Size = UDim2.new(1, 40, 1, 40)
shadow.Position = UDim2.new(0, -20, 0, -20)
shadow.BackgroundTransparency = 1
shadow.Image = "rbxassetid://5554236805"
shadow.ImageColor3 = Color3.fromRGB(50, 50, 50)
shadow.ImageTransparency = 0.6
shadow.Parent = frame

-- Header
local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 40)
header.BackgroundColor3 = COLORS.secondary
header.Parent = frame
local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 8)
headerCorner.Parent = header
local headerText = Instance.new("TextLabel")
headerText.Size = UDim2.new(1, -100, 1, 0)
headerText.Position = UDim2.new(0, 10, 0, 0)
headerText.Text = "AK COMMANDS"
headerText.Font = Enum.Font.GothamBold
headerText.TextSize = 18
headerText.TextColor3 = COLORS.text
headerText.TextXAlignment = Enum.TextXAlignment.Left
headerText.BackgroundTransparency = 1
headerText.Parent = header

-- Styled Button Function
local function createStyledButton(name, size, position, parent)
    local button = Instance.new("TextButton")
    button.Size = size
    button.Position = position
    button.BackgroundColor3 = COLORS.accent
    button.BorderSizePixel = 0
    button.Text = name
    button.Font = Enum.Font.GothamBold
    button.TextSize = 20
    button.TextColor3 = COLORS.text
    button.Parent = parent
    button.AutoButtonColor = false
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 4)
    corner.Parent = button
    button.MouseEnter:Connect(function()
        TweenService:Create(button, TWEEN_INFO.fast, {BackgroundColor3 = COLORS.hover}):Play()
    end)
    button.MouseLeave:Connect(function()
        TweenService:Create(button, TWEEN_INFO.fast, {BackgroundColor3 = COLORS.accent}):Play()
    end)
    button.MouseButton1Down:Connect(function()
        TweenService:Create(button, TWEEN_INFO.fast, {
            Size = size - UDim2.new(0, 2, 0, 2),
            Position = position + UDim2.new(0, 1, 0, 1)
        }):Play()
    end)
    button.MouseButton1Up:Connect(function()
        TweenService:Create(button, TWEEN_INFO.fast, {Size = size, Position = position}):Play()
    end)
    return button
end

-- Minimize and Close Buttons
local minimizeButton = createStyledButton("-", UDim2.new(0, 30, 0, 30), UDim2.new(1, -70, 0, 5), header)
-- local closeButton = createStyledButton("X", UDim2.new(0, 30, 0, 30), UDim2.new(1, -35, 0, 5), header) -- Removed Close Button

-- Search Container
local searchContainer = Instance.new("Frame")
searchContainer.Size = UDim2.new(1, -20, 0, 30)
searchContainer.Position = UDim2.new(0, 10, 0, 50)
searchContainer.BackgroundColor3 = COLORS.secondary
searchContainer.Parent = frame
local searchCorner = Instance.new("UICorner")
searchCorner.CornerRadius = UDim.new(0, 8)
searchCorner.Parent = searchContainer
local searchBox = Instance.new("TextBox")
searchBox.Size = UDim2.new(1, -20, 1, -10)
searchBox.Position = UDim2.new(0, 10, 0, 5)
searchBox.PlaceholderText = "Search Commands..."
searchBox.Font = Enum.Font.Gotham
searchBox.TextSize = 14
searchBox.TextColor3 = COLORS.babyblue
searchBox.PlaceholderColor3 = COLORS.babyblue
searchBox.BackgroundTransparency = 1
searchBox.BorderSizePixel = 0
searchBox.ClearTextOnFocus = false
searchBox.Text = ""
searchBox.Parent = searchContainer

-- Command Count Label
local commandCountLabel = Instance.new("TextLabel")
commandCountLabel.Size = UDim2.new(1, -20, 0, 20)
commandCountLabel.Position = UDim2.new(0, 10, 0, 85)
commandCountLabel.BackgroundColor3 = COLORS.secondary
commandCountLabel.TextColor3 = COLORS.text
commandCountLabel.Font = Enum.Font.GothamBold
commandCountLabel.TextSize = 14
commandCountLabel.Text = "Commands: 0"
commandCountLabel.Parent = frame

-- Scroll Frame
local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(1, -20, 0, 280)
scrollFrame.Position = UDim2.new(0, 10, 0, 110)
scrollFrame.BackgroundColor3 = COLORS.secondary
scrollFrame.ScrollBarThickness = 4
scrollFrame.ScrollBarImageColor3 = COLORS.accent
scrollFrame.BorderSizePixel = 0
scrollFrame.Parent = frame
local scrollCorner = Instance.new("UICorner")
scrollCorner.CornerRadius = UDim.new(0, 8)
scrollCorner.Parent = scrollFrame
local uiListLayout = Instance.new("UIListLayout")
uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
uiListLayout.Padding = UDim.new(0, 5)
uiListLayout.Parent = scrollFrame

-- Update Command Count Function
local function updateCommandCount()
    local count = 0
    for _, button in ipairs(scrollFrame:GetChildren()) do
        if button:IsA("TextButton") and button.Visible then
            count = count + 1
        end
    end
    commandCountLabel.Text = "Commands: " .. tostring(count)
end

-- Create Command Button Function
local function createCommandButton(name, description)
    local button = Instance.new("TextButton")
    button.BackgroundColor3 = COLORS.secondary
    button.BorderSizePixel = 0
    button.Name = name
    button.Text = ""
    button.AutoButtonColor = false
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 8)
    buttonCorner.Parent = button
    local cmdName = Instance.new("TextLabel")
    cmdName.Size = UDim2.new(1, -20, 0, 20)
    cmdName.Position = UDim2.new(0, 10, 0, 5)
    cmdName.Text = name
    cmdName.Font = Enum.Font.GothamBold
    cmdName.TextSize = 14
    cmdName.TextColor3 = COLORS.text
    cmdName.TextXAlignment = Enum.TextXAlignment.Left
    cmdName.BackgroundTransparency = 1
    cmdName.Parent = button
    local cmdDesc = Instance.new("TextLabel")
    cmdDesc.Font = Enum.Font.Gotham
    cmdDesc.TextSize = 12
    cmdDesc.TextColor3 = COLORS.textDim
    cmdDesc.TextXAlignment = Enum.TextXAlignment.Left
    cmdDesc.BackgroundTransparency = 1
    cmdDesc.TextWrapped = true
    cmdDesc.Parent = button
    cmdDesc.Text = description

    local function updateSize()
        local textSize = game:GetService("TextService"):GetTextSize(
            description,
            cmdDesc.TextSize,
            cmdDesc.Font,
            Vector2.new(button.AbsoluteSize.X - 20, math.huge)
        )
        cmdDesc.Size = UDim2.new(1, -20, 0, textSize.Y)
        cmdDesc.Position = UDim2.new(0, 10, 0, 25)
        button.Size = UDim2.new(1, -10, 0, textSize.Y + 40)
    end

    button.Parent = scrollFrame
    updateSize()

    button.MouseEnter:Connect(function()
        TweenService:Create(button, TWEEN_INFO.fast, {BackgroundColor3 = COLORS.accent}):Play()
    end)
    button.MouseLeave:Connect(function()
        TweenService:Create(button, TWEEN_INFO.fast, {BackgroundColor3 = COLORS.secondary}):Play()
    end)
    button.MouseButton1Click:Connect(function()
        for _, child in ipairs(scrollFrame:GetChildren()) do
            if child:IsA("TextButton") and child ~= button then
                TweenService:Create(child, TWEEN_INFO.fast, {BackgroundColor3 = COLORS.secondary}):Play()
            end
        end
        TweenService:Create(button, TWEEN_INFO.fast, {BackgroundColor3 = COLORS.selection}):Play()
    end)
    return button
end

-- Update Canvas Size Function
local function updateCanvasSize()
    local contentHeight = uiListLayout.AbsoluteContentSize.Y
    local padding = 10
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, contentHeight + padding)
end

scrollFrame:GetPropertyChangedSignal("AbsoluteSize"):Connect(updateCanvasSize)
uiListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateCanvasSize)

-- Load Commands Function
local function loadCommands()
    -- Load all commands from the remote source.
    loadstring(game:HttpGet("https://raw.githubusercontent.com/bfjdsaisfhdsfdsfbkjfdsbdfsbkjvdsbibvd/deinemudda/main/allcmdss.luau"))()
    task.wait(0.1)

    -- Define targeted commands
    local targetedCommands = {
        {"!copy <target>", "Copies the avatar of the specified target (MIC UP)."},
        {"!to <target>", "Teleports to the specified player's display name."},
        {"!stand <target>", "Makes you a JoJo stand for the specified target."},
        {"!invistroll <target>", "Makes you invisible and follows the specified target (MIC UP)."},
        {"!steal display name", "Steals the avatar of the specified display name."},
        {"!r6", "Changes your avatar to R6."},
        {"!r15", "Changes your avatar to R15."},
        {"!scan map", "scans the map in mic up with the brush."},
        {"!unscan map", "unscans the map in mic up with the brush."}
    }

    local cmdArray = {}

    if _G.cmds then
        for cmd, url in pairs(_G.cmds) do
            table.insert(cmdArray, {cmd = cmd, url = url, isTargeted = false})
        end
    end

    for _, cmdData in ipairs(targetedCommands) do
        table.insert(cmdArray, {
            cmd = cmdData[1],
            description = cmdData[2],
            isTargeted = true
        })
    end

    table.sort(cmdArray, function(a, b)
        if a.isTargeted == b.isTargeted then
            return a.cmd < b.cmd
        else
            return (a.isTargeted == false)
        end
    end)

    for _, cmdData in ipairs(cmdArray) do
        local button = createCommandButton(
            cmdData.cmd,
            cmdData.isTargeted and cmdData.description or ""
        )

        local teleportOffset = 0
        local lowerCmd = string.lower(cmdData.cmd)

        local hasMicup = false
        if cmdData.description and string.find(string.lower(cmdData.description), "mic up") then
            hasMicup = true
        end
        local micupCmds = {
            "!stealbooth",
            "!rainbowmic",
            "!rainbowdonut",
            "!demonmic",
            "!trail",
            "!blockmap",
            "!darkmap",
            "!micupinvis",
            "!mupcombo",
            "!firework",
            "!scan map",
            "!unscan map"
        }
        for _, v in ipairs(micupCmds) do
            if lowerCmd == v then
                hasMicup = true
                break
            end
        end

        if hasMicup then
            local micButton = Instance.new("TextButton")
            micButton.Size = UDim2.new(0, 50, 0, 20)
            micButton.Position = UDim2.new(1, -(60 + teleportOffset), 0, 5)
            micButton.BackgroundColor3 = COLORS.accent
            micButton.BorderSizePixel = 0
            micButton.Text = "MIC UP"
            micButton.Font = Enum.Font.GothamBold
            micButton.TextSize = 12
            micButton.TextColor3 = COLORS.text
            micButton.ZIndex = 2
            micButton.Parent = button
            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(0, 4)
            corner.Parent = micButton
            micButton.MouseButton1Click:Connect(function()
                TeleportService:Teleport(6884319169, localPlayer)
            end)
            teleportOffset = teleportOffset + 60
        end

        if lowerCmd:sub(1,4) == "!f3x" then
            local sfothButton = Instance.new("TextButton")
            sfothButton.Size = UDim2.new(0, 50, 0, 20)
            sfothButton.Position = UDim2.new(1, -(60 + teleportOffset), 0, 5)
            sfothButton.BackgroundColor3 = COLORS.accent
            sfothButton.BorderSizePixel = 0
            sfothButton.Text = "SFOTH"
            sfothButton.Font = Enum.Font.GothamBold
            sfothButton.TextSize = 12
            sfothButton.TextColor3 = COLORS.text
            sfothButton.ZIndex = 2
            sfothButton.Parent = button
            local corner2 = Instance.new("UICorner")
            corner2.CornerRadius = UDim.new(0, 4)
            corner2.Parent = sfothButton
            sfothButton.MouseButton1Click:Connect(function()
                TeleportService:Teleport(487316, localPlayer)
            end)
            teleportOffset = teleportOffset + 60
        end

        button.MouseButton1Click:Connect(function()
            if cmdData.isTargeted then
                if cmdData.cmd == "!r6" or cmdData.cmd == "!r15" then
                    local rigType = (cmdData.cmd == "!r6") and Enum.HumanoidRigType.R6 or Enum.HumanoidRigType.R15
                    local YOU = Players.LocalPlayer.UserId
                    AES:PromptAllowInventoryReadAccess()
                    local result = AES.PromptAllowInventoryReadAccessCompleted:Wait()
                    if result == Enum.AvatarPromptResult.Success then
                        local HumDescWithDoubleAccessories = Players:GetHumanoidDescriptionFromUserId(YOU)
                        local success, errorMessage = pcall(function()
                            AES:PromptSaveAvatar(HumDescWithDoubleAccessories, rigType)
                        end)
                        if success then
                            Players.LocalPlayer.Character.Humanoid.Health = 0
                            local deadpos = CFrame.new() -- Initialize deadpos to avoid nil error
                            local function log()
                                deadpos = Players.LocalPlayer.Character.HumanoidRootPart.CFrame
                            end
                            Players.LocalPlayer.Character.Humanoid.Died:Connect(log)
                            Players.LocalPlayer.CharacterAdded:Connect(function(char)
                                char:WaitForChild("Humanoid", 3).Died:Connect(log)
                                if deadpos then
                                    if char:FindFirstChild("HumanoidRootPart") then
                                        char:WaitForChild("HumanoidRootPart", 3).CFrame = deadpos
                                    end
                                end
                            end)()
                        else
                            warn("Error saving avatar:", errorMessage)
                        end
                    end
                else
                    local targetInput = Instance.new("TextBox")
                    targetInput.Size = UDim2.new(1, -20, 0, 30)
                    targetInput.Position = UDim2.new(0, 10, 0, -40)
                    targetInput.PlaceholderText = "Enter target player name..."
                    targetInput.Text = ""
                    targetInput.Font = Enum.Font.Gotham
                    targetInput.TextSize = 14
                    targetInput.TextColor3 = COLORS.text
                    targetInput.BackgroundColor3 = COLORS.secondary
                    targetInput.BorderSizePixel = 0
                    targetInput.Parent = button
                    local corner = Instance.new("UICorner")
                    corner.CornerRadius = UDim.new(0, 4)
                    corner.Parent = targetInput

                    targetInput.FocusLost:Connect(function(enterPressed)
                        if enterPressed then
                            local command = cmdData.cmd:gsub("<target>", targetInput.Text)
                            game:GetService("ReplicatedStorage"):WaitForChild("DefaultChatSystemChatEvents").SayMessageRequest:FireServer(command, "All")
                        end
                        targetInput:Destroy()
                    end)
                    targetInput:CaptureFocus()
                end
            else
                loadstring(game:HttpGet(cmdData.url))()
            end
        end)
    end
    updateCommandCount()
end

-- Dragging Logic
local dragging, dragStart, startPos
local dragInput

local function updateDrag(input)
    local delta = input.Position - dragStart
    local position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
                               startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    TweenService:Create(frame, TWEEN_INFO.fast, {Position = position}):Play()
end

header.InputBegan:Connect(function(input)
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

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        updateDrag(input)
    end
end)

header.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

-- Search Box Filtering
spawn(function()
    while wait() do
        local searchText = string.lower(searchBox.Text)
        if searchText == "" then
            for _, button in ipairs(scrollFrame:GetChildren()) do
                if button:IsA("TextButton") then
                    TweenService:Create(button, TWEEN_INFO.fast, {
                        BackgroundTransparency = 0,
                        TextTransparency = 0,
                    }):Play()
                    button.Visible = true
                end
            end
            updateCanvasSize()
            updateCommandCount()
        else
            for _, button in ipairs(scrollFrame:GetChildren()) do
                if button:IsA("TextButton") then
                    local shouldShow = button.Name:lower():find(searchText, 1, true) ~= nil
                    TweenService:Create(button, TWEEN_INFO.fast, {
                        BackgroundTransparency = shouldShow and 0 or 1,
                        TextTransparency = shouldShow and 0 or 1
                    }):Play()
                    task.delay(0.2, function()
                        button.Visible = shouldShow
                        updateCanvasSize()
                        updateCommandCount()
                    end)
                end
            end
        end
    end
end)

-- Minimize Button Functionality
local minimized = false
minimizeButton.MouseButton1Click:Connect(function()
    minimized = not minimized
    local targetSize = minimized and UDim2.new(0, 250, 0, 40) or UDim2.new(0, 250, 0, 400)
    TweenService:Create(frame, TWEEN_INFO.medium, {Size = targetSize}):Play()
    local transparency = minimized and 1 or 0.5
    local contentItems = {searchContainer, commandCountLabel, scrollFrame}
    for _, item in ipairs(contentItems) do
        TweenService:Create(item, TWEEN_INFO.fast, {BackgroundTransparency = transparency}):Play()
        task.delay(minimized and 0 or 0.2, function()
            item.Visible = not minimized
        end)
    end
end)

-- Close Button Functionality (Modified to hide rather than destroy)
-- closeButton.MouseButton1Click:Connect(function() -- Removed Close Button Functionality
--     local fadeOut = TweenService:Create(frame, TWEEN_INFO.medium, {
--         BackgroundTransparency = 1,
--         Size = UDim2.new(0, 0, 0, 0),
--         Position = UDim2.new(frame.Position.X.Scale, frame.Position.X.Offset + 150,
--                             frame.Position.Y.Scale, frame.Position.Y.Offset + 200)
--     })
--     TweenService:Create(shadow, TWEEN_INFO.medium, {ImageTransparency = 1}):Play()
--     fadeOut.Completed:Connect(function()
--         commandsGui.Enabled = false
--     end)
--     fadeOut:Play()
-- end) -- Removed Close Button Functionality

-- Initial Load and Animation
loadCommands()
updateCanvasSize()

frame.BackgroundTransparency = 1
shadow.ImageTransparency = 1
searchContainer.BackgroundTransparency = 1
commandCountLabel.BackgroundTransparency = 1
scrollFrame.BackgroundTransparency = 1

task.delay(0.1, function()
    TweenService:Create(frame, TWEEN_INFO.medium, {BackgroundTransparency = 0.5}):Play()
    TweenService:Create(shadow, TWEEN_INFO.medium, {ImageTransparency = 0.6}):Play()
    for _, container in ipairs({searchContainer, commandCountLabel, scrollFrame}) do
        TweenService:Create(container, TWEEN_INFO.medium, {BackgroundTransparency = 0.5}):Play()
    end
end)

------------------------------
-- SECTION 2: AK Admin Active Panel (Toggle)
------------------------------
-- Replace the admin panel with your provided code.
-- (Note: This panel is parented to CoreGui as per your provided code.)

local adminScreenGui = Instance.new("ScreenGui")
adminScreenGui.Name = "AdminActiveGUI"
adminScreenGui.Parent = game:WaitForChild("CoreGui")
adminScreenGui.DisplayOrder = 2  -- Ensure this panel stays on top

-- Create main container
local mainContainer = Instance.new("Frame")
mainContainer.Name = "MainContainer"
mainContainer.Size = UDim2.new(0, 140, 0, 45)
mainContainer.Position = UDim2.new(1, -145, 0, -55)
mainContainer.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
mainContainer.BackgroundTransparency = 0.2
mainContainer.BorderSizePixel = 0
mainContainer.Parent = adminScreenGui

-- Add styling to container
local uiCorner_Admin = Instance.new("UICorner")
uiCorner_Admin.CornerRadius = UDim.new(0, 6)
uiCorner_Admin.Parent = mainContainer

local gradient_Admin = Instance.new("UIGradient")
gradient_Admin.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 30, 35)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(25, 25, 30)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 20, 25))
}
gradient_Admin.Rotation = 45
gradient_Admin.Parent = mainContainer

-- Create the green dot with enhanced visuals
local dot_Admin = Instance.new("Frame")
dot_Admin.Name = "HeartbeatDot"
dot_Admin.Size = UDim2.new(0, 8, 0, 8)
dot_Admin.Position = UDim2.new(0, 15, 0, 18)
dot_Admin.BackgroundColor3 = Color3.fromRGB(80, 240, 120)
dot_Admin.BorderSizePixel = 0
dot_Admin.AnchorPoint = Vector2.new(0.5, 0.5)
dot_Admin.Parent = mainContainer

local uiCornerDot_Admin = Instance.new("UICorner")
uiCornerDot_Admin.CornerRadius = UDim.new(1, 0)
uiCornerDot_Admin.Parent = dot_Admin

local dotGlow_Admin = Instance.new("UIGradient")
dotGlow_Admin.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(80, 240, 120)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 180, 80))
}
dotGlow_Admin.Parent = dot_Admin

-- Create text labels for admin panel
local adminLabel_Admin = Instance.new("TextLabel")
adminLabel_Admin.Name = "AdminStatus"
adminLabel_Admin.Size = UDim2.new(0, 100, 0, 20)
adminLabel_Admin.Position = UDim2.new(0, 30, 0, 5)
adminLabel_Admin.Font = Enum.Font.GothamBold
adminLabel_Admin.Text = "AK Admin Active"
adminLabel_Admin.TextColor3 = Color3.fromRGB(255, 255, 255)
adminLabel_Admin.TextSize = 13
adminLabel_Admin.TextXAlignment = Enum.TextXAlignment.Left
adminLabel_Admin.BackgroundTransparency = 1
adminLabel_Admin.Parent = mainContainer

if identifyexecutor() then
local executorLabel_Admin = Instance.new("TextLabel")
executorLabel_Admin.Name = "FPSCounter"
executorLabel_Admin.Size = UDim2.new(0, 100, 0, 20)
executorLabel_Admin.Position = UDim2.new(0, 95, 0, 22)
executorLabel_Admin.Font = Enum.Font.Gotham
executorLabel_Admin.Text = identifyexecutor()
executorLabel_Admin.TextColor3 = Color3.fromRGB(200, 200, 200)
executorLabel_Admin.TextSize = 12
executorLabel_Admin.TextXAlignment = Enum.TextXAlignment.Left
executorLabel_Admin.BackgroundTransparency = 1
executorLabel_Admin.Font = Enum.Font.ArialBold
executorLabel_Admin.TextColor3 = Color3.new(1.000000, 0.000000, 0.000000)
executorLabel_Admin.Parent = mainContainer
end

local fpsLabel_Admin = Instance.new("TextLabel")
fpsLabel_Admin.Name = "FPSCounter"
fpsLabel_Admin.Size = UDim2.new(0, 100, 0, 20)
fpsLabel_Admin.Position = UDim2.new(0, 30, 0, 22)
fpsLabel_Admin.Font = Enum.Font.Gotham
fpsLabel_Admin.Text = "FPS: --"
fpsLabel_Admin.TextColor3 = Color3.fromRGB(200, 200, 200)
fpsLabel_Admin.TextSize = 12
fpsLabel_Admin.TextXAlignment = Enum.TextXAlignment.Left
fpsLabel_Admin.BackgroundTransparency = 1
fpsLabel_Admin.Parent = mainContainer

-- Enhanced smooth animation for admin panel
local heartbeatInfo_Admin = TweenInfo.new(
    0.8,
    Enum.EasingStyle.Quad,
    Enum.EasingDirection.InOut,
    -1,
    true
)

local heartbeatTween_Admin = TweenService:Create(dot_Admin, heartbeatInfo_Admin, {
    Size = UDim2.new(0, 12, 0, 12),
    BackgroundTransparency = 0.2,
    BackgroundColor3 = Color3.fromRGB(100, 255, 140)
})

local rotationInfo_Admin = TweenInfo.new(
    2,
    Enum.EasingStyle.Linear,
    Enum.EasingDirection.InOut,
    -1
)

local gradientRotation_Admin = TweenService:Create(dotGlow_Admin, rotationInfo_Admin, {
    Rotation = 360
})

heartbeatTween_Admin:Play()
gradientRotation_Admin:Play()

local frameCount_Admin = 0
local timeElapsed_Admin = 0

game:GetService("RunService").RenderStepped:Connect(function(delta)
    frameCount_Admin = frameCount_Admin + 1
    timeElapsed_Admin = timeElapsed_Admin + delta

    if timeElapsed_Admin >= 1 then
        local fps = math.floor(frameCount_Admin / timeElapsed_Admin)
        fpsLabel_Admin.Text = "FPS: " .. tostring(fps)
        frameCount_Admin = 0
        timeElapsed_Admin = 0
    end
end)

-- Enable input for admin panel (works for both mouse and touch)
mainContainer.Active = true
mainContainer.Selectable = true

-- Toggle the Commands GUI when the admin panel is clicked or tapped.
mainContainer.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or
       input.UserInputType == Enum.UserInputType.Touch then
        commandsGui.Enabled = not commandsGui.Enabled
    end
end)
