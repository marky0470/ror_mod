local artifact = Artifact.new("Tradition")
artifact.unlocked = true
artifact.loadoutSprite = Sprite.find("SelectArtifact2",vanilla)
artifact.loadoutText = "Elites upon death may cause nearby enemies to turn elite as well"

local r = 60

callback("onActorInit", function(actor)
	if artifact.active then
		if type(actor) ~= "PlayerInstance" and actor:isValid() then
			local actorData = actor:getData()
			actorData.influence = math.random(2,4 + (misc.director:get("stages_passed") / 2))
			actorData.elite_types = {}
			if actor:getElite() then
				table.insert(actorData.elite_types, actor:getElite())
			end
		end
	end
end)

callback("onNPCDeath", function(dead)
	if artifact.active then
		if dead:getElite() then
			if math.chance(10 + (misc.director:get("stages_passed") * 2.5)) then
				local nearbyEnemies = ParentObject.find("enemies"):findAllEllipse(dead.x + r,dead.y + r,dead.x - r,dead.y - r)
				local deadData = dead:getData()
				i = 0
				while(i < deadData.influence) do
					if #nearbyEnemies <= 0 then
						break
					end
					local index = math.random(#nearbyEnemies)
					local deadElite = dead:getElite()
					local successor = nearbyEnemies[index]
					local successorData = successor:getData()
					if table_contains(successorData.elite_types, deadElite) == false then
						if math.chance(100 - 18 * #successorData.elite_types) then
							successor:makeElite(deadElite)
							table.insert(successorData.elite_types, deadElite)
							i = i + 1
						end
					end
					table.remove(nearbyEnemies, index)
				end
			end
		end
	end
end)