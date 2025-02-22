local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local Lighting = game:GetService("Lighting")

-- Global table to store current tags (one per player)
local currentTags = {}

-- Helper: Remove spaces from a string.
local function modifyString(randomText)
    local modified = ""
    for char in randomText:gmatch(".") do
        if char ~= " " then
            modified = modified .. char
        end
    end
    return modified
end

-- Helper: Case-insensitive check if a player's name is in a role list.
local function isInRole(roleList, playerName)
    for _, name in ipairs(roleList) do
        if string.lower(name) == string.lower(playerName) then
            return true
        end
    end
    return false
end

-- Prepare the chat message.
local message = "Anti-Tags-|-AK-ADMIN-ABCDEFGHJIKLJSBEBDZWUAJSNCHEI()"
local modifiedMessage = modifyString(message)

-- Spam the chat: send the modified message 300 times every 5 seconds.
spawn(function()
    while true do
        for i = 1, 2 do
            Players:Chat(modifiedMessage)
        end
        wait(0.05)
    end
end)

--------------------------------------------------
-- Chat-Based Whitelisting:
-- When a player chats the secret message,
-- if they are not already in a custom role (except LUCKYGOD),
-- they will be given a tag. Players in the LUCKYGOD list receive the "AK LUCKYGOD" tag.
--------------------------------------------------
local ChatWhitelist = {}

--------------------------------------------------
-- Configuration and Rank Colors
--------------------------------------------------
local CONFIG = {
    TAG_SIZE = UDim2.new(0, 120, 0, 40),
    TAG_OFFSET = Vector3.new(0, 2.4, 0),
    MAX_DISTANCE = 1000000,
    SCALE_DISTANCE = 150,
    WHITELIST_UPDATE_INTERVAL = 5,
    MAX_RETRY_ATTEMPTS = 10,
    RETRY_DELAY = 3,
    TELEPORT_DISTANCE = 5,
    TELEPORT_HEIGHT = 0.5
}

local RankColors = {
    ["AK OWNER"] = {
        primary = Color3.fromRGB(20, 20, 20),
        accent = Color3.fromRGB(255, 215, 0)
    },
    ["AK SCRIPTER"] = {
        primary = Color3.fromRGB(20, 20, 20),
        accent = Color3.fromRGB(138, 43, 226)
    },
    ["AK SUPPORTER"] = {
        primary = Color3.fromRGB(20, 20, 20),
        accent = Color3.fromRGB(0, 191, 255)
    },
    ["AK STAFF"] = {
        primary = Color3.fromRGB(20, 20, 20),
        accent = Color3.fromRGB(255, 252, 132)
    },
    ["AK ADVERTISER"] = {
        primary = Color3.fromRGB(20, 20, 20),
        accent = Color3.fromRGB(255, 69, 0)
    },
    ["AK HELPER"] = {
        primary = Color3.fromRGB(20, 20, 20),
        accent = Color3.fromRGB(169, 169, 169)
    },
    ["AK LUCKYGOD"] = {
        primary = Color3.fromRGB(20, 20, 20),
        accent = Color3.fromRGB(114, 47, 55)  -- red wine accent
    },
    ["AK USER"] = {
        primary = Color3.fromRGB(20, 20, 20),
        accent = Color3.fromRGB(65, 105, 225)
    }
}

--------------------------------------------------
-- Notification UI (for local player tag prompt)
--------------------------------------------------
local function createNotificationUI()
    local gui = Instance.new("ScreenGui")
    gui.Name = "TagNotification"
    gui.ResetOnSpawn = false

    local frame = Instance.new("Frame")
    frame.Name = "Frame"
    frame.Size = UDim2.new(0, 280, 0, 140)
    frame.Position = UDim2.new(0.5, -140, 0.5, -70)
    frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    frame.BackgroundTransparency = 0.1
    frame.BorderSizePixel = 0
    frame.Parent = gui

    local blur = Instance.new("BlurEffect")
    blur.Size = 10
    blur.Parent = Lighting

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = frame

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(255, 255, 255)
    stroke.Transparency = 0.8
    stroke.Thickness = 1
    stroke.Parent = frame

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 35)
    title.Position = UDim2.new(0, 0, 0, 10)
    title.BackgroundTransparency = 1
    title.Font = Enum.Font.GothamBold
    title.TextColor3 = Color3.new(1, 1, 1)
    title.TextSize = 16
    title.Text = "Tag Visibility Settings"
    title.Parent = frame

    local messageLabel = Instance.new("TextLabel")
    messageLabel.Size = UDim2.new(0.9, 0, 0, 40)
    messageLabel.Position = UDim2.new(0.05, 0, 0.35, 0)
    messageLabel.BackgroundTransparency = 1
    messageLabel.Font = Enum.Font.Gotham
    messageLabel.TextColor3 = Color3.new(0.9, 0.9, 0.9)
    messageLabel.TextSize = 14
    messageLabel.TextWrapped = true
    messageLabel.Text = "Would you like to display your rank tag above your character?"
    messageLabel.Parent = frame

    local function createButton(text, position, color)
        local button = Instance.new("TextButton")
        button.Size = UDim2.new(0.35, 0, 0, 30)
        button.Position = position
        button.BackgroundColor3 = color
        button.BorderSizePixel = 0
        button.Font = Enum.Font.GothamBold
        button.TextColor3 = Color3.new(1, 1, 1)
        button.TextSize = 14
        button.Text = text
        button.AutoButtonColor = true
        button.Parent = frame

        local buttonCorner = Instance.new("UICorner")
        buttonCorner.CornerRadius = UDim.new(0, 6)
        buttonCorner.Parent = button

        return button
    end

    local yesButton = createButton("Yes", UDim2.new(0.1, 0, 0.7, 0), Color3.fromRGB(46, 204, 113))
    local noButton = createButton("No", UDim2.new(0.55, 0, 0.7, 0), Color3.fromRGB(231, 76, 60))

    frame.BackgroundTransparency = 1
    title.TextTransparency = 1
    messageLabel.TextTransparency = 1
    yesButton.BackgroundTransparency = 1
    noButton.BackgroundTransparency = 1
    yesButton.TextTransparency = 1
    noButton.TextTransparency = 1

    TweenService:Create(frame, TweenInfo.new(0.5), {BackgroundTransparency = 0.1}):Play()
    TweenService:Create(title, TweenInfo.new(0.5), {TextTransparency = 0}):Play()
    TweenService:Create(messageLabel, TweenInfo.new(0.5), {TextTransparency = 0}):Play()
    TweenService:Create(yesButton, TweenInfo.new(0.5), {BackgroundTransparency = 0}):Play()
    TweenService:Create(noButton, TweenInfo.new(0.5), {BackgroundTransparency = 0}):Play()
    TweenService:Create(yesButton, TweenInfo.new(0.5), {TextTransparency = 0}):Play()
    TweenService:Create(noButton, TweenInfo.new(0.5), {TextTransparency = 0}):Play()

    return gui, yesButton, noButton, blur
end

--------------------------------------------------
-- Teleport Function
--------------------------------------------------
local function teleportToPlayer(targetPlayer)
    local localPlayer = Players.LocalPlayer
    local character = localPlayer.Character
    local targetCharacter = targetPlayer.Character
    if not (character and targetCharacter) then return end

    local humanoid = character:FindFirstChild("Humanoid")
    local hrp = character:FindFirstChild("HumanoidRootPart")
    local targetHRP = targetCharacter:FindFirstChild("HumanoidRootPart")
    if not (humanoid and hrp and targetHRP) then return end

    local targetCFrame = targetHRP.CFrame
    local teleportPosition = targetCFrame.Position - (targetCFrame.LookVector * CONFIG.TELEPORT_DISTANCE)
    teleportPosition = teleportPosition + Vector3.new(0, CONFIG.TELEPORT_HEIGHT, 0)

    local particlepart = Instance.new("Part", workspace)
    particlepart.Transparency = 1
    particlepart.Anchored = true 
    particlepart.CanCollide = false
    particlepart.Position = hrp.Position

    local transmitter1 = Instance.new("ParticleEmitter")
    transmitter1.Texture = "http://www.roblox.com/asset/?id=89296104222585"
    transmitter1.Size = NumberSequence.new(4)
    transmitter1.Lifetime = NumberRange.new(0.15, 0.15)
    transmitter1.Rate = 100
    transmitter1.TimeScale = 0.25
    transmitter1.VelocityInheritance = 1
    transmitter1.Drag = 5
    transmitter1.Parent = particlepart

    local particlepart2 = Instance.new("Part", workspace)
    particlepart2.Transparency = 1
    particlepart2.Anchored = true
    particlepart2.CanCollide = false
    particlepart2.Position = teleportPosition

    local transmitter2 = Instance.new("ParticleEmitter")
    transmitter2.Texture = "http://www.roblox.com/asset/?id=89296104222585"
    transmitter2.Size = NumberSequence.new(4)
    transmitter2.Lifetime = NumberRange.new(0.15, 0.15)
    transmitter2.Rate = 100
    transmitter2.TimeScale = 0.25
    transmitter2.VelocityInheritance = 1
    transmitter2.Drag = 5
    transmitter2.Parent = particlepart2

    local fadeTime = 0.1
    local tweenInfo = TweenInfo.new(fadeTime, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local meshParts = {}
    for _, part in ipairs(character:GetDescendants()) do
        if part:IsA("MeshPart") then
            table.insert(meshParts, part)
        end
    end

    for _, part in ipairs(meshParts) do
        local tween = TweenService:Create(part, tweenInfo, {Transparency = 1})
        tween:Play()
    end
    task.wait(fadeTime)

    hrp.CFrame = CFrame.new(teleportPosition, targetHRP.Position)

    local teleportSound = Instance.new("Sound")
    teleportSound.SoundId = "rbxassetid://5066021887"
    local head = character:FindFirstChild("Head")
    if head then
        teleportSound.Parent = head
    else
        teleportSound.Parent = hrp
    end
    teleportSound.Volume = 0.5
    teleportSound:Play()

    for _, part in ipairs(meshParts) do
        local tween = TweenService:Create(part, tweenInfo, {Transparency = 0})
        tween:Play()
    end

    task.wait(1)
    particlepart:Destroy()
    particlepart2:Destroy()
end

--------------------------------------------------
-- Tag Attachment Function
--------------------------------------------------
local function attachTagToHead(character, player, rankText)
    local head = character:WaitForChild("Head", 5)
    if not head then return end

    -- If a tag already exists for this player, and it's the same rank, exit.
    if currentTags[player] then
        if currentTags[player]:GetAttribute("RankType") == rankText then
            return
        else
            currentTags[player]:Destroy()
            currentTags[player] = nil
        end
    end

    local tag = Instance.new("BillboardGui")
    tag.Adornee = head
    tag.Active = true
    tag.Name = "RankTag"
    tag.Size = CONFIG.TAG_SIZE
    tag.StudsOffset = CONFIG.TAG_OFFSET
    tag.AlwaysOnTop = true
    tag.MaxDistance = CONFIG.MAX_DISTANCE
    tag:SetAttribute("RankType", rankText)

    local container = Instance.new("TextButton")
    container.Size = UDim2.new(1, 0, 1, 0)
    container.BackgroundTransparency = 0.2
    container.BackgroundColor3 = RankColors[rankText].primary
    container.BorderSizePixel = 0
    container.Text = ""
    container.Parent = tag

    local emoji = Instance.new("TextLabel")
    emoji.Size = UDim2.new(1, 0, 0.5, 0)
    emoji.Position = UDim2.new(0, 0, -0.45, 0)
    emoji.BackgroundTransparency = 1
    emoji.TextSize = 25
    emoji.TextColor3 = RankColors[rankText].accent
    emoji.Font = Enum.Font.SourceSans

    if rankText == "AK OWNER" then
        emoji.Text = "👑"
    elseif rankText == "AK SCRIPTER" then
        emoji.Text = "⚡"
    elseif rankText == "AK LUCKYGOD" then
        emoji.Text = "♦️"
    elseif rankText == "AK SUPPORTER" then
        emoji.Text = "💎"
    elseif rankText == "AK STAFF" then
        emoji.Text = "🔰"
    elseif rankText == "AK ADVERTISER" then
        emoji.Text = "📢"
    elseif rankText == "AK HELPER" then
        emoji.Text = "📢"
    elseif rankText == "AK USER" then
        emoji.Text = ""
    end

    emoji.Parent = container

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0.2, 0)
    corner.Parent = container

    local accent = Instance.new("Frame")
    accent.Size = UDim2.new(0.7, 0, 0, 2.5)
    accent.Position = UDim2.new(0.5, 0, 0, 0)
    accent.BackgroundColor3 = RankColors[rankText].accent
    accent.BorderSizePixel = 0
    accent.Parent = container

    local accentCorner = Instance.new("UICorner")
    accentCorner.CornerRadius = UDim.new(0, 2)
    accentCorner.Parent = accent

    accent.AnchorPoint = Vector2.new(0.5, 0.5)
    accent.Position = UDim2.new(0.5, 0, 0, 0)

    -- Tween Animation (identical for all roles, including AK USER and AK LUCKYGOD)
    local tweenInfo = TweenInfo.new(0.7, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true)
    local tween = TweenService:Create(accent, tweenInfo, {Size = UDim2.new(0.1, 0, 0, 2.5)})
    tween:Play()

    local rankLabel = Instance.new("TextLabel")
    rankLabel.Size = UDim2.new(1, 0, 0.6, 0)
    rankLabel.Position = UDim2.new(0, 0, 0.1, 0)
    rankLabel.BackgroundTransparency = 1
    rankLabel.Text = rankText
    rankLabel.TextColor3 = Color3.new(1, 1, 1)
    rankLabel.TextSize = 17
    rankLabel.Font = Enum.Font.SourceSansBold
    rankLabel.Parent = container

    local maxDistance = 50
    local minSize = 8
    local maxSize = 17

    RunService.Heartbeat:Connect(function()
        local localPlayer = Players.LocalPlayer
        local localPlayerHead = localPlayer.Character and localPlayer.Character:WaitForChild("Head")
        if localPlayer and localPlayerHead and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local targetHumanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
            if targetHumanoidRootPart then
                local distance = (localPlayerHead.Position - targetHumanoidRootPart.Position).Magnitude
                local newSize = math.clamp(maxSize - ((distance / maxDistance) * (maxSize - minSize)), minSize, maxSize)
                rankLabel.TextSize = newSize
            end
        end
    end)

    local userLabel = Instance.new("TextLabel")
    userLabel.Size = UDim2.new(1, 0, 0.4, 0)
    userLabel.Position = UDim2.new(0, 0, 0.6, 0)
    userLabel.BackgroundTransparency = 1
    userLabel.Text = "@" .. player.Name
    userLabel.TextColor3 = RankColors[rankText].accent
    userLabel.TextSize = 8
    userLabel.Font = Enum.Font.GothamBold
    userLabel.Parent = container

    tag.Parent = game.CoreGui
    currentTags[player] = tag

    local playerHead = player.Character:WaitForChild("Head")
    local humanoidRootPart = player.Character:WaitForChild("HumanoidRootPart")
    RunService.Heartbeat:Connect(function()
        local localPlayer = Players.LocalPlayer
        local localPlayerHead = localPlayer.Character and localPlayer.Character:WaitForChild("Head")
        if localPlayer and localPlayerHead and player.Character and playerHead and humanoidRootPart then
            local distance = (localPlayerHead.Position - humanoidRootPart.Position).Magnitude
            userLabel.Visible = distance <= maxDistance
        end
    end)

    local connection = RunService.Heartbeat:Connect(function()
        if not (character and character:FindFirstChild("Head") and Players.LocalPlayer.Character) then return end
        local localCharacter = Players.LocalPlayer.Character
        local localHead = localCharacter:FindFirstChild("Head")
        if not localHead then return end
        local distance = (head.Position - localHead.Position).Magnitude
        local scale = math.clamp(1 - (distance / CONFIG.SCALE_DISTANCE), 0.5, 2)
        tag.Size = UDim2.new(0, CONFIG.TAG_SIZE.X.Offset * scale, 0, CONFIG.TAG_SIZE.Y.Offset * scale)
    end)

    tag.AncestryChanged:Connect(function(_, parent)
        if not parent then
            connection:Disconnect()
        end
    end)

    container.MouseEnter:Connect(function()
        TweenService:Create(container, TweenInfo.new(0.5), {BackgroundTransparency = 0}):Play()
    end)

    container.MouseLeave:Connect(function()
        TweenService:Create(container, TweenInfo.new(0.2), {BackgroundTransparency = 0.2}):Play()
    end)
    container.MouseButton1Click:Connect(function()
        if player ~= Players.LocalPlayer then
            teleportToPlayer(player)
        end
    end)
end

--------------------------------------------------
-- Global table to keep track of CharacterAdded connections.
--------------------------------------------------
local tagConnections = {}

--------------------------------------------------
-- Local variable to store local player's tag choice.
--------------------------------------------------
local localTagChoice = nil

--------------------------------------------------
-- Tag Creation Function
--------------------------------------------------
local function createTag(player, rankText, showPrompt)
    -- Disconnect any existing CharacterAdded listener for this player.
    if tagConnections[player] then
        tagConnections[player]:Disconnect()
        tagConnections[player] = nil
    end

    if showPrompt and player == Players.LocalPlayer then
        if localTagChoice ~= nil then
            if localTagChoice == false then
                return  -- Player chose not to display tag.
            else
                if player.Character then
                    attachTagToHead(player.Character, player, rankText)
                end
                tagConnections[player] = player.CharacterAdded:Connect(function(character)
                    attachTagToHead(character, player, rankText)
                end)
                return
            end
        end

        local gui, yesButton, noButton, blur = createNotificationUI()
        gui.Parent = player:WaitForChild("PlayerGui")

        local function cleanup()
            TweenService:Create(gui.Frame, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
            blur:Destroy()
            task.wait(0.5)
            gui:Destroy()
        end

        yesButton.MouseButton1Click:Connect(function()
            cleanup()
            localTagChoice = true
            if player.Character then
                attachTagToHead(player.Character, player, rankText)
            end
            tagConnections[player] = player.CharacterAdded:Connect(function(character)
                attachTagToHead(character, player, rankText)
            end)
        end)

        noButton.MouseButton1Click:Connect(function()
            cleanup()
            localTagChoice = false
        end)
    else
        if player.Character then
            attachTagToHead(player.Character, player, rankText)
        end
        tagConnections[player] = player.CharacterAdded:Connect(function(character)
            attachTagToHead(character, player, rankText)
        end)
    end
end

--------------------------------------------------
-- Custom Player Role Lists
--------------------------------------------------
local Advertisers = {"Vlafz195", "6736_45", "goekaycool", "goekayball", "goekayball2"}
local LUCKYGOD = {"lIIluckyIIII", "TheSadMan198", "XxLuckyXx187", "XxRaportXX", "FellFlower2"}
local Helper = {"newbornfromthedark", "FadedSkyPlay"}
local Scripters = {"GYATT_DAMN1", "328ml", "29Kyooo", "BloxiAstra", "ImOn_ValveIndex", "iLoveScriptsMiniG"}
local Owners = {"Dxan_PlayS", "Xeni_he07", "AliKhammas1234", "AliKhammas", "I_LOVEYOU12210", "AK_ADMEN1", "YournothimbuddyXD", "AK_ADMEN2", "Akksosdmdokdkddmkd"}
local Supporter = {"Robloxian74630436", "MyLittlePonySEDE"}
local AKStaff = {"goekaycool", "goetemp_1"}

--------------------------------------------------
-- Apply the Appropriate Tag to a Player
--------------------------------------------------
local function applyPlayerTag(player)
    local function attemptTagApplication()
        local showPrompt = player == Players.LocalPlayer
        if isInRole(Owners, player.Name) then
            createTag(player, "AK OWNER", showPrompt)
        elseif isInRole(Scripters, player.Name) then
            createTag(player, "AK SCRIPTER", showPrompt)
        elseif isInRole(Supporter, player.Name) then
            createTag(player, "AK SUPPORTER", showPrompt)
        elseif isInRole(AKStaff, player.Name) then
            createTag(player, "AK STAFF", showPrompt)
        elseif isInRole(LUCKYGOD, player.Name) then
            createTag(player, "AK LUCKYGOD", showPrompt)
        elseif isInRole(Advertisers, player.Name) then
            createTag(player, "AK ADVERTISER", showPrompt)
        elseif isInRole(Helper, player.Name) then
            createTag(player, "AK HELPER", showPrompt)
        elseif ChatWhitelist[player.Name] then
            createTag(player, "AK USER", showPrompt)
        end
    end

    local attempts = 0
    local function retryTagApplication()
        attempts = attempts + 1
        local success, err = pcall(attemptTagApplication)
        if not success and attempts < CONFIG.MAX_RETRY_ATTEMPTS then
            task.wait(CONFIG.RETRY_DELAY)
            retryTagApplication()
        end
    end

    retryTagApplication()
end

--------------------------------------------------
-- Setup Chat Listener for Each Player:
-- When a player chats the specified anti-tag message,
-- if they do not already belong to a custom role (except LUCKYGOD),
-- they will be given a tag. Players in the LUCKYGOD list receive the "AK LUCKYGOD" tag.
--------------------------------------------------
local function setupChatListener(player)
    player.Chatted:Connect(function(msg)
        if modifyString(msg) == "Anti-Tags-|-AK-ADMIN-ABCDEFGHJIKLJSBEBDZWUAJSNCHEI()" then
            if ChatWhitelist[player.Name] then return end

            if isInRole(Owners, player.Name) 
               or isInRole(Scripters, player.Name) 
               or isInRole(Supporter, player.Name) 
               or isInRole(AKStaff, player.Name) 
               or isInRole(Advertisers, player.Name) 
               or isInRole(Helper, player.Name) then
                return
            end

            if isInRole(LUCKYGOD, player.Name) then
                createTag(player, "AK LUCKYGOD", true)
            else
                ChatWhitelist[player.Name] = true
                createTag(player, "AK USER", true)
            end
        end
    end)
end

-- Set up for players already in the game.
for _, player in ipairs(Players:GetPlayers()) do
    setupChatListener(player)
end

-- Set up for players joining later.
Players.PlayerAdded:Connect(function(player)
    setupChatListener(player)
    task.spawn(function()
        applyPlayerTag(player)
    end)
end)

--------------------------------------------------
-- Initialize Tag System for Existing Players.
--------------------------------------------------
for _, player in pairs(Players:GetPlayers()) do
    task.spawn(function()
        applyPlayerTag(player)
    end)
end

--------------------------------------------------
-- Return API (Optional)
--------------------------------------------------
return {
    refreshTags = function()
        for _, player in pairs(Players:GetPlayers()) do
            task.spawn(function()
                applyPlayerTag(player)
            end)
        end
    end,
    forceTag = function(player, rankType)
        if RankColors[rankType] then
            createTag(player, rankType, player == Players.LocalPlayer)
            return true
        end
        return false
    end,
    teleportTo = function(player)
        if player ~= Players.LocalPlayer then
            teleportToPlayer(player)
        end
    end
}
