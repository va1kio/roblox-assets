--[[
	I believe roact isn't really needed it, but I feel like I should make one with Roact, for fun.
	and I did.
	
	This is client-sided, and is roact-based. I didn't really implement functions like hiding name, etc. But those are pretty easy
	to implement, since you just need to do some client-server-client communication and use the Roact.update() method thing.

	-- va1kio
--]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Variables
local LocalPlayer = Players.LocalPlayer
local Roact = require(ReplicatedStorage:WaitForChild("Roact"))
local Tags = {}

-- TextLabel component for easier creation
local function TextLabel(Properties)
	return Roact.createElement("TextLabel", {
		BackgroundTransparency = Properties.BackgroundTransparency or 1,
		Name = Properties.Name or Properties.Text,
		LayoutOrder = Properties.LayoutOrder or 1,
		Size = Properties.Size,
		Text = Properties.Text,
		TextScaled = Properties.TextScaled or true,
		Font = Properties.Font or Enum.Font.Gotham,
		TextStrokeTransparency = 0.8,
		TextColor3 = Properties.Color or Color3.new(1, 1, 1)
	})
end

-- Main UI rendering function
local function Render(Name, Team, Target)
	return Roact.createElement("BillboardGui", {
		Name = Name,
		Adornee = Target,
		LightInfluence = 0,
		Size = UDim2.new(5, 0, 1.25, 0),
		SizeOffset = Vector2.new(0, 1.65)
	}, {
		Layout = Roact.createElement("UIListLayout", {
			Padding = UDim.new(0, 2)	
		}),
		
		PlayerName = Roact.createElement(TextLabel, {
			Name = "Player",
			LayoutOrder = 0,
			Size = UDim2.new(1, 0, 0.5, 0),
			Text = Name
		}),
		
		TeamName = Roact.createElement(TextLabel, {
			Name = "Team",
			LayoutOrder = 1,
			Size = UDim2.new(1, 0, 0.3, 0),
			Text = Team.Name,
			Font = Enum.Font.GothamSemibold,
			Color = Team.TeamColor.Color
		})
	})
end

-- Events
Players.PlayerAdded:Connect(function(Player)
	if Tags[Player.Name] == nil then
		Tags[Player.Name] = Roact.mount(Render(Player.Name, Player.Team, Player.Character:WaitForChild("Head")), LocalPlayer.PlayerGui)
	end
end)

Players.PlayerRemoving:Connect(function(Player)
	Roact.unmount(Tags[Player.Name])
end)

-- First-time
for i,v in pairs(Players:GetPlayers()) do
	print("Rendering and mounting nametag for " .. v.Name)
	Tags[v.Name] = Roact.mount(Render(v.Name, v.Team, v.Character:WaitForChild("Head")), LocalPlayer.PlayerGui)
	
	v.CharacterAdded:Connect(function()
		if Tags[v.Name] == nil then
		Tags[v.Name] = Roact.mount(Render(v.Name, v.Team, v.Character:WaitForChild("Head")), LocalPlayer.PlayerGui)
		end
	end)
	
	v.CharacterRemoving:Connect(function()
		Roact.unmount(Tags[v.Name])
	end)
end
