
local tendTime = math.random(240,480)
local timePerUpdate = math.random(8,16)
local timeTot = 0
local Find = Object.GetNearbyObjects

function Create()
	local myGround = World.GetCell(math.floor(this.Pos.x),math.floor(this.Pos.y))
	myGround.Mat = "LongGrass"
	this.Tooltip = "tooltip_EmptyGrave1"
end

function Update(timePassed)
	timeTot = timeTot+timePassed
	if timeTot >= timePerUpdate then
		timeTot = 0
		if Get("Slot3.i") > -1 then
			this.CreateJob("DigHole")
		end
		tendTime = tendTime - timePerUpdate
		if tendTime <= 0 then
			this.CreateJob("TendGrave")
			tendTime = math.random(240,480)
		end
	end
end

function JobComplete_TendGrave()
end

function JobComplete_DigHole()
	
	nearbyCoffins = Find(this,"GraveCoffinLoaded",3)
	for thatCoffin, dist in pairs(nearbyCoffins) do
		if thatCoffin.Id.i == this.Slot3.i then
			myCoffin = thatCoffin
			
			local myGround = World.GetCell(math.floor(this.Pos.x),math.floor(this.Pos.y))
			myGround.Mat = "GraveHole"
			newGrave = Object.Spawn("GraveUnderConstruction2", this.Pos.x,this.Pos.y)
			
			newCoffin = Object.Spawn("GraveCoffinLoaded2", myCoffin.Pos.x,myCoffin.Pos.y)
			newCoffin.Or.x = myCoffin.Or.x
			newCoffin.Or.y = myCoffin.Or.y
			
			SetOn(newGrave,"CoffinID",newCoffin.Id.i)
			
			SetOn(newCoffin,"DeadBody",GetFrom(myCoffin,"DeadBody"))
			SetOn(newCoffin,"BodySubType",GetFrom(myCoffin,"BodySubType"))
			SetOn(newCoffin,"Category",GetFrom(myCoffin,"Category"))
			SetOn(newCoffin,"Snitch",GetFrom(myCoffin,"Snitch"))
			SetOn(newCoffin,"BodyDeathType",GetFrom(myCoffin,"BodyDeathType"))
			SetOn(newCoffin,"BodyMurderWeapon",GetFrom(myCoffin,"BodyMurderWeapon"))
			SetOn(newCoffin,"BodyMurdererType",GetFrom(myCoffin,"BodyMurdererType"))
			SetOn(newCoffin,"Tooltip",GetFrom(myCoffin,"Tooltip"))
			
			this.Slot3.i = -1
			this.Slot3.u = -1
			myCoffin.CarrierId.i = -1
			myCoffin.CarrierId.u = -1
			myCoffin.Loaded = false
			myCoffin.Delete()
			
			local outNum = math.random(3)
			for i = 1, outNum do
				local someRubble = Object.Spawn("Rubble",this.Pos.x,this.Pos.y+0.5)
				local velX = -1.0 + math.random() + math.random()
				local velY = -1.0 + math.random() + math.random()
				Object.ApplyVelocity(someRubble, velX, velY);
			end
			
			Object.CreateJob(newGrave,"CoffinInHole")
			this.Delete()
		end
	end
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