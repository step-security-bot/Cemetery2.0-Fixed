
local tendTime = math.random(240,480)
local timeTot = 0
local Find = Object.GetNearbyObjects
local myVisitor = ""
local myLeavingVisitor = ""
local beaconFound = false
local CurrentDay = math.ceil(World.TimeIndex/1440)

local entities = { "Workman", "Guard", "ArmedGuard", "Doctor",
				"Orderly", "Cook", "Gardener", "Janitor",
				"DogHandler", "Dog", "Sniper", "Warden", "Chief",
				"Foreman", "Psychologist", "Psychiatrist", "Accountant",
				"Lawyer", "SystemAdministrator", "ComputerNerd",
				"SimulationOfficeManager", "YogaMaster",
				"GraveDigger", 
				"PrisonFiremanA0", "PrisonFiremanA1", "PrisonFiremanA2", "PrisonFiremanA3", "PrisonFiremanB0", "PrisonFiremanB1", "PrisonFiremanB2", "PrisonFiremanB3",
				"PrisonFiremanC0", "PrisonFiremanC1", "PrisonFiremanC2", "PrisonFiremanC3", "PrisonFiremanD0", "PrisonFiremanD1", "PrisonFiremanD2", "PrisonFiremanD3",
				"LotteryOfficial",
				"ForestryWorker", "BarberChief",
				"Barber",
				"TowTruckDriver", "LimoDriver", "CarMechanic", "CarMechanicHelper", "BasketballTrainer",
				"CarMechanic2", "CraneOperator2",
				"BasketballTrainerFullCourt", "BasketballTrainerHalfCourt", "BasketballTrainerYard",
				"SmartPhoneGenius", "GardenWorker", "GreenhouseWorker",
				"PlantationWorker", "Tailor",
				"TeslaMaticExpert", "ShadyTeslaDude",
				"ParoleOfficer", "ParoleLawyer", "AppealsLawyer", "AppealsMagistrate",
				"ParoleOfficerClone", "ParoleLawyerClone", "AppealsLawyerClone","AppealsMagistrateClone",
				"Teacher", "SpiritualLeader", "TeacherClone", "SpiritualLeaderClone",
				"Fireman", "RiotGuard", "Paramedic", "Soldier",
				"Visitor", "ExecutionWitness", "MetroGuard",
				"TruckDriver", "TowTruck2Driver", "TowTruck2DriverMilitary",
				"Limo2Driver0", "Limo2Driver1", "Limo2Driver2", "Limo2Driver3", "Limo2Driver4", "Limo2Driver5", "Limo2Driver6", "Limo2Driver7",
				"Limo2Driver8", "Limo2Driver9", "Limo2Driver10", "Limo2Driver11", "Limo2Driver12", "Limo2Driver13", "Limo2Driver14", "Limo2Driver15", "Limo2DriverLeaving",
				"SomeFriendParlour1", "SomeFriendParlour2", "SomeFriendParlour3", "SomeFriendParlour4", "SomeFriendParlour5",
				"SomeFriendCemetery", "SomeFriendFuneral", "SomeFriendLeaving", "SpiritualLeaderParlour",
				"ChinookPilot", "ChinookGuard",
				"Unknown"
				 }
function Create()
	this.SubType = math.random(0,11)
	Set("RoadX",0)
	Set("VisitorSpawned",false)
	Set("VisitorLeaving",false)
	Set("VisitorID","None")
	Set("timeCleanup",CurrentDay+60)
	local timeMin = math.random(1440,2880)
	local timeMax = math.random(5760,7200)
	Set("VisitationTimer",0)
	Set("V3",true)
	SpawnVisitor("Cemetery")
end

function Update(timePassed)
	if timePerUpdate == nil then
		timePerUpdate = 10
		if not Get("V3") then
			Set("timeCleanup",CurrentDay+60)
			local timeMin = math.random(1440,2880)
			local timeMax = math.random(5760,7200)
			Set("VisitationTimer",math.random(timeMin,timeMax))
			Set("V3",true)
		end
		if Get("VisitorSpawned") == true and Get("VisitorLeaving") == false then
			timePerUpdate = 4
			myVisitor = Load(myVisitor,"SomeFriendCemetery","VisitorID",10000)
		elseif Get("VisitorSpawned") == false then
			timePerUpdate = math.random(20,60)
		end
		print("Grave will be cleaned up on day "..this.timeCleanup)
	end
	timeTot = timeTot+timePassed
	if timeTot >= timePerUpdate then
		timeTot = 0
		
		-- for Halloween
		local CurrentHour = math.floor(math.mod(World.TimeIndex,1440) /60)
		if CurrentHour >= 0 and CurrentHour <= 3 then
			local H = math.random(100)
			if H == 11 then
				Object.Spawn("Ghost",this.Pos.x,this.Pos.y)
			end
		end
		-- end Halloween
		
		tendTime = tendTime - timePerUpdate
		Set("VisitationTimer",Get("VisitationTimer") - timePerUpdate)
		CurrentDay = math.ceil(World.TimeIndex/1440)
		if Get("timeCleanup") <= CurrentDay then
			this.CreateJob("CleanGrave")
			if Get("VisitorSpawned") == true and Get("VisitorLeaving") == false then
				this.CancelJob("VisitGrave")
				if Get("VisitorID") ~= "None" then
					if myVisitor.MetroX ~= nil then
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
							myVisitor.NavigateTo(myVisitor.MetroX,myVisitor.MetroY)
							SetOn(myVisitor,"BeingTransported",true)
						else
							myVisitor.LeaveMap()
						end
					else
						myVisitor.LeaveMap()
					end
				end
				timePerUpdate = math.random(20,60)
				myVisitor = ""
				Set("VisitorID","None")
				Set("VisitorSpawned",false)
			end
		elseif Get("VisitationTimer") <= 0 then
			if Get("VisitorSpawned") == false then
				SpawnVisitor("Cemetery")
			elseif Get("VisitorLeaving") == false then
				this.CreateJob("VisitGrave")
			else
				local timeMin = math.random(1440,2880)
				local timeMax = math.random(5760,7200)
				Set("VisitationTimer",math.random(timeMin,timeMax))
				Set("VisitorSpawned",false)
				Set("VisitorLeaving",false)
				timePerUpdate = math.random(20,60)
			end
		end
		if tendTime <= 0 then
			this.CreateJob("TendGraveStone")
			tendTime = math.random(240,480)
		end
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
			myVisitor = Object.Spawn("SomeFriendCemetery",this.MetroX,this.MetroY)
			SetOn(myVisitor,"MetroX",this.MetroX)
			SetOn(myVisitor,"MetroY",this.MetroY)
			Set("VisitorID",myVisitor.Id.i)
			myVisitor.Tooltip = "tooltip_visiting_grave"
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
			myVisitor = Object.Spawn("SomeFriendCemetery",this.RoadX,1)
			Set("VisitorID",myVisitor.Id.i)
			myVisitor.Tooltip = "tooltip_visiting_grave"
			Set("VisitorSpawned",true)
		end
	end
	timePerUpdate = 4
end

function JobComplete_VisitGrave()
	if timePerUpdate == nil then
		myVisitor = Load(myVisitor,"SomeFriendCemetery","VisitorID",10000)
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

function JobComplete_TendGraveStone()
end

function JobComplete_CleanGrave()
	local outNum = math.random(3)
	local foundStone = false
	local foundFrame = false
	local foundPhoto = false
	
	for i = 1, outNum do
		local someRubble = Object.Spawn("Rubble",this.Pos.x,this.Pos.y+0.5)
		local velX = -1.0 + math.random() + math.random()
		local velY = -1.0 + math.random() + math.random()
		Object.ApplyVelocity(someRubble, velX, velY);
	end
	
	nearbyPhotoFrames = Find(this,"GravePhoto",2)
	for thatPhotoFrame, dist in pairs(nearbyPhotoFrames) do
		if thatPhotoFrame.Id.i == this.Slot0.i then
			myPhotoFrame = thatPhotoFrame
			foundFrame = true
		end
	end
	
	rememberMe = nil
	for j = 1, #entities do
		for thatPhoto in next, this.GetNearbyObjects("PhotoOfDead"..entities[j],2) do
			if foundFrame == true and thatPhoto.Id.i == myPhotoFrame.Slot0.i then
				rememberMe = thatPhoto
				foundPhoto = true
				break
			end
		end
	end
	
	if foundPhoto == true then rememberMe.Delete() end
	if foundFrame == true then myPhotoFrame.Delete() end
	
	newGrave = Object.Spawn("GraveUnderConstruction1", this.Pos.x,this.Pos.y+0.75)
	local myGround = World.GetCell(math.floor(newGrave.Pos.x),math.floor(newGrave.Pos.y))
	myGround.Mat = "LongGrass"
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
