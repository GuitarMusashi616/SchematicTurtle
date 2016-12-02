--redownload apis
--run apis
--initiate variables
Branch = "swarm"


--temp ease of access
local f = fs.open("update","w")
f.write([[
shell.run("SchematicBuilder/Debug")
local tArgs = {...}
if not tArgs[1] then
	git.run("https://raw.githubusercontent.com/GuitarMusashi616/SchematicTurtle/]]..Branch..[[/setup.lua",{"update"})
else
	git.run("https://raw.githubusercontent.com/GuitarMusashi616/SchematicTurtle/]]..Branch..[[/setup.lua",{tArgs[1]})
end
]])
f.close()



--make sure gzip is equipped
tArgs = {...}
if #tArgs < 1 then
    print("Usage: schemSetup <gunzipped schematic file> <startx> <starty> <startz> <finalx> <finaly> <finalz>")
    return
end

--checkfuel
if turtle.getFuelLevel() == 0 then
        print("No Fuel")
        error()
elseif turtle.getFuelLevel() < 300 then
        print("Low Fuel")
        error()
end

function checkWrench()
	local wrench = false
	local mem = turtle.getSelectedSlot()
	turtle.select(14)
	local item = turtle.getItemDetail()
	if item then
		if item.name == "ThermalExpansion:wrench" then
			wrench = true
		else
			wrench = false
		end
	end
	turtle.select(mem)
	return wrench
end

function checkTurtleType()
	local advanced = term.isColor()
	return advanced
end

function schemAPIs(run)
	--dl and run or just run or just update
	if not fs.isDir("SchematicBuilder") then
		fs.makeDir("SchematicBuilder")
	else
		for i,v in pairs(fs.list("SchematicBuilder")) do
			fs.delete("SchematicBuilder/"..v)
		end
	end
	
	if run ~= "update" then
		local deleteFiles = {"objective","reference","position","startup"}
		for i,v in pairs(deleteFiles) do
			if fs.exists(v) then
				fs.delete(v)
			end
		end
	end
	
	local apis = {
        GoTo = "https://raw.githubusercontent.com/GuitarMusashi616/SchematicTurtle/"..Branch.."/.apis/goto.lua",
        GPS = "https://raw.githubusercontent.com/GuitarMusashi616/SchematicTurtle/"..Branch.."/.apis/gps.lua",
        SchemParser = "https://raw.githubusercontent.com/GuitarMusashi616/SchematicTurtle/"..Branch.."/.apis/schemparser.lua",
        LocationFinder = "https://raw.githubusercontent.com/GuitarMusashi616/SchematicTurtle/"..Branch.."/.apis/locationfinder.lua",
        Refill = "https://raw.githubusercontent.com/GuitarMusashi616/SchematicTurtle/"..Branch.."/.apis/refill.lua",
        Debug = "https://raw.githubusercontent.com/GuitarMusashi616/SchematicTurtle/"..Branch.."/.apis/debug.lua",
    }

	for i,v in pairs(apis) do
		if run ~= "run" then
			git.get(v,"SchematicBuilder/"..i)
		end
		shell.run("SchematicBuilder/"..i)
	end
end

function deleteOldFiles()
	if not fs.exists("reference") then
  	  if fs.exists("position") then
        fs.delete("position")
   	  end
   	  if fs.exists("objective") then
        fs.delete("objective")
      end
	end
end


function copySetupVars()
        local h = fs.open("reference",'w')
	h.writeLine("Branch = \""..Branch.."\"")
        h.writeLine("slots = {}")
        h.writeLine("filename = ".."\""..tostring(filename).."\"")
        for i,v in pairs(slots) do
                h.writeLine("slots\["..i.."\] = {}")
                for i2,v2 in pairs(v) do
                        h.writeLine("slots\["..i.."\]\["..i2.."\] = {}")
                        for i3,v3 in pairs(v2) do
                                h.writeLine("slots\["..i.."\]\["..i2.."\]\["..i3.."\] = "..tostring(v3))
                        end
                end
        end
        h.writeLine("invList = {}")
        for i,v in pairs(invList) do
                h.writeLine("invList\["..i.."\] = {}")
                for i2,v2 in pairs(v) do
                        h.writeLine("invList\["..i.."\]\[".."\""..i2.."\"".."\] = "..tostring(v2))
                end
        end
	h.writeLine("startx,starty,startz,finalx,finaly,finalz = "..tArgs[2]..","..tArgs[3]..","..tArgs[4]..","..tArgs[5]..","..tArgs[6]..","..tArgs[7])
        h.writeLine("height = "..tostring(height))
        h.writeLine("width = "..tostring(width))
        h.writeLine("length = "..tostring(length))
        h.writeLine("chestOrder = "..tostring(chestOrder))
        h.writeLine("enderchest1 = "..tostring(enderchest1))
        h.writeLine("enderchest2 = "..tostring(enderchest2))
		h.writeLine("wrench = "..tostring(wrench))
        h.writeLine("origDir = ".."\""..tostring(origDir).."\"")
        h.writeLine("Hoff, Koff, Loff = "..tostring(Hoff)..", "..tostring(Koff)..", "..tostring(Loff))
        h.writeLine("blocks = {}")
        for i,v in pairs(blocks) do
                h.writeLine("blocks\["..i.."\] = "..tostring(v))
        end
 
        h.writeLine("data = {}")
        for i,v in pairs(data) do
                h.writeLine("data\["..i.."\] = "..tostring(v))
        end
     
        h.close()
end

function Initiate()
	if tArgs[1] == "update" then
		schemAPIs("update")
		error()
	end
	deleteOldFiles()
    schemAPIs()
	--run new apis

	--current location
    heightPos = startx
    widthPos = starty
    lengthPos = startz
    face = "south"
	
	--current objective
    x = startx
    y = starty
    z = startz

	--refill vars
    enderchest1 = 15
    enderchest2 = 16
    chestOrder = 1

	--schematic vars
    blocks = {}
    data = {}

	--initialize if available
    openRednet()
    gpsSetup()
	wrench = checkWrench()
	isAdvanced = checkTurtleType()	

	--make sure schematic is good to go
    filename = tArgs[1]
 
    if not fs.exists(filename) then
          print("File does not exist.")
          return
    end
 
    handle = fs.open(filename, "rb")
	
	--corresponding item slots
	shell.run("clr")
    setup()

	--copy down entire environment
    copySetupVars()

	if tArgs then
    	recordPos(heightPos,widthPos,lengthPos,face)
    	recordObj(x,y,z)
	recordObjSlot(1)
	else
    	shell.run("reference")
    	shell.run("position")
    	shell.run("objective")
	end
 
	local h = fs.open("startup","w")
	h.write([[
	shell.run("reference")
	local apis = {
        GoTo = "https://raw.githubusercontent.com/GuitarMusashi616/SchematicTurtle/"..Branch.."/.apis/goto.lua",
        GPS = "https://raw.githubusercontent.com/GuitarMusashi616/SchematicTurtle/"..Branch.."/.apis/gps.lua",
        SchemParser = "https://raw.githubusercontent.com/GuitarMusashi616/SchematicTurtle/"..Branch.."/.apis/schemparser.lua",
        LocationFinder = "https://raw.githubusercontent.com/GuitarMusashi616/SchematicTurtle/"..Branch.."/.apis/locationfinder.lua",
        Refill = "https://raw.githubusercontent.com/GuitarMusashi616/SchematicTurtle/"..Branch.."/.apis/refill.lua",
        Debug = "https://raw.githubusercontent.com/GuitarMusashi616/SchematicTurtle/"..Branch.."/.apis/debug.lua",
    }
	for i,v in pairs(apis) do
		shell.run("SchematicBuilder/"..i)
	end
	openRednet()
	checkIfRefill()
	if gps.locate() then
	    gpsi = true
	else
	    gpsi = false
	end
	resynchronize()
	while true do
        shell.run("position")
        shell.run("objective")
		shell.run("objectiveSlot")
        goto(x+1,y,z)
        findNextBlock(x,y,z)
        checkIfAir()
    end
	shell.run("clr")
	print("finished")
	]])
	h.close()
end


Initiate()
