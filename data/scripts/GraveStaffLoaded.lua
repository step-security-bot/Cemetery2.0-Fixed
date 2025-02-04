
local timePerUpdate = 4
local timeTot = 0
local Find = Object.GetNearbyObjects

function Create()
end

function Update(timePassed)
	timeTot = timeTot+timePassed
	if timeTot >= timePerUpdate then
		timeTot = 0
		if this.Slot0.i == -1 then
			this.CreateJob("PlaceStone")
		end
	end
end

function JobComplete_PlaceStone()
	newStone = Object.Spawn("GraveStoneStaff2", this.Pos.x,this.Pos.y-0.75)
	newStone.Tooltip = { "causeofdeath_"..string.lower(this.BodyDeathType),this.BodyMurdererType,"X",this.BodyMurderWeapon,"W" }
	
	aPhotoFrame = Object.Spawn("GravePhoto",this.Pos.x,this.Pos.y)
	aPhotoFrame.SubType = math.random(0,1)
	aPhotoFrame.Tooltip = this.Tooltip
	
	SetOn(newStone,"Slot0.i",aPhotoFrame.Id.i)
	SetOn(newStone,"Slot0.u",aPhotoFrame.Id.u)
	SetOn(aPhotoFrame,"CarrierId.i",newStone.Id.i)
	SetOn(aPhotoFrame,"CarrierId.u",newStone.Id.u)
	aPhotoFrame.Loaded = true
	
	rememberMe = Object.Spawn("PhotoOfDead"..Get("DeadBody"),this.Pos.x,this.Pos.y)
	rememberMe.Tooltip = this.Tooltip
	if Get("DeadBody") == "Prisoner" then
		if Get("Category") == "MinSec" then rememberMe.SubType = 0
		elseif Get("Category") == "Normal" then rememberMe.SubType = 1
		elseif Get("Category") == "MaxSec" then rememberMe.SubType = 2
		elseif Get("Category") == "SuperMax" then rememberMe.SubType = 3
		elseif Get("Category") == "Protected" then rememberMe.SubType = 4
		elseif Get("Category") == "DeathRow" then rememberMe.SubType = 5
		elseif Get("Category") == "Insane" then rememberMe.SubType = 6
		end
	else
		rememberMe.SubType = Get("BodySubType")
	end
	
	SetOn(aPhotoFrame,"Slot0.i",rememberMe.Id.i)
	SetOn(aPhotoFrame,"Slot0.u",rememberMe.Id.u)
	SetOn(rememberMe,"CarrierId.i",aPhotoFrame.Id.i)
	SetOn(rememberMe,"CarrierId.u",aPhotoFrame.Id.u)
	rememberMe.Loaded = true
	this.Delete()
end

























-------------------------------------------------------------------------------------------
-- Helper Functions
------------------------------------------------------------------------------------------- 
function Set(name, value)
    Object.SetProperty(name, value);
end
function Get(name)
    return Object.GetProperty(name);
end
function GetN(name)
    return tonumber(Object.GetProperty(name));
end
function GetFrom(ident, name)
    return Object.GetProperty(ident, name);
end
function SetOn(ident, name, value)
    return Object.SetProperty(ident, name, value);
end
function Print(text)
    Game.DebugOut("Cat", text);
end
function PrintProperty(name)
    local property = Get(name);
    if property == nil then
        property = "nil";
    end    
    
    Print(name .. ": " .. tostring(property));
end
function PropStr(prop)
    return " " .. prop .. ": " .. tostring(Get(prop));
end--]]


-- get the length of a table
function len(tab)
	local count = 0
	for _ in pairs(tab) do
		count = count + 1
	end
	return count
end
--Return Object if in range.
function GetObject(type,id,dist)
	objs = Object.GetNearbyObjects(type,dist or 1)
	for o,d in pairs(objs) do
		 if o.Id.i == id then
		 	return o
		 end
	end
end
--Find Object after Load.
function Load(Object, Type, ID, dist)
    if Object == "" then
        Print(tostring("Trying to load "..Type.." with ID: "..ID));
        TempID = Get(tostring(ID));
        Object = GetObject(Type,TempID,dist);
        Print("Found: "..Type.." Table: "..tostring(Object).." ID: "..TempID);
    end
	if Object == nil then Set(ID,"None") end
    return Object
end