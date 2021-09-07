--An elite that disables 5 of the player's items on every hit for 5 seconds

--Create a new object that displays disabled items, get sprites of disabled items
--and display them above the player hud

require("disabledItemsDisplay")

local disabledDisplay = Object.find("DisabledItems")

local elite = EliteType.new("Debilitating")
elite.color = Color.DARK_GREY

callback("onActorInit", function(actor)
	if isa(actor, "PlayerInstance") then
		local playerData = actor:getData()
		playerData.items = {}
		playerData.disabledItems = {}
	end
end)

callback("onItemPickup", function(item, player)
	local playerItems = player:getData().items
	table.insert(playerItems, item:getItem())
end)

callback("onHit", function(damager, hit)
	local parent = damager:getParent()
	if isa(hit, "PlayerInstance") then
		--if parent:getElite() == elite then
			local playerData = hit:getData()
			if #playerData.items > 0 then
				local data = {}
				table.insert(data, 360)
				for i = 0, 5 do
					if #playerData.items == 0 then
						break
					end
					local index = math.random( #playerData.items )
					local item = playerData.items[index]
					table.insert(data, item)
					itemremover.removeItem(hit, item)
					table.remove(playerData.items, index)
				end
				table.insert(playerData.disabledItems, data)
				disabledDisplay:create(hit.x,hit.y)
			end
		--end
	end 
end)

callback("onPlayerStep", function(player)
	local playerData = player:getData()
	local disabled = playerData.disabledItems
	if disabled then
		for i = 1, #disabled do
			disabled[i][1] = disabled[i][1] - 1
			if disabled[i][1] <= 0 then
				for j = 2, #disabled[i] do
					local item = disabled[i][j]
					player:giveItem(item)
					table.insert(playerData.items, item)
				end
				table.remove(disabled, i)
			end
		end
	end
end)