-- Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Créer le ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "InfoGui"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = playerGui

-- Frame principale
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 380, 0, 180)
frame.Position = UDim2.new(0.5, -190, 0.5, -90)
frame.BackgroundColor3 = Color3.fromRGB(15, 25, 60)
frame.BorderSizePixel = 0
frame.Parent = screenGui

-- Coins arrondis
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 15)
corner.Parent = frame

-- Contour lumineux
local frameStroke = Instance.new("UIStroke")
frameStroke.Thickness = 3
frameStroke.Color = Color3.fromRGB(80, 160, 255)
frameStroke.Parent = frame

-- Texte d'information
local label = Instance.new("TextLabel")
label.Size = UDim2.new(1, -20, 1, -20)
label.Position = UDim2.new(0, 10, 0, 10)
label.TextColor3 = Color3.fromRGB(180, 220, 255)
label.BackgroundTransparency = 1
label.Font = Enum.Font.GothamBold
label.TextSize = 18
label.TextWrapped = true
label.TextXAlignment = Enum.TextXAlignment.Left
label.TextYAlignment = Enum.TextYAlignment.Top
label.Parent = frame

-- Texte à afficher lettre par lettre
local fullText = [[
👋 Welcome! Thanks for using this script.
We are now in version 🔥 2.2.
Please do not move when AutoFarm is activated, that will kick you.
⚡ This script is constantly evolving 🚀
A new update with some patches will be available soon.
⏳ Please wait ~15s while the script loads...
And enjoy the script! 😎]]

-- Animation d’écriture du texte
spawn(function()
    label.Text = ""
    for i = 1, #fullText do
        label.Text = string.sub(fullText, 1, i)
        wait(0.02)
    end
end)

-- Bouton de fermeture
local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 25, 0, 25)
closeButton.Position = UDim2.new(1, -30, 0, 5)
closeButton.BackgroundColor3 = Color3.fromRGB(70, 140, 255)
closeButton.Text = "X"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.Font = Enum.Font.GothamBold
closeButton.TextScaled = true
closeButton.Parent = frame

-- Coins arrondis du bouton
local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 5)
closeCorner.Parent = closeButton

-- Contour lumineux du bouton
local closeStroke = Instance.new("UIStroke")
closeStroke.Thickness = 2
closeStroke.Color = Color3.fromRGB(100, 180, 255)
closeStroke.Parent = closeButton

-- Glow pulsant du bouton
spawn(function()
    local direction = 1
    while closeButton.Parent do
        local r, g, b = closeStroke.Color.R, closeStroke.Color.G, closeStroke.Color.B
        r = r + 0.005 * direction
        g = g + 0.005 * direction
        b = b + 0.005 * direction
        if r > 0.7 or r < 0.4 then direction = -direction end
        closeStroke.Color = Color3.new(r, g, b)
        wait(0.03)
    end
end)

-- Animation pulsation bouton (taille)
spawn(function()
    local scale = 1
    local growing = true
    while closeButton.Parent do
        if growing then
            scale = scale + 0.01
        else
            scale = scale - 0.01
        end
        closeButton.Size = UDim2.new(0, 25 * scale, 0, 25 * scale)
        if scale >= 1.2 or scale <= 0.9 then
            growing = not growing
        end
        wait(0.03)
    end
end)

-- Hover du bouton
closeButton.MouseEnter:Connect(function()
    closeButton.BackgroundColor3 = Color3.fromRGB(50, 130, 255)
end)

closeButton.MouseLeave:Connect(function()
    closeButton.BackgroundColor3 = Color3.fromRGB(70, 140, 255)
end)

-- Fermer GUI avec transition vers la gauche + fade-out
closeButton.MouseButton1Click:Connect(function()
    local tweenInfo = TweenInfo.new(0.7, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

    -- Slide + fade frame
    local tweenFrame = TweenService:Create(frame, tweenInfo, {
        Position = UDim2.new(-1, 0, 0.5, -90),
        BackgroundTransparency = 1
    })

    -- Fade-out du texte
    local tweenText = TweenService:Create(label, tweenInfo, {
        TextTransparency = 1
    })

    -- Fade-out du contour lumineux
    local tweenStroke = TweenService:Create(frameStroke, tweenInfo, {
        Transparency = 1
    })

    tweenFrame:Play()
    tweenText:Play()
    tweenStroke:Play()

    tweenFrame.Completed:Wait()
    screenGui:Destroy()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Cyber-Xong/script-MM2-update/refs/heads/main/beachballv2-2.lua"))()
end)
