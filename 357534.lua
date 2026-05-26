local Players = game:GetService("Players")
local version = require(game:GetService("ReplicatedStorage").Code.assets.gameVersion)

if version.default ~= "3.14.6" then
    local plr = Players.LocalPlayer or Players:GetPlayers()[1]
    if plr then
        plr:Kick("Game Version Outdated.\nPlease Report This to LunaHub Discord.\ndsc.gg/lunahubdsc")
    end
end

local OrionLib = loadstring(game:HttpGet("https://sts19735474.neocities.org/Fluxus.Orion"))()
local Window = OrionLib:MakeWindow({
    Name = "Luna Scripts ・ dsc.gg/lunahubdsc",
    HidePremium = false,
    SaveConfig = true,
    IntroEnabled = true,
    IntroText = "Ready To Use Luna?\nLunaHub Is Loading...",
    IntroIcon = "rbxassetid://79390235538362",
})


-- ==================== MAIN TAB ====================
local MainTab = Window:MakeTab({
    Name = "Main",
    Icon = "rbxassetid://117875071229221",
    PremiumOnly = false
})


MainTab:AddButton({
    Name = "Join Discord",
    Callback = function()
        setclipboard("dsc.gg/lunahubdsc")
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Discord Copied!",
            Text = "Succesfully",
            Duration = 3
        })
    end
})

MainTab:AddSection({
    Name = "Luna Updates"
})

MainTab:AddParagraph("Teleport Tab","Added Nearest Vending Machine")
MainTab:AddParagraph("Load Amination","The Load Amination. Is Just Like Cleaner and Better.")
MainTab:AddParagraph("AutoFarm Tab","Added a CoolDown For AutoFarm Tab. Like Safet For None AntiCheat Kick.")

MainTab:AddSection({
    Name = "Luna Version"
})

MainTab:AddParagraph("Luna Version","V3.4 Luna Last Version.")

-- ==================== AIMBOT TAB ====================
local AimbotTab = Window:MakeTab({
    Name = "Aimbot",
    Icon = "rbxassetid://10734977012",
    PremiumOnly = false
})


-- ==================== GUN MODS TAB ====================
local GunModsTab = Window:MakeTab({
    Name = "Gun Mods",
    Icon = "rbxassetid://137176652595915",
    PremiumOnly = false
})

-- ==================== CAR MODS TAB ====================
local CarModsTab = Window:MakeTab({
    Name = "Car Mods",
    Icon = "rbxassetid://10709789810",
    PremiumOnly = false
})

-- ==================== ESP TAB ====================
local EspTab = Window:MakeTab({
    Name = "Esp",
    Icon = "rbxassetid://140499484856973",
    PremiumOnly = false
})

-- ==================== TELEPORT TAB ====================
local TeleportTab = Window:MakeTab({
    Name = "Teleport",
    Icon = "rbxassetid://10734886004",
    PremiumOnly = false
})

-- ==================== GRAPHICS TAB ====================
local GraphicTab = Window:MakeTab({
    Name = "Graphics",
    Icon = "rbxassetid://125373696632586",
    PremiumOnly = false
})

-- ==================== POLICE TAB ====================
local PoliceTab = Window:MakeTab({
    Name = "Police",
    Icon = "rbxassetid://73598603304502",
    PremiumOnly = false
})

-- ==================== AUTO FARM TAB ====================
local AutoFarmTab = Window:MakeTab({
    Name = "Auto Farm",
    Icon = "rbxassetid://10747364031",
    PremiumOnly = false
})

-- ==================== MISC TAB ====================
local MiscTab = Window:MakeTab({
    Name = "Misc",
    Icon = "rbxassetid://10734950309",
    PremiumOnly = false
})

-- ==================== VARIABLES & SERVICES ====================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Lighting = game:GetService("Lighting")
local LocalPlayer = Players.LocalPlayer
local VehiclesFolder = workspace:FindFirstChild("Vehicles") or workspace:WaitForChild("Vehicles")
local Camera = workspace.CurrentCamera

local function Notify(text, duration)
    duration = duration or 3
    if OrionLib then
        OrionLib:MakeNotification({
            Title = "Luna",
            Content = text,
            Duration = duration
        })
    end
end

-- ==================== GRAPHICS FUNKTIONEN ====================

-- Fullbright
local LightingSettings = {
	Ambient = Lighting.Ambient,
	OutdoorAmbient = Lighting.OutdoorAmbient,
	Brightness = Lighting.Brightness,
	ShadowSoftness = Lighting.ShadowSoftness,
	GlobalShadows = Lighting.GlobalShadows
}

local function enableFullbright()
	Lighting.Ambient = Color3.fromRGB(255, 255, 255)
	Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
	Lighting.Brightness = 2
	Lighting.ShadowSoftness = 0
	Lighting.GlobalShadows = false
end

local function disableFullbright()
	Lighting.Ambient = LightingSettings.Ambient
	Lighting.OutdoorAmbient = LightingSettings.OutdoorAmbient
	Lighting.Brightness = LightingSettings.Brightness
	Lighting.ShadowSoftness = LightingSettings.ShadowSoftness
	Lighting.GlobalShadows = LightingSettings.GlobalShadows
end

-- Remove Atmosphere / Sky
local originalSky = Lighting:FindFirstChildOfClass("Sky")

local function removeSky()
    local sky = Lighting:FindFirstChildOfClass("Sky")
    if sky then
        sky:Destroy()
    end
end

local function restoreSky()
    if originalSky and not Lighting:FindFirstChildOfClass("Sky") then
        local newSky = originalSky:Clone()
        newSky.Parent = Lighting
    end
end

-- X-Ray
local xrayEnabled = false
local xrayCache = {}

local function toggleXray(val)
    xrayEnabled = val
    if val then
        for _, part in pairs(workspace:GetDescendants()) do
            if part:IsA("BasePart") and not part:FindFirstAncestorWhichIsA("Model"):FindFirstChildOfClass("Humanoid") then
                if not xrayCache[part] then
                    xrayCache[part] = part.LocalTransparencyModifier
                end
                part.LocalTransparencyModifier = 0.5
            end
        end
    else
        for part, originalValue in pairs(xrayCache) do
            if part and part.Parent then
                part.LocalTransparencyModifier = originalValue
            end
        end
        xrayCache = {}
    end
end

-- Skybox Presets
local Sky = Lighting:FindFirstChildOfClass("Sky")

if not Sky then
	Sky = Instance.new("Sky")
	Sky.Parent = Lighting
end

local SkyPresets = {
	["Standard"] = {
		SkyboxBk = "rbxasset://textures/sky/sky512_bk.tex",
		SkyboxDn = "rbxasset://textures/sky/sky512_dn.tex",
		SkyboxFt = "rbxasset://textures/sky/sky512_ft.tex",
		SkyboxLf = "rbxasset://textures/sky/sky512_lf.tex",
		SkyboxRt = "rbxasset://textures/sky/sky512_rt.tex",
		SkyboxUp = "rbxasset://textures/sky/sky512_up.tex",
		SunTextureId = "rbxasset://sky/sun.jpg",
		MoonTextureId = "rbxasset://sky/moon.jpg"
	},
	["Galaxy"] = {
		SkyboxBk = "http://www.roblox.com/asset/?id=159454299",
		SkyboxDn = "http://www.roblox.com/asset/?id=159454296",
		SkyboxFt = "http://www.roblox.com/asset/?id=159454293",
		SkyboxLf = "http://www.roblox.com/asset/?id=159454286",
		SkyboxRt = "http://www.roblox.com/asset/?id=159454300",
		SkyboxUp = "http://www.roblox.com/asset/?id=159454288",
		SunTextureId = "rbxasset://sky/sun.jpg",
		MoonTextureId = "rbxasset://sky/moon.jpg"
	},
	["Space"] = {
		SkyboxBk = "http://www.roblox.com/asset/?id=166509999",
		SkyboxDn = "http://www.roblox.com/asset/?id=166510057",
		SkyboxFt = "http://www.roblox.com/asset/?id=166510116",
		SkyboxLf = "http://www.roblox.com/asset/?id=166510092",
		SkyboxRt = "http://www.roblox.com/asset/?id=166510131",
		SkyboxUp = "http://www.roblox.com/asset/?id=166510114",
		SunTextureId = "rbxasset://sky/sun.jpg",
		MoonTextureId = "rbxasset://sky/moon.jpg"
	},
	["Universe"] = {
		SkyboxBk = "rbxassetid://15983968922",
		SkyboxDn = "rbxassetid://15983966825",
		SkyboxFt = "rbxassetid://15983965025",
		SkyboxLf = "rbxassetid://15983967420",
		SkyboxRt = "rbxassetid://15983966246",
		SkyboxUp = "rbxassetid://15983964246",
		SunTextureId = "rbxasset://sky/sun.jpg",
		MoonTextureId = "rbxasset://sky/moon.jpg"
	},
	["Aesthetic"] = {
		SkyboxBk = "rbxassetid://600830446",
		SkyboxDn = "rbxassetid://600831635",
		SkyboxFt = "rbxassetid://600832720",
		SkyboxLf = "rbxassetid://600886090",
		SkyboxRt = "rbxassetid://600833862",
		SkyboxUp = "rbxassetid://600835177",
		SunTextureId = "rbxasset://sky/sun.jpg",
		MoonTextureId = "rbxasset://sky/moon.jpg"
	},
	["Pink"] = {
		SkyboxBk = "rbxassetid://12635309703",
		SkyboxDn = "rbxassetid://12635311686",
		SkyboxFt = "rbxassetid://12635312870",
		SkyboxLf = "rbxassetid://12635313718",
		SkyboxRt = "rbxassetid://12635315817",
		SkyboxUp = "rbxassetid://12635316856",
		SunTextureId = "rbxasset://sky/sun.jpg",
		MoonTextureId = "rbxassetid://1345054856"
	}
}

local function ApplySkybox(textures)
	for property, textureId in pairs(textures) do
		if Sky[property] then
			Sky[property] = textureId
		end
	end
end

-- ==================== GHOST MODE & SKINCHANGER ====================
local PlayersGhost = game:GetService("Players")
local RunServiceGhost = game:GetService("RunService")
local LocalPlayerGhost = PlayersGhost.LocalPlayer

local STATE = "normal"
local savedColors = {}
local ghostColor = Color3.fromRGB(0, 170, 255)
local rainbowEnabled = false

local function HSVToRGBGhost(hue)
	return Color3.fromHSV(hue % 1, 1, 1)
end

local function applyGhostColor(color)
	local character = LocalPlayerGhost.Character
	if not character then return end

	for _, part in pairs(character:GetDescendants()) do
		if part:IsA("BasePart") and part.Transparency < 1 then
			if not savedColors[part] then
				savedColors[part] = {
					Color = part.Color,
					Material = part.Material
				}
			end
			part.Material = Enum.Material.ForceField
			part.Color = color
		end
	end
end

local function restoreOriginalAppearance()
	local character = LocalPlayerGhost.Character
	if not character then return end

	for _, part in pairs(character:GetDescendants()) do
		if part:IsA("BasePart") and savedColors[part] then
			part.Material = savedColors[part].Material
			part.Color = savedColors[part].Color
		end
	end
	savedColors = {}
end

local function copySkinFromPlayer(player)
	if not player or not player.Character then
		return false
	end

	local targetCharacter = player.Character
	local localCharacter = LocalPlayerGhost.Character

	if not localCharacter then
		LocalPlayerGhost.CharacterAdded:Wait()
		localCharacter = LocalPlayerGhost.Character
		task.wait(1)
	end

	for _, oldItem in pairs(localCharacter:GetChildren()) do
		if oldItem:IsA("ShirtGraphic") or oldItem:IsA("Shirt") or oldItem:IsA("Pants") then
			oldItem:Destroy()
		end
	end

	for _, item in pairs(targetCharacter:GetChildren()) do
		if item:IsA("Shirt") then
			local clone = item:Clone()
			clone.Parent = localCharacter
		elseif item:IsA("Pants") then
			local clone = item:Clone()
			clone.Parent = localCharacter
		elseif item:IsA("ShirtGraphic") then
			local clone = item:Clone()
			clone.Parent = localCharacter
		end
	end

	local bodyParts = {
		"Head", "LeftFoot", "RightFoot", "LeftHand", "RightHand", 
		"LeftLowerArm", "RightLowerArm", "LeftLowerLeg", "RightLowerLeg",
		"LeftUpperArm", "RightUpperArm", "LeftUpperLeg", "RightUpperLeg",
		"UpperTorso", "LowerTorso"
	}

	for _, partName in pairs(bodyParts) do
		local targetPart = targetCharacter:FindFirstChild(partName)
		local localPart = localCharacter:FindFirstChild(partName)
		if targetPart and localPart then
			localPart.BrickColor = targetPart.BrickColor
			localPart.Material = targetPart.Material
		end
	end

	local targetHead = targetCharacter:FindFirstChild("Head")
	local localHead = localCharacter:FindFirstChild("Head")

	if targetHead and localHead then
		for _, face in pairs(localHead:GetChildren()) do
			if face:IsA("Decal") then
				face:Destroy()
			end
		end
		local targetFace = targetHead:FindFirstChildOfClass("Decal")
		if targetFace then
			local newFace = targetFace:Clone()
			newFace.Parent = localHead
		end
	end
	return true
end

local function copyRandomSkin()
	local otherPlayers = {}
	for _, player in pairs(PlayersGhost:GetPlayers()) do
		if player ~= LocalPlayerGhost and player.Character then
			table.insert(otherPlayers, player)
		end
	end
	if #otherPlayers == 0 then return false end
	local randomIndex = math.random(1, #otherPlayers)
	local randomPlayer = otherPlayers[randomIndex]
	return copySkinFromPlayer(randomPlayer)
end

local function updatePlayerDropdown()
	local playerOptions = {"Random Player"}
	for _, player in pairs(PlayersGhost:GetPlayers()) do
		if player ~= LocalPlayerGhost and player.Character then
			table.insert(playerOptions, player.Name)
		end
	end
	return playerOptions
end

-- ==================== GRAPHICS TAB UI ====================

GraphicTab:AddSection({ Name = "Graphics" })

GraphicTab:AddToggle({
	Name = "Fullbright",
	Default = false,
	Save = false,
	Flag = "Fullbright",
	Callback = function(value)
		if value then
			enableFullbright()
		else
			disableFullbright()
		end
	end
})

GraphicTab:AddToggle({
	Name = "Xray",
	Default = false,
	Callback = function(Value)
		toggleXray(Value)
	end
})

GraphicTab:AddToggle({
	Name = "Remove Atmosphere",
	Default = false,
	Callback = function(Value)
		if Value then
			removeSky()
		else
			restoreSky()
		end
	end    
})

GraphicTab:AddDropdown({
	Name = "Change Sky",
	Default = "Standard",
	Save = true,
	Flag = "Sky",
	Options = {"Standard", "Galaxy", "Space", "Universe", "Aesthetic", "Pink"},
	Callback = function(selected)
		ApplySkybox(SkyPresets[selected])
	end    
})

GraphicTab:AddSection({ Name = "Ghost Options" })

GraphicTab:AddToggle({
	Name = "Player Ghost",
	Default = false,
	Callback = function(enabled)
		STATE = enabled and "force" or "normal"
		if enabled then
			applyGhostColor(ghostColor)
		else
			restoreOriginalAppearance()
		end
	end
})

GraphicTab:AddColorpicker({
	Name = "Ghost Color",
	Default = ghostColor,
	Save = true,
	Flag = "GhostColor",
	Callback = function(value)
		ghostColor = value
		if STATE == "force" and not rainbowEnabled then
			applyGhostColor(ghostColor)
		end
	end
})

GraphicTab:AddToggle({
	Name = "Rainbow Color",
	Default = false,
	Callback = function(enabled)
		rainbowEnabled = enabled
	end
})

RunServiceGhost.RenderStepped:Connect(function()
	if STATE == "force" and rainbowEnabled then
		local hue = tick() % 5 / 5
		local rainbowColor = HSVToRGBGhost(hue)
		applyGhostColor(rainbowColor)
	end
end)

GraphicTab:AddSection({ Name = "Skin Changer" })

local dropdownSkin = GraphicTab:AddDropdown({
	Name = "Skinchanger",
	Default = "Choose a player",
	Options = updatePlayerDropdown(),
	Callback = function(value)
		if value == "Random Player" then
			copyRandomSkin()
		else
			local selectedPlayer = PlayersGhost:FindFirstChild(value)
			if selectedPlayer then
				copySkinFromPlayer(selectedPlayer)
			end
		end
	end    
})

PlayersGhost.PlayerAdded:Connect(function(player)
	task.wait(2)
	dropdownSkin:Refresh(updatePlayerDropdown(), true)
end)

PlayersGhost.PlayerRemoving:Connect(function(player)
	dropdownSkin:Refresh(updatePlayerDropdown(), true)
end)

-- ==================== POLICE FUNKTIONEN ====================

-- Radar Farm
local radarRemote = ReplicatedStorage:WaitForChild("GpP"):WaitForChild("6f5f6fc7-bcb9-46cd-92ca-8c7e2d06bc11")
_G.RadarFarmEnabled = false

function startRadarFarm()
    _G.RadarFarmEnabled = true
    while _G.RadarFarmEnabled do
        local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local hrp = char:FindFirstChild("HumanoidRootPart")
        local radarGun = char:FindFirstChild("Radar Gun")
        if radarGun and hrp then
            for _, vehicle in ipairs(VehiclesFolder:GetChildren()) do
                local seat = vehicle:FindFirstChild("DriveSeat")
                if seat and seat.Occupant then
                    local direction = (seat.Position - hrp.Position).Unit
                    pcall(function()
                        radarRemote:FireServer(radarGun, seat.Position, direction)
                    end)
                end
            end
        end
        task.wait(0.03)
    end
end

function stopRadarFarm()
    _G.RadarFarmEnabled = false
end


local vu = game:GetService("VirtualUser")
local antiAfkEnabled = false
local antiAfkConnection = nil

local function enableAntiAfk()
    if antiAfkConnection then antiAfkConnection:Disconnect() end
    antiAfkConnection = LocalPlayer.Idled:Connect(function()
        if antiAfkEnabled then
            vu:CaptureController()
            vu:ClickButton2(Vector2.new())
        end
    end)
end


local autotaserEnabled = false
local TaserRemote = ReplicatedStorage:WaitForChild("GpP"):WaitForChild("664bcd31-3ad5-470e-87db-ab2f85f6fa5c")

local function findNearestCriminal()
    local myChar = LocalPlayer.Character
    local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if not myHRP then return nil end

    local nearest, dist = nil, math.huge
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = plr.Character.HumanoidRootPart
            local isCrime = hrp:GetAttribute("IsWanted") or (plr.Team and tostring(plr.Team) == "Criminals")
            if isCrime then
                local d = (myHRP.Position - hrp.Position).Magnitude
                if d < dist and d < 18 then
                    dist = d
                    nearest = hrp
                end
            end
        end
    end
    return nearest
end

local function getPredictedPosition(hrp, predictionTime)
    return hrp.Position + hrp.Velocity * predictionTime
end

local function doTaser(targetHRP)
    local char = LocalPlayer.Character
    local taser = char and char:FindFirstChild("Taser")
    if taser and targetHRP then
        local predPos = getPredictedPosition(targetHRP, 0.16)
        local dir = (predPos - char.HumanoidRootPart.Position).Unit
        pcall(function()
            TaserRemote:FireServer(taser, predPos, dir)
        end)
    end
end

function autotaserLoop()
    while autotaserEnabled do
        local target = findNearestCriminal()
        if target then
            doTaser(target)
            task.wait(0.5)
        else
            task.wait(0.25)
        end
    end
end


local STOP_STICK_REMOTE = ReplicatedStorage:WaitForChild("GpP"):WaitForChild("88897716-05bb-403a-913b-d168ccd6cddf")
local STOP_STICK_NAME = "Stop Stick"
local CHECK_RADIUS = 38
local autostickEnabled = false
local lastThrowPositions = {}

local function getCrimeCarsInRange()
    local crimeCars = {}
    for _, vehicle in pairs(VehiclesFolder:GetChildren()) do
        local seat = vehicle:FindFirstChild("DriveSeat")
        if seat and seat.Occupant then
            local plr = Players:GetPlayerFromCharacter(seat.Occupant.Parent)
            if plr and plr ~= LocalPlayer and plr.Team and tostring(plr.Team) ~= "Police" then
                local char = LocalPlayer.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local dist = (hrp.Position - seat.Position).Magnitude
                    if dist < CHECK_RADIUS then
                        local posStr = tostring(math.floor(seat.Position.X))..":"..tostring(math.floor(seat.Position.Z))
                        if not lastThrowPositions[posStr] or tick() - lastThrowPositions[posStr] > 2 then
                            table.insert(crimeCars, seat.Position)
                            lastThrowPositions[posStr] = tick()
                        end
                    end
                end
            end
        end
    end
    return crimeCars
end

local function autoStopStickLoop()
    while autostickEnabled do
        local stick = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild(STOP_STICK_NAME)
        if stick then
            local cars = getCrimeCarsInRange()
            for _, pos in ipairs(cars) do
                pcall(function()
                    STOP_STICK_REMOTE:FireServer(stick, pos)
                end)
                task.wait(0.12)
            end
        end
        task.wait(0.3)
    end
end


local MAX_DISTANCE = 8
local isPressingE = false
local isCuffEnabled = false

local function hasHandcuffsTool()
    if not LocalPlayer.Character then return false end
    for _, obj in pairs(LocalPlayer.Character:GetChildren()) do
        if obj:IsA("Tool") and obj.Name == "Handcuffs" then
            return true
        end
    end
    return false
end

local function isWantedPlayer(player)
    return player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character.HumanoidRootPart:GetAttribute("IsWanted") == true
end

local function startPressingE()
    if isPressingE then return end
    isPressingE = true
    task.wait(0.1)
    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game)
end

local function stopPressingE()
    if not isPressingE then return end
    isPressingE = false
    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, game)
end

local function onHeartbeat()
    if not isCuffEnabled then return end
    if not hasHandcuffsTool() then
        stopPressingE()
        return
    end
    local character = LocalPlayer.Character
    if not character then
        stopPressingE()
        return
    end
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not rootPart then
        stopPressingE()
        return
    end
    local wantedPlayerInRange = false
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and isWantedPlayer(player) then
            local targetRoot = player.Character:FindFirstChild("HumanoidRootPart")
            if targetRoot then
                local distance = (rootPart.Position - targetRoot.Position).Magnitude
                if distance <= MAX_DISTANCE then
                    wantedPlayerInRange = true
                    break
                end
            end
        end
    end
    if wantedPlayerInRange then
        startPressingE()
    else
        stopPressingE()
    end
end

RunService.Heartbeat:Connect(onHeartbeat)

-- Radar Spots
local RadarSpots = {
    ["Spot 1"] = CFrame.new(-1146.704833984375, 5.472795486450195, 2804.306884765625),
    ["Spot 2"] = CFrame.new(-1489.0484619140625, 19.34849739074707, 2918.8291015625),
    ["Spot 3"] = CFrame.new(-1278.7364501953125, 4.973498821258545, 3186.53857421875),
    ["Spot 4"] = CFrame.new(-1212.2510986328125, -22.667192459106445, 3499.859375),
    ["Spot 5"] = CFrame.new(-1670.939208984375, 10.839118957519531, 3184.929931640625),
    ["Spot 6"] = CFrame.new(-775.876708984375, 32.62535858154297, 3593.62841796875),
}

-- Flight Speed für Teleport
_G.flightSpeed = 170
local minSpeed, maxSpeed = 170, 170
local fps = 100

RunService.RenderStepped:Connect(function(deltaTime)
    fps = math.floor(1 / deltaTime)
end)

local function getPing()
    local dataPing = game:GetService("Stats"):FindFirstChild("Network"):FindFirstChild("Ping")
    if dataPing then return dataPing:GetValue() end
    return 100
end

task.spawn(function()
    while true do
        local currentPing = getPing()
        local pingFactor = math.clamp(1 - (currentPing / 50), 0, 1)
        local fpsFactor = math.clamp(fps / 60, 0.5, 1.2)
        local adjustedSpeed = math.clamp(minSpeed * fpsFactor * pingFactor, minSpeed, maxSpeed)
        _G.flightSpeed = math.floor(adjustedSpeed)
        task.wait(1)
    end
end)

function frameTween(targetCFrame)
    local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end
    local vehicle = VehiclesFolder:FindFirstChild(LocalPlayer.Name)
    if not vehicle then return end
    local driveSeat = vehicle:FindFirstChild("DriveSeat")
    if not driveSeat or not driveSeat:IsA("Seat") then return end
    if not vehicle.PrimaryPart then
        local body = vehicle:FindFirstChild("Body")
        if body then
            local mass = body:FindFirstChild("Mass")
            if mass then
                vehicle.PrimaryPart = mass
            else return end
        else return end
    end
    driveSeat:Sit(humanoid)
    task.wait(0.1)
    local originalProps = {}
    for _, part in pairs(vehicle:GetDescendants()) do
        if part:IsA("BasePart") then
            originalProps[part] = {
                Velocity = part.Velocity,
                RotVelocity = part.RotVelocity,
                AssemblyLinearVelocity = part.AssemblyLinearVelocity,
                AssemblyAngularVelocity = part.AssemblyAngularVelocity
            }
            part.Velocity = Vector3.zero
            part.RotVelocity = Vector3.zero
            part.AssemblyLinearVelocity = Vector3.zero
            part.AssemblyAngularVelocity = Vector3.zero
        end
    end
    local function createTween(startCF, endCF)
        local distance = (endCF.Position - startCF.Position).Magnitude
        local duration = distance / _G.flightSpeed
        local cframe = Instance.new("CFrameValue")
        cframe.Value = startCF
        cframe.Changed:Connect(function()
            if vehicle.PrimaryPart then
                vehicle:SetPrimaryPartCFrame(cframe.Value)
                for _, part in pairs(vehicle:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.Velocity = Vector3.zero
                        part.RotVelocity = Vector3.zero
                        part.AssemblyLinearVelocity = Vector3.zero
                        part.AssemblyAngularVelocity = Vector3.zero
                    end
                end
            end
        end)
        local tween = TweenService:Create(cframe, TweenInfo.new(duration, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), {
            Value = endCF
        })
        return tween, cframe
    end
    local function smoothMove(startCF, endCF)
        local tween, cframe = createTween(startCF, endCF)
        tween:Play()
        tween.Completed:Wait()
        cframe:Destroy()
        if humanoid.SeatPart ~= driveSeat then
            driveSeat:Sit(humanoid)
            task.wait(0.1)
        end
    end
    local fixedY = 2.30769644
    local startCF = vehicle.PrimaryPart.CFrame
    local fixedStart = CFrame.new(Vector3.new(startCF.Position.X, fixedY, startCF.Position.Z), startCF.LookVector + Vector3.new(0, 0, 1))
    local fixedTarget = CFrame.new(Vector3.new(targetCFrame.Position.X, fixedY, targetCFrame.Position.Z), targetCFrame.LookVector + Vector3.new(0, 0, 1))
    smoothMove(fixedStart, fixedTarget)
    task.wait(0.2)
    if math.abs(targetCFrame.Position.Y - fixedY) > 0.1 then
        local finalTarget = CFrame.new(Vector3.new(targetCFrame.Position.X, targetCFrame.Position.Y, targetCFrame.Position.Z), targetCFrame.LookVector + Vector3.new(0, 0, 1))
        smoothMove(fixedTarget, finalTarget)
        task.wait(0.2)
    end
    for part, props in pairs(originalProps) do
        if part and part.Parent then
            part.Velocity = props.Velocity
            part.RotVelocity = props.RotVelocity
            part.AssemblyLinearVelocity = props.AssemblyLinearVelocity
            part.AssemblyAngularVelocity = props.AssemblyAngularVelocity
        end
    end
    vehicle:SetPrimaryPartCFrame(targetCFrame)
    driveSeat:Sit(humanoid)
end

-- ==================== CAR MODS ====================

-- Vehicle Features
local VehicleFeatures = {
    godMode = false,
    infiniteFuel = false,
    lastVehicle = nil,
    player = game:GetService("Players").LocalPlayer,
    
    getVehicle = function(self)
        if not self.lastVehicle or not self.lastVehicle.Parent then
            local vehiclesFolder = workspace:FindFirstChild("Vehicles")
            self.lastVehicle = vehiclesFolder and vehiclesFolder:FindFirstChild(self.player.Name)
        end
        return self.lastVehicle
    end,
    
    update = function(self)
        if not (self.godMode or self.infiniteFuel) then return end
        
        local vehicle = self:getVehicle()
        if not vehicle then return end
        
        vehicle:SetAttribute("IsOn", true)
        
        if self.godMode then
            vehicle:SetAttribute("currentHealth", 500)
        end
        
        if self.infiniteFuel then
            vehicle:SetAttribute("currentFuel", 99999)
        end
    end,
    
    reset = function(self)
        if self.lastVehicle then
            if not self.godMode then
                self.lastVehicle:SetAttribute("currentHealth", 100)
            end
            if not self.infiniteFuel then
                self.lastVehicle:SetAttribute("currentFuel", 100)
            end
        end
        
        if not self.godMode and not self.infiniteFuel then
            self.lastVehicle = nil
        end
    end
}

local lastUpdate = 0
getgenv().VehicleConnection = game:GetService("RunService").Heartbeat:Connect(function()
    if tick() - lastUpdate >= 0.1 then
        VehicleFeatures:update()
        lastUpdate = tick()
    end
end)

-- Car Fly Settings
local CarFlySettings = {
    Enabled = false,
    SafeFly = true,
    VehicleFling = false,
    Speed = 130,
    Keybind = "X"
}

local kmhToSpeed = 7.77
local flightSpeed = 130 * kmhToSpeed
local POSITION_LERP_ALPHA = 0.3
local ROTATION_LERP_ALPHA = 0.2
local lastCarPosition = nil
local lastCarLookVector = nil
local straightFlightStartTime = nil
local STRAIGHT_FLIGHT_DURATION = 1
local hasShiftedRight = falselocal SHIFT_DISTANCE = 10
local flingStartTime = 0
local FLING_DELAY = 0.6
local hasPerformedSingleExit = false
local singleExitCompleted = false
local singleExitTimerStarted = false
local safeFlyConnection = nil
local autoEnterConnection = nil
local lastForceEnterTime = 0
local FORCE_ENTER_COOLDOWN = 0.5

local function enterVehicle()
    if not CarFlySettings.SafeFly or not CarFlySettings.Enabled then return false end
    
    local vehicles = Workspace:FindFirstChild("Vehicles")
    if not vehicles then return end
    
    local vehicle = vehicles:FindFirstChild(LocalPlayer.Name)
    if vehicle and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        local seat = vehicle:FindFirstChild("DriveSeat")
        if seat then
            seat:Sit(LocalPlayer.Character.Humanoid)
            return true
        end
    end
    return false
end

local function performSingleExit()
    if singleExitCompleted or not CarFlySettings.SafeFly or not CarFlySettings.Enabled or CarFlySettings.VehicleFling then
        return
    end
    
    local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
    if hum and hum.SeatPart and hum.SeatPart.Name == "DriveSeat" then
        hasPerformedSingleExit = true
        hum.Sit = false
        hum:ChangeState(Enum.HumanoidStateType.Jumping)
        
        task.delay(0.5, function()
            if CarFlySettings.SafeFly and CarFlySettings.Enabled and not CarFlySettings.VehicleFling then
                enterVehicle()
                singleExitCompleted = true
            end
        end)
    end
end

local function startSafeFly()
    if safeFlyConnection then return end
    
    singleExitCompleted = false
    hasPerformedSingleExit = false
    singleExitTimerStarted = false
    
    safeFlyConnection = RunService.Heartbeat:Connect(function()
        if CarFlySettings.SafeFly and CarFlySettings.Enabled and not CarFlySettings.VehicleFling then
            local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
            local currentTime = tick()
            
            if hum then
                if not singleExitTimerStarted and not hasPerformedSingleExit then
                    singleExitTimerStarted = true
                    task.delay(3, performSingleExit)
                end
                
                if not hum.SeatPart or hum.SeatPart.Name ~= "DriveSeat" then
                    if (currentTime - lastForceEnterTime) > FORCE_ENTER_COOLDOWN then
                        lastForceEnterTime = currentTime
                        local success = enterVehicle()
                        if not success then
                            task.wait(0.1)
                            enterVehicle()
                        end
                    end
                end
            end
        end
    end)
end

local function stopSafeFly()
    if safeFlyConnection then
        safeFlyConnection:Disconnect()
        safeFlyConnection = nil
    end
    hasPerformedSingleExit = false
    singleExitCompleted = false
    singleExitTimerStarted = false
end

local function updateFlightState()
    if CarFlySettings.Enabled then
        startSafeFly()
    else
        stopSafeFly()
    end
end

local function turncaroff()
    local vehiclesFolder = Workspace:FindFirstChild("Vehicles")
    if vehiclesFolder then
        local playerVehicle = vehiclesFolder:FindFirstChild(LocalPlayer.Name)
        if playerVehicle and playerVehicle:IsA("Model") then
            playerVehicle:SetAttribute("IsOn", false)
            local humanoid = playerVehicle:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.MaxHealth = 500
                humanoid.Health = 500
            end
        end
    end
end

RunService.Heartbeat:Connect(function()
    if CarFlySettings.VehicleFling then
        local c = LocalPlayer.Character
        if c then
            local h = c:FindFirstChildOfClass("Humanoid")
            if h and h.SeatPart and h:GetState() == Enum.HumanoidStateType.Seated then
                local currentTime = tick()
                if (currentTime - flingStartTime) >= FLING_DELAY then
                    local hrp = c:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        for _, part in pairs(hrp:GetTouchingParts()) do
                            if part:IsA("BasePart") and part:IsDescendantOf(Workspace) and not part:IsDescendantOf(LocalPlayer) then
                                hrp.AssemblyLinearVelocity = -(part.Position - hrp.Position).Unit * 9999999
                                turncaroff()
                                break
                            end
                        end
                    end
                end
            end
        end
    end
end)

local function startAutoEnter()
    if autoEnterConnection then return end
    
    autoEnterConnection = RunService.Heartbeat:Connect(function()
        if CarFlySettings.SafeFly and CarFlySettings.Enabled then
            local c = LocalPlayer.Character
            if not c then return end
            
            local h = c:FindFirstChildOfClass("Humanoid")
            if not h then return end
            
            if not h.SeatPart or h.SeatPart.Name ~= "DriveSeat" then
                local vehicles = Workspace:FindFirstChild("Vehicles")
                local vehicle = vehicles and vehicles:FindFirstChild(LocalPlayer.Name)
                
                if not vehicle then
                    for _, m in ipairs(Workspace:GetDescendants()) do
                        if m:IsA("Model") and m.Name:lower():find(LocalPlayer.Name:lower()) then
                            vehicle = m
                            break
                        end
                    end
                end
                
                if vehicle then
                    local seat = vehicle:FindFirstChild("DriveSeat") or vehicle:FindFirstChildWhichIsA("VehicleSeat")
                    if seat then
                        local hrp = c:FindFirstChild("HumanoidRootPart")
                        if hrp then
                            hrp.CFrame = seat.CFrame + Vector3.new(0, 3, 0)
                        end
                        h.Sit = false
                        task.wait(0.0)
                        seat:Sit(h)
                        task.wait(0.0)
                        if not h.SeatPart then
                            seat:Sit(h)
                        end
                    end
                end
            end
        end
    end)
end

local function stopAutoEnter()
    if autoEnterConnection then
        autoEnterConnection:Disconnect()
        autoEnterConnection = nil
    end
end

RunService.RenderStepped:Connect(function()
    local character = LocalPlayer.Character
    if CarFlySettings.VehicleFling then CarFlySettings.Enabled = true end
    
    if CarFlySettings.Enabled and character then
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid and humanoid.SeatPart and humanoid.SeatPart.Name == "DriveSeat" then
            local seat = humanoid.SeatPart
            local vehicle = seat.Parent
            if not vehicle.PrimaryPart then vehicle.PrimaryPart = seat end
            local lookVector = Camera.CFrame.LookVector
            if not lastCarPosition then lastCarPosition = vehicle.PrimaryPart.Position end
            if not lastCarLookVector then lastCarLookVector = lookVector end
            
            local moveY = 0
            local moveZ = 0
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveZ = 1
            elseif UserInputService:IsKeyDown(Enum.KeyCode.S) then moveZ = -1 end
            if UserInputService:IsKeyDown(Enum.KeyCode.E) then moveY = 1
            elseif UserInputService:IsKeyDown(Enum.KeyCode.Q) then moveY = -1 end
            
            local isFlyingStraight = UserInputService:IsKeyDown(Enum.KeyCode.W)
                and not UserInputService:IsKeyDown(Enum.KeyCode.S)
                and not UserInputService:IsKeyDown(Enum.KeyCode.E)
                and not UserInputService:IsKeyDown(Enum.KeyCode.Q)
                and not UserInputService:IsKeyDown(Enum.KeyCode.A)
                and not UserInputService:IsKeyDown(Enum.KeyCode.D)
            
            local currentTime = tick()
            if isFlyingStraight then
                if not straightFlightStartTime then straightFlightStartTime = currentTime end
                if not hasShiftedRight and (currentTime - straightFlightStartTime) >= STRAIGHT_FLIGHT_DURATION then
                    local rightVector = lookVector:Cross(Vector3.new(0, 1, 0)).Unit
                    local shiftPosition = vehicle.PrimaryPart.Position + (rightVector * SHIFT_DISTANCE)
                    local shiftCFrame = CFrame.new(shiftPosition, shiftPosition + lookVector)
                    vehicle:SetPrimaryPartCFrame(shiftCFrame)
                    lastCarPosition = shiftPosition
                    hasShiftedRight = true
                end
            else
                straightFlightStartTime = nil
                hasShiftedRight = false
            end
            
            local speedMultiplier = flightSpeed / 100
            local targetPosition = vehicle.PrimaryPart.Position + (lookVector * moveZ * speedMultiplier) + (Vector3.new(0, 1, 0) * moveY * speedMultiplier)
            local newPosition = lastCarPosition:Lerp(targetPosition, POSITION_LERP_ALPHA)
            local smoothLookVector = lastCarLookVector:Lerp(lookVector, ROTATION_LERP_ALPHA)
            
            if moveZ ~= 0 or moveY ~= 0 then
                local targetCFrame = CFrame.new(newPosition, newPosition + smoothLookVector)
                vehicle:SetPrimaryPartCFrame(targetCFrame)
            else
                local targetCFrame = CFrame.new(vehicle.PrimaryPart.Position, vehicle.PrimaryPart.Position + smoothLookVector)
                vehicle:SetPrimaryPartCFrame(targetCFrame)
            end
            
            lastCarPosition = newPosition
            lastCarLookVector = smoothLookVector
            
            for _, part in pairs(vehicle:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.AssemblyLinearVelocity = Vector3.zero
                    part.AssemblyAngularVelocity = Vector3.zero
                    part.Velocity = Vector3.zero
                    part.RotVelocity = Vector3.zero
                end
            end
        else
            lastCarPosition = nil
            lastCarLookVector = nil
            straightFlightStartTime = nil
            hasShiftedRight = false
        end
    else
        lastCarPosition = nil
        lastCarLookVector = nil
        straightFlightStartTime = nil
        hasShiftedRight = false
    end
end)

-- Car Mods UI Elements
CarModsTab:AddToggle({
    Name = "Car Fly",
    Default = false,
    Callback = function(Value)
        if CarFlySettings.VehicleFling then
            CarFlySettings.Enabled = true
        else
            CarFlySettings.Enabled = Value
        end
        updateFlightState()
        if CarFlySettings.Enabled then
            startAutoEnter()
        else
            stopAutoEnter()
        end
    end
})

CarModsTab:AddToggle({
    Name = "Vehicle Fling",
    Default = false,
    Callback = function(Value)
        CarFlySettings.VehicleFling = Value
        if Value then
            CarFlySettings.Enabled = true
            flingStartTime = tick()
            updateFlightState()
            startAutoEnter()
        else
            stopAutoEnter()
        end
    end
})

CarModsTab:AddBind({
    Name = "Car Fly Keybind",
    Default = Enum.KeyCode.X,
    Hold = false,
    Callback = function()
        if not CarFlySettings.VehicleFling then
            CarFlySettings.Enabled = not CarFlySettings.Enabled
            updateFlightState()
            if CarFlySettings.Enabled then
                startAutoEnter()
            else
                stopAutoEnter()
            end
        end
    end    
})

CarModsTab:AddSlider({
    Name = "Car Fly Speed",
    Min = 10,
    Max = 190,
    Default = 130,
    Color = Color3.fromRGB(255, 255, 255),
    Increment = 1,
    ValueName = "km/h",
    Callback = function(Value)
        CarFlySettings.Speed = Value
        flightSpeed = Value * kmhToSpeed
    end    
})

Players.LocalPlayer.CharacterAdded:Connect(function(character)
    CarFlySettings.Enabled = false
    lastCarPosition = nil
    lastCarLookVector = nil
    hasPerformedSingleExit = false
    singleExitCompleted = false
    singleExitTimerStarted = false
    
    task.wait(1)
    updateFlightState()
    stopAutoEnter()
    
    if CarFlySettings.SafeFly and CarFlySettings.Enabled then
        startAutoEnter()
    end
end)

CarModsTab:AddSection({
    Name = "Vehicle Mods"
})

CarModsTab:AddToggle({
    Name = "Vehicle Godmode",
    Default = false,
    Callback = function(Value)
        VehicleFeatures.godMode = Value
        if Value then
            task.spawn(function()
                while VehicleFeatures.godMode do
                    pcall(function()
                        local vehiclesFolder = workspace:FindFirstChild("Vehicles")
                        if vehiclesFolder then
                            local playerVehicle = vehiclesFolder:FindFirstChild(LocalPlayer.Name)
                            if playerVehicle and playerVehicle:IsA("Model") then
                                playerVehicle:SetAttribute("IsOn", true)
                                playerVehicle:SetAttribute("currentHealth", 1000)
                                
                                local humanoid = playerVehicle:FindFirstChildOfClass("Humanoid")
                                if humanoid then
                                    humanoid.MaxHealth = 1000
                                    humanoid.Health = 1000
                                end
                            end
                        end
                    end)
                    task.wait(2)
                end
            end)
        end
    end
})




CarModsTab:AddSection({
    Name = "Special Mods"
})

CarModsTab:AddToggle({
    Name = "Infinite Fuel",
    Default = false,
    Callback = function(Value)
        VehicleFeatures.infiniteFuel = Value
    end
})

CarModsTab:AddTextbox({
    Name = "Numberplate Text",
    Default = "Luna",
    TextDisappear = false,
    Callback = function(txt)
        local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        for _, part in ipairs(workspace:GetDescendants()) do
            if part:IsA("SurfaceGui") and part.Parent:IsA("BasePart") then
                local dist = root and (part.Parent.Position - root.Position).Magnitude
                if dist and dist < 15 then
                    local label = part:FindFirstChildWhichIsA("TextLabel")
                        if label then label.Text = txt end
                end
            end
        end
    end
})

local vehicleSoundOptions = {
   "Default",
   "v10", 
   "v8",
   "Evomr",
   "7 ExhL"
}

local vehicleSoundIds = {
   ["v10"] = "rbxassetid://92387486484055",
   ["v8"] = "rbxassetid://91912342333180", 
   ["Evomr"] = "rbxassetid://72327468507163",
   ["7 ExhL"] = "rbxassetid://75247492673971"
}

local originalVehicleSounds = {}

local function initializeVehicleSounds()
   for _, sound in pairs(game:GetDescendants()) do
       if sound:IsA("Sound") then
           local currentId = sound.SoundId
           if currentId == "rbxassetid://358130654" or currentId == "rbxassetid://358130655" then
               originalVehicleSounds[sound] = currentId
           end
       end
   end
end

local function changeVehicleSounds(selectedSound)
   local newSoundId = vehicleSoundIds[selectedSound]

   for sound, originalId in pairs(originalVehicleSounds) do
       if sound and sound.Parent then
           if selectedSound == "Default" then
               sound.SoundId = originalId
           else
               sound.SoundId = newSoundId
           end
       end
   end
end

initializeVehicleSounds()

CarModsTab:AddDropdown({
    Name = "Vehicle Sound",
    Default = "Default",
    Options = vehicleSoundOptions,
    Callback = function(Option)
        changeVehicleSounds(Option)
    end    
})

CarModsTab:AddSection({
    Name = "Tuning Garage Mods"
})

CarModsTab:AddSlider({
    Name = "Armor Level",
    Min = 0,
    Max = 6,
    Default = 0,
    Color = Color3.fromRGB(255, 255, 255),
    Increment = 1,
    Callback = function(Value)
        local vehiclesFolder = workspace:FindFirstChild("Vehicles")
        if vehiclesFolder then
            local playerVehicle = vehiclesFolder:FindFirstChild(LocalPlayer.Name)
            if playerVehicle and playerVehicle:IsA("Model") then
                playerVehicle:SetAttribute("armorLevel", Value)
            end
        end
    end    
})

CarModsTab:AddSlider({
    Name = "Brakes Level",
    Min = 0,
    Max = 6,
    Default = 0,
    Color = Color3.fromRGB(255, 255, 255),
    Increment = 1,
    Callback = function(Value)
        local vehiclesFolder = workspace:FindFirstChild("Vehicles")
        if vehiclesFolder then
            local playerVehicle = vehiclesFolder:FindFirstChild(LocalPlayer.Name)
            if playerVehicle and playerVehicle:IsA("Model") then
                playerVehicle:SetAttribute("brakesLevel", Value)
            end
        end
    end    
})

CarModsTab:AddSlider({
    Name = "Engine Level",
    Min = 0,
    Max = 6,
    Default = 0,
    Color = Color3.fromRGB(255, 255, 255),
    Increment = 1,
    Callback = function(Value)
        local vehiclesFolder = workspace:FindFirstChild("Vehicles")
        if vehiclesFolder then
            local playerVehicle = vehiclesFolder:FindFirstChild(LocalPlayer.Name)
            if playerVehicle and playerVehicle:IsA("Model") then
                playerVehicle:SetAttribute("engineLevel", Value)
            end
        end
    end    
})

-- ==================== GUN MODS ====================
local plr = Players.LocalPlayer
local running = false
local recoilConnection = nil
local aimFovConnection = nil
local aimFovValue = 40

GunModsTab:AddToggle({
    Name = "Fast Bullet",
    Default = false,
    Callback = function(Value)
        running = Value

        if running then
            task.spawn(function()
                while running do
                    local Tool = plr.Character and plr.Character:FindFirstChildOfClass("Tool")
                    if Tool then
                        Tool:SetAttribute("ShootDelay", 0)
                        Tool:SetAttribute("Automatic", true)
                    end
                    task.wait(0.1)
                end
            end)
        end
    end
})


GunModsTab:AddToggle({
    Name = "No Recoil",
    Default = false,
    Callback = function(enabled)
        if enabled then
            recoilConnection = game:GetService("RunService").Heartbeat:Connect(function()
                local tool = plr.Character and plr.Character:FindFirstChildOfClass("Tool")
                if tool then
                    tool:SetAttribute("Recoil", 0)
                    tool:SetAttribute("Instability", 0)
                end
            end)
        else
            if recoilConnection then
                recoilConnection:Disconnect()
                recoilConnection = nil
            end
        end
    end
})

GunModsTab:AddSection({
    Name = "Shoot Sounds"
})

local soundOptions = {
    "Default",
    "Ak47", 
    "M1911",
    "Glock",
    "MP40",
    "P90",
    "Pixel",
    "Undertale"
}

local soundIds = {
    ["Ak47"] = "rbxassetid://5910000043",
    ["M1911"] = "rbxassetid://1136243671", 
    ["Glock"] = "rbxassetid://6581933860",
    ["MP40"] = "rbxassetid://103807799095792",
    ["P90"] = "rbxassetid://87534588983395",
    ["Pixel"] = "rbxassetid://7380537613",
    ["Undertale"] = "rbxassetid://438149153"
}

local originalSounds = {}
local soundObjects = {}

local function initializeSounds()
    for _, sound in pairs(game:GetDescendants()) do
        if sound:IsA("Sound") then
            local currentId = sound.SoundId
            if currentId == "rbxassetid://801226154" or currentId == "rbxassetid://801217802" then
                originalSounds[sound] = currentId
                soundObjects[sound] = true
            end
        end
    end
end

local function changeSounds(selectedSound)
    local newSoundId = soundIds[selectedSound]

    for sound, originalId in pairs(originalSounds) do
        if sound and sound.Parent then
            if selectedSound == "Default" then
                sound.SoundId = originalId
            else
                sound.SoundId = newSoundId
            end
        end
    end
end

initializeSounds()

GunModsTab:AddDropdown({
    Name = "Shoot Sound",
    Default = "Default",
    Options = soundOptions,
    Callback = function(Option)
        changeSounds(Option)
    end    
})

GunModsTab:AddSection({
    Name = "Crosshair Settings"
})

local CrosshairSize = 25
local connections = {}

local function updateCrosshair(tool)
    if tool then
        tool:SetAttribute("CrosshairSize", CrosshairSize)
    end
end

local function setupToolListeners()
    for _, connection in pairs(connections) do
        connection:Disconnect()
    end
    connections = {}

    plr.CharacterAdded:Connect(function(character)
        connections.toolAdded = character.ChildAdded:Connect(function(child)
            if child:IsA("Tool") then
                updateCrosshair(child)
            end
        end)

        for _, tool in pairs(character:GetChildren()) do
            if tool:IsA("Tool") then
                updateCrosshair(tool)
            end
        end
    end)

    if plr.Character then
        for _, tool in pairs(plr.Character:GetChildren()) do
            if tool:IsA("Tool") then
                updateCrosshair(tool)
            end
        end

        connections.toolAdded = plr.Character.ChildAdded:Connect(function(child)
            if child:IsA("Tool") then
                updateCrosshair(child)
            end
        end)
    end
end

GunModsTab:AddSlider({
    Name = "Crosshair Size",
    Min = 0,
    Max = 25,
    Default = 25,
    Color = Color3.fromRGB(255, 255, 255),
    Increment = 1,
    Callback = function(Value)
        CrosshairSize = Value

        if plr and plr.Character then
            for _, tool in pairs(plr.Character:GetChildren()) do
                if tool:IsA("Tool") then
                    updateCrosshair(tool)
                end
            end
        end
    end    
})

setupToolListeners()

game:GetService("Players").LocalPlayer.CharacterAdded:Connect(function()
    task.wait(1)
    setupToolListeners()
end)

GunModsTab:AddSlider({
    Name = "Aim FOV",
    Min = 30,
    Max = 120,
    Default = 40,
    Color = Color3.fromRGB(255, 255, 255),
    Increment = 1,
    Callback = function(value)
        aimFovValue = value
    end    
})

aimFovConnection = game:GetService("RunService").Heartbeat:Connect(function()
    local tool = plr.Character and plr.Character:FindFirstChildOfClass("Tool")
    if tool then
        tool:SetAttribute("AimFieldOfView", aimFovValue)
    end
end)

-- ==================== AIMBOT ====================
local aimbotEnabled = false
local fovCircleEnabled = true
local AimFOV = 150
local fovColor = Color3.fromRGB(255, 0, 0)
local lockPart = "Head"
local predictToggle = true
local predictionFactor = 0.165
local smoothing = 0.5
local maxTargetDistance = 1000

local FOVring = Drawing.new("Circle")
FOVring.Visible = false 
FOVring.Thickness = 1
FOVring.Radius = AimFOV
FOVring.Transparency = 1
FOVring.Color = fovColor
FOVring.Position = Camera.ViewportSize / 2

AimbotTab:AddToggle({
    Name = "Aimbot",
    Default = false,
    Callback = function(value)
        aimbotEnabled = value
        FOVring.Visible = value and fovCircleEnabled
    end    
})

AimbotTab:AddBind({
    Name = "Aimbot Keybind",
    Default = Enum.KeyCode.V, 
    Hold = false,
    Callback = function()
        aimbotEnabled = not aimbotEnabled 
        FOVring.Visible = aimbotEnabled and fovCircleEnabled
    end    
})

AimbotTab:AddDropdown({
    Name = "Target Part",
    Default = "Head",  
    Options = {"Head", "HumanoidRootPart", "UpperTorso"},  
    Callback = function(value)
        lockPart = value
    end
})

AimbotTab:AddToggle({
    Name = "Prediction",
    Default = true,
    Callback = function(value)
        predictToggle = value
    end    
})

AimbotTab:AddSlider({
    Name = "Smoothness",
    Min = 1,
    Max = 20,
    Default = 10,
    Increment = 1,
    Color = Color3.fromRGB(0, 170, 255),
    ValueName = "",
    Callback = function(value)
        smoothing = value / 20
    end
})

AimbotTab:AddSlider({
    Name = "FOV Size",
    Min = 50,
    Max = 500,
    Default = 150,
    Increment = 10,
    Color = Color3.fromRGB(0, 170, 255),
    ValueName = "px",
    Callback = function(value)
        AimFOV = value
        FOVring.Radius = value
    end
})

AimbotTab:AddToggle({
    Name = "Show FOV Circle",
    Default = true,
    Callback = function(value)
        fovCircleEnabled = value
        FOVring.Visible = value and aimbotEnabled
    end
})

AimbotTab:AddColorpicker({
    Name = "FOV Color",
    Default = Color3.fromRGB(255, 0, 0),
    Callback = function(value)
        fovColor = value
        FOVring.Color = value
    end
})

AimbotTab:AddSlider({
    Name = "Max Distance",
    Min = 100,
    Max = 5000,
    Default = 1000,
    Increment = 50,
    Color = Color3.fromRGB(0, 170, 255),
    ValueName = "studs",
    Callback = function(value)
        maxTargetDistance = value
    end
})

AimbotTab:AddSlider({
    Name = "Prediction Factor",
    Min = 0.05,
    Max = 0.5,
    Default = 0.165,
    Increment = 0.005,
    Color = Color3.fromRGB(0, 170, 255),
    ValueName = "",
    Callback = function(value)
        predictionFactor = value
    end
})

local function getClosestTarget()
    local target = nil
    local shortestDistance = math.huge
    local screenCenter = Camera.ViewportSize / 2
 
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild(lockPart) then
            local targetPart = v.Character[lockPart]
 
            local screenPoint, onScreen = Camera:WorldToViewportPoint(targetPart.Position)
 
            if onScreen then
                local distanceFromCenter = (Vector2.new(screenPoint.X, screenPoint.Y) - screenCenter).Magnitude
                local worldDistance = (Camera.CFrame.Position - targetPart.Position).Magnitude
 
                if distanceFromCenter <= AimFOV and worldDistance <= maxTargetDistance then
                    local rayParams = RaycastParams.new()
                    rayParams.FilterType = Enum.RaycastFilterType.Blacklist
                    rayParams.FilterDescendantsInstances = {LocalPlayer.Character, v.Character}
 
                    local rayResult = workspace:Raycast(
                        Camera.CFrame.Position,
                        (targetPart.Position - Camera.CFrame.Position).Unit * worldDistance,
                        rayParams
                    )
 
                    if not rayResult then
                        if distanceFromCenter < shortestDistance then
                            shortestDistance = distanceFromCenter
                            target = v
                        end
                    end
                end
            end
        end
    end
    return target
end

local function getPredictedPosition(target)
    if target and target.Character and target.Character:FindFirstChild(lockPart) then
        local targetPart = target.Character[lockPart]
        local velocity = targetPart.Velocity
        local position = targetPart.Position
 
        if predictToggle and velocity.Magnitude > 0.1 then
            return position + (velocity * predictionFactor)
        else
            return position
        end
    end
    return nil
end

RunService.RenderStepped:Connect(function()
    if fovCircleEnabled and aimbotEnabled then
        FOVring.Position = Camera.ViewportSize / 2
        FOVring.Visible = true
    else
        FOVring.Visible = false
    end
 
    if aimbotEnabled and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
        local currentTarget = getClosestTarget()
 
        if currentTarget and currentTarget.Character and currentTarget.Character:FindFirstChild(lockPart) then
            local targetPosition = getPredictedPosition(currentTarget)
 
            if targetPosition then
                local currentCamCF = Camera.CFrame
                local targetCamCF = CFrame.new(currentCamCF.Position, targetPosition)
                local newCamCF = currentCamCF:Lerp(targetCamCF, smoothing)
 
                Camera.CFrame = newCamCF
            end
        end
    end
end)

-- ==================== ESP ====================
local ESP = { 
    Enabled = false, 
    MaxDistance = 800, 
    ShowName = true, 
    ShowDistance = true, 
    ShowTeam = true,
    ShowWanted = true,
    ShowBox = true,
    ShowTracer = false,
    ShowHealthBar = true,
    EspColor = "Red"
}

local teamColors = { 
    ["ADAC"] = Color3.fromRGB(255,255,0), 
    ["Police"] = Color3.fromRGB(0,0,255), 
    ["FireDepartment"] = Color3.fromRGB(255,100,0), 
    ["BusCompany"] = Color3.fromRGB(0,200,255), 
    ["TruckCompany"] = Color3.fromRGB(0,255,0), 
    ["Citizen"] = Color3.fromRGB(255,255,255), 
    ["Prisoner"] = Color3.fromRGB(255,0,0) 
}

local espObjects = {}

local function newText()
    local t = Drawing.new("Text")
    t.Size = 14
    t.Center = true
    t.Outline = true
    t.OutlineColor = Color3.new(0,0,0)
    t.Font = 2
    t.Visible = false
    return t
end

local function newBox()
    local b = Drawing.new("Square")
    b.Thickness = 1
    b.Filled = false
    b.Transparency = 1
    b.Visible = false
    return b
end

local function newLine()
    local l = Drawing.new("Line")
    l.Thickness = 1
    l.Transparency = 0.5
    l.Visible = false
    return l
end

local function getTeamColor(p)
    if p.Team and teamColors[p.Team.Name] then
        return teamColors[p.Team.Name]
    end
    return Color3.fromRGB(255, 255, 255)
end

local function getHealthColor(h, m)
    local p = h / m
    if p > 0.6 then return Color3.fromRGB(0, 255, 0)
    elseif p > 0.3 then return Color3.fromRGB(255, 255, 0)
    else return Color3.fromRGB(255, 0, 0) end
end

local function isWanted(player)
    if not player.Character then return false end
    local hrp = player.Character:FindFirstChild("HumanoidRootPart")
    return hrp and hrp:GetAttribute("IsWanted") == true
end

local function getWantedColor()
    return Color3.fromRGB(255, 50, 0)
end

-- ESP UI
EspTab:AddSection({ Name = "ESP Settings" })

EspTab:AddToggle({ Name = "ESP Enabled", Default = false, Callback = function(v)
    ESP.Enabled = v
    if not v then
        for _, obj in pairs(espObjects) do
            if obj.name then obj.name.Visible = false end
            if obj.distance then obj.distance.Visible = false end
            if obj.wanted then obj.wanted.Visible = false end
            if obj.box then obj.box.Visible = false end
            if obj.tracer then obj.tracer.Visible = false end
            if obj.healthBar then obj.healthBar.Visible = false end
        end
    end
end })

EspTab:AddToggle({ Name = "Show Name", Default = true, Callback = function(v) ESP.ShowName = v end })
EspTab:AddToggle({ Name = "Show Distance", Default = true, Callback = function(v) ESP.ShowDistance = v end })
EspTab:AddToggle({ Name = "Show Team", Default = true, Callback = function(v) ESP.ShowTeam = v end })
EspTab:AddToggle({ Name = "Show WANTED", Default = true, Callback = function(v) ESP.ShowWanted = v end })
EspTab:AddToggle({ Name = "Show Box", Default = true, Callback = function(v) ESP.ShowBox = v end })
EspTab:AddToggle({ Name = "Show Tracer", Default = false, Callback = function(v) ESP.ShowTracer = v end })
EspTab:AddToggle({ Name = "Show Health Bar", Default = true, Callback = function(v) ESP.ShowHealthBar = v end })
EspTab:AddSlider({ Name = "Max Distance", Min = 50, Max = 2000, Default = 800, Increment = 50, Callback = function(v) ESP.MaxDistance = v end })


-- Spieler ESP initialisieren
for _, p in pairs(Players:GetPlayers()) do
    if p ~= LocalPlayer then
        espObjects[p] = { 
            name = newText(), 
            distance = newText(), 
            wanted = newText(),
            box = newBox(),
            tracer = newLine(),
            healthBar = newBox()
        }
    end
end

Players.PlayerAdded:Connect(function(p)
    if p ~= LocalPlayer then
        espObjects[p] = { 
            name = newText(), 
            distance = newText(), 
            wanted = newText(),
            box = newBox(),
            tracer = newLine(),
            healthBar = newBox()
        }
    end
end)

Players.PlayerRemoving:Connect(function(p)
    if espObjects[p] then
        if espObjects[p].name then espObjects[p].name:Remove() end
        if espObjects[p].distance then espObjects[p].distance:Remove() end
        if espObjects[p].wanted then espObjects[p].wanted:Remove() end
        if espObjects[p].box then espObjects[p].box:Remove() end
        if espObjects[p].tracer then espObjects[p].tracer:Remove() end
        if espObjects[p].healthBar then espObjects[p].healthBar:Remove() end
        espObjects[p] = nil
    end
end)

-- Haupt ESP Loop
RunService.RenderStepped:Connect(function()
    if not ESP.Enabled then return end
    
    local localChar = LocalPlayer.Character
    if not localChar then return end
    local localPos = localChar:FindFirstChild("HumanoidRootPart")
    if not localPos then return end
    
    for _, p in pairs(Players:GetPlayers()) do
        if p == LocalPlayer then continue end
        
        local char = p.Character
        if not char then
            if espObjects[p] then
                if espObjects[p].name then espObjects[p].name.Visible = false end
                if espObjects[p].distance then espObjects[p].distance.Visible = false end
                if espObjects[p].wanted then espObjects[p].wanted.Visible = false end
                if espObjects[p].box then espObjects[p].box.Visible = false end
                if espObjects[p].tracer then espObjects[p].tracer.Visible = false end
                if espObjects[p].healthBar then espObjects[p].healthBar.Visible = false end
            end
            continue
        end
        
        local hrp = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")
        local head = char:FindFirstChild("Head")
        
        if not hrp or not hum or hum.Health <= 0 then
            if espObjects[p] then
                if espObjects[p].name then espObjects[p].name.Visible = false end
                if espObjects[p].distance then espObjects[p].distance.Visible = false end
                if espObjects[p].wanted then espObjects[p].wanted.Visible = false end
                if espObjects[p].box then espObjects[p].box.Visible = false end
                if espObjects[p].tracer then espObjects[p].tracer.Visible = false end
                if espObjects[p].healthBar then espObjects[p].healthBar.Visible = false end
            end
            continue
        end
        
        local dist = (hrp.Position - localPos.Position).Magnitude
        if dist > ESP.MaxDistance then
            if espObjects[p] then
                if espObjects[p].name then espObjects[p].name.Visible = false end
                if espObjects[p].distance then espObjects[p].distance.Visible = false end
                if espObjects[p].wanted then espObjects[p].wanted.Visible = false end
                if espObjects[p].box then espObjects[p].box.Visible = false end
                if espObjects[p].tracer then espObjects[p].tracer.Visible = false end
                if espObjects[p].healthBar then espObjects[p].healthBar.Visible = false end
            end
            continue
        end
        
        local pos, onScreen = Camera:WorldToViewportPoint(head and head.Position or hrp.Position)
        if not onScreen then
            if espObjects[p] then
                if espObjects[p].name then espObjects[p].name.Visible = false end
                if espObjects[p].distance then espObjects[p].distance.Visible = false end
                if espObjects[p].wanted then espObjects[p].wanted.Visible = false end
                if espObjects[p].box then espObjects[p].box.Visible = false end
                if espObjects[p].tracer then espObjects[p].tracer.Visible = false end
                if espObjects[p].healthBar then espObjects[p].healthBar.Visible = false end
            end
            continue
        end
        
        local e = espObjects[p]
        if not e then
            espObjects[p] = { name = newText(), distance = newText(), wanted = newText(), box = newBox(), tracer = newLine(), healthBar = newBox() }
            e = espObjects[p]
        end
        
        local teamColor = getTeamColor(p)
        local wantedStatus = isWanted(p)
        local espColor = wantedStatus and getWantedColor() or (ESP.ShowTeam and teamColor or ESP.EspColor)
        local yOffset = -50
        
        -- WANTED Text
        if ESP.ShowWanted and wantedStatus then
            e.wanted.Text = "⚠️ WANTED ⚠️"
            e.wanted.Color = getWantedColor()
            e.wanted.Position = Vector2.new(pos.X, pos.Y + yOffset - 16)
            e.wanted.Visible = true
            yOffset = yOffset + 16
        else
            e.wanted.Visible = false
        end
        
        -- Name
        if ESP.ShowName then
            local name = p.Name
            if ESP.ShowTeam and p.Team then name = name .. " [" .. p.Team.Name .. "]" end
            e.name.Text = name
            e.name.Color = espColor
            e.name.Position = Vector2.new(pos.X, pos.Y + yOffset)
            e.name.Visible = true
            yOffset = yOffset + 16
        else
            e.name.Visible = false
        end
        
        -- Distance
        if ESP.ShowDistance then
            e.distance.Text = math.floor(dist) .. "m"
            e.distance.Color = Color3.fromRGB(200, 200, 200)
            e.distance.Position = Vector2.new(pos.X, pos.Y + yOffset)
            e.distance.Visible = true
            yOffset = yOffset + 16
        else
            e.distance.Visible = false
        end
        
        -- BOX ESP
        if ESP.ShowBox and head and hrp then
            local footPos, footVis = Camera:WorldToViewportPoint(hrp.Position - Vector3.new(0, 3, 0))
            if footVis then
                local height = math.abs(footPos.Y - pos.Y)
                local width = height * 0.5
                e.box.Position = Vector2.new(pos.X - width/2, pos.Y)
                e.box.Size = Vector2.new(width, height)
                e.box.Color = espColor
                e.box.Visible = true
            else
                e.box.Visible = false
            end
        else
            e.box.Visible = false
        end
        
        -- HEALTH BAR
        if ESP.ShowHealthBar and head and hrp then
            local footPos, footVis = Camera:WorldToViewportPoint(hrp.Position - Vector3.new(0, 3, 0))
            if footVis then
                local height = math.abs(footPos.Y - pos.Y)
                local healthPercent = hum.Health / hum.MaxHealth
                e.healthBar.Position = Vector2.new(pos.X - 25, pos.Y + height - (height * healthPercent))
                e.healthBar.Size = Vector2.new(3, height * healthPercent)
                e.healthBar.Color = getHealthColor(hum.Health, hum.MaxHealth)
                e.healthBar.Filled = true
                e.healthBar.Visible = true
            else
                e.healthBar.Visible = false
            end
        else
            e.healthBar.Visible = false
        end
        
        -- TRACER
        if ESP.ShowTracer then
            local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
            e.tracer.From = center
            e.tracer.To = Vector2.new(pos.X, pos.Y)
            e.tracer.Color = espColor
            e.tracer.Visible = true
        else
            e.tracer.Visible = false
        end
    end
end)
-- ==================== TELEPORT FUNCTIONS ====================

local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer

_G.flightSpeed = 190

function frameTween(targetCFrame)
	local character = player.Character or player.CharacterAdded:Wait()
	local humanoid = character:FindFirstChildOfClass("Humanoid")
	if not humanoid then return end

	local vehiclesFolder = workspace:FindFirstChild("Vehicles")
	if not vehiclesFolder then
		warn("Vehicles klasörü bulunamadı.")
		return
	end

	local vehicle = vehiclesFolder:FindFirstChild(player.Name)
	if not vehicle then
		warn("Oyuncuya ait araç bulunamadı.")
		return
	end

	local driveSeat = vehicle:FindFirstChild("DriveSeat")
	if not driveSeat or not driveSeat:IsA("Seat") then
		warn("DriveSeat bulunamadı veya uygun değil.")
		return
	end

	if not vehicle.PrimaryPart then
		local body = vehicle:FindFirstChild("Body")
		if body then
			local mass = body:FindFirstChild("Mass")
			if mass then
				vehicle.PrimaryPart = mass
			else
				warn("Body içinde 'Mass' bulunamadı.")
				return
			end
		else
			warn("Araç içinde 'Body' bulunamadı.")
			return
		end
	end

	driveSeat:Sit(humanoid)
	task.wait(0.1)

	local originalProps = {}
	for _, part in pairs(vehicle:GetDescendants()) do
		if part:IsA("BasePart") then
			originalProps[part] = {
				Velocity = part.Velocity,
				RotVelocity = part.RotVelocity,
				AssemblyLinearVelocity = part.AssemblyLinearVelocity,
				AssemblyAngularVelocity = part.AssemblyAngularVelocity
			}
			part.Velocity = Vector3.zero
			part.RotVelocity = Vector3.zero
			part.AssemblyLinearVelocity = Vector3.zero
			part.AssemblyAngularVelocity = Vector3.zero
		end
	end

	local function createTween(startCF, endCF)
		local distance = (endCF.Position - startCF.Position).Magnitude
		local duration = distance / _G.flightSpeed

		local cframe = Instance.new("CFrameValue")
		cframe.Value = startCF

		cframe.Changed:Connect(function()
			if vehicle.PrimaryPart then
				vehicle:SetPrimaryPartCFrame(cframe.Value)

				for _, part in pairs(vehicle:GetDescendants()) do
					if part:IsA("BasePart") then
						part.Velocity = Vector3.zero
						part.RotVelocity = Vector3.zero
						part.AssemblyLinearVelocity = Vector3.zero
						part.AssemblyAngularVelocity = Vector3.zero
					end
				end
			end
		end)

		local tween = TweenService:Create(cframe, TweenInfo.new(duration, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), {
			Value = endCF
		})

		return tween, cframe
	end

	local function smoothMove(startCF, endCF)
		local tween, cframe = createTween(startCF, endCF)
		tween:Play()
		tween.Completed:Wait()
		cframe:Destroy()

		if humanoid.SeatPart ~= driveSeat then
			driveSeat:Sit(humanoid)
			task.wait(0.1)
		end
	end

	local fixedY = 2.30769644

	local startCF = vehicle.PrimaryPart.CFrame
	local fixedStart = CFrame.new(Vector3.new(startCF.Position.X, fixedY, startCF.Position.Z), startCF.LookVector + Vector3.new(0, 0, 1))
	local fixedTarget = CFrame.new(Vector3.new(targetCFrame.Position.X, fixedY, targetCFrame.Position.Z), targetCFrame.LookVector + Vector3.new(0, 0, 1))

	smoothMove(fixedStart, fixedTarget)

	task.wait(0.2)

	if math.abs(targetCFrame.Position.Y - fixedY) > 0.1 then
		local finalTarget = CFrame.new(Vector3.new(targetCFrame.Position.X, targetCFrame.Position.Y, targetCFrame.Position.Z), targetCFrame.LookVector + Vector3.new(0, 0, 1))
		smoothMove(fixedTarget, finalTarget)
		task.wait(0.2)
	end

	for part, props in pairs(originalProps) do
		if part and part.Parent then
			part.Velocity = props.Velocity
			part.RotVelocity = props.RotVelocity
			part.AssemblyLinearVelocity = props.AssemblyLinearVelocity
			part.AssemblyAngularVelocity = props.AssemblyAngularVelocity
		end
	end

	vehicle:SetPrimaryPartCFrame(targetCFrame)
	driveSeat:Sit(humanoid)

end

-- Teleport zu Dealer Button
TeleportTab:AddButton({
    Name = "Teleport to Nearest Dealer",
    Callback = function()
        local character = player.Character or player.CharacterAdded:Wait()
        local vehicle = workspace.Vehicles:FindFirstChild(player.Name)
        if not vehicle then return end

        local dealers = workspace:FindFirstChild("Dealers")
        if not dealers then return end

        local closest, shortest = nil, math.huge
        for _, dealer in pairs(dealers:GetChildren()) do
            if dealer:FindFirstChild("Head") then
                local dist = (character.HumanoidRootPart.Position - dealer.Head.Position).Magnitude
                if dist < shortest then
                    shortest = dist
                    closest = dealer.Head
                end
            end
        end
        if not closest then return end

        frameTween(closest.CFrame + Vector3.new(0, 5, 0))
    end
})


TeleportTab:AddButton({
	Name = "Nearest Vending Machine",
	Callback = function()
		local Players = game:GetService("Players")
		local LocalPlayer = Players.LocalPlayer
		
		-- Prüfen ob Character existiert
		if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
			return
		end
		
		local function findNearestVendingMachine()
			local nearestPart = nil
			local closestDistance = math.huge
			
			for _, obj in pairs(workspace:GetDescendants()) do
				if obj:IsA("Model") and obj.Name == "Vending Machine" then
					for _, part in pairs(obj:GetChildren()) do
						if part:IsA("BasePart") and part.Name == "Light" then
							local success, lightColor = pcall(function()
								return part.Color
							end)
							
							if success and lightColor == Color3.fromRGB(73, 147, 0) then
								local distance = (LocalPlayer.Character.HumanoidRootPart.Position - part.Position).magnitude
								if distance < closestDistance then
									nearestPart = part
									closestDistance = distance
								end
							end
						end
					end
				end
			end
			return nearestPart
		end
		
		local vendingMachinePart = findNearestVendingMachine()
		if vendingMachinePart then
			local vehicle = workspace:FindFirstChild("Vehicles") and workspace.Vehicles:FindFirstChild(LocalPlayer.Name)
			if vehicle and vehicle:IsA("Model") then
				frameTween(vendingMachinePart.CFrame + Vector3.new(0, 5, 0))
			else
				LocalPlayer.Character.HumanoidRootPart.CFrame = vendingMachinePart.CFrame + Vector3.new(0, 3, 0)
			end
		end
	end
})

-- Normal Places Dropdown
TeleportTab:AddDropdown({
    Name = "Normal Places",
    Default = "1",
    Options = {"Prison Out", "Prison In","Police","Tuning Garage", "Hospital", "Dealership", "Fire Station", "Truck Company", "Bus Company"},
    Callback = function(Value)
        local locations = {
            ["Prison Out"] = CFrame.new(-615.5797729492188, 5.289504051208496, 2862.23681640625),
            ["Prison In"] = CFrame.new(-572.1055297851562, 6.382352352142334, 3061.3740234375),
            ["Police"] = CFrame.new(-1658.071899, 5.63, 2737.27),
            ["Tuning Garage"] = CFrame.new(-1438.654053, 5.63, 118.45),
            ["Fire Station"] = CFrame.new(-1025.360595703125, 4.500086784362793, 3899.155029296875),
            ["Parking Garage"] = CFrame.new(-1001.6951904296875, 10.850526809692383, 3655.860595703125),
            ["Truck Company"] = CFrame.new(704.4508666992188, 4.229461669921875, 1479.9267578125),
            ["Bus Company"] = CFrame.new(-1682.2969970703125, 8.779464721679688, -1273.07763671875),
            ["Hospital"] = CFrame.new(-278.833740234375, 7.7454142570495605, 1085.7965087890625),
            ["Dealership"] = CFrame.new(-1415.6986083984375, 4.552238464355469, 940.5262451171875),
        }

        local targetCFrame = locations[Value]
        if not targetCFrame then return end

        local vehicle = workspace:FindFirstChild("Vehicles") and workspace.Vehicles:FindFirstChild(player.Name)
        if not vehicle or not vehicle:IsA("Model") then return end

        frameTween(targetCFrame)
    end
})

-- Robbery Places Dropdown
TeleportTab:AddDropdown({
    Name = "Robbery Places",
    Default = "1",
    Options = {"Bank", "Jewellery", "Erwin Club", "Gas-N-Go Fuel", "Ares Fuel", "Tool Shop", "Farm Shop", "Osso Fuel", "Container Ship", "Clothing Store"},
    Callback = function(Value)
        local locations = {
            ["Bank"] = CFrame.new(-1183.296, 10.912, 3228.297),
            ["Jewellery"] = CFrame.new(-407.536, 21.950, 3516.854),
            ["Erwin Club"] = CFrame.new(-1856.962, 5.706, 2990.518),
            ["Gas-N-Go Fuel"] = CFrame.new(-1560.674, 3.944, 3813.656),
            ["Ares Fuel"] = CFrame.new(-824.447, 4.182, 1512.941),
            ["Tool Shop"] = CFrame.new(-767.815, 4.374, 663.494),
            ["Farm Shop"] = CFrame.new(-887.220, 5.831, -1150.356),
            ["Osso Fuel"] = CFrame.new(-27.464, 5.245, -749.413),
            ["Container Ship"] = CFrame.new(1191.836, 29.550, 2140.703),
            ["Clothing Store"] = CFrame.new(440.400, 5.520, -1438.111),
        }

        local targetCFrame = locations[Value]
        if not targetCFrame then return end

        local vehicle = workspace:FindFirstChild("Vehicles") and workspace.Vehicles:FindFirstChild(player.Name)
        if not vehicle or not vehicle:IsA("Model") then return end

        frameTween(targetCFrame)
    end
})

-- ==================== POLICE TAB UI ====================
PoliceTab:AddSection({ Name = "Radar Farm" })

PoliceTab:AddToggle({
    Name = "Radar Farm",
    Default = false,
    Callback = function(Value)
        _G.RadarFarmEnabled = Value
        if Value then
            spawn(startRadarFarm)
        else
            stopRadarFarm()
        end
    end
})

PoliceTab:AddToggle({
    Name = "Anti-AFK",
    Default = false,
    Callback = function(state)
        antiAfkEnabled = state
        if state then
            enableAntiAfk()
        else
            if antiAfkConnection then
                antiAfkConnection:Disconnect()
                antiAfkConnection = nil
            end
        end
    end
})

PoliceTab:AddSection({ Name = "Radar Farm Positions" })

PoliceTab:AddDropdown({
    Name = "Teleport to Spot",
    Options = {"Spot 1", "Spot 2", "Spot 3", "Spot 4", "Spot 5", "Spot 6"},
    Callback = function(Value)
        local cf = RadarSpots[Value]
        if cf then
            frameTween(cf)
        end
    end
})

PoliceTab:AddSection({ Name = "Police Options" })

PoliceTab:AddToggle({
    Name = "Auto Taser",
    Default = false,
    Callback = function(Value)
        autotaserEnabled = Value
        if Value then
            spawn(autotaserLoop)
        end
    end
})

PoliceTab:AddToggle({
    Name = "Auto StopStick",
    Default = false,
    Callback = function(Value)
        autostickEnabled = Value
        if Value then
            spawn(autoStopStickLoop)
        end
    end
})

PoliceTab:AddToggle({
    Name = "Auto Cuff",
    Default = false,
    Callback = function(Value)
        isCuffEnabled = Value
        if not isCuffEnabled then
            stopPressingE()
        end
    end
})

PoliceTab:AddSlider({
    Name = "Cuff Range",
    Min = 1,
    Max = 8,
    Default = 6,
    Increment = 1,
    Callback = function(Value)
        MAX_DISTANCE = Value
    end
})

-- ==================== AUTO FARM ====================
AutoFarmTab:AddSection({
    Name = "Auto Farm Features"
})

local busFarmToggle = false
local truckFarmToggle = false
local FARMheight = -10
local FARMspeed = 110
local FARMPos = nil
local FARMLastPos = nil
local FARMcooldown = false
local FARMcurrentTween = nil
local FARMstopFarm = false

-- COOLDOWN VARIABLEN
local cooldownActive = false
local COOLDOWN_TIME = 3

-- FUNKTION FÜR ORION COOLDOWN NACHRICHT
local function showCooldownMessage()
    OrionLib:MakeNotification({
        Name = "CoolDown",
        Content = COOLDOWN_TIME .. " Seconds End (Safet For None Anti Cheat Kick)",
        Time = 3
    })
end

AutoFarmTab:AddToggle({
    Name = "Autofarm Bus",
    Default = false,
    Callback = function(Value)
        busFarmToggle = Value
        if FARMLastPos then FARMLastPos = nil end
        if FARMcurrentTween then
            FARMcurrentTween:Cancel()
            FARMstopFarm = true
            task.wait(0.5)
            FARMstopFarm = false
        end
    end
})

AutoFarmTab:AddToggle({
    Name = "Autofarm Truck",
    Default = false,
    Callback = function(Value)
        truckFarmToggle = Value
        if FARMLastPos then FARMLastPos = nil end
        if FARMcurrentTween then
            FARMcurrentTween:Cancel()
            FARMstopFarm = true
            task.wait(0.5)
            FARMstopFarm = false
        end
    end
})

local function ensurePlayerInVehicleFarm()
    if LocalPlayer.Team == game:GetService("Teams").TruckCompany or LocalPlayer.Team == game:GetService("Teams").BusCompany then
        local vehicle = workspace.Vehicles:FindFirstChild(LocalPlayer.Name)
        if vehicle and LocalPlayer.Character then
            local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
            if humanoid and not humanoid.SeatPart then
                local driveSeat = vehicle:FindFirstChild("DriveSeat")
                if driveSeat then
                    driveSeat:Sit(humanoid)
                end
            end
        end
    end
end

local function partfind()
    for _, v in pairs(LocalPlayer.PlayerGui:GetDescendants()) do
        if v:IsA("BillboardGui") and v.Adornee then
            if v.Adornee.CFrame then
                return v.Adornee.CFrame
            end
        end
    end
    return nil
end

local function destination()
    local busStops = workspace:FindFirstChild("BusStops")
    if busStops then
        for _, v in pairs(busStops:GetDescendants()) do
            if v.Name == "SelectionBox" and v.Visible and v.Transparency ~= 1 then
                return v.Parent.CFrame
            end
        end
    end
    local deliveryDestinations = workspace:FindFirstChild("DeliveryDestinations")
    if deliveryDestinations then
        for _, v in pairs(deliveryDestinations:GetDescendants()) do
            if v.Name == "SelectionBox" and v.Visible and v.Transparency ~= 1 then
                return v.Parent.CFrame
            end
        end
    end
    return nil
end

local function tweenModel(model, targetCFrame, duration)
    if FARMcurrentTween then
        FARMcurrentTween:Cancel()
        FARMcurrentTween = nil
    end

    local info = TweenInfo.new(
        duration,
        Enum.EasingStyle.Linear,
        Enum.EasingDirection.InOut
    )

    local CFrameValue = Instance.new("CFrameValue")
    CFrameValue.Value = model:GetPrimaryPartCFrame()

    CFrameValue:GetPropertyChangedSignal("Value"):Connect(function()
        model:SetPrimaryPartCFrame(CFrameValue.Value)
        if model.PrimaryPart then
            model.PrimaryPart.AssemblyLinearVelocity = Vector3.zero
            model.PrimaryPart.AssemblyAngularVelocity = Vector3.zero
        end
    end)

    local tween = TweenService:Create(CFrameValue, info, { Value = targetCFrame })
    tween:Play()

    local tweenCompleted = false
    tween.Completed:Connect(function()
        CFrameValue:Destroy()
        tweenCompleted = true
    end)

    FARMcurrentTween = tween

    repeat task.wait(0.5) until tweenCompleted or FARMstopFarm

    return tweenCompleted
end

local function tweenFunction()
    local vehicle = workspace.Vehicles:FindFirstChild(LocalPlayer.Name)
    if not vehicle then
        FARMLastPos = nil
        return
    end
    if vehicle.PrimaryPart == nil then
        vehicle.PrimaryPart = vehicle:FindFirstChild("Mass", true)
    end
    if not vehicle.PrimaryPart then return end
    
    local _, size = vehicle:GetBoundingBox()

    if FARMPos then
        local currentPosition = vehicle.PrimaryPart.CFrame
        local downwardPosition = CFrame.new(currentPosition.Position.X, currentPosition.Position.Y + FARMheight, currentPosition.Position.Z)

        vehicle:SetPrimaryPartCFrame(downwardPosition)
        if vehicle.PrimaryPart then
            vehicle.PrimaryPart.AssemblyLinearVelocity = Vector3.zero
            vehicle.PrimaryPart.AssemblyAngularVelocity = Vector3.zero
        end

        if not FARMstopFarm then
            local adjustedPosition = FARMPos * CFrame.new(0, FARMheight, 0)
            if not tweenModel(vehicle, adjustedPosition, (adjustedPosition.Position - downwardPosition.Position).Magnitude / math.abs(FARMspeed)) then return end
        end

        if not FARMstopFarm then
            tweenModel(vehicle, (FARMPos * CFrame.new(0, size.Y / 2, 0)), math.abs(FARMheight) / (FARMspeed * 2))
            if vehicle.PrimaryPart then
                local slightForwardPosition = vehicle.PrimaryPart.CFrame * CFrame.new(0, 0, -5)
                vehicle:SetPrimaryPartCFrame(slightForwardPosition)
            end
        end
    else
        FARMLastPos = nil
    end
end

RunService.RenderStepped:Connect(function()
    local active = false
    if busFarmToggle and LocalPlayer.Team and LocalPlayer.Team.Name == "BusCompany" then
        active = true
    elseif truckFarmToggle and LocalPlayer.Team and LocalPlayer.Team.Name == "TruckCompany" then
        active = true
    end

    if active then
        ensurePlayerInVehicleFarm()
        FARMPos = destination() or partfind()
        
        -- COOLDOWN CHECK MIT 4.2 SEKUNDEN UND ORION NACHRICHT
        if not cooldownActive then
            if not workspace.Vehicles:FindFirstChild(LocalPlayer.Name) then
                cooldownActive = true
                showCooldownMessage()  -- ORION NACHRICHT MIT "CoolDown", "4.2 Sekunden", Image="timer"
                Notify("Please spawn the first vehicle.", 3)
                task.wait(COOLDOWN_TIME)
                cooldownActive = false
                return
            end
            
            cooldownActive = true
            showCooldownMessage()  -- ORION NACHRICHT MIT "CoolDown", "4.2 Sekunden", Image="timer"
            
            FARMPos = destination() or partfind()

            local significantChange = true
            if FARMPos and FARMLastPos then
                local distance = (FARMPos.Position - FARMLastPos.Position).Magnitude
                significantChange = distance > 1
            end

            if FARMPos and significantChange then
                if FARMcurrentTween then
                    FARMcurrentTween:Cancel()
                end
                FARMstopFarm = true
                task.wait(0.5)
                FARMstopFarm = false
                FARMLastPos = FARMPos
                tweenFunction()
            end

            task.wait(COOLDOWN_TIME)  -- 4.2 SEKUNDEN COOLDOWN
            cooldownActive = false
        end
    end
end)

AutoFarmTab:AddSlider({
    Name = "Farm Height",
    Min = -50,
    Max = 50,
    Default = 0,
    Color = Color3.fromRGB(255, 255, 255),
    Increment = 1,
    ValueName = "studs",
    Callback = function(Value)
        FARMheight = Value
    end    
})

AutoFarmTab:AddSlider({
    Name = "Farm Speed",
    Min = 50,
    Max = 300,
    Default = 100,
    Color = Color3.fromRGB(255, 255, 255),
    Increment = 10,
    ValueName = "speed",
    Callback = function(Value)
        FARMspeed = Value
    end    
})

AutoFarmTab:AddParagraph("How to use:", "1. Join Bus Company or Truck Company team\n2. Spawn your work vehicle\n3. Enable the appropriate autofarm toggle\n4. Start your work shift")

-- ==================== MISC ====================

MiscTab:AddSection({
    Name = "Movement"
})

local noclipEnabled = false
local noclipConnection = nil

local function noclipFunction()
    if noclipEnabled then
        local character = LocalPlayer.Character
        if character then
            for _, part in pairs(character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end
    end
end

MiscTab:AddToggle({
    Name = "Noclip",
    Default = false,
    Callback = function(v)
        noclipEnabled = v
        if v then
            if not noclipConnection then
                noclipConnection = RunService.Stepped:Connect(noclipFunction)
            end
        else
            if noclipConnection then
                noclipConnection:Disconnect()
                noclipConnection = nil
            end
            local character = LocalPlayer.Character
            if character then
                for _, part in pairs(character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = true
                    end
                end
            end
        end
    end
})

local speedHackEnabled = false
local speedHackStepSize = 0.1
local speedHackConnection = nil

MiscTab:AddToggle({
    Name = "Speed Hack",
    Default = false,
    Callback = function(Value)
        speedHackEnabled = Value
        if Value then
            if speedHackConnection then speedHackConnection:Disconnect() end
            speedHackConnection = RunService.Heartbeat:Connect(function()
                if speedHackEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                    local character = LocalPlayer.Character
                    local humanoid = character:FindFirstChild("Humanoid")
                    local direction = humanoid.MoveDirection
                    if direction.Magnitude > 0 then
                        character:SetPrimaryPartCFrame(character.PrimaryPart.CFrame + direction.Unit * speedHackStepSize)
                    end
                end
            end)
        else
            if speedHackConnection then
                speedHackConnection:Disconnect()
                speedHackConnection = nil
            end
        end
    end
})

MiscTab:AddBind({
    Name = "Speed Hack Keybind",
    Default = Enum.KeyCode.T,
    Hold = false,
    Callback = function()
        speedHackEnabled = not speedHackEnabled
        if speedHackEnabled then
            if speedHackConnection then speedHackConnection:Disconnect() end
            speedHackConnection = RunService.Heartbeat:Connect(function()
                if speedHackEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                    local character = LocalPlayer.Character
                    local humanoid = character:FindFirstChild("Humanoid")
                    local direction = humanoid.MoveDirection
                    if direction.Magnitude > 0 then
                        character:SetPrimaryPartCFrame(character.PrimaryPart.CFrame + direction.Unit * speedHackStepSize)
                    end
                end
            end)
        else
            if speedHackConnection then
                speedHackConnection:Disconnect()
                speedHackConnection = nil
            end
        end
    end    
})

MiscTab:AddSlider({
    Name = "Speed Hack Speed",
    Min = 0.1,
    Max = 0.9,
    Default = 0.1,
    Color = Color3.fromRGB(255, 255, 255),
    Increment = 0.05,
    ValueName = "Speed",
    Callback = function(Value)
        speedHackStepSize = Value
    end    
})

MiscTab:AddButton({
    Name = "Infinite Stamina",
    Callback = function()
        local Module = game:GetService("Players").LocalPlayer.PlayerScripts.Code.controllers.character.characterStaminaController
        local ClassModule = require(Module).CharacterStaminaController

        hookfunction(ClassModule.useStamina, function()
            return true
        end)
    end
})


MiscTab:AddSection({
    Name = "Safety"
})

local antiTaserEnabled = false
local antiTaserConnections = {}
local charAddedConnectionAnti = nil
local NORMAL_WALKSPEED = 20

local function disconnectAntiTaser()
    for _, conn in ipairs(antiTaserConnections) do
        pcall(function() conn:Disconnect() end)
    end
    antiTaserConnections = {}
end

local function setupAntiTaser(char)
    disconnectAntiTaser()
    if not char then return end

    local humanoid = char:FindFirstChildOfClass("Humanoid")
    local hrp = char:FindFirstChild("HumanoidRootPart")

    if not humanoid then return end

    table.insert(antiTaserConnections, humanoid.StateChanged:Connect(function(_, newState)
        if newState == Enum.HumanoidStateType.PlatformStanding or 
           newState == Enum.HumanoidStateType.Physics then
            pcall(function()
                humanoid.PlatformStand = false
                humanoid:ChangeState(Enum.HumanoidStateType.Running)
            end)
        end
    end))

    table.insert(antiTaserConnections, RunService.Heartbeat:Connect(function()
        if not humanoid.Parent then return end
        pcall(function()
            if humanoid.PlatformStand then
                humanoid.PlatformStand = false
            end
            if humanoid.WalkSpeed < NORMAL_WALKSPEED then
                humanoid.WalkSpeed = NORMAL_WALKSPEED
            end
            if hrp and hrp.Anchored then
                hrp.Anchored = false
            end
        end)
    end))
end

MiscTab:AddToggle({
    Name = "Anti-Taser",
    Default = false,
    Callback = function(Value)
        antiTaserEnabled = Value
        if Value then
            setupAntiTaser(LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait())

            if not charAddedConnectionAnti then
                charAddedConnectionAnti = LocalPlayer.CharacterAdded:Connect(function(newChar)
                    task.wait(0.5)
                    if antiTaserEnabled then
                        setupAntiTaser(newChar)
                    end
                end)
            end
        else
            disconnectAntiTaser()
            if charAddedConnectionAnti then
                charAddedConnectionAnti:Disconnect()
                charAddedConnectionAnti = nil
            end
        end
    end
})


local antiFallEnabled = false
local antiFallConnection = nil

MiscTab:AddToggle({
    Name = "Anti-Fall/Damage",
    Default = false,
    Callback = function(Value)
        antiFallEnabled = Value
        if Value and not antiFallConnection then
            antiFallConnection = RunService.RenderStepped:Connect(function()
                local character = LocalPlayer.Character
                if character then
                    local humanoid = character:FindFirstChild("Humanoid")
                    local rootPart = character:FindFirstChild("HumanoidRootPart")
                    if rootPart and humanoid then
                        if humanoid:GetState() == Enum.HumanoidStateType.Freefall then
                            local velocity = rootPart.Velocity
                            if velocity.Y < -20 then
                                rootPart.Velocity = Vector3.new(velocity.X, -20, velocity.Z)
                            end
                        end
 
                        if rootPart.Velocity.Y < -50 then
                            rootPart.Velocity = Vector3.new(rootPart.Velocity.X, -50, rootPart.Velocity.Z)
                        end
                    end
                end
            end)
        elseif not Value and antiFallConnection then
            antiFallConnection:Disconnect()
            antiFallConnection = nil
        end
    end
})



MiscTab:AddButton({
    Name = "Self Revive",
    Callback = function()
        local PlayersSR = game:GetService("Players")
        local TweenServiceSR = game:GetService("TweenService")
        local WorkspaceSR = game:GetService("Workspace")

        local LocalPlayerSR = PlayersSR.LocalPlayer

        local autoReviveEnabled = true
        local healthConnectionSR = nil
        local isHealing = false

        local function tweenTo(destination)
            local VehiclesFolderSR = WorkspaceSR:FindFirstChild("Vehicles")
            local car = VehiclesFolderSR and VehiclesFolderSR:FindFirstChild(LocalPlayerSR.Name)
            if not car then return false end

            car.PrimaryPart = car:FindFirstChild("DriveSeat", true) or car.PrimaryPart
            if car.DriveSeat and LocalPlayerSR.Character and LocalPlayerSR.Character:FindFirstChild("Humanoid") then
                pcall(function() car.DriveSeat:Sit(LocalPlayerSR.Character.Humanoid) end)
            end

            if typeof(destination) == "CFrame" then
                destination = destination.Position
            end

            local function moveTo(targetPosition)
                if not car.PrimaryPart then return end
                local distance = (car.PrimaryPart.Position - targetPosition).Magnitude
                local tweenDuration = math.clamp(distance / 175, 0.05, 20)
                local tweenInfo = TweenInfo.new(tweenDuration, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)

                local value = Instance.new("CFrameValue")
                value.Value = car:GetPivot()

                local con
                con = value.Changed:Connect(function(newCFrame)
                    if car and car.Parent then
                        car:PivotTo(newCFrame)
                        if car:FindFirstChild("DriveSeat") then
                            pcall(function()
                                car.DriveSeat.AssemblyLinearVelocity = Vector3.zero
                                car.DriveSeat.AssemblyAngularVelocity = Vector3.zero
                            end)
                        end
                    else
                        if con then con:Disconnect() end
                    end
                end)

                local success, err = pcall(function()
                    local tween = TweenServiceSR:Create(value, tweenInfo, { Value = CFrame.new(targetPosition) })
                    tween:Play()
                    tween.Completed:Wait()
                end)

                if con then con:Disconnect() end
                value:Destroy()
                if not success then
                    warn("tweenTo moveTo error:", err)
                end
            end

            pcall(function() moveTo(car.PrimaryPart.Position + Vector3.new(0, -4, 0)) end)
            pcall(function() moveTo(destination + Vector3.new(0, -4, 0)) end)
            pcall(function() moveTo(destination) end)
            return true
        end

        local function autoHealAndReturn(originalPosition)
            if isHealing then return true end
            isHealing = true
            
            local char = LocalPlayerSR.Character or LocalPlayerSR.CharacterAdded:Wait()
            local humanoid = char:FindFirstChild("Humanoid")
            if not humanoid then 
                isHealing = false
                return false 
            end

            local bed = WorkspaceSR:FindFirstChild("Buildings")
                and WorkspaceSR.Buildings:FindFirstChild("Hospital")
                and WorkspaceSR.Buildings.Hospital:FindFirstChild("HospitalBed")
                and WorkspaceSR.Buildings.Hospital.HospitalBed:FindFirstChild("Seat")

            if not bed then
                OrionLib:MakeNotification({
                    Name = "Self-Revive Error",
                    Content = "Error",
                    Time = 4
                })
                isHealing = false
                return false
            end

            if humanoid.Sit then
                humanoid.Sit = false
                humanoid.Jump = true
                task.wait(0.12)
            end

            if char:FindFirstChild("HumanoidRootPart") then
                local hrp = char.HumanoidRootPart
                
                hrp.CFrame = bed.CFrame * CFrame.new(0, 2, 0)
                task.wait(0.1)
                
                pcall(function()
                    hrp.AssemblyLinearVelocity = Vector3.zero
                    hrp.AssemblyAngularVelocity = Vector3.zero
                end)
                
                hrp.CFrame = bed.CFrame * CFrame.new(0, 0.5, 0)
                task.wait(0.1)
            end

            local attempts = 0
            while not humanoid.Sit and attempts < 10 do
                pcall(function() bed:Sit(humanoid) end)
                attempts = attempts + 1
                task.wait(0.1)
            end

            local waitTime = 0
            while humanoid.Health < humanoid.MaxHealth * 0.9 and waitTime < 30 do
                task.wait(0.5)
                waitTime = waitTime + 0.5
            end

            humanoid.Sit = false
            task.wait(0.2)

            local car = WorkspaceSR:FindFirstChild("Vehicles") and WorkspaceSR.Vehicles:FindFirstChild(LocalPlayerSR.Name)
            if car and char:FindFirstChild("HumanoidRootPart") and car:FindFirstChild("DriveSeat") then
                char.HumanoidRootPart.CFrame = car.DriveSeat.CFrame * CFrame.new(0, 2, 2)
                task.wait(0.1)
                
                pcall(function() car.DriveSeat:Sit(humanoid) end)
                task.wait(0.2)
                
                pcall(function() tweenTo(originalPosition) end)
            end

            isHealing = false
            return true
        end

        local function checkHealthAndTeleport()
            if isHealing then return end
            
            local car = WorkspaceSR:FindFirstChild("Vehicles") and WorkspaceSR.Vehicles:FindFirstChild(LocalPlayerSR.Name)
            if not car then
                OrionLib:MakeNotification({
                    Name = "Self-Revive",
                    Content = "No Car Found",
                    Time = 3
                })
                return
            end

            local char = LocalPlayerSR.Character or LocalPlayerSR.CharacterAdded:Wait()
            local humanoid = char:FindFirstChild("Humanoid")
            if not humanoid then return end

            local success, originalPos = pcall(function() return car:GetPivot().Position end)
            if not success or not originalPos then return end

            local hospital = CFrame.new(-120.30, 5.61, 1077.29)

            if humanoid.Health <= humanoid.MaxHealth * 0.27 then
                if tweenTo(hospital) then
                    task.wait(1.5)
                    autoHealAndReturn(originalPos)
                end
            end
        end

        local function enableAutoRevive(val)
            autoReviveEnabled = val
            if val then
                local char = LocalPlayerSR.Character or LocalPlayerSR.CharacterAdded:Wait()
                local humanoid = char:WaitForChild("Humanoid")
                
                if healthConnectionSR then
                    pcall(function() healthConnectionSR:Disconnect() end)
                    healthConnectionSR = nil
                end
                
                healthConnectionSR = humanoid.HealthChanged:Connect(function(hp)
                    if autoReviveEnabled and not isHealing and hp <= humanoid.MaxHealth * 0.27 then
                        pcall(function() checkHealthAndTeleport() end)
                    end
                end)
                
                OrionLib:MakeNotification({
                    Name = "Self Revive",
                    Content = "Please Wait a Second.",
                    Time = 3
                })
            else
                if healthConnectionSR then
                    pcall(function() healthConnectionSR:Disconnect() end)
                    healthConnectionSR = nil
                end
            end
        end

        LocalPlayerSR.CharacterAdded:Connect(function(char)
            task.wait(1)
            if autoReviveEnabled then
                local humanoid = char:WaitForChild("Humanoid")
                humanoid.HealthChanged:Connect(function(hp)
                    if autoReviveEnabled and not isHealing and hp <= humanoid.MaxHealth * 0.27 then
                        pcall(function() checkHealthAndTeleport() end)
                    end
                end)
            end
        end)

        enableAutoRevive(true)
    end
})


OrionLib:Init()