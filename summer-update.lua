-- Services
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Créer le ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "InfoGui"
screenGui.Parent = playerGui

-- Créer la frame principale
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 380, 0, 180) -- largeur augmentée pour réduire la marge droite
frame.Position = UDim2.new(0.5, -190, 0.5, -90) -- centrage ajusté pour nouvelle largeur
frame.BackgroundColor3 = Color3.fromRGB(15, 25, 60) -- bleu nuit
frame.BorderSizePixel = 0
frame.Parent = screenGui

-- Coins arrondis
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 15)
corner.Parent = frame

-- Contour lumineux autour de la frame
local frameStroke = Instance.new("UIStroke")
frameStroke.Thickness = 3
frameStroke.Color = Color3.fromRGB(80, 160, 255)
frameStroke.Parent = frame

-- Texte d'information
local label = Instance.new("TextLabel")
label.Size = UDim2.new(1, -20, 1, -20) -- marge interne conservée
label.Position = UDim2.new(0, 10, 0, 10)
label.Text = [[
👋 Welcome! Thanks for using this script.
We are now in version 🔥 2.2.
Please do not move when AutoFarm is activated, that will kick you.

⚡ This script is constantly evolving 🚀
A new update with some patches will be available soon.
Enjoy the script! 😎]]
label.TextColor3 = Color3.fromRGB(180, 220, 255)
label.BackgroundTransparency = 1
label.Font = Enum.Font.GothamBold
label.TextSize = 18
label.TextWrapped = true
label.TextXAlignment = Enum.TextXAlignment.Left
label.TextYAlignment = Enum.TextYAlignment.Top
label.Parent = frame

-- Bouton de fermeture "X"
local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 25, 0, 25)
closeButton.Position = UDim2.new(1, -25, 0, -1) -- position ajustée pour la nouvelle largeur
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

-- Glow néon du bouton
local closeStroke = Instance.new("UIStroke")
closeStroke.Thickness = 2
closeStroke.Color = Color3.fromRGB(100, 180, 255)
closeStroke.Parent = closeButton

-- Fonction pulsation néon
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

-- Effet hover du bouton
closeButton.MouseEnter:Connect(function()
    closeButton.BackgroundColor3 = Color3.fromRGB(50, 130, 255)
    closeButton.Size = UDim2.new(0, 28, 0, 28)
end)

closeButton.MouseLeave:Connect(function()
    closeButton.BackgroundColor3 = Color3.fromRGB(70, 140, 255)
    closeButton.Size = UDim2.new(0, 25, 0, 25)
end)

-- Fermer le GUI et lancer le script
closeButton.MouseButton1Click:Connect(function()
    screenGui:Destroy()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Cyber-Xong/script-MM2-update/refs/heads/main/beachballv2-2.lua"))()
end)
