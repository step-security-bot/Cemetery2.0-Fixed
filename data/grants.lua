
function CreateGrants()
	CreateMorgue2()
	CreateParlour2()
	CreateCemetery2()
	CreateCoffinWorkshop2()
	CreateCoffinProduction2()
	CreateCemetery2Jobs()
end

function CreateMorgue2()
	Objective.CreateGrant			( "Grant_Morgue2", 1500, 2500 )
	Objective.SetPreRequisite		( "Unlocked", "Health", 0 )
	
 	Objective.CreateGrant			( "Grant_Morgue2_MorgueRoom", 0, 0 )
	Objective.SetParent				( "Grant_Morgue2" )
	Objective.RequireRoom			( "Morgue", true )
	
	Objective.CreateGrant			( "Grant_Morgue2_MorgueSlabNumber", 0, 0 )
	Objective.SetParent				( "Grant_Morgue2" )
	Objective.RequireObjects		( "MorgueSlab", 1 )
	
	Objective.CreateGrant			( "Grant_Morgue2_MorgueTableNumber", 0, 0 )
	Objective.SetParent				( "Grant_Morgue2" )
	Objective.RequireObjects		( "SmallTableMorgue", 1 )
	
	Objective.CreateGrant			( "Grant_Morgue2_CoffinNumber", 0, 0 )
	Objective.SetParent				( "Grant_Morgue2" )
	Objective.RequireObjects		( "GraveCoffin", 2 )
	
	Objective.CreateGrant			( "Grant_Morgue2_HearseRemoverNumber", 0, 0 )
	Objective.SetParent				( "Grant_Morgue2" )
	Objective.RequireObjects		( "HearseRemover", 1 )
	
end

function CreateParlour2()
	Objective.CreateGrant			( "Grant_Parlour2", 1500, 2500 )
	Objective.SetPreRequisite		( "Unlocked", "Health", 0 )
	Objective.SetPreRequisite		( "Completed", "Grant_Morgue2", 0 )
    Objective.HiddenWhileLocked     ()
		
	Objective.CreateGrant			( "Grant_Parlour2_ParlourRoom", 0, 0 )
	Objective.SetParent				( "Grant_Parlour2" )
	Objective.RequireRoom			( "FuneralParlour", true )
	
	Objective.CreateGrant			( "Grant_Parlour2_ParlourTableNumber", 0, 0 )
	Objective.SetParent				( "Grant_Parlour2" )
	Objective.RequireObjects		( "SmallTableFP", 1 )
	
	Objective.CreateGrant			( "Grant_Parlour2_AltarNumber", 0, 0 )
	Objective.SetParent				( "Grant_Parlour2" )
	Objective.RequireObjects		( "ParlourAltar", 1 )
	
	Objective.CreateGrant			( "Grant_Parlour2_ChairNumber", 0, 0 )
	Objective.SetParent				( "Grant_Parlour2" )
	Objective.RequireObjects		( "ParlourChair", 5 )
end

function CreateCemetery2()
	Objective.CreateGrant			( "Grant_Cemetery2", 1500, 2500 )
	Objective.SetPreRequisite		( "Unlocked", "Health", 0 )
	Objective.SetPreRequisite		( "Completed", "Grant_Parlour2", 0 )
    Objective.HiddenWhileLocked     ()
		
	Objective.CreateGrant			( "Grant_Cemetery2_CemeteryRoom", 0, 0 )
	Objective.SetParent				( "Grant_Cemetery2" )
	Objective.RequireRoom			( "Cemetery", true )
	
	Objective.CreateGrant			( "Grant_Cemetery2_GraveStoneNumber", 0, 0 )
	Objective.SetParent				( "Grant_Cemetery2" )
	Objective.RequireObjects		( "GraveStone", 2 )
	
	Objective.CreateGrant			( "Grant_Cemetery2_GraveNumber", 0, 0 )
	Objective.SetParent				( "Grant_Cemetery2" )
	Objective.RequireObjects		( "GraveUnderConstruction1", 2 )
	
	Objective.CreateGrant			( "Grant_Cemetery2_StaffGraveNumber", 0, 0 )
	Objective.SetParent				( "Grant_Cemetery2" )
	Objective.RequireObjects		( "GraveStaffUnderConstruction1", 2 )
	
	Objective.CreateGrant			( "Grant_Cemetery2_GraveDiggerNumber", 0, 0 )
	Objective.SetParent				( "Grant_Cemetery2" )
	Objective.RequireObjects		( "GraveDigger", 1 )
end

function CreateCoffinWorkshop2()
	Objective.CreateGrant			( "Grant_CoffinWorkshop2", 1500, 2500 )
	Objective.SetPreRequisite		( "Unlocked", "Health", 0 )
    Objective.SetPreRequisite       ( "Unlocked", "Maintainance", 0 )
    Objective.HiddenWhileLocked     ()
		
	Objective.CreateGrant			( "Grant_CoffinWorkshop2_Research", 0, 0 )
	Objective.SetParent				( "Grant_CoffinWorkshop2" )
	Objective.Requires				( "Unlocked", "PrisonLabour", 0 )
	
	Objective.CreateGrant			( "Grant_CoffinWorkshop2_CoffinWorkshopRoom", 0, 0 )
	Objective.SetParent				( "Grant_CoffinWorkshop2" )
	Objective.RequireRoom			( "CoffinWorkshop", true )
	
	Objective.CreateGrant			( "Grant_CoffinWorkshop2_CoffinTableNumber", 0, 0 )
	Objective.SetParent				( "Grant_CoffinWorkshop2" )
	Objective.RequireObjects		( "CoffinTable", 1 )
	
	Objective.CreateGrant			( "Grant_CoffinWorkshop2_GraveDiggerNumber", 0, 0 )
	Objective.SetParent				( "Grant_CoffinWorkshop2" )
	Objective.RequireObjects		( "GraveDigger", 1 )
end

function CreateCoffinProduction2()
	Objective.CreateGrant			( "Grant_CoffinProduction2", 1500, 2500 )
	Objective.SetPreRequisite		( "Unlocked", "Health", 0 )
    Objective.SetPreRequisite       ( "Unlocked", "Maintainance", 0 )
    Objective.HiddenWhileLocked     ()
	
	Objective.CreateGrant			( "Grant_CoffinProduction2_Research", 0, 0 )
	Objective.SetParent				( "Grant_CoffinProduction2" )
	Objective.Requires				( "Completed", "Grant_CoffinWorkshop2", 0 )
	
	Objective.CreateGrant			( "Grant_CoffinProduction2_ProgramPassed", 0, 0 )
	Objective.SetParent				( "Grant_CoffinProduction2" )
	Objective.Requires				( "ReformPassed", "CoffinProduction", 2 )
	
	Objective.CreateGrant			( "Grant_CoffinProduction2_Assigned", 0, 0 )
	Objective.SetParent				( "Grant_CoffinProduction2")
	Objective.Requires				( "PrisonerJobs", "CoffinWorkshop", 1 )
	
	Objective.CreateGrant			( "Grant_CoffinProduction2_CoffinNumber", 0, 0 )
	Objective.SetParent				( "Grant_CoffinProduction2" )
	Objective.RequireManufactured	( "GraveCoffin", 10 )
end

function CreateCemetery2Jobs()
	Objective.CreateGrant			( "Grant_Cemetery2Jobs", 1500, 2500 )
	Objective.SetPreRequisite		( "Completed", "Grant_Cemetery2", 0 )
    Objective.SetPreRequisite       ( "Unlocked", "PrisonLabour", 0 )
    Objective.HiddenWhileLocked     ()

	Objective.CreateGrant			( "Grant_Cemetery2Jobs_Research", 0, 0 )
	Objective.SetParent				( "Grant_Cemetery2Jobs" )
	Objective.Requires				( "Unlocked", "PrisonLabour", 0 )
	
	Objective.CreateGrant			( "Grant_Cemetery2Jobs_ProgramPassed", 0, 0 )
	Objective.SetParent				( "Grant_Cemetery2Jobs" )
	Objective.Requires				( "ReformPassed", "GraveDigging", 2 )
	
	Objective.CreateGrant			( "Grant_Cemetery2Jobs_Assigned", 0, 0 )
	Objective.SetParent				( "Grant_Cemetery2Jobs")
	Objective.Requires				( "PrisonerJobs", "Cemetery", 1 )
	
	Objective.CreateGrant			( "Grant_Cemetery2Jobs_BuryDead", 0, 0 )
	Objective.SetParent				( "Grant_Cemetery2Jobs")
	Objective.RequireObjects		( "GraveLoaded", 1 )
end
