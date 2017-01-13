--made by me
--setup() made by orwell

local h2 = fs.open("readbytes","w")
local h3 = fs.open("parse","w")

local tArgs = { ... }
if #tArgs ~= 1 then
  error("Usage: blueprint <gunzipped schematic file>")
end

local filename = tArgs[1]

if not fs.exists(filename) then
  error("File does not exist.")
end

function save(name,table)
	local h = fs.open(name,"w")
	table = textutils.serialize(table)
	h.write(table)
	h.close()
end

function saveBlueprint(reference,slots,instructions,uniqueblocks)
	local fname = filename:gsub("%.(.*)","")..".blueprint"
	local h = fs.open(fname,"w")
	h.writeLine("reference ="..textutils.serialize(reference)..";")
	h.writeLine("slots = "..textutils.serialize(slots)..";")
	h.writeLine("uniqueblocks = "..textutils.serialize(uniqueblocks)..";")
	h.writeLine("instructions = "..textutils.serialize(instructions)..";")
	h.close()
	return fname
end

local block_id = {}

block_id[0] = "Air"
block_id[1] = "Stone"
block_id[2] = "Grass"
block_id[3] = "Dirt"
block_id[4] = "Cobblestone"
block_id[5] = "Wood Planks"
block_id[6] = "Sapling"
block_id[7] = "Bedrock"
block_id[8] = "Water"
block_id[9] = "Stationary water"
block_id[10] = "Lava"
block_id[11] = "Stationary lava"
block_id[12] = "Sand"
block_id[13] = "Gravel"
block_id[14] = "Gold Ore"
block_id[15] = "Iron (Ore)"
block_id[16] = "Coal Ore"
block_id[17] = "Wood"
block_id[18] = "Leaves"
block_id[19] = "Sponge"
block_id[20] = "Glass"
block_id[21] = "Lapis Lazuli (Ore)"
block_id[22] = "Lapis Lazuli (Block)"
block_id[23] = "Dispenser"
block_id[24] = "Sandstone"
block_id[25] = "Note Block Tile entity"
block_id[26] = "Bed"
block_id[27] = "Powered Rail "
block_id[28] = "Detector Rail "
block_id[29] = "Sticky Piston"
block_id[30] = "Cobweb"
block_id[31] = "Tall Grass"
block_id[32] = "Dead Bush"
block_id[33] = "Piston"
block_id[34] = "Piston Extension"
block_id[35] = "Wool"
block_id[36] = "Block moved by Piston"
block_id[37] = "Dandelionandelion"
block_id[38] = "Rose"
block_id[39] = "Brown Mushroom"
block_id[40] = "Red Mushroom"
block_id[41] = "Block of Gold"
block_id[42] = "Block of Iron"
block_id[43] = "Double Slabs"
block_id[44] = "non-Wooden Slabs"
block_id[45] = "Brick Block"
block_id[46] = "TNT"
block_id[47] = "Bookshelf"
block_id[48] = "Moss Stone"
block_id[49] = "Obsidian"
block_id[50] = "Torch"
block_id[51] = "Fire"
block_id[52] = "Monster Spawner"
block_id[53] = "Wooden Stairs"
block_id[54] = "Chest"
block_id[55] = "Redstone (Wire)"
block_id[56] = "Diamond (Ore)"
block_id[57] = "Block of Diamond"
block_id[58] = "Crafting Table"
block_id[59] = "Seeds"
block_id[60] = "Farland"
block_id[61] = "Furnace"
block_id[62] = "Burning Furnace"
block_id[63] = "Sign Post"
block_id[64] = "Wooden Door"
block_id[65] = "Ladders"
block_id[66] = "Rails"
block_id[67] = "Cobblestone Stairs"
block_id[68] = "Wall Sign"
block_id[69] = "Lever"
block_id[70] = "Stone Pressure Plate"
block_id[71] = "Iron Door"
block_id[72] = "Wooden Pressure Plates"
block_id[73] = "Redstone Ore"
block_id[74] = "Glowing Redstone Ore"
block_id[75] = "Redstone Torch"
block_id[76] = "Redstone Torch"
block_id[77] = "Stone Button "
block_id[78] = "Snow"
block_id[79] = "Ice"
block_id[80] = "Snow Block"
block_id[81] = "Cactus"
block_id[82] = "Clay (Block)"
block_id[83] = "Sugar Cane"
block_id[84] = "Jukebox"
block_id[85] = "Fence"
block_id[86] = "Pumpkin"
block_id[87] = "Netherrack"
block_id[88] = "Soul Sand"
block_id[89] = "Glowstone"
block_id[90] = "Portal"
block_id[91] = "Jack-O-Lantern"
block_id[92] = "Cake Block"
block_id[93] = "Redstone Repeater"
block_id[94] = "Redstone Repeater"
block_id[95] = "Stained Glass"
block_id[96] = "Trapdoors"
block_id[97] = "Hidden Silverfish"
block_id[98] = "Stone Bricks"
block_id[99] = "Huge brown and red mushroom"
block_id[100] = "Huge brown and red mushroom"
block_id[101] = "Iron Bars"
block_id[102] = "Glass Pane"
block_id[103] = "Melon"
block_id[104] = "Pumpkin Stem"
block_id[105] = "Melon Stem"
block_id[106] = "Vines"
block_id[107] = "Fence Gate"
block_id[108] = "Brick Stairs"
block_id[109] = "Stone Brick Stairs"
block_id[110] = "Mycelium"
block_id[111] = "Lily Pad"
block_id[112] = "Nether Brick"
block_id[113] = "Nether Brick Fence"
block_id[114] = "Nether Brick Stairs"
block_id[115] = "Nether Wart"
block_id[116] = "Enchantment Table"
block_id[117] = "Brewing Stand"
block_id[118] = "Cauldron"
block_id[119] = "End Portal"
block_id[120] = "End Portal Frame"
block_id[121] = "End Stone "
block_id[126] = "Wood Slabs"
block_id[128] = "Sandstone Stairs"
block_id[134] = "Spruce Wood Stairs"
block_id[135] = "Birch Wood Stairs"
block_id[136] = "Jungle Wood Stairs"
block_id[156] = "Quartz Stairs"
block_id[159] = "Stained Clay"
block_id[160] = "Stained Glass Pane"
block_id[163] = "Acacia Wood Stairs"
block_id[164] = "Dark Oak Wood Stairs"
block_id[171] = "Carpet"
block_id[172] = "Hardened Clay"
block_id[256] = "Iron Ingotron Shovel"
block_id[257] = "Iron Pickaxe"
block_id[258] = "Iron Axe"
block_id[259] = "Flint and Steel"
block_id[260] = "Red Apple"
block_id[261] = "Bow"
block_id[262] = "Arrow"
block_id[263] = "Coal"

local woolColors = {}
woolColors[0] = "White"
woolColors[1] = "Orange"
woolColors[2] = "Magenta"
woolColors[3] = "Light Blue"
woolColors[4] = "Yellow"
woolColors[5] = "Lime"
woolColors[6] = "Pink"
woolColors[7] = "Gray"
woolColors[8] = "Light Gray"
woolColors[9] = "Cyan"
woolColors[10] = "Purple"
woolColors[11] = "Blue"
woolColors[12] = "Brown"
woolColors[13] = "Green"
woolColors[14] = "Red"
woolColors[15] = "Black"

local woodTypes = {}
woodTypes[0] = "Oak"
woodTypes[1] = "Spruce"
woodTypes[2] = "Birch"
woodTypes[3] = "Jungle"
woodTypes[4] = "Acacia"
woodTypes[5] = "Dark Oak"

local stairOrientation = {}
stairOrientation[0] = "East"
stairOrientation[1] = "West"
stairOrientation[2] = "South"
stairOrientation[3] = "North"
stairOrientation[4] = "East Inverted"
stairOrientation[5] = "West Inverted"
stairOrientation[6] = "South Inverted"
stairOrientation[7] = "North Inverted"

local length = 0
local height = 0
local width = 0
local blocks = {}
local data = {}

function getBlockName(id, blockData)
  blockData = blockData or nil
  local str = nil
  if(block_id[id] == nil) then
    return tostring(id)..", "..tostring(blockData)
  else
    if(blockData) then
      if(id == 35) or (id == 159) or (id == 95) or (id == 160) or (id == 171) then
        str = woolColors[blockData] .. " " .. block_id[id]
        return str
      elseif id == 5 or id==17 or id==126 then
		str = woodTypes[blockData].." "..block_id[id]
		return str
	  end
    end
    return block_id[id]
  end
end

function getBlockId(x,y,z)
  return blocks[y + z*width + x*length*width + 1]
end

function getData(x,y,z)
  return data[y + z*width + x*length*width + 1]
end

function readbytes(h, n)
  h2.writeLine(n)
  h2.flush()
  for i=1,n do
    h.read()
  end
end

function readname(h)  
  local n1 = h.read()
  local n2 = h.read()

  if(n1 == nil or n2 == nil) then
    return ""
  end
  
  local n = n1*256 + n2
  
  local str = ""
  for i=1,n do
    local c = h.read()
    if c == nil then
      return
    end  
    str = str .. string.char(c)
  end
  return str
end

function parse(a, h, containsName)
  h3.writeLine(a)
  h3.flush()
  local containsName = containsName or true
  local i,i1,i2,i3,i4
  if a==0 then
    return
  end
  if containsName then
    name = readname(h)
  end  

  if a==1 then
    readbytes(h,1)  
  elseif a==2 then
    i1 = h.read()
    i2 = h.read()
    i = i1*256 + i2
    if(name=="Height") then
      height = i
    elseif (name=="Length") then
      length = i
    elseif (name=="Width") then
      width = i
    end
  elseif a==3 then
    readbytes(h,4)
  elseif a==4 then
    readbytes(h,8)
  elseif a==5 then
    readbytes(h,4)
  elseif a==6 then
    readbytes(h,8)
  elseif a==7 then
    i1 = h.read()
    i2 = h.read()
    i3 = h.read()
    i4 = h.read()
    i = i1*256*256*256 + i2*256*256 + i3*256 + i4
    if name == "Blocks" then
      for i=1,i do
        table.insert(blocks, h.read())
      end
    elseif name == "Data" then
      for i=1,i do
        table.insert(data, h.read())
      end
    else
      readbytes(h,i)
    end
  elseif a==8 then
    i1 = h.read()
    i2 = h.read()
    i = i1*256 + i2
    readbytes(h,i)
  elseif a==9 then
  	--readbytes(h,5)
  	local type = h.read()
  	i1 = h.read()
    i2 = h.read()
    i3 = h.read()
    i4 = h.read()
    i = i1*256*256*256 + i2*256*256 + i3*256 + i4
    for j=1,i do
      parse(h.read(), h, false)
    end
  end
end

function forward()
  while not turtle.forward() do
    turtle.dig()
  end
end

function up()
  while not turtle.up() do
    turtle.digUp()
  end
end

function down()
  while not turtle.down() do
    turtle.digDown()
  end
end

function place()
  while not turtle.placeDown() do
    turtle.digDown()
  end
end


function setup(filename)
--input file
--returns blocks,data
--requires parse, getBlockName

	if not fs.exists(filename) then
  		error("File "..tostring(filename).." does not exist.")
	end
	h = fs.open(filename, "rb")

	local a = 0
	while (a ~= nil) do
 		a = h.read()
  		parse(a, h)
	end

	write("length: " .. length)
	write("   width: " .. width)
	write("   height: " .. height .. "\n")
	
	uniqueblocks={}
	for i,v in ipairs(blocks) do
  		found = false
  		for j,w in ipairs(uniqueblocks) do

			--[[if (w.blockID==v and (w.data==data[i] or w.blockID ~= 35)) then
      			found = true
      			w.amount = w.amount + 1
      			break
    		end]]--

    		--for now, data is only accounted for when the block is whool
    		if (w.blockID==v) and (w.data==data[i]) then
      			found = true
      			w.amount = w.amount + 1
      			break
    		end
  		end
  
  		if found==false then
    		uniqueblocks[#uniqueblocks+1] = {}
    		uniqueblocks[#uniqueblocks].blockID = v
    		uniqueblocks[#uniqueblocks].data = data[i]
    		uniqueblocks[#uniqueblocks].amount = 1
  		end
	end

	if fs.exists("slots") then
		print("slots file discovered...")
		print("skipping setup")
		h.close()
		return
	end

	print("number of block types: " .. #uniqueblocks)
	for i,v in ipairs(uniqueblocks) do
  		if (i%9)==0 then
    		read()
  		end
		local stacks = math.ceil( (v.amount/64) * 100) / 100
  		print(" -" .. getBlockName(v.blockID, v.data).."("..v.blockID..", "..v.data..")" .. ": " ..stacks.."*64 )")
	end

	read()

	print("Use arrowKeys and enter to select slots containing which block the turtle will use for the specified blockType")
	print("select an empty block or press x to skip(not use) the specified blockType ie air")

	slots={}
	for i,block in ipairs(uniqueblocks) do
		local n = nil
  		blockData = block.data
  		print(" -in which slots is " .. getBlockName(block.blockID, blockData).."("..block.blockID..", "..blockData .. ") ?")
  		if not slots[block.blockID] then
    		slots[block.blockID] = {}
  		end
  		slots[block.blockID][blockData] = {}

		--input none
		--output(n)		

		--(oldWay)
		if tArgs[2] == "sim" or tArgs[2] == "simulate" then
  			write("   ")
  			str = read()
			n = tonumber(str)
		else
			n = numberSelector()
		end

		if(n) then
			local itemData = turtle.getItemDetail(n)
			if itemData then
				print("    "..itemData.name..", "..itemData.damage)
				slots[block.blockID][blockData] = {itemData.name,itemData.damage}
			end
   		else
			print("    SKIPPING")
			slots[block.blockID][blockData] = {}
		end
	end
	
	h.close()
	save("slots",slots)
end

function numberSelector()
    local function selectNext(newSelect)
        if newSelect >= 1 and newSelect <= 16 then
            turtle.select(newSelect)
        end
    end
 
    local function ifKey(events,nKey,fn,...)
        if events[1] == "key" and events[2] == tonumber(nKey) then
            fn(...)
        end
    end
 
    local bRunning = true
	local bNothing = false
    while bRunning do
        local events = { os.pullEvent("key") }
        local newSelect
        local selected = turtle.getSelectedSlot()
   
        ifKey(events,203,function() newSelect = selected - 1 ; selectNext(newSelect) ; end)
        ifKey(events,205,function() newSelect = selected + 1 ; selectNext(newSelect) ; end)
        ifKey(events,200,function() newSelect = selected - 4 ; selectNext(newSelect) ; end)
        ifKey(events,208,function() newSelect = selected + 4 ; selectNext(newSelect) ; end)
		ifKey(events,28,function() bRunning = false ; end)
        ifKey(events,45,function() bNothing = true ; bRunning = false ; end)
 		ifKey(events,15,function() bNothing = true ; bRunning = false; end)

        for i = 2,13 do
            ifKey(events,i,function() selectNext(i-1) end)
        end
        for i = 26,27 do
            ifKey(events,i,function() selectNext(i-13) end)
        end
        for i = 39,40 do
            ifKey(events,i,function() selectNext(i-24) end)
        end
    end
    if bNothing then
    	return nil
    else
    	return turtle.getSelectedSlot()
    end
end

-- [[ Iterators ]] --

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
            --elseif x == height then
                --x,y,z = "max","max","max"
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


-- [[ schematic --> blueprint ]] --

--turtles[i].instructions[n] = {x,y,z,id,data}
--i = multiturtle ie 1,2,3,4 ; n = step ie 1 - 256 (no air) 

--fn splits 16x16 grid between 4 turtles returning startx,y,z and endx,y,z of 4 4x4 grids
--fn takes each 4x4 grid and turns them into instructions[n] = {x,y,z,id,data}
--fn for master turtle to setup all slave turtles with the instructions[n] table and goto/find/place functions

function blueprint(startx,starty,startz,finalx,finaly,finalz)
	--uses iterator to make instructions[n] table
	local x,y,z = startx,starty,startz
	local simx,simy,simz = startx,starty,startz
	local instructions = {}
	while true do
		if x == "max" then
			break
		end
		local id = getBlockId(x,y,z)
		local data = getData(x,y,z)
		if id > 0 then
			table.insert(instructions,{x,y,z,id,data})
			simx,simy,simz = addDistance(x,y,z,simx,simy,simz)
		end
		x,y,z = iterate(x,y,z,startx,starty,startz,finalx,finaly,finalz)
	end
	return instructions
end

function addDistance(x,y,z,simx,simy,simz)
	--input x,y,z
	--output running count
end


function createInstructions(startx,starty,startz,height,width,length,nTurtles,placeMode)

	 local x,y,z = startx,starty,startz
	 instructions = {}
	 nTurtles = nTurtles or 1
	 --startx,starty,startz = startx,starty,startz or 0,0,0
	 placeMode = placeMode or "horizontal"
	 local oTurtles = {}
	
	--if horizontal
	for i = 1,nTurtles do
		oTurtles[i] = {}
		if i == tonumber(nTurtles) then
			oTurtles[tonumber(nTurtles)].responsibleLength = math.floor(x/nTurtles) + (x - (math.floor(x/nTurtles)*nTurtles))
		else
			oTurtles[i].responsibleLength =  math.floor(x/nTurtles)
		end
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
			
			
			while true do
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


setup(filename)

save("blocks",blocks)
save("data",data)
save("uniqueblocks",uniqueblocks)

local reference = {
	startx = 0,
	starty = 0,
	startz = 0,
	finalx = height-1,
	finaly = width-1,
	finalz = length-1,
	height = height,
	width = width,
	length = length,
	wrench = 16,
	multiturtle = false -- otherwise its a number (1,2,4,8,12,etc),
}

local ins = blueprint(reference.startx,reference.starty,reference.startz,reference.finalx,reference.finaly,reference.finalz)

save("instructions",ins)
local fname = saveBlueprint(reference,slots,ins,uniqueblocks)
print(fname," saved")
--delete slots,reference,ins,uniqueblocks files