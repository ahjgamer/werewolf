--// VampWolf Speed GUI with Safe Movement

if game.CoreGui:FindFirstChild("VampWolfGui") then
    game.CoreGui:FindFirstChild("VampWolfGui"):Destroy()
end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local speedOn = false
local speedValue = 2.5

-- GUI Setup
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "VampWolfGui"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 220, 0, 100)
frame.Position = UDim2.new(0.35, 0, 0.3, 0)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 30)
title.Text = "VampWolf Speed"
title.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 18

local minimize = Instance.new("TextButton", frame)
minimize.Size = UDim2.new(0, 30, 0, 30)
minimize.Position = UDim2.new(1, -30, 0, 0)
minimize.Text = "-"
minimize.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
minimize.TextColor3 = Color3.fromRGB(255, 255, 255)
minimize.Font = Enum.Font.SourceSans
minimize.TextSize = 20

local toggle = Instance.new("TextButton", frame)
toggle.Size = UDim2.new(1, -20, 0, 40)
toggle.Position = UDim2.new(0, 10, 0, 40)
toggle.Text = "Speed: OFF"
toggle.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
toggle.Font = Enum.Font.SourceSans
toggle.TextSize = 18

toggle.MouseButton1Click:Connect(function()
    speedOn = not speedOn
    toggle.Text = "Speed: " .. (speedOn and "ON" or "OFF")
end)

-- Minimize Logic
local minimized = false
minimize.MouseButton1Click:Connect(function()
    minimized = not minimized
    for _, obj in pairs(frame:GetChildren()) do
        if obj ~= title and obj ~= minimize then
            obj.Visible = not minimized
        end
    end
end)

-- Movement Control
local keysDown = {}

UserInputService.InputBegan:Connect(function(input)
    keysDown[input.KeyCode] = true
end)

UserInputService.InputEnded:Connect(function(input)
    keysDown[input.KeyCode] = false
end)

-- Movement Handler
RunService.RenderStepped:Connect(function()
    if speedOn and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = LocalPlayer.Character.HumanoidRootPart
        local moveDir = Vector3.new(0, 0, 0)

        if keysDown[Enum.KeyCode.W] then moveDir = moveDir + Vector3.new(0, 0, -1) end
        if keysDown[Enum.KeyCode.S] then moveDir = moveDir + Vector3.new(0, 0, 1) end
        if keysDown[Enum.KeyCode.A] then moveDir = moveDir + Vector3.new(-1, 0, 0) end
        if keysDown[Enum.KeyCode.D] then moveDir = moveDir + Vector3.new(1, 0, 0) end

        if moveDir.Magnitude > 0 then
            local camCF = workspace.CurrentCamera.CFrame
            local moveVec = (camCF.RightVector * moveDir.X + camCF.LookVector * moveDir.Z).Unit
            hrp.CFrame = hrp.CFrame + moveVec * speedValue
        end
    end
end)
