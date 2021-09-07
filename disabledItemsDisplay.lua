local sound = Sound.find("Shrine1")
local display = Object.new("DisabledItems")

display:addCallback("create", function(self)

	sound:play()

	selfData = self:getData()
	selfData.life = 180
	selfData.surface = nil

	local player = misc.players[1]:getData()
	local items = table.clone(player.disabledItems[#player.disabledItems])
	table.remove(items, 1)
	local itemSprites = {}
	for _, item in ipairs(items) do
		table.insert(itemSprites, item.sprite)
	end

	local width = 0
	local height = 40
	for _, sprite in ipairs(itemSprites) do
		width = width + sprite.width
	end

	local surface = Surface.new(width, height)
	if Surface.isValid(surface) then

		surface:clear()
		graphics.setTarget(surface)

		local offset = itemSprites[1].width/2
		for i, sprite in ipairs(itemSprites) do
			graphics.drawImage{
				image = sprite,
				x = offset,
				y = 25
			}
			if i < #itemSprites then
				offset = offset + sprite.width/2 + itemSprites[i+1].width/2
			end
		end

		selfData.surface = surface

	end
end)

display:addCallback("step", function(self)

	local selfData = self:getData()

	selfData.life = selfData.life - 1
	if selfData.life <= 0 then
		self:destroy()
	end

	local player = misc.players[1]
	self.x = player.x
	self.y = player.y

end)

display:addCallback("draw", function(self)

	local selfData = self:getData()
	local surface = selfData.surface

	graphics.drawImage{
		image = surface,
		x = self.x - surface.width/2,
		y = self.y - surface.height/2 - 20,
		color = Color.GREY,
		alpha = 1 - selfData.life / 180
	}

end)

display:addCallback("destroy", function(self)

	self:getData().surface:free()

end)