
function Create()

end

function Update()
	newGrave = Object.Spawn("GraveStone",this.Pos.x,this.Pos.y)
	Object.SetProperty(newGrave,"SubType",math.random(0,15))
	this.Delete()
end
