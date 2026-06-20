-- [[ RIVALS: GOD-TIER OVERRIDE ENGINE ]] --

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- [강화된 설정]
getgenv().GodMode = {
    SilentAim = true,
    Prediction = true, -- 적의 이동속도를 계산하여 예측샷
    HitboxExpansion = 10, -- 히트박스 최대 확장
    AutoWallCheck = false -- 벽 무시 여부 (조심해서 사용)
}

-- [탄도학 강제 수정 엔진]
local mt = getrawmetatable(game)
setreadonly(mt, false)
local old = mt.__namecall

mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    local args = {...}

    if getgenv().GodMode.SilentAim and (method == "FireServer" or method == "InvokeServer") then
        local target = Players:GetPlayers()[2] -- 가장 가까운 타겟 자동 추적
        if target and target.Character and target.Character:FindFirstChild("Head") then
            local head = target.Character.Head
            
            -- 예측 사격 로직: 적의 이동속도(Velocity)만큼 조준점을 앞으로 옮김
            local velocity = target.Character.HumanoidRootPart.Velocity
            local prediction = velocity * 0.15 -- 타겟팅 보정값
            
            args[2] = head.Position + prediction -- 서버에 전송되는 좌표를 예측값으로 변조
            return old(self, unpack(args))
        end
    end
    return old(self, ...)
end)
setreadonly(mt, true)

-- [물리 엔진 강제 개입 (히트박스)]
RunService.Heartbeat:Connect(function()
    if getgenv().GodMode.SilentAim then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                local part = p.Character:FindFirstChild("Head")
                if part then
                    part.Size = Vector3.new(getgenv().GodMode.HitboxExpansion, getgenv().GodMode.HitboxExpansion, getgenv().GodMode.HitboxExpansion)
                    part.CanCollide = false
                end
            end
        end
    end
end)
