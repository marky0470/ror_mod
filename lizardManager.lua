--[[
Variables which are not used should not be included in checking?
Clear lizards table every 5 seconds/entering new stage?
]]

callback("onGameStart", function()
	misc.director:getData().lizards = {}
end)

local lemurian = {Object.find("LizardFG"), Object.find("LizardF")}

for _, enemy in ipairs(lemurian) do
	enemy:addCallback("create", function(self)
		local lizardDirector = misc.director:getData().lizards
		if #lizardDirector > 0 then
			local index = table_lookup2(lizardDirector, self.x)[1]
			print(index)
			if index then	
				local lizard = self:getData()
				lizard.wrath = lizardDirector[index][2]
				lizard.age = lizardDirector[index][3]
				lizard.maturity = lizardDirector[index][4]
				lizard.maturity_scale = lizardDirector[index][5]
				table.remove(lizardDirector, lizardDirector[index])
			end
		end
	end)

	enemy:addCallback("destroy", function(self)
		if self:get("hp") > 0 then
			local lizard = self:getData()
			local xoffset = 0
			if enemy:getName() == "LizardFG" then
				xoffset = 4 * self.xscale
			end
			local data = {
				self.x + xoffset,
				lizard.wrath,
				lizard.age,
				lizard.maturity,
				lizard.maturity_scale,
			}		
			table.insert(misc.director:getData().lizards, data)
		end
	end)
end

--[[
callback("onSecond", function(second)
	if second % 5 == 0 then
		misc.director:getData().lizards = {}
	end
end)]]