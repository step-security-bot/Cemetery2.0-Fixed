
local CurrentDay = math.ceil(World.TimeIndex/1440)

function Create()
   local Grave = this.GetNearbyObjects( "GraveStone2", 2 )
 
   for thatGrave, _ in next, Grave do
		Object.SetProperty(thatGrave,"timeCleanup",CurrentDay+60)
		Object.CancelJob(thatGrave,"VisitGrave")
		Object.CreateJob(thatGrave,"CleanGrave")
   end
 
   this.Delete()
end
