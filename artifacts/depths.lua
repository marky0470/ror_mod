--WIP

--[[
Lower depths decrease movement speed and jump height, and damage the player, vision
	is also decreased
Breath meter, the player takes damage as 1/10 of their max health and all healing is 
	disabled
Killing enemies spawn temporary bubbles which are free from the depth's effects,
	they get smaller over time, as well as when the player is inside. These replenish
	the player's breath
The teleporter periodically spawns bubbles
]]

local artifact = Artifact.new("Depths")
artifact.unlocked = true
artifact.loadoutSprite = Sprite.find("SelectArtifact2", vanilla) --Sprite.load("art_danger.png", 2, 18, 18)
artifact.loadoutText = "Build that boat"

--Water
local water = Object.find("Water")

--Remove all existing water instances and create a new one at the bottom of the stage
callback("onStageEntry", function()
	for _, _water in ipairs(water:findAll()) do
		_water:destroy()
	end
	water:create(0,Stage.getDimensions()[2])
end)

--Water rising
callback("onStep", function()
	local _water = water:find(1)
	_water.y = _water.y - 0.2
end)

--BREATH MECHANICS
--Player breath meter initialized
callback("onActorInit", function(actor)
	if isa(actor, "PlayerInstance") then
		local playerData = actor:getData()
		playerData.breath = 1
	end
end)

--Breath meter increment/decrement
callback("onPlayerStep", function(player)
	local _water = water:find(1)
	local playerData = player:getData()
	if player.y < _water.y then
		playerData.breath = playerData.breath - 0.1 / 60
	else if 
		playerData.breath = playerData.breath + 0.1 / 60
	if playerData.breath <
end)