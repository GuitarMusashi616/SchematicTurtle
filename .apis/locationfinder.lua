function checkIfAir()
	--finds the location to place the next block
    while true do
	iterate(0,0,0,height-1,width-1,length-1)
		--makes the turtle build faster by having to travel less
        blockID2 = getBlockId(x,y,z)	-- temporary variable 
        blockData2 = getData(x,y,z) 	-- temporary variable
	if blockID2 == "finished" then
		break
	end
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

function YiteratePro(startx,starty,startz,finalx,finaly,finalz)
    if oddx then
        if y < finaly then
            y = y + 1
        elseif y == finaly then
            if x < finalx then
                x = x + 1
            elseif x == finalx then
                x,y,z = "max","max","max"
            end
        end
    else
        if y <= starty then
            if x < finalx then
                x = x + 1
			elseif x == finalx then
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

function iteratePro(startx,starty,startz,finalx,finaly,finalz) 
	
    check()
    
    
    if z == finalz and oddy then
        YiteratePro(startx,starty,startz,finalx,finaly,finalz)    
    elseif z == startz and oddy then
        z = z + 1
    elseif z == startz and (not oddy) then
        YiteratePro(startx,starty,startz,finalx,finaly,finalz)
    elseif z==finalz and (not oddy) then
        z = z - 1

    elseif z < finalz then
        if oddy then
            z = z + 1
        else
            z = z - 1
        end
    end
end


function check(startx,starty,startz)
    if x%2==startx%2 then
        oddx = true
        if y%2==starty%2 then
            oddy = true
        else
            oddy = false
        end
    else
        oddx = false
        if y%2==starty%2 then
            oddy = false
        else
            oddy = true
        end
    end
end


function Yiterate(startx,starty,startz,finalx,finaly,finalz)
	
	local height = finalx
	local width = finaly
	local length = finalz
	
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
        if y <= starty then
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

function iterate(startx,starty,startz,finalx,finaly,finalz) 
	
	local height = finalx
	local width = finaly
	local length = finalz
	
	
    check(startx,starty,startz)
    if z == length and oddy then
        Yiterate(startx,starty,startz,finalx,finaly,finalz)    
    elseif z == startz and oddy then
        z = z + 1
    elseif z == startz and (not oddy) then
        Yiterate(startx,starty,startz,finalx,finaly,finalz)
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
