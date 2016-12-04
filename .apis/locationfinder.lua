function checkIfAir()
	--finds the location to place the next block
    while true do
	x,y,z = iterate(x,y,z,startx,starty,startz,height-1,width-1,length-1)
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



function createInstructions(startx,starty,startz,height,width,length,nTurtles,placeMode)
	local x,y,z = startx,starty,startz
	local instructions = {}
	local nTurtles = nTurtles or 1
	local startx,starty,startz = startx,starty,startz or 0,0,0
	local placeMode = placeMode or "horizontal"
	
	for i = 1,nTurtles do
		local oTurtles = {}
		oTurtles[i] = {}
		oTurtles[i].responsibleLength =  math.floor(x/nTurtles)
		oTurtles[tonumber(nTurtles)].responsibleLength = math.floor(x/nTurtles) + (x - (math.floor(x/nTurtles)*nTurtles))
		oTurtles[i].startHeight = startx
		if i == 1 then
			oTurtles[i].startWidth = starty
		else
			oTurtles[i].startWidth = oTurtles[i-1].startWidth + oTurtles[i].responsibleLength
		end
		oTurtles[i].startLength = startz
		oTurtles[i].finalHeight = height-1
		oTurtles[i].finalWidth = oTurtles[i].startWidth + oTurtles[i].responsibleLength - 1
		oTurtles[i].finalLength = length-1
		instructions[i] = {}
		
	end
	
	

		for i = 1,nTurtles do
			x,y,z = startx,starty,startz
			
			
			while type(z) == "number" do
				local n = #instructions[i]+1
				instructions[i][n]={}
				instructions[i][n].x,instructions[1][n].y,instructions[1][n].z = x,y,z
				instructions[i][n].placeMode = placeMode
				instructions[i][n].id = getBlockId(x,y,z)
				instructions[i][n].data = getData(x,y,z)
				x,y,z = iterate(x,y,z,
					oTurtles[i].startHeight, oTurtles[i].startWidth, oTurtles[i].startLength,
					oTurtles[i].finalHeight, oTurtles[i].finalWidth, oTurtles[i].finalLength
				)
				--attach methods here
			end
			
			
		end
	return instructions
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


function check(x,y,z,startx,starty,startz)
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
	return oddx,oddy
end


function Yiterate(x,y,z,startx,starty,startz,finalx,finaly,finalz)
	
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
	return x,y,z
end

function iterate(x,y,z,startx,starty,startz,finalx,finaly,finalz) 
	
	local height = finalx
	local width = finaly
	local length = finalz
	
	
    local oddx,oddy = check(x,y,z,startx,starty,startz)
    if z == length and oddy then
        x,y,z = Yiterate(x,y,z,startx,starty,startz,finalx,finaly,finalz)    
    elseif z == startz and oddy then
        z = z + 1
    elseif z == startz and (not oddy) then
        x,y,z = Yiterate(x,y,z,startx,starty,startz,finalx,finaly,finalz)
    elseif z==length and (not oddy) then
        z = z - 1

    elseif z < length then
        if oddy then
            z = z + 1
        else
            z = z - 1
        end
    end
	return x,y,z
 end


