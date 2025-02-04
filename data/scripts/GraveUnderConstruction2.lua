
local timeTot = 0
local Find = Object.GetNearbyObjects
local myVisitor = ""
local myLeavingVisitor = ""

function Create()
	Set("VisitorID","None")
	this.Tooltip = "tooltip_EmptyGrave2"
end

function Update(timePassed)
	if timePerUpdate == nil then
		if Get("VisitorSpawned") == true and not Get("VisitorLeaving") then
			myVisitor = Load(myVisitor,"SomeFriendFuneral","VisitorID",10000)
		end
		timePerUpdate = 4
	end
	timeTot = timeTot+timePassed
	if timeTot >= timePerUpdate then
		timeTot = 0
		if Get("Slot0.i") > -1 then
			this.CreateJob("BuryEntity")
		end
	end
end

function JobComplete_CoffinInHole()
	nearbyCoffins = Find(this,"GraveCoffinLoaded2",3)
	for thatCoffin, dist in pairs(nearbyCoffins) do
		if thatCoffin.Id.i == Get("CoffinID") then
			this.Slot0.i = thatCoffin.Id.i
			this.Slot0.u = thatCoffin.Id.u
			thatCoffin.CarrierId.i = this.Id.i
			thatCoffin.CarrierId.u = this.Id.u
			thatCoffin.Loaded = true
			break
		end
	end
	timeTot = timePerUpdate
end

function JobComplete_BuryEntity()
	nearbyCoffins = Find(this,"GraveCoffinLoaded2",3)
	for thatCoffin, dist in pairs(nearbyCoffins) do
		if thatCoffin.Id.i == this.Slot0.i then
			myCoffin = thatCoffin
			
			local myGround = World.GetCell(math.floor(this.Pos.x),math.floor(this.Pos.y))
			myGround.Mat = "ConcreteTiles"
			
			newGrave = Object.Spawn("GraveLoaded", this.Pos.x,this.Pos.y)
			SetOn(newGrave,"DeadBody",GetFrom(myCoffin,"DeadBody"))
			SetOn(newGrave,"BodySubType",GetFrom(myCoffin,"BodySubType"))
			SetOn(newGrave,"Category",GetFrom(myCoffin,"Category"))
			SetOn(newGrave,"Snitch",GetFrom(myCoffin,"Snitch"))
			SetOn(newGrave,"BodyDeathType",GetFrom(myCoffin,"BodyDeathType"))
			SetOn(newGrave,"BodyMurderWeapon",GetFrom(myCoffin,"BodyMurderWeapon"))
			SetOn(newGrave,"BodyMurdererType",GetFrom(myCoffin,"BodyMurdererType"))
			SetOn(newGrave,"Tooltip",GetFrom(myCoffin,"Tooltip"))
			newGrave.CreateJob("PlaceStone")
			myCoffin.Delete()
			this.Delete()
		end
	end
end

function FindMapEdge()
	if World.NumCellsY ~= nil and World.NumCellsX ~= nil then
		Set("MapBottom",World.NumCellsY-1)
		Set("MapSide",World.NumCellsX-11)
		Set("RoadX",World.NumCellsX-12)
	else
		local endX=-1
		local foundEndX=false
		local endY=-1
		local foundEndY=false
		
		while foundEndY==false do
			endY=endY+1
			local myCell = World.GetCell(this.Pos.x,endY)
			if myCell.Mat==nil then
				foundEndY=true
				endY=endY-1
			end
		end
		Set("MapBottom",endY)

		while foundEndX==false do
			endX=endX+1
			local myCell = World.GetCell(endX,0)
			if myCell.Mat==nil then
				foundEndX=true
				endX=endX-1
			elseif myCell.Mat=="RoadMarkingsLeft" then
				Set("RoadX",endX-2)
			end
		end
		Set("MapSide",endX)
	end
end

function SpawnVisitor(theType)
	FindMapEdge()
	beaconFound = false
	nearbyBeacons = Find("MetroStationBeacon",10000)
	for thatBeacon, dist in pairs(nearbyBeacons) do
		if GetFrom(thatBeacon,"CEMETERYstationID") ~= "None" then
			Set("MetroX",GetFrom(thatBeacon,"CEMETERYstationPosX"))
			Set("MetroY",GetFrom(thatBeacon,"CEMETERYstationPosY"))
			beaconFound = true
		elseif GetFrom(thatBeacon,"PRISONstationID") ~= "None" then
			Set("MetroX",GetFrom(thatBeacon,"PRISONstationPosX"))
			Set("MetroY",GetFrom(thatBeacon,"PRISONstationPosY"))
			beaconFound = true
		end
	end
	if beaconFound == true then
		if theType == "Leaving" then
			myLeavingVisitor = Object.Spawn("SomeFriendLeaving",myVisitor.Pos.x,myVisitor.Pos.y)
			myLeavingVisitor.SubType = myVisitor.SubType
			myLeavingVisitor.Or.x = myVisitor.Or.x
			myLeavingVisitor.Or.y = myVisitor.Or.y
			SetOn(myLeavingVisitor,"MetroX",this.MetroX)
			SetOn(myLeavingVisitor,"MetroY",this.MetroY)
			myLeavingVisitor.Tooltip = "tooltip_friend_leaving"
			myVisitor.Delete()
			myVisitor = ""
			Set("VisitorID","None")
		else
			myVisitor = Object.Spawn("SomeFriendFuneral",this.MetroX,this.MetroY)
			SetOn(myVisitor,"MetroX",this.MetroX)
			SetOn(myVisitor,"MetroY",this.MetroY)
			Set("VisitorID",myVisitor.Id.i)
			myVisitor.Tooltip = "tooltip_visiting_funeral"
			Set("VisitorSpawned",true)
		end
	else
		if theType == "Leaving" then
			myLeavingVisitor = Object.Spawn("SomeFriendLeaving",myVisitor.Pos.x,myVisitor.Pos.y)
			myLeavingVisitor.SubType = myVisitor.SubType
			myLeavingVisitor.Or.x = myVisitor.Or.x
			myLeavingVisitor.Or.y = myVisitor.Or.y
			myLeavingVisitor.Tooltip = "tooltip_friend_leaving"
			myVisitor.Delete()
			myVisitor = ""
			Set("VisitorID","None")
		else
			myVisitor = Object.Spawn("SomeFriendFuneral",this.RoadX,1)
			Set("VisitorID",myVisitor.Id.i)
			myVisitor.Tooltip = "tooltip_visiting_funeral"
			Set("VisitorSpawned",true)
		end
	end
end

function JobComplete_VisitFuneral()
	if timePerUpdate == nil then
		myVisitor = Load(myVisitor,"SomeFriendFuneral","VisitorID",10000)
	end
	SpawnVisitor("Leaving")
	local outNum = math.random(3)
	for i = 1, outNum do
		local someFlowers = Object.Spawn("GraveFlowers",this.Pos.x,this.Pos.y+0.75)
		local velX = -1.0 + math.random() + math.random()
		local velY = -1.0 + math.random() + math.random()
		Object.ApplyVelocity(someFlowers, velX, velY);
	end
	
	if myLeavingVisitor.MetroX ~= nil then
		beaconFound = false
		nearbyBeacons = Find("MetroStationBeacon",10000)
		for thatBeacon, dist in pairs(nearbyBeacons) do
			if GetFrom(thatBeacon,"CEMETERYstationID") ~= "None" then
				Set("MetroX",GetFrom(thatBeacon,"CEMETERYstationPosX"))
				Set("MetroY",GetFrom(thatBeacon,"CEMETERYstationPosY"))
				beaconFound = true
			elseif GetFrom(thatBeacon,"PRISONstationID") ~= "None" then
				Set("MetroX",GetFrom(thatBeacon,"PRISONstationPosX"))
				Set("MetroY",GetFrom(thatBeacon,"PRISONstationPosY"))
				beaconFound = true
			end
		end
		if beaconFound == true then
			myLeavingVisitor.NavigateTo(myLeavingVisitor.MetroX,myLeavingVisitor.MetroY)
			SetOn(myLeavingVisitor,"BeingTransported",true)
		else
			myLeavingVisitor.LeaveMap()
		end
	else
		myLeavingVisitor.LeaveMap()
	end
	Set("VisitorLeaving",true)
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