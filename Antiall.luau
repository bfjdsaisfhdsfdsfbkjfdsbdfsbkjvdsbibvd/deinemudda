local TeleportTime = 0.2
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

local localPlayer = Players.LocalPlayer

local function resetCameraSubject()
    if workspace.CurrentCamera and localPlayer.Character then
        local humanoid = localPlayer.Character:FindFirstChildWhichIsA("Humanoid")
        if humanoid then
            workspace.CurrentCamera.CameraSubject = humanoid
        end
    end
end

local gui = Instance.new("ScreenGui")
local btn = Instance.new("TextButton")
local UICorner = Instance.new("UICorner")
local UIStroke = Instance.new("UIStroke")

local targetPos = Vector3.new(905, -49997, 0)
local lastPos = nil
local velConn


-- CoreGui Setup
gui.Parent = CoreGui
gui.Name = "VoidGui"
gui.IgnoreGuiInset = true

-- Button Setup
btn.Parent = gui
btn.Name = "VoidButton"
btn.Size = UDim2.new(0, 50, 0, 50)
btn.Position = UDim2.new(1, -60, 0.5, -25)
btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
btn.BackgroundTransparency = 0.5
btn.BorderSizePixel = 0
btn.Text = "V"
btn.TextColor3 = Color3.fromRGB(255, 255, 255)
btn.Font = Enum.Font.GothamBold
btn.TextSize = 20
btn.Active = true
btn.Draggable = true

-- Add Rounded Corners and Outline
UICorner.Parent = btn
UICorner.CornerRadius = UDim.new(1, 0)

UIStroke.Parent = btn
UIStroke.Color = Color3.fromRGB(255, 255, 255)
UIStroke.Thickness = 1


-- Make it Draggable for All Devices
local dragging = false
local dragInput, dragStart, startPos

btn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = btn.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

btn.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        btn.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)


local function createTween(hrp, targetCFrame)
    local tweenInfo = TweenInfo.new(TeleportTime, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
    return TweenService:Create(hrp, tweenInfo, {CFrame = targetCFrame})
end


local function startVelLoop(hrp)
    velConn = RunService.Heartbeat:Connect(function()
            hrp.Velocity = Vector3.new(0, 0, 0)
    end)
end

local function stopVelLoop()
    if velConn then
        velConn:Disconnect()
        velConn = nil
    end
end


local function teleport(clickedPosition)
    local camera = Workspace.CurrentCamera
    local character = localPlayer.Character
    if not character then
		return
    end
	local hrp = character:FindFirstChild("HumanoidRootPart")
	if not hrp then
		return
	end

	local originalCameraType = camera.CameraType
    local originalCameraSubject = camera.CameraSubject

    lastPos = clickedPosition
    workspace.FallenPartsDestroyHeight = math.huge * -1

	camera.CameraType = Enum.CameraType.Fixed

	local tweenToTarget = createTween(hrp,CFrame.new(targetPos))
    tweenToTarget:Play()
    tweenToTarget.Completed:Wait()
	
    startVelLoop(hrp)
    task.wait(0.2)
    stopVelLoop()
	
    local tweenBack = createTween(hrp,CFrame.new(lastPos))
    tweenBack:Play()
    tweenBack.Completed:Wait()

    camera.CameraType = originalCameraType
    camera.CameraSubject = originalCameraSubject
	
    resetCameraSubject()
end


btn.MouseButton1Click:Connect(function()
        if localPlayer.Character then
            local hrp = localPlayer.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                teleport(hrp.CFrame.Position)
            end
        end
end)

-- Listen for Character Added events to handle respawns
localPlayer.CharacterAdded:Connect(function(character)
    resetCameraSubject()
end)

resetCameraSubject()
