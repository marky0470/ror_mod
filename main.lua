require("artifacts/evolution")
require("artifacts/vengeanceNew")
require("artifacts/tradition")
require("artifacts/darkness")
--require("artifacts/depths")
require("misc")
require("elites/debilitating")
require("lizardManager")

callback("onStep", function()
	local directorAc = misc.director:getAccessor()
	directorAc.points = 0
end)
--[[
callback("onHit", function(damager, hit)
	if not isa(hit, "PlayerInstance") then
		print(hit.xscale)
	end
end)]]
--[[
local liz = Object.new("LizardSoul")

liz:addCallback("create", function(self)
	self:getData().lizard = Object.find("Lizard"):find(1)
end)]]