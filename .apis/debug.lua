function visualize()
	local h = fs.open("visualize","w")
	h.write([[
	shell.run("pastebin run QAM3LnYJ")
	--shell.run("helpful/uWords")

	x,y,z = 0,0,0
	--recordObj(1,1,1)
	height = 20
	width = 19
	length = 1


	local woolColors = {
		[0] = colors.white,
		[1] = colors.orange,
		[2] = colors.magenta,
		[3] = colors.lightBlue,
		[4] = colors.yellow,
		[5] = colors.lime,
		[6] = colors.pink,
		[7] = colors.grey,
		[10] = colors.purple,
		[11] = colors.blue,
		[12] = colors.brown,
		[13] = colors.green,
		[14] = colors.red,
		[15] = colors.black,
	}



	for x = 0,height do
		shell.run("clr")
		for y = 0,width do
			for z = 0,length do
				local res = getBlockId(x,y,z)
				if res == 0 then
					draw("0",y,z)
				elseif res == 35 then
					local data = getBlockData(x,y,z)
					draw(" ",y,z,_,wooldColors[data])
				else
					draw(" ",y,z,_,colors.grey)
				end
			end
		end
		os.pullEvent("mouse_click")
	end
	]])
	h.close()
	print("visualize program created")
end

function saveToConsole(str)
	local h = fs.open("console","a")
	if type(str) ~= "table" then
		str = tostring(str)
		h.writeLine(str)
		h.close()
	else
		for i,v in pairs(str) do
			h.writeLine(i,": ",v)
		end
	end
end



function saveVarsToConsole(name)
    local h = fs.open(name,'w')
    local env = getfenv()
    for i,v in pairs(env) do
        if i then
            h.write(i)
            if v then
                --h.write("("..tostring(type(v))..")")
                h.write(': ')
                h.writeLine(v)
            end
        end
    end
    h.close()
end

function saveVarsToFile()
    local h = fs.open("currentVars",'w')
    local env = getfenv()
    for i,v in pairs(env) do
        if type(v) == "string" then
            h.write(tostring(i))
            h.write(" = ")
            h.write([["]]..tostring(v)..[["]])
        elseif type(v) == "table" then
            h.write(i)
            h.write(" = ")
            h.write(textutils.serialize(v))
        end
    end
    h.close()
end
 
function loadVars()
    local h = fs.open("currentVars",'r')
end

function checkIfRefill()
    local _,inFront = turtle.inspect()
    local _,below = turtle.inspectDown()
    local mem = turtle.getSelectedSlot()
    turtle.select(16)
    local check = turtle.getItemDetail()
    if check and check.name ~= "EnderStorage:enderChest" then
        if not turtle.dropDown() then
            if not turtle.drop() then
                turtle.dropUp()
            end
        end  
    end
    if inFront or below then
        if inFront.name == "EnderStorage:enderChest" then
            turtle.select(enderchest1)
            turtle.dig()
        end
        if below.name == "EnderStorage:enderChest" then
            turtle.select(enderchest2)
            turtle.digDown()
        end
    end
    turtle.select(mem)
end

git = {}
 
function createFile(filename,string)
    local h = fs.open(filename,"w")
    h.write(string)
    h.close()
end
 
function git.get(address,filename)
    write("Connecting to github.com... ")
    local response = http.get(address)
    if response then
        print("")
        print( "Downloaded as "..filename )
    else
        print("")
        print("Failed.")
    end
    createFile(filename,response.readAll())
end
 
function git.run(address,...)
    sCode = http.get(address).readAll()
    if sCode then
        local func, err = loadstring(sCode)
        if not func then
            printError( err )
            return
        end
        setfenv(func, getfenv())
        local success, msg = pcall(func, unpack(...))
        if not success then
            printError( msg )
        end
    end
end
