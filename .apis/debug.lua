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