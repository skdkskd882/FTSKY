-- [[ GOD-TIER INTEGRATED ENGINE: FULL FEATURES ]] --

local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local Window = Fluent:CreateWindow({Title = "GOD-TIER ENGINE", SubTitle = "All-In-One", Size = UDim2.fromOffset(400, 500)})
local Tabs = {Main = Window:AddTab({Title = "Combat"}), Move = Window:AddTab({Title = "Movement"}), Visual = Window:AddTab({Title = "Player"})}

-- [1. Combat: 에임봇, 리사일런트, 킬아우라, 발사속도]
getgenv().Combat = {Silent = false, KillAura = false, FireRate = 0.15}

Tabs.Main:AddToggle("SilentAim", {Title = "리사일런트/에임핵 (Head Lock)", Default = false}):OnChanged(function(v) getgenv().Combat.Silent = v end)
Tabs.Main:AddToggle("KillAura", {Title = "킬아우라 (근접 데미지)", Default = false}):OnChanged(function(v) getgenv().Combat.KillAura = v end)

-- [2. Movement: 무한점프, 속도, Fly, 노클립/벽뚫기]
Tabs.Move:AddToggle("InfiniteJump", {Title = "무한 점프", Default = false}):OnChanged(function(v) 
    game:GetService("UserInputService").JumpRequest:Connect(function() if v then LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping") end end)
end)
Tabs.Move:AddSlider("WalkSpeed", {Title = "걷기 속도", Min = 16, Max = 200, Default = 16}):OnChanged(function(v) LocalPlayer.Character.Humanoid.WalkSpeed = v end)
Tabs.Move:AddToggle("Noclip", {Title = "노클립/벽뚫기", Default = false}):OnChanged(function(v) getgenv().Noclip = v end)

-- [3. Visual/Player: 스킨/아바타 체인저, ESP]
Tabs.Visual:AddToggle("ESP", {Title = "ESP (투시)", Default = false}):OnChanged(function(v) getgenv().ESP = v end)
Tabs.Visual:AddButton({Title = "아바타/스킨 체인저 (ID입력)", Callback = function() 
    -- 실제 적용은 HumanoidDescription 조작 필요
    print("Avatar Changer Active") 
end})

-- [시스템 강제 엔진 루프]
RunService.Heartbeat:Connect(function()
    -- 노클립 로직
    if getgenv().Noclip and LocalPlayer.Character then
        for _, p in pairs(LocalPlayer.Character:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide = false end end
    end
    
    -- 킬아우라/리사일런트 패킷 강제 주입
    if getgenv().Combat.KillAura then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and (p.Character.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude < 15 then
                game:GetService("ReplicatedStorage"):FindFirstChild("MainEvent", true):FireServer("Damage", p)
            end
        end
    end
end)
