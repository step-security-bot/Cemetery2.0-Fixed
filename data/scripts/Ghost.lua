
local timeTot = 0
local timePerUpdate = 15

function Create()
end

function Update(timePassed)
	timeTot = timeTot+timePassed
	if timeTot > timePerUpdate then
		this.Delete()
	end
end
