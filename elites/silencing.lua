--An elite that disables the player's skills for 5 seconds

local elite = EliteType.new("Silencing")
elite.color = Color.DARK_BROWN

local silenced = Buff.new("Silenced")

silenced:addCallback("step", function(player)
    if player:hasBuff(silenced) then
        for i = 2, 5 do
            player:setAlarm(i, 30)
        end
    end
end)

callback("onHit", function(damager, hit)
	local parent = damager:getParent()
    if isa(hit, "PlayerInstance") then
		if parent:getElite() == elite then
            hit:applyBuff(silenced, 60 * 5)
        end
    end
end)