
local timeInit = 0
local initTimer = 0.1 + math.random()	-- only used when object is placed down.
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

local MyDoor = ""
local MyFire = ""

local CrematoriumCoffinPending = ""

local myTotalCoffins = 0
local CrematoriumCoffinNr = 0

local CurrentHour = math.floor(math.mod(World.TimeIndex,1440) /60)
local myCremationHour = 0		-- set to 0 (midnight) (=disabled)

local HourToCremate = { [0] = "disabled", [1] = "01:00", [2] = "02:00", [3] = "03:00", [4] = "04:00", [5] = "05:00", [6] = "06:00", [7] = "07:00", [8] = "08:00", [9] = "09:00", [10] = "10:00", [11] = "11:00", [12] = "12:00", [13] = "13:00", [14] = "14:00", [15] = "15:00", [16] = "16:00", [17] = "17:00", [18] = "18:00", [19] = "19:00", [20] = "20:00", [21] = "21:00", [22] = "22:00", [23] = "23:00" }

function Create()
	if CurrentHour == 0 then							-- when placed at midnight set harvest hour to 11pm, otherwise it would say -1
		myCremationHour = 23
	end
	Set("CremationHour", myCremationHour)
	Set("CremationDone","No")
	Set("DoorTimerDone","No")
	Set("TotalCoffins",myTotalCoffins)
	this.Tooltip = "tooltip_Init_TimeWarpA"
	Set("SmokeTimer",-1)
	Set("DoorID","None")
	Set("FireID","None")
	Set("PendingCoffinsID","None")
	MakeWall()
end

function MakeWall()
	local cell = World.GetCell(this.Pos.x-3,this.Pos.y+1)
	cell.Mat = "PerimeterWall"; cell.Con = 100
	cell = World.GetCell(this.Pos.x-3,this.Pos.y)
	cell.Mat = "PerimeterWall"; cell.Con = 100
	cell = World.GetCell(this.Pos.x-3,this.Pos.y-1)
	cell.Mat = "PerimeterWall"; cell.Con = 100
	
	cell = World.GetCell(this.Pos.x-2,this.Pos.y+1)
	cell.Mat = "PerimeterWall"; cell.Con = 100
	cell = World.GetCell(this.Pos.x-2,this.Pos.y)
	cell.Mat = "BurntFloor"
	cell = World.GetCell(this.Pos.x-2,this.Pos.y-1)
	cell.Mat = "PerimeterWall"; cell.Con = 100
	
	cell = World.GetCell(this.Pos.x-1,this.Pos.y-1)
	cell.Mat = "PerimeterWall"; cell.Con = 100
	cell = World.GetCell(this.Pos.x-1,this.Pos.y)
	cell.Mat = "BurntFloor"
	cell = World.GetCell(this.Pos.x-1,this.Pos.y+1)
	cell.Mat = "PerimeterWall"; cell.Con = 100
	
	cell = World.GetCell(this.Pos.x,this.Pos.y-1)
	cell.Mat = "PerimeterWall"; cell.Con = 100
	cell = World.GetCell(this.Pos.x,this.Pos.y)
	cell.Mat = "BurntFloor"
	cell = World.GetCell(this.Pos.x,this.Pos.y+1)
	cell.Mat = "BurntFloor"
	
	cell = World.GetCell(this.Pos.x+1,this.Pos.y-1)
	cell.Mat = "PerimeterWall"; cell.Con = 100
	cell = World.GetCell(this.Pos.x+1,this.Pos.y)
	cell.Mat = "BurntFloor"
	cell = World.GetCell(this.Pos.x+1,this.Pos.y+1)
	cell.Mat = "BurntFloor"
	
	cell = World.GetCell(this.Pos.x+2,this.Pos.y-1)
	cell.Mat = "PerimeterWall"; cell.Con = 100
	cell = World.GetCell(this.Pos.x+2,this.Pos.y)
	cell.Mat = "PerimeterWall"; cell.Con = 100
	cell = World.GetCell(this.Pos.x+2,this.Pos.y+1)
	cell.Mat = "PerimeterWall"; cell.Con = 100
end

function toggleCremationHourPlusClicked()
	myCremationHour=myCremationHour+1
	if myCremationHour>23 then
		myCremationHour=0
	end
	Set("CremationHour",myCremationHour)
	this.SetInterfaceCaption("toggleCremationHour", "tooltip_button_CremationHour",HourToCremate[this.CremationHour],"X")
	if myCremationHour > 0 then
		local newAge = 0
		if CurrentHour > myCremationHour then
			newAge = CurrentHour-myCremationHour
		else
			newAge = CurrentHour-myCremationHour+24
		end
		if CurrentHour == myCremationHour then
			newAge = 0
		end
	end
	SetMyTooltip()
end

function toggleCremationHourClicked()
	if myCremationHour > 0 then
		myCremationHour=0
	else
		myCremationHour = CurrentHour
		Set("CremationDone","Yes")
	end
	Set("CremationHour",myCremationHour)
	this.SetInterfaceCaption("toggleCremationHour", "tooltip_button_CremationHour",HourToCremate[this.CremationHour],"X")
	SetMyTooltip()
end

function toggleCremationHourMinusClicked()
	myCremationHour=myCremationHour-1
	if myCremationHour<0 then
		myCremationHour=23
	end
	Set("CremationHour",myCremationHour)
	this.SetInterfaceCaption("toggleCremationHour", "tooltip_button_CremationHour",HourToCremate[this.CremationHour],"X")
	if myCremationHour > 0 then
		local newAge = 0
		if CurrentHour > myCremationHour then
			newAge = CurrentHour-myCremationHour
		else
			newAge = CurrentHour-myCremationHour+24
		end
		if CurrentHour == myCremationHour then
			newAge = 0
		end
	end
	SetMyTooltip()
end

function FindPendingCrematoriumCoffins(SpawnIfNotFound)
	print("FindPendingCrematoriumCoffins")
	CrematoriumCoffinPending = Load(CrematoriumCoffinPending,"CrematoriumCoffinPending","PendingCoffinsID",2)
	if Get("PendingCoffinsID") == "None" and SpawnIfNotFound == true then
		print("Spawn new CrematoriumCoffinPending")
		CrematoriumCoffinPending = Object.Spawn("CrematoriumCoffinPending",this.Pos.x+0.75,this.Pos.y+1.25)
		Set("PendingCoffinsID",CrematoriumCoffinPending.Id.i)
	end
end

function FindCrematoriumDoor()
	MyDoor = Load(MyDoor,"CrematoriumDoor","DoorID",3)
	if Get("DoorID") == "None" then
		MyDoor = Object.Spawn("CrematoriumDoor",this.Pos.x+2,this.Pos.y+1.35)
		Set("DoorID",MyDoor.Id.i)
	end
end

function MoveTheDoor(Direction,MoveToX)
	if Get("DoorID") == "None" then FindCrematoriumDoor() end
	if MyDoor.Pos.x >= MoveToX-0.01 and MyDoor.Pos.x <= MoveToX+0.01 then
		Object.ApplyVelocity(MyDoor,0,0)
		MyDoor.Pos.x = MoveToX
		if Direction == "Close" then
			Set("DoorIsClosed",true)
		else
			Set("DoorIsOpen",true)
		end
	else
		if MyDoor.Pos.x > MoveToX then
			print("close door. DoorX: "..MyDoor.Pos.x.."  MoveToX: "..MoveToX)
			if MyDoor.Pos.x - MoveToX > 0 then
				Object.ApplyVelocity(MyDoor,-(MyDoor.Pos.x+0.1 - MoveToX),0,false)
			else
				Object.ApplyVelocity(MyDoor,0,0,false)
				MyDoor.Pos.x = MoveToX
				Set("DoorIsClosed",true)
			end
		elseif MyDoor.Pos.x < MoveToX then
			print("open door. DoorX: "..MyDoor.Pos.x.."  MoveToX: "..MoveToX)
			if MoveToX - MyDoor.Pos.x > 0 then
				Object.ApplyVelocity(MyDoor,MoveToX+0.1 - MyDoor.Pos.x,0,false)
			else
				Object.ApplyVelocity(MyDoor,0,0,false)
				MyDoor.Pos.x = MoveToX
				Set("DoorIsOpen",true)
			end
		end
	end
end

function CountCoffins()
	for n = 0,7 do
		if Get("Slot"..n..".i") > -1 then
			burnedCoffin = GetObject("GraveCoffinLoaded",Get("Slot"..n..".i"),2)
			if burnedCoffin ~= nil and burnedCoffin.SubType ~= nil then
				print("Found coffin at Slot"..n)
				Set("Slot"..n..".i",-1)
				Set("Slot"..n..".u",-1)
				burnedCoffin.Loaded = false
				burnedCoffin.Delete()
				myTotalCoffins = myTotalCoffins + 1
				print("Total Coffins is now: "..myTotalCoffins)
			else
				burnedCoffin = GetObject("GraveCoffinStaffLoaded",Get("Slot"..n..".i"),2)
				if burnedCoffin ~= nil and burnedCoffin.SubType ~= nil then
					print("Found staff coffin at Slot"..n)
					Set("Slot"..n..".i",-1)
					Set("Slot"..n..".u",-1)
					burnedCoffin.Loaded = false
					burnedCoffin.Delete()
					myTotalCoffins = myTotalCoffins + 1
					print("Total Coffins is now: "..myTotalCoffins)
				end
			end
		end
	end
	Set("TotalCoffins",myTotalCoffins)
	if myTotalCoffins > 0 then
		if Get("PendingCoffinsID") == "None" then FindPendingCrematoriumCoffins(true) end
		if myTotalCoffins <= 5 then CrematoriumCoffinPending.SubType = myTotalCoffins end
	end
	SetMyTooltip()
end

function Update( timePassed )
	if this.TimeWarp == nil then
		if World.TimeWarpFactor ~= nil then
			Set("TimeWarp",World.TimeWarpFactor)
		else
			CalculateTimeWarpFactor(timePassed)
		end
		return
	elseif timePerUpdate == nil then
		PreviousHour = math.floor(math.mod(World.TimeIndex,1440) /60)
		myTimeWarpFactor = Get("TimeWarp")
		timePerUpdate = 1 / myTimeWarpFactor
		
		if not Get("CremationHour") then this.Delete() return end
		myCremationHour = Get("CremationHour")
		myTotalCoffins = Get("TotalCoffins")
		
		Interface.AddComponent(this,"toggleCremationHourPlus", "Button", "tooltip_button_CremationHourPlus")
		Interface.AddComponent(this,"toggleCremationHour", "Button", "tooltip_button_CremationHour",HourToCremate[this.CremationHour],"X")
		Interface.AddComponent(this,"toggleCremationHourMinus", "Button", "tooltip_button_CremationHourMinus")
		
		if Get("PendingCoffinsID") ~= "None" then FindPendingCrematoriumCoffins(false) end
		FindCrematoriumDoor()
		if this.DoCremate == true then
			MyFire = Load(MyFire,"Fire","FireID",5)
			timePerUpdate = 0
		end
		if this.DoCremate == true and not Get("DoorIsClosed") then timePerUpdate = 0 end
		if this.DoCremate == true and this.SmokeTimer == -1 and not Get("DoorIsOpen") then timePerUpdate = 0 end
		SetMyTooltip()
	end
	
	timeTot=timeTot+timePassed
	if timeTot>timePerUpdate then
		timeTot=0
		
		PreviousHour = CurrentHour
		CurrentHour = math.floor(math.mod(World.TimeIndex,1440) /60)
		
		
		-- forced cremation by game hour
		
		if CurrentHour == myCremationHour and myCremationHour > 0 then
			if this.CremationDone == "No" and myTotalCoffins > 0 then
				Set("CremationDone","Yes")
				Set("DoCremate",true)
				SetMyTooltip()
				return
			end
		else
			if this.CremationDone == "Yes" then
				Set("CremationDone","No")
			end
		end
		
		-- end cremation
		
		-- forced cremation by doortimer
		
		local hasPower = ( this.Triggered or 0 ) > 0
		if hasPower then
			if this.DoorTimerDone == "No" and myTotalCoffins > 0 then
				myCremationHour = CurrentHour
				Set("CremationHour",myCremationHour)
				this.SetInterfaceCaption("toggleCremationHour", "tooltip_button_CremationHour",HourToCremate[this.CremationHour],"X")
				Set("DoCremate",true)
				Set("DoorTimerDone","Yes")
				SetMyTooltip()
				return
			end
		else
			if this.DoorTimerDone == "Yes" then
				Set("DoorTimerDone","No")
			end
		end
		
		-- end doortimer
		
		
		-- if no CremationHour is specified, or no cremation via DoorTimer issued
		-- then start cremation at the next whole hour if 30 or more coffins are in the Crematorium
		if CurrentHour ~= PreviousHour then
			if myTotalCoffins >= 30 then
				Set("DoCremate",true)
				SetMyTooltip()
			end
			PreviousHour = CurrentHour
		end

		
		if this.DoCremate == true and not Get("CremationInProcess") then
			if not Get("ProcessorDone") then
				if not Get("CremationActivated") then
					print("Activate Crematorium")			-- feed the Processor so the Gravedigger comes to 'Operate the Crematorium'
					FindStackNumbers()
					MyStackedCoffins = Object.Spawn("Stack",this.Pos.x+0.75,this.Pos.y+1.25)
					MyStackedCoffins.Contents = CrematoriumCoffinNr
					MyStackedCoffins.Quantity = myTotalCoffins
					this.Slot0.i = MyStackedCoffins.Id.i
					this.Slot0.u = MyStackedCoffins.Id.u
					MyStackedCoffins.CarrierId.i = this.Id.i
					MyStackedCoffins.CarrierId.u = this.Id.u
					MyStackedCoffins.Loaded = true
					
					FindPendingCrematoriumCoffins(false)
					if Get("PendingCoffinsID") ~= "None" then
						CrematoriumCoffinPending.Delete()
						CrematoriumCoffinPending = ""
						Set("PendingCoffinsID","None")
					end
				
					Set("CremationActivated",true)
					timePerUpdate = 0
				end
				if this.Timer ~= nil and this.Timer > 0 then	-- OperatingTime is set to 2 in production.txt, so he will stay here for at least 2 minutes
					this.Slot0.i = -1				-- Gravedigger is busy operating the Processor, so now unload the processed stack to continue
					this.Slot0.u = -1				-- otherwise he would stay there processing the whole stack which we don't need him to do
					this.Slot1.i = -1
					this.Slot1.u = -1
					this.Slot2.i = -1
					this.Slot2.u = -1
					Set("ProcessorDone",true)
					Set("Timer",0)
				end
			else
				if not Get("SmokeActive") then
					this.SubType = 1
					mySmoke1 = Object.Spawn("SmokeGenerator",this.Pos.x+0.9,this.Pos.y-2)
					mySmoke2 = Object.Spawn("SmokeGenerator",this.Pos.x+0.9,this.Pos.y-2)
					mySmoke3 = Object.Spawn("SmokeGenerator",this.Pos.x+0.9,this.Pos.y-2)
					mySmoke4 = Object.Spawn("SmokeGenerator",this.Pos.x+0.9,this.Pos.y-2)
					mySmoke5 = Object.Spawn("SmokeGenerator",this.Pos.x+0.9,this.Pos.y-2)
					SetMyTooltip()
					Set("SmokeActive",true)
					timePerUpdate = 0
				elseif not Get("DoorIsClosed") then
					MoveTheDoor("Close",this.Pos.x+0.75)
					timePerUpdate = 0
				else
					print("Spawn fire")
					MyFire = Object.Spawn("Fire",this.Pos.x+0.75,this.Pos.y+1.25)
					Set("FireID",MyFire.Id.i)
					print("Fuel: "..MyFire.Fuel.."  Setting Fuel to 30   Intensity: "..MyFire.Intensity.." Timer: "..MyFire.Timer)
					MyFire.Timer = 30
					MyFire.Fuel = 30
					print("Remove coffins")
					local nearbyObject = Find("Stack",2)	-- remove all the stack from the Processor since it's now covered in flames
					if next(nearbyObject) then
						for thatStack, dist in pairs(nearbyObject) do
							if thatStack.Contents == "CrematoriumCoffinStacked" then
								thatStack.Delete()
							end
						end
					end
					nearbyObject = nil
					Set("CremationInProcess",true)
					SetMyTooltip()
					timePerUpdate = 1 / myTimeWarpFactor
				end
			end
		elseif this.DoCremate == true then
			print("Cremation in progress...")
			if MyFire ~= nil and MyFire.SubType ~= nil then
				Set("Damage",0)
				OopsUpsideYourHead()
				print("Fire Intensity: "..MyFire.Intensity)
				timePerUpdate = 1 / myTimeWarpFactor
			elseif MyFire.SubType == nil and this.SmokeTimer == -1 then
				MyFire = ""
				Set("FireID","None")
				Set("Damage",0)
				if MyDoor.Damage < 0.85 then SetOn(MyDoor,"Damage",0) end
				Set("SmokeTimer",2)
				print("Setting SmokeTimer to "..this.SmokeTimer)
				timePerUpdate = 1 / myTimeWarpFactor
			elseif this.SmokeTimer > 1 then
				this.SmokeTimer = this.SmokeTimer - 1
				print("Setting SmokeTimer to "..this.SmokeTimer)
				timePerUpdate = 1 / myTimeWarpFactor
			elseif this.SmokeTimer > 0 then
				print("Remove smoke")
				local nearbyObject = Find("SmokeGenerator",5)
				for thatSmoke, dist in pairs(nearbyObject) do
					thatSmoke.Delete()
				end
				mySmoke1 = nil
				mySmoke2 = nil
				mySmoke3 = nil
				mySmoke4 = nil
				mySmoke5 = nil
				print("Spawn "..myTotalCoffins.."x CrematoriumUrn")
				for u = 1,myTotalCoffins do
					myUrn = Object.Spawn("CrematoriumUrn",this.Pos.x+0.25+math.random(),this.Pos.y+0.75+math.random())
				end
				myTotalCoffins = 0
				Set("TotalCoffins",myTotalCoffins)
				this.SubType = 0
				this.SmokeTimer = this.SmokeTimer - 1
				timePerUpdate = 0
			elseif not Get("DoorIsOpen") then
				MoveTheDoor("Open",this.Pos.x+2)
				timePerUpdate = 0
			else
				print("Cremation finished")
				newRubble = Object.Spawn("Rubble",this.Pos.x+0.25+math.random(),this.Pos.y+0.75+math.random())
				Set("ProcessorDone",nil)
				Set("CremationActivated",nil)
				Set("SmokeActive",nil)
				Set("SmokeTimer",-1)
				Set("DoorIsClosed",nil)
				Set("CremationInProcess",nil)
				Set("DoCremate",nil)
				Set("DoorIsOpen",nil)
				MakeWall()
				timePerUpdate = 1 / myTimeWarpFactor
			end
			SetMyTooltip()
		elseif this.DoCremate == nil then
			CountCoffins()
		end
    end
end

function JobComplete_CremateEntity()
end

function SetMyTooltip()
	if this.DoCremate == true then
		if not Get("DoorIsClosed") then
			this.Tooltip = {"tooltip_CrematoriumInit",myTotalCoffins,"A"}
		else
			if MyFire ~= nil and MyFire.SubType ~= nil then
				this.Tooltip = {"tooltip_CrematoriumActive",math.ceil(MyFire.Intensity*10)+2,"A"}
			else
				this.Tooltip = {"tooltip_CrematoriumActive",this.SmokeTimer,"A"}
			end
		end
	else
		if myTotalCoffins >= 30 then
			this.Tooltip = {"tooltip_CrematoriumIdle",myTotalCoffins,"A",(CurrentHour+1)..":00","B"}
		else
			this.Tooltip = {"tooltip_CrematoriumIdle",myTotalCoffins,"A",HourToCremate[this.CremationHour],"B"}
		end
	end
end

function CalculateTimeWarpFactor(timePassed)
	if timeInit > initTimer then
	
		if timePerUpdate == nil then
			Now = math.floor(math.mod(World.TimeIndex,60))
			if not StartCountdown then
				if Now ~= StartingMinute then
				--	this.SubType = 2
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
					--	this.SubType = 3
						myMapSize = "LARGE"
						mySlowTime = "YES"
						timeWarpFound = true
					elseif timeTot >= 4.1 then		-- the result should be around 5.33 (3/16) for medium map with slow time enabled
						myTimeWarpFactor = 0.1875
					--	this.SubType = 4
						myMapSize = "MEDIUM"
						mySlowTime = "YES"
						timeWarpFound = true
					elseif timeTot >= 2.1 then		-- the result should be around 4 (1/4) for small map with slow time enabled
						myTimeWarpFactor = 0.25
					--	this.SubType = 5
						myMapSize = "SMALL"
						mySlowTime = "YES"
						timeWarpFound = true
					elseif timeTot >= 1.4 then		-- the result should be around 2 (1/2) for large map
						myTimeWarpFactor = 0.5
					--	this.SubType = 6
						myMapSize = "LARGE"
						mySlowTime = "NO"
						timeWarpFound = true
					elseif timeTot >= 1.1 then		-- the result should be around 1.33 (3/4) for medium map
						myTimeWarpFactor = 0.75
					--	this.SubType = 7
						myMapSize = "MEDIUM"
						mySlowTime = "NO"
						timeWarpFound = true
					else							-- the result should be around 1 (1) for small map
						myTimeWarpFactor = 1
					--	this.SubType = 8
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
			--	newLight = Object.Spawn("Light",this.Pos.x-1.5,this.Pos.y+0.5)
			--	newLight = Object.Spawn("Light",this.Pos.x-0.5,this.Pos.y+0.5)
			--	newLight = Object.Spawn("Light",this.Pos.x+0.5,this.Pos.y+0.5)
			--	newLight = Object.Spawn("Light",this.Pos.x+1.5,this.Pos.y+0.5)
			--	this.SubType = 0						-- change sprite back to normal
				Set("TimeWarp",myTimeWarpFactor)	-- this tells function Update() to proceed
				FindCrematoriumDoor()
				timePerUpdate = nil				-- reset to nil so function Update() can proceed with normal activity
			end
		end
	else
		timeInit = timeInit+timePassed
		StartingMinute = math.floor(math.mod(World.TimeIndex,60))
	end
end



function OopsUpsideYourHead()
	local Oops = math.random(0,1000)
	if Oops == 666 then
		print("Oops...")
		SetOn(MyDoor,"Damage",0.85)
		MoveTheDoor("Open",this.Pos.x+2)
		OopsFire1 = Object.Spawn("Fire",this.Pos.x+0.25+math.random(),this.Pos.y+1.75+math.random())
		OopsFire2 = Object.Spawn("Fire",this.Pos.x+0.25+math.random(),this.Pos.y+1.75+math.random())
		OopsFire3 = Object.Spawn("Fire",this.Pos.x+0.25+math.random(),this.Pos.y+1.75+math.random())
		OopsFire4 = Object.Spawn("Fire",this.Pos.x+0.25+math.random()+math.random(),this.Pos.y+2.75+math.random()+math.random())
		OopsFire5 = Object.Spawn("Fire",this.Pos.x+0.25+math.random()+math.random(),this.Pos.y+2.75+math.random()+math.random())
		OopsFire6 = Object.Spawn("Fire",this.Pos.x+0.25+math.random()+math.random(),this.Pos.y+2.75+math.random()+math.random())
	else
		if MyDoor.Damage < 0.85 then SetOn(MyDoor,"Damage",0) end
	end
	Oops = nil
end





function FindStackNumbers()
	local newStack = Object.Spawn("Stack", this.Pos.x, this.Pos.y+2)
	for i = 1,2000 do
		SetOn(newStack,"Quantity",2)
		SetOn(newStack,"Contents",i)
		if newStack.Contents == "CrematoriumCoffinStacked" then
			CrematoriumCoffinNr = i
		end
		if CrematoriumCoffinNr > 1 then
			newStack.Delete()
			print("Stack CrematoriumCoffinNr: "..CrematoriumCoffinNr)
			break
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
	print("trying to find "..type.." with id "..id.." within "..dist.." tiles")
	objs = Object.GetNearbyObjects(type,dist or 1)
	for o,d in pairs(objs) do
		 if o.Id.i == id then
			print("found "..o.Type.." at distance: "..d)
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
