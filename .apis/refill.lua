function checkIfEnderchest()
	local slot = turtle.getSelectedSlot()
	for i=15,16 do
		turtle.select(i)
		local item = turtle.getItemDetail()
		if item then
			if item.name == "EnderStorage:enderChest" then
				return true
			end
		end
	end
	turtle.select(slot)
end

function scanInv()
        local invList = {}
        for i = 1,16 do
                turtle.select(i)
                local item = turtle.getItemDetail()
                if item then
                        invList[i] = {}
            invList[i][item.name] = item.damage
                end
        end
        return invList
end
 
function ParseInv()
        turtle.select(16)
        turtle.dropUp()
        while turtle.suck() do
			local item = turtle.getItemDetail()
			if item then
				if item.name == "minecraft:lava_bucket" or item.name == "minecraft:coal" or item.name == "minecraft:coal_block" then
                    turtle.refuel(64)
				else
                	for i = 1,16 do
						if invList[i] then
                        	if invList[i][item.name] then
                            	if invList[i][item.name] == item.damage then
									turtle.transferTo(i)
									break
								end
							end
						end
					end
				end
			end
			turtle.dropUp()
        end
end
 
function refill()
	local mem = turtle.getSelectedSlot()
	local enderChest = checkIfEnderchest()
	if enderChest then
    		chester("set")
        	ParseInv()
        	chester("gather")
	end
	turtle.select(mem)
end
 
function chester(action)
        --action = 'set' or 'gather'
        if action == "set" then
                turtle.select(tonumber(enderchest1))
                turtle.place()
                turtle.select(tonumber(enderchest2))
                turtle.placeUp()
        elseif action == "gather" then
                if tonumber(chestOrder) == 1 then
                        turtle.digUp()
						transferTo(enderchest1)
                        turtle.dig()
						transferTo(enderchest2)
                        chestOrder = 2
                elseif tonumber(chestOrder) == 2 then
                        turtle.dig()
						transferTo(enderchest1)
                        turtle.digUp()
						transferTo(enderchest2)
                        chestOrder = 1
                end
        end
end

function transferTo(enderchestSlot)
	for i=1,16 do
		turtle.select(i)
		local item = turtle.getItemDetail()
		if item then
			if item.name == "EnderStorage:enderChest" then
				turtle.transferTo(enderchestSlot)
			end
		end
	end
end
