-- [[ AZURE HUB | TIME BOMB ]]
-- Author: by gh00l
-- PlaceId: 11379739543 | Optimized for Delta Executor
-- Image Asset ID: 115431073964455

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local VirtualInputManager = game:GetService("VirtualInputManager")

local LocalPlayer = Players.LocalPlayer

-- Global Configuration Table
getgenv().AzureHub = {
    AntiBomb = false,
    AutoPass = false,
    AutoChase = false,
    AutoActive = false,
    ZoomHitbox = false,
    HitboxRadius = 25,
    Speed1Enabled = false,
    Speed1Value = 20,
    Speed2Enabled = false,
    Speed2Value = 24,
    DoubleJump = false,
    Disappearance = false,
    AutoReady = false,
    AutoFlee = false,
    FleeDistance = 25
}

-- ====================================================================
-- 1. ADVANCED SECURITY SHIELD (حماية واعتراض ريموتات العقوبات)
-- ====================================================================
task.spawn(function()
    pcall(function()
        local old_namecall
        old_namecall = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
            if not checkcaller() and typeof(self) == "Instance" then
                local method = getnamecallmethod()
                if method == "FireServer" or method == "InvokeServer" then
                    local rName = tostring(self.Name)
                    if rName == "BanPlayer" or rName == "KickPlayer" or rName == "KillPlayer" 
                        or rName == "MutePlayer" or rName == "ConsoleLog" or rName == "SendCommand" 
                        or rName == "UnpunishPlayer" then
                        return nil
                    end
                end
            end
            return old_namecall(self, ...)
        end))
    end)
end)

-- ====================================================================
-- 2. WINDUI INITIALIZATION
-- ====================================================================
local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"))()

local Window = WindUI:CreateWindow({
    Title   = "Azure Hub | Time Bomb",
    Author  = "by gh00l",
    Folder  = "azure_hub_timebomb",
    Icon    = "bomb",
    Theme   = "Dark",
    Size    = UDim2.fromOffset(680, 460),
    MinSize = Vector2.new(560, 350),
    MaxSize = Vector2.new(850, 560),

    ToggleKey   = Enum.KeyCode.RightShift,
    Resizable   = true,
    AutoScale   = true,
    NewElements = true,

    HideSearchBar    = false,
    ScrollBarEnabled = false,
    SideBarWidth     = 200,

    Topbar = {
        Height      = 44,
        ButtonsType = "Mac",
    },

    OpenButton = {
        Title   = "Open Hub",
        Enabled = false,
    },

    User = {
        Enabled   = true,
        Anonymous = false,
        Callback  = function() end,
    },
})

-- ====================================================================
-- 3. INTERACTIVE RAINBOW FLOATING BUTTON (ROUNDED SQUARE)
-- ====================================================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Azure_FloatGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

pcall(function() ScreenGui.Parent = CoreGui end)
if not ScreenGui.Parent then ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

local FloatButton = Instance.new("ImageButton")
FloatButton.Name = "RainbowFloatBtn"
FloatButton.Size = UDim2.new(0, 56, 0, 56)
FloatButton.Position = UDim2.new(0.06, 0, 0.28, 0)
FloatButton.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
FloatButton.AutoButtonColor = false
FloatButton.Parent = ScreenGui

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 14)
Corner.Parent = FloatButton

local Stroke = Instance.new("UIStroke")
Stroke.Thickness = 2.4
Stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
Stroke.Parent = FloatButton

task.spawn(function()
    local hue = 0
    while true do
        hue = (hue + 0.008) % 1
        Stroke.Color = Color3.fromHSV(hue, 0.85, 1)
        RunService.RenderStepped:Wait()
    end
end)

local ButtonIcon = Instance.new("ImageLabel")
ButtonIcon.Name = "Icon"
ButtonIcon.Size = UDim2.new(0, 36, 0, 36)
ButtonIcon.Position = UDim2.new(0.5, -18, 0.5, -18)
ButtonIcon.BackgroundTransparency = 1
ButtonIcon.Image = "rbxassetid://115431073964455"
ButtonIcon.Parent = FloatButton

-- نظام سحب الزر العائم
local dragging, dragInput, dragStart, startPos
FloatButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = FloatButton.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

FloatButton.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        FloatButton.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

FloatButton.MouseButton1Click:Connect(function()
    local tw = TweenService:Create(FloatButton, TweenInfo.new(0.1, Enum.EasingStyle.Quad), {Size = UDim2.new(0, 50, 0, 50)})
    tw:Play()
    tw.Completed:Wait()
    TweenService:Create(FloatButton, TweenInfo.new(0.1, Enum.EasingStyle.Quad), {Size = UDim2.new(0, 56, 0, 56)}):Play()

    if Window and Window.Toggle then
        Window:Toggle()
    else
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.RightShift, false, game)
        task.wait(0.05)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.RightShift, false, game)
    end
end)

-- ====================================================================
-- 4. BOMB SCANNER & WORKSPACE.CHARACTERS ENGINE
-- ====================================================================
local function checkHasBomb(char)
    if not char then return nil, nil end

    local tool = char:FindFirstChildOfClass("Tool")
    if tool then
        local handle = tool:FindFirstChild("Handle") or tool:FindFirstChildOfClass("BasePart") or char:FindFirstChild("HumanoidRootPart")
        return tool, handle
    end

    local bp = LocalPlayer:FindFirstChildOfClass("Backpack")
    if bp then
        local bpTool = bp:FindFirstChildOfClass("Tool")
        if bpTool then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then pcall(function() hum:EquipTool(bpTool) end) end
            local handle = bpTool:FindFirstChild("Handle") or bpTool:FindFirstChildOfClass("BasePart") or char:FindFirstChild("HumanoidRootPart")
            return bpTool, handle
        end
    end

    local checkParts = {"Right Arm", "Left Arm", "RightHand", "LeftHand", "Torso", "UpperTorso"}
    for _, partName in ipairs(checkParts) do
        local bodyPart = char:FindFirstChild(partName)
        if bodyPart then
            for _, item in ipairs(bodyPart:GetChildren()) do
                if item:IsA("BasePart") or item:IsA("Model") or item:IsA("Accessory") then
                    local lower = string.lower(item.Name)
                    if string.find(lower, "bomb") or item:FindFirstChildOfClass("TouchTransmitter") then
                        local contact = item:IsA("BasePart") and item or item:FindFirstChildOfClass("BasePart") or bodyPart
                        return item, contact
                    end
                end
            end
        end
    end

    return nil, nil
end

local function fireTouch(part1, part2)
    if typeof(firetouchinterest) == "function" and part1 and part2 and part1.Parent and part2.Parent then
        pcall(function()
            firetouchinterest(part1, part2, 0)
            firetouchinterest(part1, part2, 1)
        end)
    end
end

local function getOpponents()
    local opponents = {}
    local charFolder = workspace:FindFirstChild("Characters")
    if charFolder then
        for _, c in ipairs(charFolder:GetChildren()) do
            if c:IsA("Model") and c.Name ~= LocalPlayer.Name then
                local hum = c:FindFirstChildOfClass("Humanoid")
                local root = c:FindFirstChild("HumanoidRootPart")
                if hum and root and hum.Health > 0 and hum:GetState() ~= Enum.HumanoidStateType.Dead then
                    table.insert(opponents, c)
                end
            end
        end
    end
    return opponents
end

local function getClosestVictim(myPos)
    local closest = nil
    local minDist = 99999
    for _, c in ipairs(getOpponents()) do
        local root = c:FindFirstChild("HumanoidRootPart")
        if root then
            local dist = (myPos - root.Position).Magnitude
            if dist < minDist then
                minDist = dist
                closest = c
            end
        end
    end
    return closest
end

-- ====================================================================
-- 5. REAL HITBOX EXPANDER (NEON CUBES VIA RENDERSTEPPED)
-- ====================================================================
local originalHitboxSizes = {}

RunService.RenderStepped:Connect(function()
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local rad = tonumber(getgenv().AzureHub.HitboxRadius) or 25
    local opponents = getOpponents()

    if getgenv().AzureHub.ZoomHitbox then
        for _, opp in ipairs(opponents) do
            local oppRoot = opp:FindFirstChild("HumanoidRootPart")
            if oppRoot then
                if not originalHitboxSizes[oppRoot] then
                    originalHitboxSizes[oppRoot] = oppRoot.Size
                end
                oppRoot.Size = Vector3.new(rad, rad, rad)
                oppRoot.Transparency = 0.65
                oppRoot.Material = Enum.Material.Neon
                oppRoot.BrickColor = BrickColor.new("Really blue")
                oppRoot.CanCollide = false
                oppRoot.Massless = true

                if root and checkHasBomb(char) then
                    local dist = (root.Position - oppRoot.Position).Magnitude
                    if dist <= rad then
                        local _, contactPart = checkHasBomb(char)
                        local bombPart = contactPart or root
                        fireTouch(bombPart, oppRoot)
                    end
                end
            end
        end
    else
        for oppRoot, origSize in pairs(originalHitboxSizes) do
            if oppRoot and oppRoot.Parent then
                oppRoot.Size = origSize
                oppRoot.Transparency = 1
                oppRoot.CanCollide = false
            end
        end
        originalHitboxSizes = {}
    end
end)

-- ====================================================================
-- 6. CORE GAMEPLAY ENGINE
-- ====================================================================
RunService.Heartbeat:Connect(function(dt)
    local char = LocalPlayer.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if not root or not humanoid then return end

    -- Invisibility
    if getgenv().AzureHub.Disappearance then
        pcall(function()
            if char:FindFirstChild("Head") and char.Head:FindFirstChildOfClass("BillboardGui") then
                char.Head:FindFirstChildOfClass("BillboardGui").Enabled = false
            end
            for _, p in ipairs(char:GetDescendants()) do
                if p:IsA("BasePart") and p.Name ~= "HumanoidRootPart" then
                    p.Transparency = 1
                elseif p:IsA("Decal") then
                    p.Transparency = 1
                end
            end
        end)
    else
        pcall(function()
            if char:FindFirstChild("Head") and char.Head:FindFirstChildOfClass("BillboardGui") then
                char.Head:FindFirstChildOfClass("BillboardGui").Enabled = true
            end
            for _, p in ipairs(char:GetDescendants()) do
                if p:IsA("BasePart") and p.Name ~= "HumanoidRootPart" then
                    if p.Name == "CastShadow" then p.Transparency = 1 else p.Transparency = 0 end
                elseif p:IsA("Decal") then
                    p.Transparency = 0
                end
            end
        end)
    end

    -- Anti-Bomb (Prone)
    if getgenv().AzureHub.AntiBomb then
        humanoid.PlatformStand = true
        local _, yaw, _ = root.CFrame:ToEulerAnglesYXZ()
        root.CFrame = CFrame.new(root.Position) * CFrame.Angles(math.rad(-90), yaw, 0)
        if humanoid.MoveDirection.Magnitude == 0 then
            root.Velocity = Vector3.new(0, root.Velocity.Y, 0)
            root.RotVelocity = Vector3.new(0, 0, 0)
        end
    else
        if humanoid.PlatformStand and not getgenv().AzureHub.AntiBomb then
            humanoid.PlatformStand = false
            local _, yaw, _ = root.CFrame:ToEulerAnglesYXZ()
            root.CFrame = CFrame.new(root.Position) * CFrame.Angles(0, yaw, 0)
        end
    end

    -- Speed 1
    if getgenv().AzureHub.Speed1Enabled then
        humanoid.WalkSpeed = getgenv().AzureHub.Speed1Value
    else
        if not getgenv().AzureHub.AutoActive then
            humanoid.WalkSpeed = 16
        end
    end

    -- Speed 2 (CFrame Delta Injection)
    if getgenv().AzureHub.Speed2Enabled then
        local moveDir = humanoid.MoveDirection
        if moveDir.Magnitude > 0 then
            local extraSpeed = math.max(0, getgenv().AzureHub.Speed2Value - 16)
            root.CFrame = root.CFrame + (moveDir * (extraSpeed * dt))
        end
    end
end)

-- Double Jump
UserInputService.JumpRequest:Connect(function()
    if getgenv().AzureHub.DoubleJump and LocalPlayer.Character then
        local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if humanoid and root then
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            pcall(function()
                root.Velocity = Vector3.new(root.Velocity.X, humanoid.JumpPower > 0 and humanoid.JumpPower or 50, root.Velocity.Z)
            end)
        end
    end
end)

-- Auto Pass Bomb
local isPassing = false
task.spawn(function()
    while true do
        task.wait(0.04)
        if getgenv().AzureHub.AutoPass and not isPassing and LocalPlayer.Character then
            local char = LocalPlayer.Character
            local root = char:FindFirstChild("HumanoidRootPart")
            if root then
                local bombObj, contactPart = checkHasBomb(char)
                if bombObj and contactPart then
                    local targetVictim = getClosestVictim(root.Position)
                    if targetVictim then
                        isPassing = true
                        local originalCFrame = root.CFrame
                        local vicRoot = targetVictim:FindFirstChild("HumanoidRootPart")
                        local vicHum = targetVictim:FindFirstChildOfClass("Humanoid")
                        local latchStart = tick()

                        while (tick() - latchStart < 1.0) and vicRoot and vicHum and vicHum.Health > 0 and vicHum:GetState() ~= Enum.HumanoidStateType.Dead and checkHasBomb(char) do
                            root.CFrame = vicRoot.CFrame * CFrame.new(0, 0, 1.2)
                            fireTouch(contactPart, vicRoot)
                            task.wait(0.02)
                        end

                        root.CFrame = originalCFrame
                        task.wait(0.15)
                        isPassing = false
                    end
                end
            end
        end
    end
end)

-- Auto Chase
local lastTouchTime = 0
RunService.Heartbeat:Connect(function(dt)
    if getgenv().AzureHub.AutoChase and getgenv().AzureHub.AutoActive and LocalPlayer.Character then
        local char = LocalPlayer.Character
        local root = char:FindFirstChild("HumanoidRootPart")
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        if not root or not humanoid then return end

        local bombObj, contactPart = checkHasBomb(char)
        if not bombObj then return end

        local targetVictim = getClosestVictim(root.Position)
        if targetVictim then
            local vicRoot = targetVictim:FindFirstChild("HumanoidRootPart")
            if vicRoot then
                local targetPos = vicRoot.Position
                local dist = (root.Position - targetPos).Magnitude
                if dist > 20 then
                    humanoid:MoveTo(targetPos)
                    humanoid.WalkSpeed = getgenv().AzureHub.Speed1Enabled and getgenv().AzureHub.Speed1Value or 24
                elseif dist > 3 then
                    humanoid:MoveTo(targetPos)
                    local behindPos = vicRoot.CFrame * CFrame.new(0, 0, 1.5)
                    root.CFrame = root.CFrame:Lerp(behindPos, 0.2)
                else
                    if tick() - lastTouchTime > 0.08 then
                        lastTouchTime = tick()
                        local touchPart = contactPart or root
                        fireTouch(touchPart, vicRoot)
                    end
                end
            end
        end
    end
end)

-- Auto Ready Loop
task.spawn(function()
    while true do
        task.wait(0.5)
        if getgenv().AzureHub.AutoReady then
            pcall(function()
                local arenaRemotes = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("Arena")
                if arenaRemotes and arenaRemotes:FindFirstChild("Ready") then
                    arenaRemotes.Ready:FireServer()
                    arenaRemotes.Ready:FireServer(true)
                end
            end)
        end
    end
end)

-- Auto Flee (Horizontal Evade)
task.spawn(function()
    while true do
        task.wait(0.1)
        if getgenv().AzureHub.AutoFlee and LocalPlayer.Character then
            local myChar = LocalPlayer.Character
            local myRoot = myChar:FindFirstChild("HumanoidRootPart")
            if myRoot and not checkHasBomb(myChar) then
                for _, oppChar in ipairs(getOpponents()) do
                    if oppChar and oppChar.Parent then
                        local oppRoot = oppChar:FindFirstChild("HumanoidRootPart")
                        if oppRoot and checkHasBomb(oppChar) then
                            local dist = (myRoot.Position - oppRoot.Position).Magnitude
                            local fleeDist = getgenv().AzureHub.FleeDistance or 25
                            if dist < fleeDist then
                                local rawDir = (myRoot.Position - oppRoot.Position)
                                local flatDir = Vector3.new(rawDir.X, 0, rawDir.Z).Unit
                                if flatDir.Magnitude > 0 then
                                    myRoot.CFrame = CFrame.new(myRoot.Position + flatDir * 5, myRoot.Position + flatDir * 10)
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end)

-- ====================================================================
-- 7. WINDUI TABS & CONTROLS
-- ====================================================================
local TabCombat = Window:Tab({ Title = "Combat", Icon = "swords" })
local TabMove   = Window:Tab({ Title = "Movement", Icon = "zap" })
local TabArena  = Window:Tab({ Title = "Arena", Icon = "trophy" })

-- Tab: Combat
TabCombat:Section({ Title = "Hitbox & Passing" })

TabCombat:Toggle({
    Title = "Hitbox Expander",
    Default = false,
    Callback = function(val)
        getgenv().AzureHub.ZoomHitbox = val
    end,
})

TabCombat:Input({
    Title = "Hitbox Radius",
    Default = "25",
    Placeholder = "25",
    Callback = function(text)
        local n = tonumber(text)
        if n then getgenv().AzureHub.HitboxRadius = n end
    end,
})

TabCombat:Toggle({
    Title = "Auto Pass Bomb",
    Default = false,
    Callback = function(val)
        getgenv().AzureHub.AutoPass = val
    end,
})

TabCombat:Toggle({
    Title = "Auto Chase Target",
    Default = false,
    Callback = function(val)
        getgenv().AzureHub.AutoChase = val
        getgenv().AzureHub.AutoActive = val
    end,
})

TabCombat:Toggle({
    Title = "Auto Evade / Flee",
    Default = false,
    Callback = function(val)
        getgenv().AzureHub.AutoFlee = val
    end,
})

TabCombat:Toggle({
    Title = "Anti Bomb (Prone)",
    Default = false,
    Callback = function(val)
        getgenv().AzureHub.AntiBomb = val
    end,
})

-- Tab: Movement
TabMove:Section({ Title = "Speed & Skills" })

TabMove:Toggle({
    Title = "Speed 1",
    Default = false,
    Callback = function(val)
        getgenv().AzureHub.Speed1Enabled = val
    end,
})

TabMove:Input({
    Title = "Speed 1 Value",
    Default = "20",
    Placeholder = "20",
    Callback = function(text)
        local n = tonumber(text)
        if n then getgenv().AzureHub.Speed1Value = n end
    end,
})

TabMove:Toggle({
    Title = "Speed 2 (Bypass)",
    Default = false,
    Callback = function(val)
        getgenv().AzureHub.Speed2Enabled = val
    end,
})

TabMove:Input({
    Title = "Speed 2 Value",
    Default = "24",
    Placeholder = "24",
    Callback = function(text)
        local n = tonumber(text)
        if n then getgenv().AzureHub.Speed2Value = n end
    end,
})

TabMove:Toggle({
    Title = "Double Jump",
    Default = false,
    Callback = function(val)
        getgenv().AzureHub.DoubleJump = val
    end,
})

TabMove:Toggle({
    Title = "Disappearance",
    Default = false,
    Callback = function(val)
        getgenv().AzureHub.Disappearance = val
    end,
})

-- Tab: Arena
TabArena:Section({ Title = "Arena & Misc" })

TabArena:Toggle({
    Title = "Auto Ready",
    Default = false,
    Callback = function(val)
        getgenv().AzureHub.AutoReady = val
    end,
})

TabArena:Button({
    Title = "TP Above Map",
    Callback = function()
        local char = LocalPlayer.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if root then
            root.CFrame = root.CFrame + Vector3.new(0, 220, 0)
            local p = Instance.new("Part")
            p.Size = Vector3.new(20, 1, 20)
            p.Position = root.Position - Vector3.new(0, 3, 0)
            p.Anchored = true
            p.Material = Enum.Material.Glass
            p.Transparency = 0.5
            p.Parent = workspace
            game:GetService("Debris"):AddItem(p, 15)
        end
    end,
})

WindUI:Notify({
    Title = "Azure Hub",
    Content = "Loaded successfully by gh00l",
    Duration = 4,
})
