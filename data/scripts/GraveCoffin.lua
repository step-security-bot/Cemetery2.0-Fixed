
local timePerUpdate = math.random(4,8)
local timeTot = 0
local Find = Object.GetNearbyObjects

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
	this.Tooltip = "This coffin is empty"
end

function Update(timePassed)
	timeTot = timeTot+timePassed
	if timeTot >= timePerUpdate then
		timeTot = 0
		if Get("Slot0.i") > -1 then
			GatherEntityData()
		end
	end
end

function GatherEntityData()
	Set("BodyIdentified",false)
	for j = 1, #entities do
		for thatEntity in next, Find(this,entities[j],1) do
			if thatEntity.Id.i == this.Slot0.i then
				if thatEntity.Type == "Prisoner" then
					newCoffin = Object.Spawn("GraveCoffinParlour", this.Pos.x,this.Pos.y)
					SetOn(thatEntity,"Shackled",false)
					SetOn(newCoffin,"Category",thatEntity.Category)
					if thatEntity.SnitchTimer ~= 0 then
						SetOn(newCoffin,"Snitch",true)
					else
						SetOn(newCoffin,"Snitch",false)
					end
				else
					newCoffin = Object.Spawn("GraveCoffinParlourStaff", this.Pos.x,this.Pos.y)
					SetOn(newCoffin,"Category","Staff")
				end
				SetOn(newCoffin,"DeadBody",thatEntity.Type)
				SetOn(newCoffin,"BodySubType",thatEntity.SubType)
				
				SetOn(newCoffin,"BodyDeathType",thatEntity.DeathType)
				SetOn(newCoffin,"BodyMurderWeapon",thatEntity.MurderWeapon)
				SetOn(newCoffin,"BodyMurdererType",thatEntity.MurdererType)
				
				SetOn(newCoffin,"Slot0.i",this.Slot0.i)		-- transfer body to new coffin
				this.Slot0.i = -1
				SetOn(newCoffin,"Slot0.u",this.Slot0.u)
				this.Slot0.u = -1
				SetOn(thatEntity,"CarrierId.i",newCoffin.Id.i)
				SetOn(thatEntity,"CarrierId.u",newCoffin.Id.u)
				SetOn(thatEntity,"Loaded",true)
				SetOn(thatEntity,"Locked",true)
				Set("BodyIdentified",true)
				break
			end
		end
		if Get("BodyIdentified") == true then break end
	end
	if Get("BodyIdentified") == false then
		newCoffin = Object.Spawn("GraveCoffinParlourStaff", this.Pos.x,this.Pos.y)
		SetOn(newCoffin,"DeadBody","Unknown")
		SetOn(newCoffin,"Snitch",false)
		SetOn(newCoffin,"Category","Staff")
		SetOn(newCoffin,"BodySubType",0)
		SetOn(newCoffin,"BodyDeathType","unknown")
		SetOn(newCoffin,"BodyMurderWeapon","")
		SetOn(newCoffin,"BodyMurdererType","")
		
		SetOn(newCoffin,"Slot0.i",this.Slot0.i)		-- transfer body to new coffin
		this.Slot0.i = -1
		SetOn(newCoffin,"Slot0.u",this.Slot0.u)
		this.Slot0.u = -1
		Set("BodyIdentified",true)
	end
	local tmpTooltip = " "
	if GetFrom(newCoffin,"DeadBody") == "Prisoner" and GetFrom(newCoffin,"Snitch") == true then
		tmpTooltip = "\nSnitches get stitches"
	end
	if GetFrom(newCoffin,"DeadBody") == nil then
		newCoffin.Delete()
		return
	else
		SetOn(newCoffin,"Tooltip","R.I.P. dear "..GetFrom(newCoffin,"DeadBody")..""..tmpTooltip.."\n")
		local velX = -0.5 + math.random()
		local velY = -0.5 + math.random()
		Object.ApplyVelocity(newCoffin, velX, velY)
		this.Delete()
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