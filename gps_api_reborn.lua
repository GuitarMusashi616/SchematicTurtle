local tArgs = {...}

function delay()
	sleep(.4)
	return true
end

function recordStep(n)
    local h = fs.open("nObjective",'w')
    h.writeLine("nObjective = "..tostring(n))
    h.close()
end

function recordPos(heightPos,widthPos,lengthPos,face)
    local h = fs.open("position","w")
    h.writeLine("heightPos = "..tostring(heightPos))
    h.writeLine("widthPos = "..tostring(widthPos))
    h.writeLine("lengthPos = "..tostring(lengthPos))
    h.writeLine("face = ".."\""..tostring(face).."\"")
    h.close()
end

function updateVar(file,variable,newValue)
	local exists
	if not fs.exists(file) then
		error("file does not exist")
	end
	
	variable = tostring(variable)
	newValue = textutils.serialize(newValue)
	--print(variable)
	
	local string = fs.open(file,"r").readAll()
	local pattern = variable.."=(.*;)"
	local replace = variable.."="..newValue..";"
	--print(string:find(pattern))

	exists = string:find(pattern)

	if exists then
		local h = fs.open(file,"w")
		string = string:gsub(pattern,replace)
		h.write(string)
		h.close()
	else
		local h = fs.open(file,"a")
		h.writeLine(replace)
		h.close()
	end
end


function reinitialize()
	heightPos = 0
    widthPos = 0
    lengthPos = 0
    face = "south"
    recordPos(heightPos,widthPos,lengthPos,face)
end
 
if tArgs[1] == "reset" then
	reinitialize()
end

if fs.exists("position") then
	shell.run("position")
else
	reinitialize()
end

--[[Navigation function]]--
 
function goto(heightGoal,widthGoal,lengthGoal)
    shell.run("position")
    if turtle.getFuelLevel() < 200 then
        refill()
    end
    if heightGoal > heightPos then
        while heightGoal > heightPos do
            up()
        end
    elseif heightGoal < heightPos then
        while heightGoal < heightPos do
            down()
        end
    end
    if widthGoal > widthPos then
        turn("east")
        while widthGoal > widthPos do
            forward()
        end
    elseif widthGoal < widthPos then
        turn("west")
        while widthGoal < widthPos do
            forward()
        end
    end
    if lengthGoal > lengthPos then
        turn("south")
        while lengthGoal > lengthPos do
            forward()
        end
    elseif lengthGoal < lengthPos then
        turn("north")
        while lengthGoal < lengthPos do
            forward()
        end
    end
end
 
function update(dir)
        if dir == "forward" then
            if face == "north" then
                lengthPos = lengthPos - 1
            elseif face == "south" then
                lengthPos = lengthPos + 1
            elseif face == "west" then
                widthPos = widthPos - 1
            elseif face == "east" then
                widthPos = widthPos + 1
            end
        elseif dir == "backward" then
                if face == "north" then
                        lengthPos = lengthPos + 1
                elseif face == "south" then
                        lengthPos = lengthPos - 1
                elseif face == "west" then
                        widthPos = widthPos + 1
                elseif face == "east" then
                        widthPos = widthPos - 1
                end
        elseif dir == "up" then
                heightPos = heightPos + 1
        elseif dir == "down" then
                heightPos = heightPos - 1
        elseif dir == "right" then
                if face == "north" then
                        face = "east"
                elseif face == "east" then
                        face = "south"
                elseif face == "south" then
                        face = "west"
                elseif face == "west" then
                        face = "north"
                end
        elseif dir == "left" then
                if face == "north" then
                        face = "west"
                elseif face == "west" then
                        face = "south"
                elseif face == "south" then
                        face = "east"
                elseif face == "east" then
                        face = "north"
                end
        end
        recordPos(heightPos,widthPos,lengthPos,face)
end
 
--[[Movement functions]]--
 
function forward()
  parallel.waitForAll(delay,function() while not turtle.forward() do turtle.dig() end return true end,function() update("forward") end)
end
 
function up()
  parallel.waitForAll(delay,function() while not turtle.up() do turtle.digUp() end return true end,function() update("up") end)
end
 
function down()
  parallel.waitForAll(delay,function() while not turtle.down() do turtle.digDown() end return true end,function() update("down") end)
end
 
function right()
  parallel.waitForAll(delay,turtle.turnRight,function() update("right") end)
end
   
function left()
  parallel.waitForAll(delay,turtle.turnLeft,function() update("left") end)
end
 
function turn(dir)
    if face == "north" then
        if dir == "east" then
            while face ~= dir do
                right()
            end
        else
            while face ~= dir do
                left()
            end
        end
   elseif face == "east" then
        if dir == "south" then
            while face ~= dir do
                right()
            end
        else
            while face ~= dir do
                left()
            end
        end
    elseif face == "south" then
        if dir == "west" then
            while face ~= dir do
                right()
            end
        else
            while face ~= dir do
                left()
            end
        end
    elseif face == "west" then
        if dir == "north" then
            while face ~= dir do
                right()
            end
        else
            while face ~= dir do
                left()
            end
        end
    end
end
 
function place()
  while not turtle.placeDown() do
    turtle.digDown()
  end
  return true
end

function saveInventory()

end

function updateInventory()
	--updates inventory table with whats in the turtle inventory
	local inventory = {}
	for i = 1,16 do
		inventory[i] = turtle.getItemDetail(i)
	end
end


function find(id,data,slots)
    --input numid or strname, numdata, and tabslots
    --output slotNumber
    --slots[id][data] = {name,damage,orientation}
    local exceptions = {"stairs","slabs","door","ladder","torch","lever","button","rail","chest","furnace"}
    local name, damage, orientation
 	
    if type(id) == "number" then
        name = slots[id][data][1]
        damage = slots[id][data][2]
        orientation = data
        --convert to string ie minecraft:stone
    elseif type(id) == "string" then
        name = id
        damage = data
        orientation = data
    end
	--assert(name)
	if not name then
		--skips if not assigned in slots
		return nil
	end   	

    for i=1,16 do
        local item = turtle.getItemDetail(i)
        if item and item.name == name then
            --[[for s = 1,#exceptions do
                if name:find(exceptions[s]) then
                    return i
                end
            end]]
           
            if item.damage == damage then
                return i
            end
        end
    end
    
    
    error("not enough "..name..", "..damage)
end

function findBackup(id,data,slots)
    --input numid or strname, numdata, and tabslots
    --output slotNumber
    --slots[id][data] = {name,damage,orientation}
    local exceptions = {"stairs","slabs","door","ladder","torch","lever","button","rail","chest","furnace"}
    local name, damage, orientation
 	
    if type(id) == "number" then
        name = slots[id][data][1]
        damage = slots[id][data][2]
        orientation = data
        --convert to string ie minecraft:stone
    elseif type(id) == "string" then
        name = id
        damage = data
        orientation = data
    end
	--assert(name)
	if not name then
		--skips if not assigned in slots
		return nil
	end   	

    for i=1,16 do
        turtle.select(i)
        local item = turtle.getItemDetail()
        if item and item.name == name then
            --[[for s = 1,#exceptions do
                if name:find(exceptions[s]) then
                    return i
                end
            end]]
           
            if item.damage == damage then
                return i
            end
        end
    end
    
    
    error("not enough "..name..", "..damage)
end

function smartPlace(wrench,orientation)
--wrench turning included
--check for wrench 14
--check if slabs or stairs
    local block = turtle.getItemDetail()
    if block then
        --lookup stairs or slabs
        if (block.name:lower():find("stairs") or block.name:lower():find("slab") or block.name:lower():find("chest")) and wrench then
            --place until metadata matches
            place()
            while true do
                local stair,orient = turtle.inspectDown()
                if stair then
                    if orient.metadata == orientation then
                        break
                    end
                end
                local mem = turtle.getSelectedSlot()
                turtle.select(wrench)
                turtle.placeDown()
                turtle.select(mem)
            end
        else
            place()
        end
    else
        return false
    end
end

function findAndPlace(id,data,slots,wrench)
--wrench turning included
--check for wrench 14
--check if slabs or stairs
	local nSlot = find(id,data,slots)
	if not nSlot then
		return
	end
	turtle.select(nSlot)
    local block = turtle.getItemDetail()
    if block then
        --lookup stairs or slabs
        if (block.name:lower():find("stairs") or block.name:lower():find("slab") or block.name:lower():find("chest")) and wrench then
            --place until metadata matches
            place()
            while true do
                local stair,orient = turtle.inspectDown()
                if stair then
                    if orient.metadata == data then
                        break
                    end
                end
                local mem = turtle.getSelectedSlot()
                turtle.select(wrench)
                turtle.placeDown()
                turtle.select(mem)
            end
        else
            place()
        end
    else
        return false
    end
end

function smartPlaceBackup(wrench)
--wrench turning included
--check for wrench 14
--check if slabs or stairs
    local block = turtle.getItemDetail()
    if block then
        --lookup stairs or slabs
        if (block.name:lower():find("stairs") or block.name:lower():find("slab")) and wrench then
            --place until metadata matches
            place()
            while true do
                local stair,orient = turtle.inspectDown()
                if stair then
                    if orient.metadata == blockData then
                        break
                    end
                end
                local mem = turtle.getSelectedSlot()
                turtle.select(14)
                turtle.placeDown()
                turtle.select(mem)
            end
        else
            place()
        end
    else
        return false
    end
end
