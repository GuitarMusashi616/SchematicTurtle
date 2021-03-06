
function hasItem()
	local found=false
	for i,v in ipairs(slot_lst) do
		turtle.select(v)
		if(turtle.getItemCount(v) > 0) then
			found=true
			--turtle.select(v)
			--recordObjSlot(v)--
			--slot = v
			return found
		end
	end
	return found
end

function findNextBlock(x,y,z)
	blockID = getBlockId(x,y,z)
	blockData = getData(x,y,z)
	if blockID then
		slot_lst = slots[blockID][blockData]
	        if(slot_lst ~= nil) then
            		if(#slot_lst > 0) then
				found = hasItem()
				if not found then
					print("Not enough " .. getBlockName(blockID, blockData) .. ". Please refill...")
				end
				while not found do
					found = hasItem()
					
					if not found then
						refill()
					else
						break
					end
			
                		end
			smartPlace(wrench)
			end
			if turtle.getFuelLevel() < 200 then
                		refill()
            		end
		end
	end
end


function setup()
    a = 0
    while (a ~= nil) do
        a = handle.read()
        parse(a, handle)
    end
 
    write("length: " .. length)
    write("   width: " .. width)
    write("   height: " .. height .. "\n")
 
    uniqueblocks={}
    for i,v in ipairs(blocks) do
        found = false
        for j,w in ipairs(uniqueblocks) do
            -- for now, data is only accounted for when the block is wool
                if w.blockID==v and w.data==data[i] then
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
 
    print("number of block types: " .. #uniqueblocks)
    for i,v in ipairs(uniqueblocks) do
        if (i%9)==0 then
            read()
        end
        print(" -" .. getBlockName(v.blockID, v.data) .. ": " .. v.amount)
    end
 
    read()
 
    print("Give the numbers of all slots containing the specified block type:")
 
    slots={}
    for i,block in ipairs(uniqueblocks) do
        blockData = block.data
        print(" -in which slots is " .. getBlockName(block.blockID, blockData) .. "?")
        if not slots[block.blockID] then
            slots[block.blockID] = {}
        end
        slots[block.blockID][blockData] = {}
        write("   ")
        str = read()
		str = str:gsub(","," ")


		space = {}
		res = 0

		while true do
			res = findSpace(str,res)
			if not res then
				break
			end
			table.insert(space,res)
		end


		for i = 1,#space+1 do
			if i==1 then
				table.insert(slots[block.blockID][blockData],tonumber(str:sub(0,space[1])))
			elseif space[i] then
				table.insert(slots[block.blockID][blockData],tonumber(str:sub(space[i-1],space[i])))
			else
				table.insert(slots[block.blockID][blockData],tonumber(str:sub(space[i-1])))
			end
		end	
    end
    invList = scanInv()
end

function findSpace(str,last)
	nSpace = str:find(" ",last+1)
	return nSpace
end

function setupWORKS()
    a = 0
    while (a ~= nil) do
        a = handle.read()
        parse(a, handle)
    end
 
    write("length: " .. length)
    write("   width: " .. width)
    write("   height: " .. height .. "\n")
 
    uniqueblocks={}
    for i,v in ipairs(blocks) do
        found = false
        for j,w in ipairs(uniqueblocks) do
            -- for now, data is only accounted for when the block is wool
                if (w.blockID==v and (w.data==data[i] or w.blockID ~= 35)) then
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
 
    print("number of block types: " .. #uniqueblocks)
    for i,v in ipairs(uniqueblocks) do
        if (i%9)==0 then
            read()
        end
        print(" -" .. getBlockName(v.blockID, v.data) .. ": " .. v.amount)
    end
 
    read()
 
    print("Give the numbers of all slots containing the specified block type:")
 
    slots={}
    for i,block in ipairs(uniqueblocks) do
        blockData = block.data
        print(" -in which slots is " .. getBlockName(block.blockID, blockData) .. "?")
        if not slots[block.blockID] then
            slots[block.blockID] = {}
        end
        slots[block.blockID][blockData] = {}
        write("   ")
        str = read()
        for i = 1, #str do
                local c = str:sub(i,i)
                n = tonumber(c)
                if(n) then
                    if(n>0 and n<10) then
                        table.insert(slots[block.blockID][blockData], n)
                    end
            end
        end
    end
    invList = scanInv()
 end

function getBlockName(id, blockData)
  blockData = blockData or nil
  if(block_id[id] == nil) then
    return "ID: "..tostring(id)..", Data: "..tostring(blockData)
  else
    if(blockData) then
      if(id == 35 or id == 160) then
        str = woolColors[blockData] .. " " .. block_id[id]
        return str
      end
    end
    return block_id[id] .. " " .. id .. ", " .. blockData
  end
end
 
function getBlockId(x,y,z)
	return blocks[y + z*width + x*length*width + 1]
end
 
function getData(x,y,z)
	return data[y + z*width + x*length*width + 1]
end
 
function readbytes(handle, n)
  for i=1,n do
    handle.read()
  end
end
 
function readname(handle)  
  n1 = handle.read()
  n2 = handle.read()
 
  if(n1 == nil or n2 == nil) then
    return ""
  end
 
  n = n1*256 + n2
 
  str = ""
  for i=1,n do
    c = handle.read()
    if c == nil then
      return
    end  
    str = str .. string.char(c)
  end
  return str
end
 
function parse(a, handle, containsName)
  containsName = containsName or true
  if a==0 then
    return
  end
  if containsName then
    name = readname(handle)
  end
   
  if a==1 then
    readbytes(handle,1)  
  elseif a==2 then
    i1 = handle.read()
    i2 = handle.read()
    i = i1*256 + i2
    if(name=="Height") then
      height = i
    elseif (name=="Length") then
      length = i
    elseif (name=="Width") then
      width = i
    end
  elseif a==3 then
    readbytes(handle,4)
  elseif a==4 then
    readbytes(handle,8)
  elseif a==5 then
    readbytes(handle,4)
  elseif a==6 then
    readbytes(handle,8)
  elseif a==7 then
    i1 = handle.read()
    i2 = handle.read()
    i3 = handle.read()
    i4 = handle.read()
    i = i1*256*256*256 + i2*256*256 + i3*256 + i4
    if name == "Blocks" then
      for i=1,i do
        table.insert(blocks, handle.read())
      end
    elseif name == "Data" then
      for i=1,i do
        table.insert(data, handle.read())
      end
    else
      readbytes(handle,i)
    end
  elseif a==8 then
    i1 = handle.read()
    i2 = handle.read()
    i = i1*256 + i2
    readbytes(handle,i)
  elseif a==9 then
        --readbytes(handle,5)
        type = handle.read()
        i1 = handle.read()
    i2 = handle.read()
    i3 = handle.read()
    i4 = handle.read()
    i = i1*256*256*256 + i2*256*256 + i3*256 + i4
    for j=1,i do
      parse(handle.read(), handle, false)
    end
  end
end


block_id = {}
block_id[0] = "Air"
block_id[1] = "Stone"
block_id[2] = "Grass"
block_id[3] = "Dirt"
block_id[4] = "Cobblestone"
block_id[5] = "Wooden Plank"
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
block_id[17] = "Log"
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
block_id[44] = "Slabs"
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
block_id[95] = "Locked Chest"
block_id[96] = "Trapdoors"
block_id[97] = "Hidden Silverfish"
block_id[98] = "Stone Brick"
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
block_id[134] = "Spruce Wood Stairs"
block_id[155] = "Block of Quartz"
block_id[160] = "Stained Glass"
block_id[256] = "Iron Ingotron Shovel"
block_id[257] = "Iron Pickaxe"
block_id[258] = "Iron Axe"
block_id[259] = "Flint and Steel"
block_id[260] = "Red Apple"
block_id[261] = "Bow"
block_id[262] = "Arrow"
block_id[263] = "Coal"
 
woolColors = {}
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
