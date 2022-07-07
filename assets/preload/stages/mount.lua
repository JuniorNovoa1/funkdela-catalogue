
local followchars = true
local xx = 1000
local yy = 760
local xx2 = 1000
local yy2 = 760
local ofs = 30



function onCreate()
	makeLuaSprite('stageback', 'goul', -600, -500);
	addLuaSprite('stageback', false);
	doTweenAlpha('stageback', 'stageback', 0, 0.00001, 'linear')
	addVCREffect('camGame',0.06,true,true,true)
end

function onTimerCompleted(tag, loops, loopsLeft)
	if tag == 'glitch' then
		doTweenAlpha('stageback', 'stageback', 1, 0.5, 'linear')
		doTweenAlpha('waves', 'waves', 0, 0.7, 'circInOut');
	end
end

function onSongStart()
	runTimer('glitch', 29.4)
end

function onCreatePost()
	makeAnimatedLuaSprite('waves', 'waves', -600, -500)
	addAnimationByPrefix('waves', 'idle', 'idle', 16, true)
	setObjectCamera('waves', 'camGame')
	setProperty('waves.alpha', 0)
	scaleObject('waves', 1420/512, 920/512)
	addLuaSprite('waves', true);
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

function onStartCountdown()
	setProperty('gf.alpha', 0)
	return Function_Continue
end

function onStepHit()
	if curStep == 24 then
		xx = 200; yy = 100
    elseif curStep == 192 then
		doTweenAlpha('waves', 'waves', 1, 1, 'circInOut')
	end
end

function onUpdate(elapsed)
	if followchars == true then
		if mustHitSection == false then
			setProperty('defaultCamZoom',0.8)
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
			setProperty('defaultCamZoom',0.96)
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