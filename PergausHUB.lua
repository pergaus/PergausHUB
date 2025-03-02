-- Pergaus HUB - Gelişmiş Script

-- UI Library
local success, Library = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/yourusername/UILibrary/main.lua"))()
end)
if not success or not Library then
    warn("UI Library yüklenemedi!")
    return
end

local Window = Library:CreateWindow("Pergaus HUB")

-- Uçuş Sistemi
local flying = false
function toggleFly()
    flying = not flying
    local player = game.Players.LocalPlayer
    if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then return end
    local char = player.Character
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.PlatformStand = flying
    end
    if flying then
        local bv = Instance.new("BodyVelocity", char.HumanoidRootPart)
        bv.Velocity = Vector3.new(0, 50, 0)
        bv.MaxForce = Vector3.new(4000, 4000, 4000)
    else
        for _, v in pairs(char.HumanoidRootPart:GetChildren()) do
            if v:IsA("BodyVelocity") then v:Destroy() end
        end
    end
end
Window:CreateButton("Uçmayı Aç/Kapat", toggleFly)

-- Hız Ayarı
local speed = 16
Window:CreateSlider("Hız Ayarı", 16, 100, function(value)
    speed = value
    local player = game.Players.LocalPlayer
    if player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
        player.Character.Humanoid.WalkSpeed = speed
    end
end)

-- Animasyon Seçimi
local animations = {
    Normal = "rbxassetid://2510198475",
    Ninja = "rbxassetid://6561188527",
    Superhero = "rbxassetid://3333333333"
}
Window:CreateDropdown("Animasyon Seç", {"Normal", "Ninja", "Superhero"}, function(selected)
    local player = game.Players.LocalPlayer
    if not player.Character or not player.Character:FindFirstChildOfClass("Humanoid") then return end
    local anim = Instance.new("Animation")
    anim.AnimationId = animations[selected]
    local animator = player.Character:FindFirstChildOfClass("Animator")
    if animator then
        local loadedAnim = animator:LoadAnimation(anim)
        loadedAnim:Play()
    end
end)

-- ESP Sistemi
Window:CreateToggle("ESP Aç/Kapat", function(state)
    for _, v in pairs(game.Players:GetPlayers()) do
        if v ~= game.Players.LocalPlayer and v.Character then
            local highlight = v.Character:FindFirstChild("Highlight") or Instance.new("Highlight", v.Character)
            highlight.FillColor = Color3.new(1, 0, 0)
            highlight.OutlineColor = Color3.new(1, 1, 1)
            highlight.Enabled = state
        end
    end
end)

-- Sohbet Temizleme
Window:CreateButton("Chat'i Temizle", function()
    local chatFrame = game.Players.LocalPlayer:FindFirstChild("PlayerGui")
    if chatFrame and chatFrame:FindFirstChild("Chat") then
        local chatLog = chatFrame.Chat:FindFirstChild("Frame")
        if chatLog and chatLog:FindFirstChild("ChatChannelParentFrame") then
            for _, message in pairs(chatLog.ChatChannelParentFrame:GetDescendants()) do
                if message:IsA("TextLabel") then
                    message.Text = ""
                end
            end
        end
    end
end)

print("Pergaus HUB yüklendi!")
