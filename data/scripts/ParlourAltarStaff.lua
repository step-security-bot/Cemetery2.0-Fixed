
local timeInit = 0
local initTimer = math.random()	-- only used when object is placed down.
								-- this will prevent a dozen objects being placed down at the same time from starting to calculate
								-- the TimeWarp all at the same moment, give your potato a break and spread the cpu load a bit :)
local Now = 0
local StartingMinute = 0
local EndingMinute = 0

local myMapSize = "UNKNOWN"
local mySlowTime = "UNKNOWN"

local myTimeWarpFactor = 0
local timeWarpFound = false

local timeTot = 0

local Find = Object.GetNearbyObjects
local mySpiritualLeader = ""
local myLeavingSpiritualLeader = ""
local myFuneralWreath = ""
local myCoffin = ""
local myChair1 = ""
local myChair2 = ""
local myChair3 = ""
local myChair4 = ""
local myChair5 = ""
local myVisitor1 = ""
local myVisitor2 = ""
local myVisitor3 = ""
local myVisitor4 = ""
local myVisitor5 = ""
local myLeavingVisitor1 = ""
local myLeavingVisitor2 = ""
local myLeavingVisitor3 = ""
local myLeavingVisitor4 = ""
local myLeavingVisitor5 = ""
local totalChairs = 0

function Create()
	Set("StartFuneral",false)
	Set("CoffinID","None")
	Set("SpiritualLeaderID","None")
	Set("FuneralWreathID","None")
	Set("Chair1ID","None")
	Set("Chair2ID","None")
	Set("Chair3ID","None")
	Set("Chair4ID","None")
	Set("Chair5ID","None")
	Set("Visitor1ID","None")
	Set("Visitor2ID","None")
	Set("Visitor3ID","None")
	Set("Visitor4ID","None")
	Set("Visitor5ID","None")
	this.Tooltip = "tooltip_Init_TimeWarpA"
end

function Update(timePassed)
	if this.TimeWarp == nil then
		if World.TimeWarpFactor ~= nil then
			Set("TimeWarp",World.TimeWarpFactor)
			this.Tooltip = "tooltip_ReadyForAction"
		else
			CalculateTimeWarpFactor(timePassed)
		end
		return
	elseif timePerUpdate == nil then
		this.Tooltip = ""
		if Get("VisitorSpawned") == true and not Get("VisitorLeaving") then
			myCoffin = Load(myCoffin,"GraveCoffinParlourStaff","CoffinID",5)
			myChair1 = Load(myChair1,"ParlourChair","Chair1ID",10)
			if Get("Chair1ID") ~= "None" then totalChairs = 1 end
			myChair2 = Load(myChair2,"ParlourChair","Chair2ID",10)
			if Get("Chair2ID") ~= "None" then totalChairs = 2 end
			myChair3 = Load(myChair3,"ParlourChair","Chair3ID",10)
			if Get("Chair3ID") ~= "None" then totalChairs = 3 end
			myChair4 = Load(myChair4,"ParlourChair","Chair4ID",10)
			if Get("Chair4ID") ~= "None" then totalChairs = 4 end
			myChair5 = Load(myChair5,"ParlourChair","Chair5ID",10)
			if Get("Chair5ID") ~= "None" then totalChairs = 5 end
			myFuneralWreath = Load(myFuneralWreath,"FuneralWreath","FuneralWreathID",5)
			mySpiritualLeader = Load(mySpiritualLeader,"SpiritualLeaderParlour","SpiritualLeaderID",10000)
			myVisitor1 = Load(myVisitor1,"SomeFriendParlour1","Visitor1ID",10000)
			myVisitor2 = Load(myVisitor2,"SomeFriendParlour2","Visitor2ID",10000)
			myVisitor3 = Load(myVisitor3,"SomeFriendParlour3","Visitor3ID",10000)
			myVisitor4 = Load(myVisitor4,"SomeFriendParlour4","Visitor4ID",10000)
			myVisitor5 = Load(myVisitor5,"SomeFriendParlour5","Visitor5ID",10000)
		end
		myTimeWarpFactor = Get("TimeWarp")
		timePerUpdate = 3 / myTimeWarpFactor
	end
	timeTot = timeTot+timePassed
	if timeTot >= timePerUpdate then
		timeTot = 0
		if Get("StartFuneral") == true then
			if not Get("CoffinFound") then
				myCoffin = GetObject("GraveCoffinParlourStaff",this.Slot3.i,3)
				if myCoffin ~= nil then
					Set("CoffinID",myCoffin.Id.i)
					FindMyChairs()
				else
					Set("StartFuneral",false)
				end
			elseif not Get("VisitorSpawned") then
				SpawnSpiritualLeader("Parlour")
				if Get("Chair1ID") ~= "None" then SpawnVisitor(1,"Parlour"); myChair1.CreateJob("VisitParlour1A") end
				if Get("Chair2ID") ~= "None" then SpawnVisitor(2,"Parlour"); myChair2.CreateJob("VisitParlour2A") end
				if Get("Chair3ID") ~= "None" then SpawnVisitor(3,"Parlour"); myChair3.CreateJob("VisitParlour3A") end
				if Get("Chair4ID") ~= "None" then SpawnVisitor(4,"Parlour"); myChair4.CreateJob("VisitParlour4A") end
				if Get("Chair5ID") ~= "None" then SpawnVisitor(5,"Parlour"); myChair5.CreateJob("VisitParlour5A") end
			elseif not Get("PriestIsAtAltar") then
				this.CreateJob("PriestToAltar")
				KeepFriendsOnChair(1,"A")
				KeepFriendsOnChair(2,"A")
				KeepFriendsOnChair(3,"A")
				KeepFriendsOnChair(4,"A")
				KeepFriendsOnChair(5,"A")
				KeepFriendsOnChair(1,"B")
				KeepFriendsOnChair(2,"B")
				KeepFriendsOnChair(3,"B")
				KeepFriendsOnChair(4,"B")
				KeepFriendsOnChair(5,"B")
			elseif not Get("SpeechDone") then
				this.CreateJob("GiveParlourSpeech")
				KeepFriendsOnChair(1,"A")
				KeepFriendsOnChair(2,"A")
				KeepFriendsOnChair(3,"A")
				KeepFriendsOnChair(4,"A")
				KeepFriendsOnChair(5,"A")
			elseif not Get("WreathPlaced") then
				this.CreateJob("PlaceFuneralWreath")
				KeepFriendsOnChair(1,"B")
				KeepFriendsOnChair(2,"B")
				KeepFriendsOnChair(3,"B")
				KeepFriendsOnChair(4,"B")
				KeepFriendsOnChair(5,"B")
			elseif totalChairs >= 1 and not Get("Visitor1Leaving") then
				myChair1.CancelJob("VisitParlour1A")
				myChair1.CancelJob("VisitParlour1B")
				KeepFriendsOnChair(2,"A")
				KeepFriendsOnChair(3,"A")
				KeepFriendsOnChair(4,"A")
				KeepFriendsOnChair(5,"A")
				this.CreateJob("SayGoodbye1")
			elseif totalChairs >= 2 and not Get("Visitor2Leaving") then
				KeepFriendsOnChair(3,"B")
				KeepFriendsOnChair(4,"B")
				KeepFriendsOnChair(5,"B")
				myChair1.CancelJob("VisitParlour1A")
				myChair1.CancelJob("VisitParlour1B")
				this.CreateJob("SayGoodbye2")
			elseif totalChairs >= 3 and not Get("Visitor3Leaving") then
				KeepFriendsOnChair(4,"A")
				KeepFriendsOnChair(5,"A")
				myChair2.CancelJob("VisitParlour2A")
				myChair2.CancelJob("VisitParlour2B")
				this.CreateJob("SayGoodbye3")
			elseif totalChairs >= 4 and not Get("Visitor4Leaving") then
				KeepFriendsOnChair(5,"B")
				myChair3.CancelJob("VisitParlour3A")
				myChair3.CancelJob("VisitParlour3B")
				this.CreateJob("SayGoodbye4")
			elseif totalChairs >= 5 and not Get("Visitor5Leaving") then
				myChair4.CancelJob("VisitParlour4A")
				myChair4.CancelJob("VisitParlour4B")
				this.CreateJob("SayGoodbye5")
			else
				myCoffin.CreateJob("CloseCoffin")
				if Get("FuneralWreathID") ~= "None" then 
					myFuneralWreathRubbish = Object.Spawn("FuneralWreathRubbish",myFuneralWreath.Pos.x,myFuneralWreath.Pos.y)
					myFuneralWreath.Delete()
					myFuneralWreath = ""
					Set("FuneralWreathID","None")
					myCoffin.Slot1.i = myFuneralWreathRubbish.Id.i
					myCoffin.Slot1.u = myFuneralWreathRubbish.Id.u
					myFuneralWreathRubbish.CarrierId.i = myCoffin.Id.i
					myFuneralWreathRubbish.CarrierId.u = myCoffin.Id.u
					myFuneralWreathRubbish.Loaded = true
				end
				Set("CoffinID","None")
				Set("CoffinFound",nil)
				Set("VisitorSpawned",nil)
				Set("PriestIsAtAltar",nil)
				Set("SpeechDone",nil)
				Set("WreathPlaced",nil)
				Set("SpiritualLeaderLeaving",nil)
				Set("SpiritualLeaderSpawned",nil)
				Set("Visitor1Leaving",nil)
				Set("Visitor2Leaving",nil)
				Set("Visitor3Leaving",nil)
				Set("Visitor4Leaving",nil)
				Set("Visitor5Leaving",nil)
				Set("StartFuneral",false)
			end
		else
			this.Tooltip = ""
		end
	end
end

function FindMyChairs()
	print("finding parlour chairs")
	totalChairs = 0
	myChair1 = ""
	myChair2 = ""
	myChair3 = ""
	myChair4 = ""
	myChair5 = ""
	Set("Chair1ID","None")
	Set("Chair2ID","None")
	Set("Chair3ID","None")
	Set("Chair4ID","None")
	Set("Chair5ID","None")
	nearbyParlourChairs = Find("ParlourChair",10)
	for thatChair, dist in pairs(nearbyParlourChairs) do
		totalChairs=totalChairs+1
		if totalChairs == 1 then myChair1 = thatChair; Set("Chair1ID",thatChair.Id.i); print("found parlour chair1")
		elseif totalChairs == 2 then myChair2 = thatChair; Set("Chair2ID",thatChair.Id.i); print("found parlour chair2")
		elseif totalChairs == 3 then myChair3 = thatChair; Set("Chair3ID",thatChair.Id.i); print("found parlour chair3")
		elseif totalChairs == 4 then myChair4 = thatChair; Set("Chair4ID",thatChair.Id.i); print("found parlour chair4")
		elseif totalChairs == 5 then myChair5 = thatChair; Set("Chair5ID",thatChair.Id.i); print("found parlour chair5")
		else
			break
		end
	end
	if Get("Chair1ID") == "None" then
		this.Tooltip = "No parlour chairs found, funeral ceremony cancelled"
		Set("CoffinID","None")
		SetOn(myCoffin,"QuickFuneral",true)
		myCoffin.CreateJob("CloseCoffin")
		Set("StartFuneral",false)
	else
		this.Tooltip = "The funeral ceremony has started"
		Object.Sound("SmartPhone","Ringtone6")
		Set("CoffinFound",true)
	end
end

function KeepFriendsOnChair(theChairNr,theToggle) -- when a job already exists, it won't be issued again. So the 'sit on chair' job gets split in two with a toggle, A and B, so these two jobs can stack and keep the visitors on their chair at all times without breaks in between the timePerUpdate
	if theChairNr == 1 then if Get("Chair1ID") ~= "None" then if Get("Visitor1ID") ~= "None" then myChair1.CreateJob("VisitParlour1"..theToggle) else myChair1.CancelJob("VisitParlour1"..theToggle) end end end
	if theChairNr == 2 then if Get("Chair2ID") ~= "None" then if Get("Visitor2ID") ~= "None" then myChair2.CreateJob("VisitParlour2"..theToggle) else myChair2.CancelJob("VisitParlour2"..theToggle) end end end
	if theChairNr == 3 then if Get("Chair3ID") ~= "None" then if Get("Visitor3ID") ~= "None" then myChair3.CreateJob("VisitParlour3"..theToggle) else myChair3.CancelJob("VisitParlour3"..theToggle) end end end
	if theChairNr == 4 then if Get("Chair4ID") ~= "None" then if Get("Visitor4ID") ~= "None" then myChair4.CreateJob("VisitParlour4"..theToggle) else myChair4.CancelJob("VisitParlour4"..theToggle) end end end
	if theChairNr == 5 then if Get("Chair5ID") ~= "None" then if Get("Visitor5ID") ~= "None" then myChair5.CreateJob("VisitParlour5"..theToggle) else myChair5.CancelJob("VisitParlour5"..theToggle) end end end
end

function SpawnSpiritualLeader(theType)
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
			myLeavingSpiritualLeader = Object.Spawn("SpiritualLeaderClone",mySpiritualLeader.Pos.x,mySpiritualLeader.Pos.y)
			myLeavingSpiritualLeader.SubType = mySpiritualLeader.SubType
			myLeavingSpiritualLeader.Or.x = mySpiritualLeader.Or.x
			myLeavingSpiritualLeader.Or.y = mySpiritualLeader.Or.y
			SetOn(myLeavingSpiritualLeader,"MetroX",this.MetroX)
			SetOn(myLeavingSpiritualLeader,"MetroY",this.MetroY)
			myLeavingSpiritualLeader.Tooltip = "tooltip_friend_leaving"
			mySpiritualLeader.Delete()
			mySpiritualLeader = ""
			Set("SpiritualLeaderID","None")
		else
			mySpiritualLeader = Object.Spawn("SpiritualLeaderParlour",this.MetroX,this.MetroY)
			SetOn(mySpiritualLeader,"MetroX",this.MetroX)
			SetOn(mySpiritualLeader,"MetroY",this.MetroY)
			Set("SpiritualLeaderID",mySpiritualLeader.Id.i)
			mySpiritualLeader.Tooltip = "tooltip_visiting_funeral"
			Set("SpiritualLeaderSpawned",true)
		end
	else
		if theType == "Leaving" then
			myLeavingSpiritualLeader = Object.Spawn("SpiritualLeaderClone",mySpiritualLeader.Pos.x,mySpiritualLeader.Pos.y)
			myLeavingSpiritualLeader.SubType = mySpiritualLeader.SubType
			myLeavingSpiritualLeader.Or.x = mySpiritualLeader.Or.x
			myLeavingSpiritualLeader.Or.y = mySpiritualLeader.Or.y
			myLeavingSpiritualLeader.Tooltip = "tooltip_friend_leaving"
			mySpiritualLeader.Delete()
			mySpiritualLeader = ""
			Set("SpiritualLeaderID","None")
		else
			mySpiritualLeader = Object.Spawn("SpiritualLeaderParlour",this.RoadX,1)
			Set("SpiritualLeaderID",mySpiritualLeader.Id.i)
			mySpiritualLeader.Tooltip = "tooltip_visiting_funeral"
			Set("SpiritualLeaderSpawned",true)
		end
	end
end

function SpawnVisitor(theNr,theType)
--	FindMapEdge()
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
			if theNr == 1 then
				myLeavingVisitor1 = Object.Spawn("SomeFriendLeaving",myVisitor1.Pos.x,myVisitor1.Pos.y)
				myLeavingVisitor1.SubType = myVisitor1.SubType
				myLeavingVisitor1.Or.x = myVisitor1.Or.x
				myLeavingVisitor1.Or.y = myVisitor1.Or.y
				SetOn(myLeavingVisitor1,"MetroX",this.MetroX)
				SetOn(myLeavingVisitor1,"MetroY",this.MetroY)
				myLeavingVisitor1.Tooltip = "tooltip_friend_leaving"
				myVisitor1.Delete()
				myVisitor1 = ""
				Set("Visitor1ID","None")
			elseif theNr == 2 then
				myLeavingVisitor2 = Object.Spawn("SomeFriendLeaving",myVisitor2.Pos.x,myVisitor2.Pos.y)
				myLeavingVisitor2.SubType = myVisitor2.SubType
				myLeavingVisitor2.Or.x = myVisitor2.Or.x
				myLeavingVisitor2.Or.y = myVisitor2.Or.y
				SetOn(myLeavingVisitor2,"MetroX",this.MetroX)
				SetOn(myLeavingVisitor2,"MetroY",this.MetroY)
				myLeavingVisitor2.Tooltip = "tooltip_friend_leaving"
				myVisitor2.Delete()
				myVisitor2 = ""
				Set("Visitor2ID","None")
			elseif theNr == 3 then
				myLeavingVisitor3 = Object.Spawn("SomeFriendLeaving",myVisitor3.Pos.x,myVisitor3.Pos.y)
				myLeavingVisitor3.SubType = myVisitor3.SubType
				myLeavingVisitor3.Or.x = myVisitor3.Or.x
				myLeavingVisitor3.Or.y = myVisitor3.Or.y
				SetOn(myLeavingVisitor3,"MetroX",this.MetroX)
				SetOn(myLeavingVisitor3,"MetroY",this.MetroY)
				myLeavingVisitor3.Tooltip = "tooltip_friend_leaving"
				myVisitor3.Delete()
				myVisitor3 = ""
				Set("Visitor3ID","None")
			elseif theNr == 4 then
				myLeavingVisitor4 = Object.Spawn("SomeFriendLeaving",myVisitor4.Pos.x,myVisitor4.Pos.y)
				myLeavingVisitor4.SubType = myVisitor4.SubType
				myLeavingVisitor4.Or.x = myVisitor4.Or.x
				myLeavingVisitor4.Or.y = myVisitor4.Or.y
				SetOn(myLeavingVisitor4,"MetroX",this.MetroX)
				SetOn(myLeavingVisitor4,"MetroY",this.MetroY)
				myLeavingVisitor4.Tooltip = "tooltip_friend_leaving"
				myVisitor4.Delete()
				myVisitor4 = ""
				Set("Visitor4ID","None")
			elseif theNr == 5 then
				myLeavingVisitor5 = Object.Spawn("SomeFriendLeaving",myVisitor5.Pos.x,myVisitor5.Pos.y)
				myLeavingVisitor5.SubType = myVisitor5.SubType
				myLeavingVisitor5.Or.x = myVisitor5.Or.x
				myLeavingVisitor5.Or.y = myVisitor5.Or.y
				SetOn(myLeavingVisitor5,"MetroX",this.MetroX)
				SetOn(myLeavingVisitor5,"MetroY",this.MetroY)
				myLeavingVisitor5.Tooltip = "tooltip_friend_leaving"
				myVisitor5.Delete()
				myVisitor5 = ""
				Set("Visitor5ID","None")
			end
		else
			if theNr == 1 then
				myVisitor1 = Object.Spawn("SomeFriendParlour1",this.MetroX,this.MetroY)
				SetOn(myVisitor1,"MetroX",this.MetroX)
				SetOn(myVisitor1,"MetroY",this.MetroY)
				Set("Visitor1ID",myVisitor1.Id.i)
				myVisitor1.Tooltip = "tooltip_visiting_funeral"
				Set("VisitorSpawned",true)
			elseif theNr == 2 then
				myVisitor2 = Object.Spawn("SomeFriendParlour2",this.MetroX,this.MetroY)
				SetOn(myVisitor2,"MetroX",this.MetroX)
				SetOn(myVisitor2,"MetroY",this.MetroY)
				Set("Visitor2ID",myVisitor2.Id.i)
				myVisitor2.Tooltip = "tooltip_visiting_funeral"
				Set("VisitorSpawned",true)
			elseif theNr == 3 then
				myVisitor3 = Object.Spawn("SomeFriendParlour3",this.MetroX,this.MetroY)
				SetOn(myVisitor3,"MetroX",this.MetroX)
				SetOn(myVisitor3,"MetroY",this.MetroY)
				Set("Visitor3ID",myVisitor3.Id.i)
				myVisitor3.Tooltip = "tooltip_visiting_funeral"
				Set("VisitorSpawned",true)
			elseif theNr == 4 then
				myVisitor4 = Object.Spawn("SomeFriendParlour4",this.MetroX,this.MetroY)
				SetOn(myVisitor4,"MetroX",this.MetroX)
				SetOn(myVisitor4,"MetroY",this.MetroY)
				Set("Visitor4ID",myVisitor4.Id.i)
				myVisitor4.Tooltip = "tooltip_visiting_funeral"
				Set("VisitorSpawned",true)
			elseif theNr == 5 then
				myVisitor5 = Object.Spawn("SomeFriendParlour5",this.MetroX,this.MetroY)
				SetOn(myVisitor5,"MetroX",this.MetroX)
				SetOn(myVisitor5,"MetroY",this.MetroY)
				Set("Visitor5ID",myVisitor5.Id.i)
				myVisitor5.Tooltip = "tooltip_visiting_funeral"
				Set("VisitorSpawned",true)
			end
		end
	else
		if theType == "Leaving" then
			if theNr == 1 then
				myLeavingVisitor1 = Object.Spawn("SomeFriendLeaving",myVisitor1.Pos.x,myVisitor1.Pos.y)
				myLeavingVisitor1.SubType = myVisitor1.SubType
				myLeavingVisitor1.Or.x = myVisitor1.Or.x
				myLeavingVisitor1.Or.y = myVisitor1.Or.y
				myLeavingVisitor1.Tooltip = "tooltip_friend_leaving"
				myVisitor1.Delete()
				myVisitor1 = ""
				Set("Visitor1ID","None")
			elseif theNr == 2 then
				myLeavingVisitor2 = Object.Spawn("SomeFriendLeaving",myVisitor2.Pos.x,myVisitor2.Pos.y)
				myLeavingVisitor2.SubType = myVisitor2.SubType
				myLeavingVisitor2.Or.x = myVisitor2.Or.x
				myLeavingVisitor2.Or.y = myVisitor2.Or.y
				myLeavingVisitor2.Tooltip = "tooltip_friend_leaving"
				myVisitor2.Delete()
				myVisitor2 = ""
				Set("Visitor2ID","None")
			elseif theNr == 3 then
				myLeavingVisitor3 = Object.Spawn("SomeFriendLeaving",myVisitor3.Pos.x,myVisitor3.Pos.y)
				myLeavingVisitor3.SubType = myVisitor3.SubType
				myLeavingVisitor3.Or.x = myVisitor3.Or.x
				myLeavingVisitor3.Or.y = myVisitor3.Or.y
				myLeavingVisitor3.Tooltip = "tooltip_friend_leaving"
				myVisitor3.Delete()
				myVisitor3 = ""
				Set("Visitor3ID","None")
			elseif theNr == 4 then
				myLeavingVisitor4 = Object.Spawn("SomeFriendLeaving",myVisitor4.Pos.x,myVisitor4.Pos.y)
				myLeavingVisitor4.SubType = myVisitor4.SubType
				myLeavingVisitor4.Or.x = myVisitor4.Or.x
				myLeavingVisitor4.Or.y = myVisitor4.Or.y
				myLeavingVisitor4.Tooltip = "tooltip_friend_leaving"
				myVisitor4.Delete()
				myVisitor4 = ""
				Set("Visitor4ID","None")
			elseif theNr == 5 then
				myLeavingVisitor5 = Object.Spawn("SomeFriendLeaving",myVisitor5.Pos.x,myVisitor5.Pos.y)
				myLeavingVisitor5.SubType = myVisitor5.SubType
				myLeavingVisitor5.Or.x = myVisitor5.Or.x
				myLeavingVisitor5.Or.y = myVisitor5.Or.y
				myLeavingVisitor5.Tooltip = "tooltip_friend_leaving"
				myVisitor5.Delete()
				myVisitor5 = ""
				Set("Visitor5ID","None")
			end
		else
			if theNr == 1 then
				myVisitor1 = Object.Spawn("SomeFriendParlour1",this.RoadX,1)
				Set("Visitor1ID",myVisitor1.Id.i)
				myVisitor1.Tooltip = "tooltip_visiting_funeral"
				Set("VisitorSpawned",true)
			elseif theNr == 2 then
				myVisitor2 = Object.Spawn("SomeFriendParlour2",this.RoadX,1)
				Set("Visitor2ID",myVisitor2.Id.i)
				myVisitor2.Tooltip = "tooltip_visiting_funeral"
				Set("VisitorSpawned",true)
			elseif theNr == 3 then
				myVisitor3 = Object.Spawn("SomeFriendParlour3",this.RoadX,1)
				Set("Visitor3ID",myVisitor3.Id.i)
				myVisitor3.Tooltip = "tooltip_visiting_funeral"
				Set("VisitorSpawned",true)
			elseif theNr == 4 then
				myVisitor4 = Object.Spawn("SomeFriendParlour4",this.RoadX,1)
				Set("Visitor4ID",myVisitor4.Id.i)
				myVisitor4.Tooltip = "tooltip_visiting_funeral"
				Set("VisitorSpawned",true)
			elseif theNr == 5 then
				myVisitor5 = Object.Spawn("SomeFriendParlour5",this.RoadX,1)
				Set("Visitor5ID",myVisitor5.Id.i)
				myVisitor5.Tooltip = "tooltip_visiting_funeral"
				Set("VisitorSpawned",true)
			end
		end
	end
end

function JobComplete_PriestToAltar()
	Set("PriestIsAtAltar",true)
	timeTot = 0
end

function JobComplete_GiveParlourSpeech()
	Set("SpeechDone",true)
	timeTot = timePerUpdate
end

function JobComplete_PlaceFuneralWreath()
	if timePerUpdate == nil then
		myCoffin = Load(myCoffin,"GraveCoffinParlourStaff","CoffinID",3)
		mySpiritualLeader = Load(mySpiritualLeader,"SpiritualLeaderParlour","SpiritualLeaderID",10000)
	end
	Set("WreathPlaced",true)
	SpawnSpiritualLeader("Leaving")
	myFuneralWreath = Object.Spawn("FuneralWreath",this.Pos.x+1.5,this.Pos.y)
	Set("FuneralWreathID",myFuneralWreath.Id.i)
	myCoffin.Slot1.i = myFuneralWreath.Id.i
	myCoffin.Slot1.u = myFuneralWreath.Id.u
	myFuneralWreath.CarrierId.i = myCoffin.Id.i
	myFuneralWreath.CarrierId.u = myCoffin.Id.u
	myFuneralWreath.Loaded = true
	
	if myLeavingSpiritualLeader.MetroX ~= nil then
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
			myLeavingSpiritualLeader.NavigateTo(myLeavingSpiritualLeader.MetroX,myLeavingSpiritualLeader.MetroY)
			SetOn(myLeavingSpiritualLeader,"BeingTransported",true)
		else
			myLeavingSpiritualLeader.LeaveMap()
		end
	else
		myLeavingSpiritualLeader.LeaveMap()
	end
	Set("SpiritualLeaderLeaving",true)
	timeTot = 2 / myTimeWarpFactor
end

function JobComplete_SayGoodbye1()
	if timePerUpdate == nil then
		myVisitor1 = Load(myVisitor1,"SomeFriendParlour1","Visitor1ID",10000)
	end
	SpawnVisitor(1,"Leaving")
	if myLeavingVisitor1.MetroX ~= nil then
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
			myLeavingVisitor1.NavigateTo(myLeavingVisitor1.MetroX,myLeavingVisitor1.MetroY)
			SetOn(myLeavingVisitor1,"BeingTransported",true)
		else
			myLeavingVisitor1.LeaveMap()
		end
	else
		myLeavingVisitor1.LeaveMap()
	end
	Set("Visitor1Leaving",true)
	timeTot = 2 / myTimeWarpFactor
end

function JobComplete_SayGoodbye2()
	if timePerUpdate == nil then
		myVisitor2 = Load(myVisitor2,"SomeFriendParlour2","Visitor2ID",10000)
	end
	SpawnVisitor(2,"Leaving")
	if myLeavingVisitor2.MetroX ~= nil then
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
			myLeavingVisitor2.NavigateTo(myLeavingVisitor2.MetroX,myLeavingVisitor2.MetroY)
			SetOn(myLeavingVisitor2,"BeingTransported",true)
		else
			myLeavingVisitor2.LeaveMap()
		end
	else
		myLeavingVisitor2.LeaveMap()
	end
	Set("Visitor2Leaving",true)
	timeTot = 2 / myTimeWarpFactor
end

function JobComplete_SayGoodbye3()
	if timePerUpdate == nil then
		myVisitor3 = Load(myVisitor3,"SomeFriendParlour3","Visitor3ID",10000)
	end
	SpawnVisitor(3,"Leaving")
	if myLeavingVisitor3.MetroX ~= nil then
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
			myLeavingVisitor3.NavigateTo(myLeavingVisitor3.MetroX,myLeavingVisitor3.MetroY)
			SetOn(myLeavingVisitor3,"BeingTransported",true)
		else
			myLeavingVisitor3.LeaveMap()
		end
	else
		myLeavingVisitor3.LeaveMap()
	end
	Set("Visitor3Leaving",true)
	timeTot = 2 / myTimeWarpFactor
end

function JobComplete_SayGoodbye4()
	if timePerUpdate == nil then
		myVisitor4 = Load(myVisitor4,"SomeFriendParlour4","Visitor4ID",10000)
	end
	SpawnVisitor(4,"Leaving")
	if myLeavingVisitor4.MetroX ~= nil then
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
			myLeavingVisitor4.NavigateTo(myLeavingVisitor4.MetroX,myLeavingVisitor4.MetroY)
			SetOn(myLeavingVisitor4,"BeingTransported",true)
		else
			myLeavingVisitor4.LeaveMap()
		end
	else
		myLeavingVisitor4.LeaveMap()
	end
	Set("Visitor4Leaving",true)
	timeTot = 2 / myTimeWarpFactor
end

function JobComplete_SayGoodbye5()
	if timePerUpdate == nil then
		myVisitor5 = Load(myVisitor5,"SomeFriendParlour5","Visitor5ID",10000)
	end
	SpawnVisitor(5,"Leaving")
	if myLeavingVisitor5.MetroX ~= nil then
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
			myLeavingVisitor5.NavigateTo(myLeavingVisitor5.MetroX,myLeavingVisitor5.MetroY)
			SetOn(myLeavingVisitor5,"BeingTransported",true)
		else
			myLeavingVisitor5.LeaveMap()
		end
	else
		myLeavingVisitor5.LeaveMap()
	end
	Set("Visitor5Leaving",true)
	timeTot = 2 / myTimeWarpFactor
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

function CalculateTimeWarpFactor(timePassed)
	if timeInit > initTimer then
	
		if timePerUpdate == nil then
			Now = math.floor(math.mod(World.TimeIndex,60))
			if not StartCountdown then
				if Now ~= StartingMinute then
				--	this.SubType = 1
					StartingMinute = Now
					if Now < 59 then
						EndingMinute = Now + 1				-- calculate TimeWarp within the next minute
						StartCountdown = true
					else
						return				-- wait another minute if object is placed 1 minute before next whole hour
					end
				end
			else
				timeTot=timeTot+timePassed
				this.Tooltip = {"tooltip_Init_TimeWarpB",StartingMinute,"A",EndingMinute,"B",Now,"C",timeTot,"D" }	-- show stopwatch
				if Now >= StartingMinute+1 then
					if timeTot >= 5.4 then			-- the result should be around 8 (1/8) for large map with slow time enabled, compare with 5.4 to compensate for lag
						myTimeWarpFactor = 0.125
					--	this.SubType = 2
						myMapSize = "LARGE"
						mySlowTime = "YES"
						timeWarpFound = true
					elseif timeTot >= 4.1 then		-- the result should be around 5.33 (3/16) for medium map with slow time enabled
						myTimeWarpFactor = 0.1875
					--	this.SubType = 3
						myMapSize = "MEDIUM"
						mySlowTime = "YES"
						timeWarpFound = true
					elseif timeTot >= 2.1 then		-- the result should be around 4 (1/4) for small map with slow time enabled
						myTimeWarpFactor = 0.25
					--	this.SubType = 4
						myMapSize = "SMALL"
						mySlowTime = "YES"
						timeWarpFound = true
					elseif timeTot >= 1.4 then		-- the result should be around 2 (1/2) for large map
						myTimeWarpFactor = 0.5
					--	this.SubType = 5
						myMapSize = "LARGE"
						mySlowTime = "NO"
						timeWarpFound = true
					elseif timeTot >= 1.1 then		-- the result should be around 1.33 (3/4) for medium map
						myTimeWarpFactor = 0.75
					--	this.SubType = 6
						myMapSize = "MEDIUM"
						mySlowTime = "NO"
						timeWarpFound = true
					else							-- the result should be around 1 (1) for small map
						myTimeWarpFactor = 1
					--	this.SubType = 7
						myMapSize = "SMALL"
						mySlowTime = "NO"
						timeWarpFound = true
					end
					
					-- Instead of using the hard coded TimeWarp values (found in de saved game and mentioned above),
					-- you could also calculate your own by dividing 1 minute by the time it took to get to that minute.
					-- The result will be approximately the hard coded TimeWarp value, but can be different for each object you place,
					-- depending on how busy the game is, this is should not be used by default:
					
					--timeWarpFound = false					-- enable to see this calculation result in action
					--if timeWarpFound == false then myTimeWarpFactor = 1 / timeTot end
					
					this.Tooltip = {"tooltip_Init_TimeWarpC",StartingMinute,"A",EndingMinute,"B",Now,"C",timeTot,"D",myMapSize,"E",myTimeWarpFactor,"F",mySlowTime,"G" }	-- show results
					
					-- set the timePerUpdate here so we get out of this function
					timePerUpdate = 1 / myTimeWarpFactor	-- will show the results for 3 game minutes
				end
			end
		else		-- calculation completed, so save the results
			timeTot = timeTot+timePassed
			if timeTot > timePerUpdate then
			--	this.SubType = 0						-- change sprite back to normal
				Set("TimeWarp",myTimeWarpFactor)	-- this tells function Update() to proceed
				this.Tooltip = "tooltip_ReadyForAction"
				timePerUpdate = nil				-- reset to nil so function Update() can proceed with normal activity
			end
		end
	else
		timeInit = timeInit+timePassed
		StartingMinute = math.floor(math.mod(World.TimeIndex,60))
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
