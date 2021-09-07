--[[ TODO
* Not all enemies can evolve
* No evolutions on the first n stages/minutes of game
* Graphical indication of evolution
	- n seconds before maturity
* Evolved Lemurians cannot take elite types; this is fine but once they become Elder 
	Lemurians they are no longer elite
]]

local artifact = Artifact.new("Evolution")
artifact.unlocked = true
artifact.loadoutSprite = Sprite.find("SelectArtifact2",vanilla)
artifact.loadoutText = "Enemies evolve over time"

--nil is there to prevent index error
local evoTable = {
	{8.5, "Lizard", nil, "LizardG"},--{2.7, "Lizard", 5, "LizardFG", nil, "LizardG"}
	{2.5, "Wisp", 5, "WispG", nil, "WispG2"},
	{3, "Child", nil, "ChildG"},
	{7, "Jelly", nil, "JellyG2"},
	{5, "Imp", nil, "ImpS"},
	{4, "Guard", nil, "GuardG"}
}

--Enemies to exclude from aging
local blacklist = {
	Object.find("Bug"),
	Object.find("Crab"),
	Object.find("Naut"),
	Object.find("Mush"),
	Object.find("ImpS"),
	Object.find("ImpM"),
	Object.find("Clay"),
  Object.find("Golem"),
	Object.find("Bison"),
	Object.find("BoarM"),
	Object.find("Slime"),
	Object.find("GolemS"),
	Object.find("WispG2"),
	Object.find("ChildG"),
	Object.find("Spider"),
	Object.find("GuardG"),
	Object.find("BoarMS"),
	Object.find("Spitter"),
	Object.find("LizardG"),
	Object.find("JellyG2"),
	Object.find("LizardF"),
	Object.find("LizardFG")
}

callback("onActorInit", function(actor)
	if artifact.active then
		if type(actor) ~= "PlayerInstance" then
			if math.chance(50 + misc.director:get("stages_passed") * 4) then
				if actor:isBoss() == false then
					local enemyData = actor:getData()			
					if table_contains(blacklist, actor:getObject()) == false then
						enemyData.age = 0
						local index = table_lookup2(evoTable, actor:getObject():getName())
						enemyData.maturity_scale = evoTable[index[1]][index[2] - 1]
						enemyData.next_stage = evoTable[index[1]][index[2] + 2]
						enemyData.maturity = (1 - misc.director:get("stages_passed")) * enemyData.maturity_scale * 60
					end
				end	
			end
		end
	end
end)

callback("onStep", function()
	if artifact.active then
		local enemies = ParentObject.find("enemies"):findAll()
		for _, enemy in ipairs(enemies) do
			if enemy:isBoss() == false then
				if table_contains(blacklist, enemy:getObject()) == false then
					local enemyData = enemy:getData()
					if enemyData.age ~= nil then
						enemyData.age = enemyData.age + 1
						if enemyData.age >= enemyData.maturity then
							local enemyAc = enemy:getAccessor()
							local enemyElite = enemy:getElite()
							local nextEnemy = Object.find(enemyData.next_stage)
							local new = nextEnemy:create(enemy.x,enemy.y - nextEnemy.sprite.height / 2)
							new:set("hp", new:get("hp") * enemyAc.hp/enemyAc.maxhp)		--Lmao should I just getAccessor for all?
							if enemyElite then
								new:makeElite(enemyElite)
							end
							enemy:destroy()
						end
					end
				end
			end
		end
	end
end)