--setup gps: pastebin get qLthLak5 gps-deploy, gps-deploy x y z height


function gpsSetup()
    if gps.locate() then
        gpsi = true
        origDir = calibrateDir()
        local h,k,l = gps.locate()
        local k = k + 1
        Hoff,Koff,Loff = h,k,l
        Hoff = math.floor(Hoff)
        Koff = math.floor(Koff)
        Loff = math.floor(Loff)
    else
        origDir = "south"
    end
end
 
function openRednet()
    for _,v in ipairs(peripheral.getNames()) do
            if peripheral.getType(v)=="modem" then
                    rednet.open(v)
            end
    end
end


function resynchronize()
	if gpsi then
    	recalibratePos()
    	face = calibrateDir()
    	recalibrateFace()
		recordPos(heightPos,widthPos,lengthPos,face)
	end
end

function calibrateDir()
    --if gpsi then
        local dir
        local h,k,l = gps.locate()
		h = math.floor(h)
		k = math.floor(k)
		l = math.floor(l)
        while not turtle.forward() do
            turtle.dig()
        end
        local h2,k2,l2 = gps.locate()
        turtle.back()
        if h2>h then
            dir = "east"
        elseif h2<h then
            dir = "west"
        elseif l2>l then
            dir = "south"
        elseif l2<l then
            dir = "north"
        end
        return dir
    --end
end
 
function recalibratePos()
    local h,k,l = gps.locate() 
    local xtemp,ytemp,ztemp  = h - Hoff, k - Koff, l - Loff
 
    if origDir == "south" then
        widthPos = 0 + xtemp   
        heightPos = ytemp
        lengthPos = 0 + ztemp
    elseif origDir == "north" then
        widthPos = 0 - xtemp
        heightPos = ytemp
        lengthPos = 0 - ztemp
    elseif origDir == "east" then
        widthPos = 0  - ztemp
        heightPos = ytemp
        lengthPos = 0  + xtemp
    elseif origDir == "west" then
        widthPos = 0 + ztemp
        heightPos = ytemp
        lengthPos = 0 - xtemp
    end

end
 
function recalibrateFace() 
    if origDir ~= "south" then
        if origDir == "north" then
            update("right")
            update("right")
        elseif origDir == "east" then
            update("right")
        elseif origDir == "west" then
            update("left")
        end
    end
end