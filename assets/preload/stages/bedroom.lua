function onCreate()
	-- background shit
	makeLuaSprite('stageback', 'bedwall', -600, -300);
	addLuaSprite('stageback', false);
	scaleObject('stageback', 1.4, 1.4);

	makeLuaSprite('tablething', 'tablebed', 850, 520);
	addLuaSprite('tablething', true);
	scaleObject('tablething', 1.4, 1.4);

	makeLuaSprite('bedthing', 'bed', -550, 350);
	addLuaSprite('bedthing', false);
	scaleObject('bedthing', 1.4, 1.4);
	
	addVCREffect('camGame',0.06,true,true,true)
	close(true); --For performance reasons, close this script once the stage is fully loaded, as this script won't be used anymore after loading the stage
end

