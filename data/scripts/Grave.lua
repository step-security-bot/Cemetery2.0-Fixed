
local timeTot = 0
local Find = Object.GetNearbyObjects
local aLid = ""
local aPhotoFrame = ""
local rememberMe = ""
local myGround = ""
local myVisitor = ""
local visitorFlowers = ""
local beaconFound = false

local entities = { "Prisoner", "Workman", "Guard", "ArmedGuard", "Doctor",
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
end

function Update(timePassed)
	DeleteGrave()
end

function DeleteGrave()
	aLid = Load(aLid,"GraveLid","MyLidID",3)
	if Get("MyLidID") ~= "None" then aLid.Delete() end
	aPhotoFrame = Load(aPhotoFrame,"GravePhoto","MyPhotoID",3)
	if Get("MyPhotoID") ~= "None" then aPhotoFrame.Delete() end
	for j = 1, #entities do
		for thatPhoto in next, this.GetNearbyObjects("PhotoOfDead"..entities[j],3) do
			if this.RememberID == thatPhoto.Id.i then
				thatPhoto.Delete()
				break
			end
		end
	end
	if Get("VisitorSpawned") == true then
		myVisitor = Load(myVisitor,"SomeFriendCemetery","VisitorID",10000)
		visitorFlowers = Load(visitorFlowers,"GraveFlowers","VisitorFlowersID",10000)
		if Get("VisitorID") ~= "None" then myVisitor.Delete() end
		if Get("VisitorFlowersID") ~= "None" then visitorFlowers.Delete() end
	end
	local myGround = World.GetCell(math.floor(this.Pos.x),math.floor(this.Pos.y))
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