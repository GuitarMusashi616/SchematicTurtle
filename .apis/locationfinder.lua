function checkIfAir()
	--finds the location to place the next block
    while true do
		iterate()
		--makes the turtle build faster by having to travel less
        blockID2 = getBlockId(x,y,z)	-- temporary variable 
        blockData2 = getData(x,y,z) 	-- temporary variable
        if slots[blockID2] then
			-- makes sure the next block to place at location is not air
            slot_2nd = slots[blockID2][blockData2]
            if slot_2nd then
                if #slot_2nd > 0 then
                    recordObj(x,y,z)
                    break
                end
            end
        end
    end
end


function checkIfAirBUILTIN(x,y,z,height,width,length)
	--finds the location to place the next block
    while true do
		--makes the turtle build faster by having to travel less
        blockID2 = getBlockId(x,y,z)	-- temporary variable 
        blockData2 = getData(x,y,z) 	-- temporary variable
        if slots[blockID2] then
			-- makes sure the next block to place at location is not air
            slot_2nd = slots[blockID2][blockData2]
            if slot_2nd then
                if #slot_2nd > 0 then
                    recordObj(x,y,z)
                    break
                end
            end
        end
		x,y,z = iterate(x,y,z,height,width,length)
    end
end



function checkIfAir2(slots,height,width,length)
	local ObjectivesList = {}
	x,y,z = 0,0,0
	while x do
		local id = getBlockId(x,y,z)
		local data = getData(x,y,z)
		if slots[id] and #slots[id][data] > 0 then
			table.insert(ObjectivesList,{
				x = x,
				y = y,
				z = z,
				id = id,
				data = data,
				slotNums = slots[id][data],
			})
		end
		print(x,y,z)
		x,y,z = iterate(x,y,z,height,width,length)
	end
	return ObjectivesList
end

--iterator api

function oldIterate()
    --x,y,z = height,width,length
    if z < length then
        z = z + 1
    elseif z == length then
        z = 1
        if y < width then
            y = y + 1
        elseif y == width then
            y = 1
            if x < height then
                x = x + 1
            elseif x == height then
                --x = 'max'
                --y = 'max'
                --z = 'max'
				error()
            end
        end
    end
    recordObj(x,y,z)
end

function checkInternal(x,y,z)
    if x%2==0 then
        evenx = true
        if y%2==0 then
            eveny = true
        else
            eveny = false
        end
    else
        evenx = false
        if y%2==0 then
            eveny = false
        else
            eveny = true
        end
    end
	return evenx,eveny
end

function check()
    if x%2==1 then
        oddx = true
        if y%2==1 then
            oddy = true
        else
            oddy = false
        end
    else
        oddx = false
        if y%2==1 then
            oddy = false
        else
            oddy = true
        end
    end
end


function Yiterate()
    if oddx then
        if y < width then
            y = y + 1
        elseif y == width then
            if x < height then
                x = x + 1
            elseif x == height then
                x,y,z = "max","max","max"
            end
        end
    else
        if y == 1 then
            if x < height then
                x = x + 1
			elseif x == height then
				x = "max"
				y = "max"
				z = "max"
            end
        else
            y=y-1
        end
    end
end

function iterate() 
    check()
    if z == length and oddy then
        Yiterate()    
    elseif z == 1 and oddy then
        z = z + 1
    elseif z == 1 and (not oddy) then
        Yiterate()
    elseif z==length and (not oddy) then
        z = z - 1

    elseif z < length then
        if oddy then
            z = z + 1
        else
            z = z - 1
        end
    end
end

function YiterateInternal(x,y,z,length,width,height)
    if evenx then
        if y < width then
            y = y + 1
        elseif y == width then
            if x < height then
                x = x + 1
            elseif x == height then
                x,y,z = "max","max","max"
            end
        end
    else
        if y == 0 then
            if x < height then
                x = x + 1
			elseif x == height then
				x = "max"
				y = "max"
				z = "max"
            end
        else
            y=y-1
        end
    end
	return x,y,z
end

function iterateInternal(x,y,z,length,width,height) 
    evenx,eveny = check(x,y,z)
    if z == length and eveny then
        x,y,z = Yiterate(x,y,z,length,width,height)
    elseif z==length and (not eveny) then
        z = z - 1
    elseif z == 0 and eveny then
        z = z + 1
    elseif z == 0 and (not eveny) then
        x,y,z = Yiterate(x,y,z,length,width,height)
    elseif z < length then
        if eveny then
            z = z + 1
        else
            z = z - 1
        end
    end
	return x,y,z
end

function autorun()
    --get the current coords
    --get the iterater/goal block location
    while true do
        shell.run("position")
        shell.run("objective")
        goto(x,y,z)
        findNextBlock(x,y,z)
        checkIfAir()
    end
	shell.run("clr")
	print("finished")
end
