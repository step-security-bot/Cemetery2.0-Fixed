
--    Name                 Ambulance
--    Height               5  
--    SpriteScale          1.2

local timeTot=0
local Get = Object.GetProperty
local Set = Object.SetProperty
local Find = Object.GetNearbyObjects
local MyMarker={}
local NeighbourMarkerLeft={}
local NeighbourMarkerRight={}
local MarkerFound=false

function FindMyRoadMarker()
    local roadMarkers = Find(this,"RoadMarker",1500)
    if roadMarkers~=nil then
		if Get(this,"MarkerUID")~=nil then
			for name,dist in pairs(roadMarkers) do
				if Get(name,"MarkerUID")==this.MarkerUID then
					MyMarker=name
					MarkerFound=true
					this.Pos.x = name.Pos.x
					for nameL,dist in pairs(roadMarkers) do		-- also get my neighbourmarker if this marker is on a double lane
						if nameL.Pos.x==this.Pos.x-3 then
							NeighbourMarkerLeft=nameL
							break
						end
					end
					for nameR,dist in pairs(roadMarkers) do		-- also get my neighbourmarker if this marker is on a double lane
						if nameR.Pos.x==this.Pos.x+3 then
							NeighbourMarkerRight=nameR
							break
						end
					end
					return
				end
			end
		else
			local trafficManager = Find(this,"StreetManager",1500)
			if trafficManager~=nil then
				for n,d in pairs(trafficManager) do
					local roadToUse = n.emergencycount
					Set(n,"IE",true)
					for name,dist in pairs(roadMarkers) do
						if Get(name,"EmgTraffic")=="yes" then
							if name.EmergencyMarkerID==roadToUse then
								MyMarker=name
								Set(this,"MarkerUID",MyMarker.MarkerUID)
								MarkerFound=true
								this.Pos.x = name.Pos.x
								for nameL,dist in pairs(roadMarkers) do		-- also get my neighbourmarker if this marker is on a double lane
									if nameL.Pos.x==this.Pos.x-3 then
										NeighbourMarkerLeft=nameL
										break
									end
								end
								for nameR,dist in pairs(roadMarkers) do		-- also get my neighbourmarker if this marker is on a double lane
									if nameR.Pos.x==this.Pos.x+3 then
										NeighbourMarkerRight=nameR
										break
									end
								end
								return
							end
						end
					end
				end
			end
		end
	end
end

function WaitForGateToOpen()
	if Get(this,"GateCount")<=Get(MyMarker,"TotalGates") then
		if Get(MyMarker,"Authorized"..this.GateCount)~=this.HomeUID then
			if Get(MyMarker,"GatePosY"..this.GateCount)-this.Pos.y<=5 then
				this.Speed=-.2
				timePerUpdate=0
				if Get(MyMarker,"RequestFrom"..this.GateCount) == "none" then
					Set(MyMarker,"RequestFrom"..this.GateCount,this.HomeUID)
					if Get(MyMarker,"LargeGate"..this.GateCount)=="yes" then
						if Get(MyMarker,"GatePosX"..this.GateCount)==this.Pos.x+1.5 and next(NeighbourMarkerRight) then
							Set(NeighbourMarkerRight,"RequestFrom"..this.GateCount,this.HomeUID)
						elseif Get(MyMarker,"GatePosX"..this.GateCount)==this.Pos.x-1.5 and next(NeighbourMarkerLeft) then
							Set(NeighbourMarkerLeft,"RequestFrom"..this.GateCount,this.HomeUID)
						end
					end
				end
				if Get(MyMarker,"LinkGate"..this.GateCount)~="no" then
					for j=1,Get(MyMarker,"TotalGates") do
						if Get(MyMarker,"LinkGate"..j)==Get(MyMarker,"LinkGate"..this.GateCount) and Get(MyMarker,"RequestFrom"..j) == "none" then
							Set(MyMarker,"RequestFrom"..j,this.HomeUID)
							if Get(MyMarker,"LargeGate"..j)=="yes" then
								if Get(MyMarker,"GatePosX"..j)==this.Pos.x+1.5 and next(NeighbourMarkerRight) then
									Set(NeighbourMarkerRight,"RequestFrom"..j,this.HomeUID)
								elseif Get(MyMarker,"GatePosX"..j)==this.Pos.x-1.5 and next(NeighbourMarkerLeft) then
									Set(NeighbourMarkerLeft,"RequestFrom"..j,this.HomeUID)
								end
							end
						end
					end
				end
			elseif (Get(MyMarker,"GatePosY"..this.GateCount)-this.Pos.y)<=9 then
				if Get(MyMarker,"LargeGate"..this.GateCount)=="yes" then
					this.Speed=(Get(MyMarker,"GatePosY"..this.GateCount)-this.Pos.y)-4.4
				else
					this.Speed=(Get(MyMarker,"GatePosY"..this.GateCount)-this.Pos.y)-4.9
				end
				timePerUpdate=0
			end
		end
		if Get(MyMarker,"LinkGate"..this.GateCount)=="no" then
			if Get(MyMarker,"Authorized"..this.GateCount)==this.HomeUID and Get(MyMarker,"GateOpen"..this.GateCount)==1 then
				Set(this,"GateCount",this.GateCount+1)
				timePerUpdate=0.2
			end
		else
			if Get(MyMarker,"GatePosY"..this.GateCount)-this.Pos.y<=5 then
				local gatesopencounter=0
				local linkedgatescounter=0
				for j=1,Get(MyMarker,"TotalGates") do
					if Get(MyMarker,"LinkGate"..j)==Get(MyMarker,"LinkGate"..this.GateCount) then
						linkedgatescounter=linkedgatescounter+1
						if (Get(MyMarker,"Authorized"..j)==this.HomeUID and Get(MyMarker,"GateOpen"..j)==1) or (Get(MyMarker,"Authorized"..j)~="none" and Get(MyMarker,"GateOpen"..j)==1 and Get(MyMarker,"LargeGate"..this.GateCount)=="yes") then
							gatesopencounter=gatesopencounter+1
						end
					end
				end
				if gatesopencounter==linkedgatescounter then
					Set(this,"GateCount",this.GateCount+linkedgatescounter)
					timePerUpdate=0.2
				else
					this.Speed=-.2
				end
			end
		end
	end
end

function CloseGatesBehindMe()
	for i=1,this.GateCount do
		if Get(MyMarker,"Authorized"..i)==this.HomeUID then
			if this.Pos.y-Get(MyMarker,"GatePosY"..i)>1.5 then
				Set(MyMarker,"CloseGate"..i,"yes")
				if Get(MyMarker,"LargeGate"..i)=="yes" then
					if Get(MyMarker,"GatePosX"..i)==this.Pos.x+1.5 and next(NeighbourMarkerRight) then
						Set(NeighbourMarkerRight,"CloseGate"..i,"yes")
					elseif Get(MyMarker,"GatePosX"..i)==this.Pos.x-1.5 and next(NeighbourMarkerLeft) then
						Set(NeighbourMarkerLeft,"CloseGate"..i,"yes")
					end
				end
			end
			if this.Pos.y-Get(MyMarker,"GatePosY"..i)>10 then 
				for j=1,this.GateCount do
					if Get(MyMarker,"LinkGate"..j)==Get(MyMarker,"LinkGate"..i) then
						Set(MyMarker,"Authorized"..i,"no")
						Set(MyMarker,"CloseGate"..i,"no")
						if Get(MyMarker,"LargeGate"..i)=="yes" then
							if Get(MyMarker,"GatePosX"..i)==this.Pos.x+1.5 and next(NeighbourMarkerRight) then
								Set(NeighbourMarkerRight,"Authorized"..i,"no")
								Set(NeighbourMarkerRight,"CloseGate"..i,"no")
							elseif Get(MyMarker,"GatePosX"..i)==this.Pos.x-1.5 and next(NeighbourMarkerLeft) then
								Set(NeighbourMarkerLeft,"Authorized"..i,"no")
								Set(NeighbourMarkerLeft,"CloseGate"..i,"no")
							end
						end
					end
				end
			end
		end
	end
end

function Create()
	Set(this,"HomeUID","Ambulance_"..me["id-uniqueId"])
	Set(this,"GateCount",1)
	this.Speed=-.2
end

function DeleteVehicleClicked()
	this.Delete()
end

function FindGraves()
--	nearbyGraveCoffins = Find("GraveCoffin",10000)
--	for thatCoffin, dist in pairs(nearbyGraveCoffins) do
--		if thatCoffin.Slot0.i == -1 then
--			this.Delete()
--		end
--	end
	if not Get(this,"FromParlour") then
		nearbyRemover = Find("HearseRemover",10000)
		if next(nearbyRemover) then
			print("Hearse Remover found, deleting myself")
			this.Delete()
		end
	end
end

function Update(timePassed)
	if timePerUpdate==nil then
		FindGraves()
		Interface.AddComponent( this,"DeleteVehicle", "Button", "Delete")
		this.Speed=-.2
		FindMyRoadMarker()
		this.Speed=-.2
		if Get(this,"HomeUID")==nil then this.Delete() end
		this.Speed=-.2
		timePerUpdate=0.2
		this.Speed=-.2
	end
	timeTot=timeTot+timePassed
	if timeTot>=timePerUpdate then
		timeTot=0
		if this.State=="Arriving" or this.State=="Leaving" then
			if Get(MyMarker,"TotalGates")~=nil then
				CloseGatesBehindMe()
				WaitForGateToOpen()
				this.Tooltip="\nVehicle ID: "..this.HomeUID.."\n\nDistance to gate "..this.GateCount..": "..Get(MyMarker,"GatePosY"..this.GateCount)-this.Pos.y.."  Speed: "..this.Speed
			else
				if MarkerFound==true then	-- marker got replaced by a new one, delete vehicle
					this.Delete()
				else
					if this.Tooltip~=this.State then
						this.Tooltip=this.State
					end
				end							-- else there were no markers at all, so do nothing
			end
		else
			if this.Tooltip~=this.State then
				this.Tooltip=this.State
			end
		end
	end
end
