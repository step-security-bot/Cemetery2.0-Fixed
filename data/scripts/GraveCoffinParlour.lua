
local timeTot = 0
local Find = Object.GetNearbyObjects
local myAltar = ""

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
	Set("AltarID","None")
	this.Tooltip = "This coffin is being prepared for funeral"
end

function Update(timePassed)
	if timePerUpdate == nil then
		myAltar = Load(myAltar,"ParlourAltar","AltarID",3)
		timePerUpdate = 4
	end
	timeTot = timeTot+timePassed
	if timeTot >= timePerUpdate then
		timeTot = 0
		if this.Loaded == true then
			if not Get("AltarFound") then
				myAltar = GetObject("ParlourAltar",this.CarrierId.i,3)
				if myAltar ~= nil then
					Set("AltarID",myAltar.Id.i)
					Set("AltarFound",true)
					Set("QuickFuneral",false)
					SetOn(myAltar,"StartFuneral",true)
				else
					Set("AltarFound",true)
					Set("QuickFuneral",true)
				end
			elseif Get("QuickFuneral") == true then
				this.CreateJob("CloseCoffin")
				return
			end
		end
	end
end

function JobComplete_CloseCoffin()
	DeleteDeadEntity()
	this.Delete()
end

function DeleteDeadEntity()
	if Get("Category") == "Staff" then
		newCoffin = Object.Spawn("GraveCoffinStaffLoaded", this.Pos.x,this.Pos.y)
	else
		newCoffin = Object.Spawn("GraveCoffinLoaded", this.Pos.x,this.Pos.y)
	end
	SetOn(newCoffin,"DeadBody",this.DeadBody)
	SetOn(newCoffin,"BodySubType",this.BodySubType)
	SetOn(newCoffin,"Category",this.Category)
	SetOn(newCoffin,"Snitch",this.Snitch)
	SetOn(newCoffin,"BodyDeathType",this.BodyDeathType)
	SetOn(newCoffin,"BodyMurderWeapon",this.BodyMurderWeapon)
	SetOn(newCoffin,"BodyMurdererType",this.BodyMurdererType)
	if this.Slot1.i > -1 then
		SetOn(newCoffin,"Slot0.i",this.Slot1.i)	-- transfer funeral wreath to new coffin
		this.Slot1.i = -1
		SetOn(newCoffin,"Slot0.u",this.Slot1.u)
		this.Slot1.u = -1
	end
	Set("BodyIdentified",false)
	for j = 1, #entities do
		for thatEntity in next, Find(this,entities[j],1) do
			if thatEntity.Id.i == this.Slot0.i then
				thatEntity.Delete()
				Set("BodyIdentified",true)
				break
			end
		end
		if Get("BodyIdentified") == true then break end
	end
	if Get("BodyIdentified") == false then
		SetOn(newCoffin,"DeadBody","Unknown")
		DoMagic()	-- funky stuff needed without knowing who the entity actually is
		Set("BodyIdentified",true)
	end
	local tmpTooltip = " "
	if this.DeadBody == "Prisoner" and this.Snitch == true then
		tmpTooltip = "\nSnitches get stitches"
	end
	
	SetOn(newCoffin,"Tooltip","R.I.P. dear "..GetFrom(newCoffin,"DeadBody")..""..tmpTooltip.."\n")
	local velX = -0.5 + math.random()
	local velY = -0.5 + math.random()
	Object.ApplyVelocity(newCoffin, velX, velY)
end

function DoMagic()
	FindMapEdge()
	newHearse = Object.Spawn("Hearse",this.MapSide,this.MapBottom)	-- about the bottom right corner of the map
	SetOn(newHearse,"FromParlour",true)
	SetOn(newHearse,"Slot0.i",this.Slot0.i)							-- get rid of the unknown entity by loading him onto the hearse
	SetOn(newHearse,"Slot0.u",this.Slot0.u)
	Set("Slot0.i",-1)
	Set("Slot0.u",-1)
	SetOn(newHearse,"State","Leaving")								-- bye
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