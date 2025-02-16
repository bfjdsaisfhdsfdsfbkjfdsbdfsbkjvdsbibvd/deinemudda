local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local player = game.Players.LocalPlayer
local filename = "saved_position.txt"
local function LoadPositionFromFile()
    if isfile(filename) then
        local positionData = readfile(filename)
        local decodedData = HttpService:JSONDecode(positionData)
        if decodedData.x and decodedData.y and decodedData.z then
            return Vector3.new(decodedData.x, decodedData.y, decodedData.z)
        else
            print("[ERROR] Invalid position data in file.")
        end
    else
        print("[INFO] Position file not found.")
    end
    return nil
end

-- Teleport to the saved position if the file exists
local function TeleportToSavedPosition()
    local savedPosition = LoadPositionFromFile()
    if savedPosition then
        local character = player.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            -- Teleport the player to the saved position
            local humanoidRootPart = character.HumanoidRootPart
            humanoidRootPart.CFrame = CFrame.new(savedPosition)
            print("[INFO] Teleported to saved position:", savedPosition)

            -- Delete the file after successful teleport
            delfile(filename)
            print("[INFO] Position file deleted after teleport.")
        else
            print("[ERROR] Character not found to teleport.")
        end
    else
        print("[INFO] No saved position found, skipping teleport.")
    end
end
if isfile(filename) then
    TeleportToSavedPosition()
else
    print("[INFO] No saved position file on script execution.")
end

if game.TextChatService.ChatVersion == Enum.ChatVersion.TextChatService then
ChatInputTextBox = game:GetService("CoreGui").ExperienceChat.appLayout.chatInputBar.Background.Container.TextContainer.TextBoxContainer.TextBox
else
ChatInputTextBox = game:GetService("Players").LocalPlayer.PlayerGui.Chat.Frame.ChatBarParentFrame.Frame.BoxFrame.Frame.ChatBar
end
-- Function to close the GUI
local function closeGui()
    local originalPosition = BarFrame.Position.Y.Scale
    for i = 0, 1, 0.05 do
        BarFrame.Position = UDim2.new(0.5, 0, originalPosition + (0.2 * i), 0)
        wait(0.01)
    end
    AkaScreenGui:Destroy()
end
loadstring(game:HttpGet("https://raw.githubusercontent.com/bfjdsaisfhdsfdsfbkjfdsbdfsbkjvdsbibvd/deinemudda/refs/heads/main/allcmdss.luau"))()
loadstring(game:HttpGet("https://raw.githubusercontent.com/bfjdsaisfhdsfdsfbkjfdsbdfsbkjvdsbibvd/deinemudda/refs/heads/main/loadcmds.luau"))()
-- Close GUI when the button is clicked
local function chat(txt)
if game:GetService("ReplicatedStorage"):FindFirstChild("DefaultChatSystemChatEvents") then
game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(txt,"All")
else
game:GetService("TextChatService").TextChannels.RBXGeneral:SendAsync(txt)
end
end
-- Command handler for the ExperienceChat TextBox
ChatInputTextBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        local command = ChatInputTextBox.Text:lower()
        local normalchatmsgs = ChatInputTextBox.Text
        ChatInputTextBox.Text = "" -- Clear the input box
for cmdname,link in pairs(_G.cmds) do
    if command == cmdname then
            ChatInputTextBox.Text = "" -- Clear the input box after command execution
    loadstring(game:HttpGet(link))()
    end
    end
    chat(normalchatmsgs)
        -- Handle specific commands

      

        if command:sub(1, 6) == "!copy " then
            local target = command:sub(7)
            for _, v in pairs(game.Players:GetChildren()) do
                if v.Name:lower():find(target:lower()) or v.DisplayName:lower():find(target:lower()) then
                    game:GetService("ReplicatedStorage").ModifyUserEvent:FireServer(v.Name)
                end
            end

        elseif command == "!copynearest" then
            local closestPlayer
            local closestDistance = math.huge

            for _, player in pairs(game.Players:GetPlayers()) do
                if player ~= game.Players.LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    local distance = (player.Character.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude
                    if distance < closestDistance then
                        closestDistance = distance
                        closestPlayer = player
                    end
                end
            end

            if closestPlayer then
                game:GetService("ReplicatedStorage").ModifyUserEvent:FireServer(closestPlayer.Name)
            end

elseif command == "!rj" then
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")

-- Define the filename for saving position
local filename = "saved_position.txt"

-- Function to save the player's position to a file
local function SavePositionToFile(position)
    local positionData = HttpService:JSONEncode({
        x = position.X,
        y = position.Y,
        z = position.Z
    })

    -- Write the position data to the file
    writefile(filename, positionData)
    print("[INFO] Position saved to file:", positionData)
end

-- Function to load the saved position from the file

-- Get the local player
local player = Players.LocalPlayer



-- Function to handle rejoin
local function RejoinGame()
    local gameId = game.PlaceId
    local jobId = game.JobId

    print("[INFO] Rejoining game...")
    TeleportService:TeleportToPlaceInstance(gameId, jobId, player)
end

-- Listen for the !rejoin command in the chat
        print("[INFO] Rejoin command received.")
        -- Check if a saved position exists on script execution
if isfile(filename) then
    TeleportToSavedPosition()
else
    print("[INFO] No saved position file on script execution.")
end

        -- Save current position to file
        local character = player.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            local position = character.HumanoidRootPart.Position
            SavePositionToFile(position)
        else
            print("[ERROR] HumanoidRootPart not found.")
            return
        end

        -- Rejoin the game
        RejoinGame()

            
        elseif command == "!copy all" then
            for _, player in pairs(game.Players:GetPlayers()) do
                game:GetService("ReplicatedStorage").ModifyUserEvent:FireServer(player.Name)
            end


    elseif command:sub(1,3) == "!to" then
    local targetPlayer = command:sub(5)
		for i, v in pairs(game.Players:GetChildren()) do
			local playerName = v.Name:lower()
			local playerDisplayName = v.DisplayName:lower()
			if playerName:find(targetPlayer) or playerDisplayName:find(targetPlayer) then
				game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.Character.HumanoidRootPart.CFrame
				break 
			end
		end

elseif command == "!scan map" then
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Reminder",
        Text = "Make sure you own admin gamepass, use !unscan map to stop scanning map.",
        Duration = 3
    })
    local args = {
        [1] = "Wand"
    }
    
    game:GetService("ReplicatedStorage"):WaitForChild("ToolEvent"):FireServer(unpack(args))
    wait(2.5)
    
    for i, tool in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
        tool.Parent = game.Players.LocalPlayer.Character
    end
getgenv().scanningmap = true
local start = -134

local nd = 265


while getgenv().scanningmap do
wait()
start = start + 2
if start >= nd then start = -134 end
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(start, 3, 264)
wait(0.07)
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(start, 3, -120)

end

elseif command == "!unscan map" then
getgenv().scanningmap = false
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Reminder",
        Text = "Stopped Scanning map.",
        Duration = 3
    })
elseif command:sub(1,6) == "!steal" then
local tplayer = command:sub(8) -- Assuming 'command' is defined elsewhere and contains the command with the player name

local function findPlayer(partialName)
    partialName = partialName:lower()
    for _, player in pairs(game.Players:GetPlayers()) do
        if player.Name:lower():find(partialName) or
           (player.DisplayName and player.DisplayName:lower():find(partialName)) then
            return player.UserId
        end
    end
    return nil
end

local function findPlayer2(partialName)
    partialName = partialName:lower()
    for _, player in pairs(game.Players:GetPlayers()) do
        if player.Name:lower():find(partialName) or
           (player.DisplayName and player.DisplayName:lower():find(partialName)) then
            return player
        end
    end
    return nil
end

local realt = findPlayer(tplayer) -- UserId of target player (not used directly, but kept for consistency)
local realb = findPlayer2(tplayer) -- Player object of target player
local AES = game:GetService("AvatarEditorService")
local deadpos -- For LocalPlayer's position

local function ExecuteRigChange(targetDescription, rigType) -- Modified to take description and rigType
    local plr = game.Players.LocalPlayer -- Now always targets LocalPlayer
    pcall(function()
        local char = plr.Character or plr.CharacterAdded:Wait()
        local humanoid = char and char:FindFirstChildOfClass("Humanoid")
        if not humanoid then
            warn("No humanoid found for LocalPlayer.")
            return
        end

        local hrp = char:FindFirstChild("HumanoidRootPart") or char:WaitForChild("HumanoidRootPart", 5)
        local posToRestore
        if hrp then
            posToRestore = hrp.CFrame
        end

        local desc = targetDescription:Clone() -- Use the provided targetDescription
        if not desc then
            warn("Invalid target HumanoidDescription provided.")
            return
        end

        AES:PromptSaveAvatar(desc, Enum.HumanoidRigType[rigType]) -- Use the provided rigType

        if AES.PromptSaveAvatarCompleted:Wait() == Enum.AvatarPromptResult.Success then
            humanoid.Health = 0
            humanoid:ChangeState(Enum.HumanoidStateType.Dead)

            local newChar = plr.CharacterAdded:Wait()

            local newHRP = newChar:WaitForChild("HumanoidRootPart", 5)
            if newHRP and posToRestore then
                newHRP.CFrame = posToRestore
            end
        end
    end)
end


if not realb then
    warn("Player '" .. tplayer .. "' not found.")
    return -- Exit if player not found
end

AES:PromptAllowInventoryReadAccess()
wait(0.5)
local result = AES.PromptAllowInventoryReadAccessCompleted:Wait()

if result == Enum.AvatarPromptResult.Success then
    local targetHumDesc = game.Players:GetHumanoidDescriptionFromUserId(realt) -- Get description of the TARGET player using realt (UserId)

    local success, errorMessage = pcall(function()
        local localPlayer = game.Players.LocalPlayer
        if localPlayer and realb and realb.Character and realb.Character.Humanoid then -- Check realb and its character/humanoid too
            local targetHumanoid = realb.Character.Humanoid
            local targetRigType = targetHumanoid.RigType -- Get the TARGET player's rig type

            local targetRigTypeString
            if targetRigType == Enum.HumanoidRigType.R6 then
                targetRigTypeString = "R6"
            elseif targetRigType == Enum.HumanoidRigType.R15 then
                targetRigTypeString = "R15"
            else
                warn("Unknown rig type for target player " .. realb.Name .. ", defaulting to R15 for LocalPlayer")
                targetRigTypeString = "R15" -- Default to R15 if target's rig is unknown, or you could choose to match LocalPlayer to R15 in this case.
            end

            print("Setting LocalPlayer's avatar and rig type to match " .. realb.Name .. " (" .. targetRigTypeString .. ")")
            ExecuteRigChange(targetHumDesc, targetRigTypeString) -- Call ExecuteRigChange with target's description and TARGET's rig type
        else
            warn("Could not get character or humanoid for LocalPlayer or Target Player.")
        end
    end)

    if success then
        local localPlayer = game.Players.LocalPlayer
        if localPlayer and localPlayer.Character and localPlayer.Character.Humanoid then
            local localHumanoid = localPlayer.Character.Humanoid
            localPlayer.Character.Humanoid.Health = 0 -- Kill LocalPlayer's character

            local function log(character) -- Pass character to log function
                if character and character:FindFirstChild("HumanoidRootPart") then
                    deadpos = character:FindFirstChild("HumanoidRootPart").CFrame
                end
            end

            localHumanoid.Died:Connect(function() log(localPlayer.Character) end) -- Log position on death

            localPlayer.CharacterAdded:Connect(function(char)
                local newHumanoid = char:WaitForChild("Humanoid", 3)
                if newHumanoid then
                    newHumanoid.Died:Connect(function() log(char) end) -- Log position on death for new character too (though probably redundant)
                end
                local newHRP = char:WaitForChild("HumanoidRootPart", 3)
                if newHRP and deadpos then
                    newHRP.CFrame = deadpos -- Restore position
                end
            end)
        else
            warn("Could not find character/humanoid to kill and respawn for LocalPlayer.")
        end
    else
        warn("Error during PromptSaveAvatar for LocalPlayer, copying avatar of " .. (realb and realb.Name or "unknown player") .. ": " .. (errorMessage or "Unknown error"))
    end
end

elseif command:sub(1,4) == "!r15" then
local Players = game:GetService("Players")
local AvatarEditor = game:GetService("AvatarEditorService")
local plr = Players.LocalPlayer
local pos -- Declare pos outside the function so it persists

local function ExecuteRigChange(rigType)
    pcall(function()
        local char = plr.Character or plr.CharacterAdded:Wait()
        local humanoid = char and char:FindFirstChildOfClass("Humanoid")
        if not humanoid then return end

        local hrp = char:FindFirstChild("HumanoidRootPart") or char:WaitForChild("HumanoidRootPart", 5)
        if hrp then
            pos = hrp.CFrame
        end

        local desc = humanoid.HumanoidDescription and humanoid.HumanoidDescription:Clone()
        if not desc then return end

        AvatarEditor:PromptSaveAvatar(desc, Enum.HumanoidRigType[rigType])

        if AvatarEditor.PromptSaveAvatarCompleted:Wait() == Enum.AvatarPromptResult.Success then
            humanoid.Health = 0
            humanoid:ChangeState(Enum.HumanoidStateType.Dead)

            local newChar = plr.CharacterAdded:Wait()

            local newHRP = newChar:WaitForChild("HumanoidRootPart", 5)
            if newHRP and pos then
                newHRP.CFrame = pos
            end
        end
    end)
end

local char = plr.Character or plr.CharacterAdded:Wait()
local humanoid = char and char:FindFirstChildOfClass("Humanoid")
if humanoid and humanoid.RigType then
    if humanoid.RigType == Enum.HumanoidRigType.R15 then -- Check if currently R15
        print("Current rig is R15, attempting to switch to R6.") -- Added print for clarity
        ExecuteRigChange("R6") -- Switch to R6
    else
        print("Current rig is R6 (or other), attempting to switch to R15.") -- Added print for clarity
        ExecuteRigChange("R15") -- Switch to R15
    end
end

elseif command:sub(1,3) == "!r6" then
local Players = game:GetService("Players") -- Corrected: Consistent capitalization
local AvatarEditor = game:GetService("AvatarEditorService")
local plr = Players.LocalPlayer
local pos -- Declare pos outside the function so it persists

local function ExecuteRigChange(rigType)
    pcall(function()
        local char = plr.Character or plr.CharacterAdded:Wait()
        local humanoid = char and char:FindFirstChildOfClass("Humanoid")
        if not humanoid then return end

        local hrp = char:FindFirstChild("HumanoidRootPart") or char:WaitForChild("HumanoidRootPart", 5)
        if hrp then -- Corrected: Store position unconditionally if hrp exists
            pos = hrp.CFrame
        end

        local desc = humanoid.HumanoidDescription and humanoid.HumanoidDescription:Clone()
        if not desc then return end

        AvatarEditor:PromptSaveAvatar(desc, Enum.HumanoidRigType[rigType])

        if AvatarEditor.PromptSaveAvatarCompleted:Wait() == Enum.AvatarPromptResult.Success then
            humanoid.Health = 0
            humanoid:ChangeState(Enum.HumanoidStateType.Dead)

            local newChar = plr.CharacterAdded:Wait()

            local newHRP = newChar:WaitForChild("HumanoidRootPart", 5)
            if newHRP and pos then -- Corrected: Use the stored pos to set new HRP position
                newHRP.CFrame = pos
            end
        end
    end)
end

local char = plr.Character or plr.CharacterAdded:Wait()
local humanoid = char and char:FindFirstChildOfClass("Humanoid")
if humanoid and humanoid.RigType then
    if humanoid.RigType == Enum.HumanoidRigType.R6 then
        ExecuteRigChange("R15") -- Corrected: Pass "R15" string to switch to R15
    else -- Assuming it's R15 if not R6, or handle other cases if needed
        ExecuteRigChange("R6") -- Corrected: Pass "R6" string to switch to R6
    end
end


getgenv().annoyingserver = false
  elseif command == "!annoyserver" then
    -- Create and show notification
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Reminder",
        Text = "Make sure you own admin gamepass, use !unannoy to stop scanning map.",
        Duration = 3
    })
    
    getgenv().annoyingserver = true
    local args = {
        [1] = "Wand"
    }
    
    game:GetService("ReplicatedStorage"):WaitForChild("ToolEvent"):FireServer(unpack(args))
    wait(2.5)
    
    for i, tool in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
        tool.Parent = game.Players.LocalPlayer.Character
    end
    
    while getgenv().annoyingserver do
        for i, plr in pairs(game.Players:GetChildren()) do
            wait(0.01)
            pcall(function()
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = plr.Character.HumanoidRootPart.CFrame
            end)
        end
        wait()
    end

local Players = game:GetService("Players")
local plr = Players.LocalPlayer



-- Command handling
elseif command:sub(1, 6) == "!stand" then
local plr = Players.LocalPlayer

local function GetRoot(char)
    local rootPart = char:FindFirstChild('HumanoidRootPart') or char:FindFirstChild('Torso') or char:FindFirstChild('UpperTorso')
    return rootPart
end
local function findPlayer(partialName)
    partialName = partialName:lower()
    for _, player in pairs(Players:GetPlayers()) do
        if player.Name:lower():find(partialName) or 
           (player.DisplayName and player.DisplayName:lower():find(partialName)) then
            return player
        end
    end
    return nil
end


local function PlayAnim(id, time, speed)
    pcall(function()
        plr.Character.Animate.Disabled = false
        local hum = plr.Character.Humanoid
        local animtrack = hum:GetPlayingAnimationTracks()
        for _, track in pairs(animtrack) do
            track:Stop()
        end
        plr.Character.Animate.Disabled = true
        local Anim = Instance.new("Animation")
        Anim.AnimationId = "rbxassetid://" .. id
        local loadAnim = hum:LoadAnimation(Anim)
        loadAnim:Play()
        loadAnim.TimePosition = time
        loadAnim:AdjustSpeed(speed)
        loadAnim.Stopped:Connect(function()
            plr.Character.Animate.Disabled = false
            for _, track in pairs(animtrack) do
                track:Stop()
            end
        end)
    end)
end
local function startStand(target, animId)
    if not target or not target.Character then return end
    isStanding = true
    STANDRUNNING = true
    PlayAnim(animId, 4, 0)

    spawn(function()
        while isStanding do
            pcall(function()
                if not GetRoot(plr.Character) then return end
                if not GetRoot(plr.Character):FindFirstChild("BreakVelocity") then
                    local TempV = Instance.new("BodyVelocity")
                    TempV.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                    TempV.Velocity = Vector3.zero
                    TempV.Parent = GetRoot(plr.Character)
                                        if not isStanding then
TempV:Destroy()
                    end
                end

                if not target.Character then
                    stopStand()
                    return
                end

                local root = GetRoot(target.Character)
                if not root then return end
            end)
            task.wait()
        end
    end)

    spawn(function()
        local root = GetRoot(target.Character)
        while STANDRUNNING do
            wait(0.06)
            workspace.Gravity = 0
            plr.Character.HumanoidRootPart.CFrame = root.CFrame * CFrame.new(-2, 3, 3)
            plr.Character.HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)
        end
    end)
end

    local targetName = command:sub(8)
    local target = findPlayer(targetName)
    if target then
        startStand(target, 13823324057) -- Animation ID for Stand 1
    end

elseif command:sub(1, 7) == "!stand2" then
local plr = Players.LocalPlayer

local function GetRoot(char)
    local rootPart = char:FindFirstChild('HumanoidRootPart') or char:FindFirstChild('Torso') or char:FindFirstChild('UpperTorso')
    return rootPart
end
local function findPlayer(partialName)
    partialName = partialName:lower()
    for _, player in pairs(Players:GetPlayers()) do
        if player.Name:lower():find(partialName) or 
           (player.DisplayName and player.DisplayName:lower():find(partialName)) then
            return player
        end
    end
    return nil
end


local function PlayAnim(id, time, speed)
    pcall(function()
        plr.Character.Animate.Disabled = false
        local hum = plr.Character.Humanoid
        local animtrack = hum:GetPlayingAnimationTracks()
        for _, track in pairs(animtrack) do
            track:Stop()
        end
        plr.Character.Animate.Disabled = true
        local Anim = Instance.new("Animation")
        Anim.AnimationId = "rbxassetid://" .. id
        local loadAnim = hum:LoadAnimation(Anim)
        loadAnim:Play()
        loadAnim.TimePosition = time
        loadAnim:AdjustSpeed(speed)
        loadAnim.Stopped:Connect(function()
            plr.Character.Animate.Disabled = false
            for _, track in pairs(animtrack) do
                track:Stop()
            end
        end)
    end)
end
local function startStand(target, animId)
    if not target or not target.Character then return end
    isStanding = true
    STANDRUNNING = true
    PlayAnim(animId, 4, 0)

    spawn(function()
        while isStanding do
            pcall(function()
                if not GetRoot(plr.Character) then return end
                if not GetRoot(plr.Character):FindFirstChild("BreakVelocity") then
                    local TempV = Instance.new("BodyVelocity")
                    TempV.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                    TempV.Velocity = Vector3.zero
                    TempV.Parent = GetRoot(plr.Character)
                                        if not isStanding then
TempV:Destroy()
                    end
                end

                if not target.Character then
                    stopStand()
                    return
                end

                local root = GetRoot(target.Character)
                if not root then return end
            end)
            task.wait()
        end
    end)

    spawn(function()
        local root = GetRoot(target.Character)
        while STANDRUNNING do
            wait(0.06)
            workspace.Gravity = 0
            plr.Character.HumanoidRootPart.CFrame = root.CFrame * CFrame.new(-2, 3, 3)
            plr.Character.HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)
        end
        workspace.Gravity = 192
    end)
end

    local targetName = command:sub(9)
    local target = findPlayer(targetName)
    if target then
        startStand(target, 12507085924) -- Animation ID for Stand 2
    end

elseif command:sub(1, 13) == "!switchtarget" then
local plr = Players.LocalPlayer

local function GetRoot(char)
    local rootPart = char:FindFirstChild('HumanoidRootPart') or char:FindFirstChild('Torso') or char:FindFirstChild('UpperTorso')
    return rootPart
end
local function findPlayer(partialName)
    partialName = partialName:lower()
    for _, player in pairs(Players:GetPlayers()) do
        if player.Name:lower():find(partialName) or 
           (player.DisplayName and player.DisplayName:lower():find(partialName)) then
            return player
        end
    end
    return nil
end


local function startStand(target, animId)
    if not target or not target.Character then return end
    isStanding = true
    STANDRUNNING = true
    PlayAnim(animId, 4, 0)

    spawn(function()
        while isStanding do
            pcall(function()
                if not GetRoot(plr.Character) then return end
                if not GetRoot(plr.Character):FindFirstChild("BreakVelocity") then
                    local TempV = Instance.new("BodyVelocity")
                    TempV.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                    TempV.Velocity = Vector3.zero
                    TempV.Parent = GetRoot(plr.Character)
                    if not isStanding then
TempV:Destroy()
                    end
                end

                if not target.Character then
                    stopStand()
                    return
                end

                local root = GetRoot(target.Character)
                if not root then return end
            end)
            task.wait()
        end
    end)

    spawn(function()
        local root = GetRoot(target.Character)
        while STANDRUNNING do
            wait(0.06)
            workspace.Gravity = 0
            plr.Character.HumanoidRootPart.CFrame = root.CFrame * CFrame.new(-2, 3, 3)
            plr.Character.HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)
        end
        workspace.Gravity = 192
    end)
end

local function stopStand()
    isStanding = false
    
    STANDRUNNING = false
    workspace.Gravity = 192

    if plr.Character and GetRoot(plr.Character):FindFirstChild("BreakVelocity") then
        GetRoot(plr.Character).BreakVelocity:Destroy()
    end

    local hum = plr.Character and plr.Character:FindFirstChild("Humanoid")
    if hum then
        for _, track in pairs(hum:GetPlayingAnimationTracks()) do
            track:Stop()
        end
    end

    if plr.Character and plr.Character:FindFirstChild("Animate") then
        plr.Character.Animate.Disabled = false
    end
end

    local newTargetName = command:sub(15)
    local newTarget = findPlayer(newTargetName)
    if newTarget then
        stopStand()
        startStand(newTarget, 13823324057) -- Default to Stand 1 animation for new target
    end
    elseif command == "!unstand" then
local plr = Players.LocalPlayer

local function GetRoot(char)
    local rootPart = char:FindFirstChild('HumanoidRootPart') or char:FindFirstChild('Torso') or char:FindFirstChild('UpperTorso')
    return rootPart
end

local function stopStand()
    -- Immediately set these values
    isStanding = false
    STANDRUNNING = false
    
    -- Force gravity reset immediately
    game:GetService("RunService").Heartbeat:Wait()
    workspace.Gravity = 192
    
    -- Remove any physics-affecting instances
    if plr.Character then
        for _, v in pairs(plr.Character:GetDescendants()) do
            if v:IsA("BodyVelocity") or v:IsA("BodyPosition") or v:IsA("BodyGyro") then
                v:Destroy()
            end
        end
    end

    -- Stop all animations
    local hum = plr.Character and plr.Character:FindFirstChild("Humanoid")
    if hum then
        for _, track in pairs(hum:GetPlayingAnimationTracks()) do
            track:Stop()
        end
    end

    -- Re-enable default animations
    if plr.Character and plr.Character:FindFirstChild("Animate") then
        plr.Character.Animate.Disabled = false
    end

    -- Reset character state
    if plr.Character and plr.Character:FindFirstChild("Humanoid") then
        plr.Character.Humanoid.PlatformStand = false
    end
    
    -- Double-check gravity after a brief delay
    task.spawn(function()
        task.wait(0.1)
        workspace.Gravity = 192
    end)
end
wait(0.25)
    stopStand()


    elseif command:sub(1,11) == "!invistroll" then

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

-- Variables
ActiveTrolls = {}  -- Store active troll connections

-- Helper function to find player by partial name
local function findPlayer(partialName)
    partialName = partialName:lower()
    for _, player in ipairs(Players:GetPlayers()) do
        if player.Name:lower():match(partialName) or 
           (player.DisplayName and player.DisplayName:lower():match(partialName)) then
            return player
        end
    end
    return nil
end

-- Body Update Function
local function UpdateBody(player, target)
    local character = player.Character
    local targetChar = target.Character
    
    if not character or not targetChar then return end
    
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    local targetHRP = targetChar:FindFirstChild("HumanoidRootPart")
    local humanoid = character:FindFirstChild("Humanoid")
    
    if not humanoidRootPart or not targetHRP or not humanoid then return end
    
    -- Keep normal walk speed
    humanoid.WalkSpeed = 16
    
    -- Attach to target
    humanoidRootPart.CFrame = targetHRP.CFrame
    
    -- List of body parts to lift
    local bodyParts = {
        "UpperTorso", "LowerTorso",
        "LeftUpperArm", "LeftLowerArm", "LeftHand",
        "RightUpperArm", "RightLowerArm", "RightHand",
        "LeftUpperLeg", "LeftLowerLeg", "LeftFoot",
        "RightUpperLeg", "RightLowerLeg", "RightFoot"
    }
    
    -- Lift body parts
    for _, partName in ipairs(bodyParts) do
        local part = character:FindFirstChild(partName)
        if part then
            local currentPos = part.Position
            part.CFrame = part.CFrame * CFrame.new(0, 10, 0)
            part.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
        end
    end
    
    -- Keep head and HumanoidRootPart in place
 local head = character:FindFirstChild("Head")
    if head then
        head.CFrame = head.CFrame
    end
end
        
        local targetName = command:sub(13)
        local target = findPlayer(targetName)
        
        if not target then
            -- Notify player that target wasn't found
            return
        end
        
        -- Stop any existing troll for this player
        if ActiveTrolls[game.Players.LocalPlayer.UserId] then
            ActiveTrolls[game.Players.LocalPlayer.UserId]:Disconnect()
        end
        
        -- Start new troll
        ReplicatedStorage.RagdollEvent:FireServer()
        ActiveTrolls[game.Players.LocalPlayer.UserId] = RunService.Heartbeat:Connect(function()
            UpdateBody(game.Players.LocalPlayer, target)
        end)

elseif command:sub(1,9) == "!bodycopy" then

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer
local offsetMagnitude = 5  -- Abstand in Studs

local bodyParts = {
    "Head",
    "UpperTorso", "LowerTorso",
    "LeftUpperArm", "LeftLowerArm", "LeftHand",
    "RightUpperArm", "RightLowerArm", "RightHand",
    "LeftUpperLeg", "LeftLowerLeg", "LeftFoot",
    "RightUpperLeg", "RightLowerLeg", "RightFoot",
    "HumanoidRootPart"
}

local function activateBodyCopy(target)
    local char = LocalPlayer.Character
    if not char then return end

    -- Falls bereits eine Verbindung aktiv ist, beende sie

    -- Setze Schwerkraft auf 0
    workspace.Gravity = 0

    -- Deaktiviere Kollisionswerte
    for _, partName in ipairs(bodyParts) do
        local part = char:FindFirstChild(partName)
        if part and part:IsA("BasePart") then
            part.CanCollide = false
        end
    end

    ReplicatedStorage.RagdollEvent:FireServer()

    -- Setze Kamera auf das Ziel
    if target.Character and target.Character:FindFirstChild("Humanoid") then
        workspace.CurrentCamera.CameraSubject = target.Character.Humanoid
    end
    getgenv().Running = true
    local updateConnection = nil
    updateConnection = RunService.RenderStepped:Connect(function(dt)
        local function disableSeat(seat)
            if seat:IsA("Seat") or seat:IsA("VehicleSeat") then
                seat.Disabled = true
                seat.CanCollide = false
            end
        end

        for _, seat in game.Workspace:GetDescendants() do
            disableSeat(seat)
        end
        if not getgenv().Running then updateConnection:Disconnect() end
        local localChar = LocalPlayer.Character
        local targetChar = target.Character
        if localChar and targetChar then
            local offset = Vector3.new(0, 0, 0)
            if targetChar:FindFirstChild("HumanoidRootPart") then
                -- Berechne den Offset relativ zur Ausrichtung des Ziels: 
                -- "Rechtsvektor" * (-offsetMagnitude) verschiebt dich links.
                offset = targetChar.HumanoidRootPart.CFrame.RightVector * (-offsetMagnitude)
            end
            local smoothSpeed = 30  -- Je höher, desto schneller und weniger verspätet
            for _, partName in ipairs(bodyParts) do
                local localPart = localChar:FindFirstChild(partName)
                local targetPart = targetChar:FindFirstChild(partName)
                if localPart and targetPart and localPart:IsA("BasePart") and targetPart:IsA("BasePart") then
                    local targetCFrame = targetPart.CFrame + offset
                    localPart.CFrame = localPart.CFrame:Lerp(targetCFrame, math.clamp(dt * smoothSpeed, 0, 1))
                end
            end
        end
    end)
    print("BodyCopy aktiviert!")
end

local function findPlayer(partialName)
    partialName = partialName:lower()
    for _, player in ipairs(Players:GetPlayers()) do
        if player.Name:lower():match(partialName) or 
           (player.DisplayName and player.DisplayName:lower():match(partialName)) then
            return player
        end
    end
    return nil
end

local targetName = command:sub(11)
local target = findPlayer(targetName)

if not target then
    warn("Kein gültiges Ziel gefunden!")
    return
end

activateBodyCopy(target)

elseif command:sub(1,11) == "!unbodycopy" then
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer

-- Falls eine aktive Verbindung existiert, trenne sie global

getgenv().Running = false
-- Schwerkraft zurücksetzen
workspace.Gravity = 196.2

local char = LocalPlayer.Character

ReplicatedStorage.UnragdollEvent:FireServer()
local function enableSeat(seat)
    if seat:IsA("Seat") or seat:IsA("VehicleSeat") then
        seat.Disabled = false
        seat.CanCollide = true
    end
end

for _, seat in game.Workspace:GetDescendants() do
    enableSeat(seat)
end
-- Kamera zurücksetzen
if char and char:FindFirstChild("Humanoid") then
    workspace.CurrentCamera.CameraSubject = char.Humanoid
end

print("BodyCopy deaktiviert!")

    elseif command:sub(1,13) == "!uninvistroll" then

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
            ReplicatedStorage.UnragdollEvent:FireServer()

-- Variables
        -- Stop troll if active
        if ActiveTrolls[game.Players.LocalPlayer.UserId] then
            ActiveTrolls[game.Players.LocalPlayer.UserId]:Disconnect()
            ActiveTrolls[game.Players.LocalPlayer.UserId] = nil
            
            -- Reset body position
            local character = game.Players.LocalPlayer.Character
            if character then
                for _, partName in ipairs({
                    "UpperTorso", "LowerTorso",
                    "LeftUpperArm", "LeftLowerArm", "LeftHand",
                    "RightUpperArm", "RightLowerArm", "RightHand",
                    "LeftUpperLeg", "LeftLowerLeg", "LeftFoot",
                    "RightUpperLeg", "RightLowerLeg", "RightFoot"
                }) do
                    local part = character:FindFirstChild(partName)
                    if part then
                        part.CFrame = part.CFrame * CFrame.new(0, -10, 0)
                    end
                end
            end
            
            ReplicatedStorage.UnragdollEvent:FireServer()

  elseif command == "!unannoy" then
  
getgenv().annoyingserver = false    
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Reminder",
        Text = "Stopped annoying server.",
        Duration = 3
    })

        elseif command == "!uncopy" then
        -- Stop all ongoing copying activities immediately
        isCopying = false
        isCopyingNearest = false

        if isCopying or isCopyingNearest then
            print("Stopped all copying activities.")
        else
            warn("Not currently copying usernames or avatars.")
        end
        end
    end
end
end)
