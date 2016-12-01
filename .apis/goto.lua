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
 

function goto2(heightGoal,widthGoal,lengthGoal,dir)
    shell.run("position")
    if turtle.getFuelLevel() < 200 then
        refill()
    end
	if widthGoal > widthPos then
        turn("west")
        while widthGoal > widthPos do
            backward()
        end
    elseif widthGoal < widthPos then
        turn("east")
        while widthGoal < widthPos do
            backward()
        end
    end
    if lengthGoal > lengthPos then
        turn("north")
        while lengthGoal > lengthPos do
            backward()
        end
    elseif lengthGoal < lengthPos then
        turn("south")
        while lengthGoal < lengthPos do
            backward()
        end
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
	turn(dir)
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
  update("forward")
  while not turtle.forward() do
    turtle.dig()
  end
end

function backward()
	update("backward")
	turtle.back()
end

function up()
  update("up")
  while not turtle.up() do
    turtle.digUp()
  end
end
 
function down()
  update("down")
  while not turtle.down() do
    turtle.digDown()
  end
end
 
function right()
  update("right")
  turtle.turnRight()
end
   
function left()
  update("left")
  turtle.turnLeft()
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

function smartPlace(wrench)
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


--[[record keeping functions]]--

function recordPos(heightPos,widthPos,lengthPos,face)
    local h = fs.open("position","w")
    h.writeLine("heightPos = "..tostring(heightPos))
    h.writeLine("widthPos = "..tostring(widthPos))
    h.writeLine("lengthPos = "..tostring(lengthPos))
    h.writeLine("face = ".."\""..tostring(face).."\"")
    h.close()
end
 
function recordObj(x,y,z)
    local h = fs.open("objective",'w')
    h.writeLine("x = "..tostring(x))
    h.writeLine("y = "..tostring(y))
    h.writeLine("z = "..tostring(z))
    h.close()
end

function recordObjSlot(num)
	local h = fs.open("objectiveSlot",'w')
	h.writeLine("slot = "..tostring(num))
    h.close()
end
