
local Find = Object.GetNearbyObjects
local timeTot = 0
local timePerUpdate = 2

function Update(timePassed)
	timeTot = timeTot + timePassed
	if timeTot >= timePerUpdate then
		timeTot = 0
		
		if this.Slot4.i > -1 then
			loadedBoxes = Find(this,"Box",1)
			if next(loadedBoxes) then
				for thatBox, dist in pairs(loadedBoxes) do
					if thatBox.Id.i == this.Slot4.i then
						thatBox.Delete()
						newCoffin = Object.Spawn("GraveCoffin",this.Pos.x,this.Pos.y)
						this.Slot4.i = newCoffin.Id.i
						this.Slot4.u = newCoffin.Id.u
						newCoffin.CarrierId.i = this.Id.i
						newCoffin.CarrierId.u = this.Id.u
						newCoffin.Loaded = true
						break
					end
				end
			end
		end
		if this.Slot5.i > -1 then
			loadedBoxes = Find(this,"Box",1)
			if next(loadedBoxes) then
				for thatBox, dist in pairs(loadedBoxes) do
					if thatBox.Id.i == this.Slot5.i then
						thatBox.Delete()
						newCoffin = Object.Spawn("GraveCoffin",this.Pos.x,this.Pos.y)
						this.Slot5.i = newCoffin.Id.i
						this.Slot5.u = newCoffin.Id.u
						newCoffin.CarrierId.i = this.Id.i
						newCoffin.CarrierId.u = this.Id.u
						newCoffin.Loaded = true
						break
					end
				end
			end
		end
	end
end
