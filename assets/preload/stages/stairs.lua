local followchars = true
local xx = 1340
local yy = 560
local xx2 = 1340
local yy2 = 560
local ofs = 30

local assets = {'backpiece', 'midwall', 'stairs', 'frontwall'}; local xpos = {100, -400, -520, 1700}; local ypos = {350, 0, -30, 100}

function onCreate()
	addCharacterToList('dream_intruder', 'dad')
	addCharacterToList('dream_mark', 'bf')
	addVCREffect('camGame',0.06,true,true,true)
end

function onCreatePost()
    setProperty('gf.alpha', 0)

	makeLuaSprite('dreambackpiece', 'dreambackpiece', 100, 350); scaleObject('dreambackpiece', 10, 10);addLuaSprite('dreambackpiece'); setProperty('dreambackpiece.alpha', 0)

	for i = 2,4 do makeAnimatedLuaSprite('dream'..assets[i], 'dream'..assets[i], xpos[i], ypos[i]); addAnimationByPrefix('dream'..assets[i], 'idle', assets[i], 12, true); setProperty(assets[i]..'.alpha', 0); if i < 4 then addLuaSprite('dream'..assets[i]) else addLuaSprite('dream'..assets[i], true) end ; objectPlayAnimation('dream'..assets[i], 'idle', false); setProperty('dream'..assets[i]..'.alpha', 0) end
	for i = 1,4 do makeLuaSprite(assets[i], ''..assets[i], xpos[i], ypos[i]); if i < 4 then addLuaSprite(assets[i]) else addLuaSprite(assets[i], true) end; end

	makeAnimatedLuaSprite('waves', 'waves', -200, -100); addAnimationByPrefix('waves', 'idle', 'idle', 16, true); setObjectCamera('waves', 'camGame'); setProperty('waves.alpha', 0); scaleObject('waves', 1420/512, 920/512); addLuaSprite('waves', true);
	scaleObject('waves', 5.2, 4)
	setProperty('waves.antialiasing', false)

	makeAnimatedLuaSprite('vintage', 'vintage', 0, 0)
	addAnimationByPrefix('vintage', 'vintage', 'idle', 16,true)
	addLuaSprite('vintage',true)
	objectPlayAnimation('vintage', 'vintage')
	setBlendMode('vintage', 'add')
	setProperty('vintage.alpha', .2)
	scaleObject('vintage', 3, 3)
	setObjectCamera('vintage', 'camHud')
end

function onStepHit()
	if curStep == 10 then xx = 550; yy = 770; end
	if curStep == 1590 then doTweenAlpha('waves1', 'waves', 1, 6, 'circInOut') end
	if curStep == 1664 then doTweenAlpha('waves2', 'waves', 0, 1, 'circInOut'); for i = 1,3 do setProperty(assets[i]..'.alpha', 0) end; setProperty('dreambackpiece.alpha', 1); setProperty('dreammidwall.alpha', 1); setProperty('dreamstairs.alpha', 1); setProperty('backpiece.alpha', 0); setProperty('midwall.alpha', 0); setProperty('stairs.alpha', 0); triggerEvent('Change Character', 0, 'dream_mark'); triggerEvent('Change Character', 1, 'dream_intruder'); setProperty('frontwall.alpha', 0); setProperty('dreamfrontwall.alpha', 1) end
	if curStep == 2424 then doTweenAlpha('waves3', 'waves', 1, 0.8, 'linear') end
	if curStep == 2432 then for i = 1,3 do setProperty(assets[i]..'.alpha', 1) end; setProperty('dreambackpiece.alpha', 0); setProperty('dreammidwall.alpha', 0); setProperty('dreamstairs.alpha', 0); setProperty('backpiece.alpha', 1); setProperty('midwall.alpha', 1); setProperty('stairs.alpha', 1); triggerEvent('Change Character', 0, 'lilmark'); triggerEvent('Change Character', 1, 'intruder'); setProperty('frontwall.alpha', 1); setProperty('dreamfrontwall.alpha', 0); doTweenAlpha('waves4', 'waves', 0, 0.8, 'linear') end
end

function onUpdate(elapsed)
	if followchars == true then
		if mustHitSection == false then
		  if getProperty('dad.animation.curAnim.name') == 'singLEFT' then
			triggerEvent('Camera Follow Pos',xx-ofs,yy)
		  end
		  if getProperty('dad.animation.curAnim.name') == 'singRIGHT' then
			triggerEvent('Camera Follow Pos',xx+ofs,yy)
		  end
		  if getProperty('dad.animation.curAnim.name') == 'singUP' then
			triggerEvent('Camera Follow Pos',xx,yy-ofs)
		  end
		  if getProperty('dad.animation.curAnim.name') == 'singDOWN' then
			triggerEvent('Camera Follow Pos',xx,yy+ofs)
		  end
		  if getProperty('dad.animation.curAnim.name') == 'singLEFT-alt' then
			triggerEvent('Camera Follow Pos',xx-ofs,yy)
		  end
		  if getProperty('dad.animation.curAnim.name') == 'singRIGHT-alt' then
			triggerEvent('Camera Follow Pos',xx+ofs,yy)
		  end
		  if getProperty('dad.animation.curAnim.name') == 'singUP-alt' then
			triggerEvent('Camera Follow Pos',xx,yy-ofs)
		  end
		  if getProperty('dad.animation.curAnim.name') == 'singDOWN-alt' then
			triggerEvent('Camera Follow Pos',xx,yy+ofs)
		  end
		  if getProperty('dad.animation.curAnim.name') == 'idle-alt' then
			triggerEvent('Camera Follow Pos',xx,yy)
		  end
		  if getProperty('dad.animation.curAnim.name') == 'idle' then
			triggerEvent('Camera Follow Pos',xx,yy)
		  end
		else
		  if getProperty('boyfriend.animation.curAnim.name') == 'singLEFT' then
			triggerEvent('Camera Follow Pos',xx2-ofs,yy2)
		  end
		  if getProperty('boyfriend.animation.curAnim.name') == 'singRIGHT' then
			triggerEvent('Camera Follow Pos',xx2+ofs,yy2)
		  end
		  if getProperty('boyfriend.animation.curAnim.name') == 'singUP' then
			triggerEvent('Camera Follow Pos',xx2,yy2-ofs)
		  end
		  if getProperty('boyfriend.animation.curAnim.name') == 'singDOWN' then
			triggerEvent('Camera Follow Pos',xx2,yy2+ofs)
		  end
		  if getProperty('boyfriend.animation.curAnim.name') == 'idle-alt' then
			triggerEvent('Camera Follow Pos',xx2,yy2)
		  end
		  if getProperty('boyfriend.animation.curAnim.name') == 'idle' then
			triggerEvent('Camera Follow Pos',xx2,yy2)
		  end
		end
	else
		triggerEvent('Camera Follow Pos','','')
	end
end