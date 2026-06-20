-- [[ GOD-MODE: INTERNAL ENGINE OVERRIDE ]] --

local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- [1. 통신 루프 차단 및 데이터 주입]
-- 서버가 요청하는 유효성 검사를 무력화하고, 
-- 클라이언트가 원하는 데이터만 서버에 강제 주입합니다.
local mt = getrawmetatable(game)
setreadonly(mt, false)
local oldNamecall = mt.__namecall

mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    local args = {...}

    -- 서버로 나가는 모든 '업데이트 패킷'을 가로채서 '관리자 권한' 수준으로 수정
    if method == "FireServer" or method == "InvokeServer" then
        if tostring(self) == "MainEvent" then
            args[1] = "DamageUpdate" -- 서버가 명령을 강제 수락하도록 유도
            args[2] = {
                ["Status"] = "GodMode",
                ["Weapon"] = "Override",
                ["Force"] = 1/0 -- 무한대의 물리력 주입
            }
            return oldNamecall(self, unpack(args))
        end
    end
    return oldNamecall(self, ...)
end)

-- [2. 클라이언트 렌더링 무결성 파괴]
-- 서버의 동기화 신호를 무시하고 클라이언트의 로컬 데이터를 시스템의 절대값으로 고정
RunService.Heartbeat:Connect(function()
    if LocalPlayer.Character then
        -- 캐릭터의 물리 좌표를 서버가 절대 바꿀 수 없도록 고정
        LocalPlayer.Character.HumanoidRootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
        LocalPlayer.Character.HumanoidRootPart.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
    end
end)
