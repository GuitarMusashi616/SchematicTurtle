--no pastebin? no problem!
--fs.open("setup","w").write(http.post("http://pastebin.com/raw/8Th5VpE5").readAll())

local tArgs = {...}
--local filename

function get(name,address)
    local response = nil
    local tmp = fs.open(name,"w")
    local function setColor(color)
        if term.isColor() then
            term.setTextColor(color)
        end
    end
    setColor(colors.yellow)
    if address:sub(1,4) == "http" then
        write("Connecting to Github.com... ")
        response = http.get(address)
    else
        write("Connecting to Pastebin.com... ")
        response = http.get("http://pastebin.com/raw/"..tostring(address))
    end
    if response then
        setColor(colors.green)
        print("Success")
        tmp.write( response.readAll() )
        tmp.close()
        setColor(colors.white)
        return true
    else
        setColor(colors.red)
        print("Failed")
        setColor(colors.white)
        return false
    end
end

if tArgs[1] == "download" or tArgs[1] == "dl" then
	get("market","BztihKh3")
	get("turtle","7mnsWVwz")
	get("blueprint","RZbvQfWG")
	get("simulate","Th40FmCz")
	shell.run("market")
	return
else
	assert(tArgs[1],"no tArgs[1]")
	if not fs.exists(tArgs[1]) then
		error("File non existent")
	end
end

if not fs.exists("turtle") then
	error("dont forget to dl the api skrub")
end
	--shell.run("turtle reset")

function file2table(filename)
	local h = fs.open(filename,"r")
	local sOutput = h.readAll()
	sOutput = textutils.unserialize(sOutput)
	h.close()
	return sOutput
end

--slots = textutils.unserialize(fs.open("slots","r").readAll())

-- [[ reference file ]] --


-- [[ dynamic method ]] --

function recordStep(n)
    local h = fs.open("nObjective",'w')
    h.writeLine("nObjective = "..tostring(n))
    h.close()
end

-- [[ deprecated ]] --


local startup = [[
	
--  reference  --

	shell.run("]]..tostring(tArgs[1])..[[")

--  startup  --

	shell.run("turtle") --runs position
	shell.run("nObjective")
	
	while true do
		--break and return when finished
		if nObjective > #instructions then
			print("finished")
			goto(reference.finalx,reference.starty,reference.startz)
			turn("south")
			goto(reference.startx,reference.starty,reference.startz)
			break
		end
		
		--repeat 
		local x,y,z,id,data = unpack(instructions[nObjective])
		goto(x+1,y,z)
		findAndPlace(id,data,slots,reference.wrench)
		nObjective = nObjective + 1
		recordStep(nObjective)
	end
]]

local h = fs.open("startup","w")
h.write(startup)
h.close()

recordStep(1)
shell.run("turtle reset")
