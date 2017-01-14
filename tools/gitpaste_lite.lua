--fs.open("gitpaste","w").write(http.post("http://pastebin.com/raw/P39qvr3j").readAll())
--Usage: gitpaste [get/run] [address] [filename]

local tArgs = {...}

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

local bRespose = nil
if tArgs[1] == "get" then
	get(tArgs[3], tArgs[2])
elseif tArgs[1] == "run" then
	bResponse = get("tmp",tArgs[2])
	if bResponse then
		shell.run("tmp",table.concat(tArgs,", ",3) )
		fs.delete("tmp")
	end
end
