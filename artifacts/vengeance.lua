local artifact = Artifact.new("Vengeance")
artifact.unlocked = true
artifact.loadoutSprite = Sprite.find("SelectArtifact2",vanilla)
artifact.loadoutText = "Killing enemies angers surrounding enemies"

--Exclude from wrath
local blacklist = {Object.find("WormHead"), Object.find("WormBody")}

local r = 100

function anger(actor)
	local actorAc = actor:getAccessor()
	local actorData = actor:getData()
	actorData.wrath = actorData.wrath + 1
	actorAc.damage = actorAc.damage * 1.3
	actorAc.pHmax = actorAc.pHmax * 1.1
	actorAc.attack_speed = actorAc.attack_speed * 1.1
end

callback("onActorInit", function(actor)
	if artifact.active then
		if type(actor) ~= "PlayerInstance" then
			local enemyData = actor:getData()
			enemyData.wrath = 0
		end
	end
end)

callback("onNPCDeath", function(dead)
	if artifact.active then
		if type(dead) ~= "PlayerInstance" then
			local nearbyEnemies = ParentObject.find("enemies"):findAllEllipse(dead.x + r,dead.y + r,dead.x - r,dead.y - r)
			for _, enemy in ipairs(nearbyEnemies) do
				if enemy:getObject() == Object.find("WormBody") then
					break
				elseif enemy:getObject() == Object.find("WormHead") then
					local wormController = enemy:getAccessor().controller
					enemy = Object.find("Worm"):findMatching("id", wormController)[1]
				end
				if enemy:getData().wrath < 5 + misc.director:get("stages_passed") / 2 then
					anger(enemy)
				end
			end
		end
	end
end)

callback("onDraw", function()
	if artifact.active then
		local enemies = ParentObject.find("enemies"):findAll()
		for _, enemy in ipairs(enemies) do
			if table_contains(blacklist, enemy:getObject()) == false then
				local enemyData = enemy:getData()
				if enemyData.wrath > 0 then
					graphics.drawImage{
						image = enemy.sprite,
						x = enemy.x,
						y = enemy.y,
						xscale = enemy.xscale,
						yscale = enemy.yscale,
						subimage = enemy.subimage,
						color = Color.RED,
						alpha = enemyData.wrath / 10,
						angle = enemy.angle
					}
				end
			end
		end
	end
end)