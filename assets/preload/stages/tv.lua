local followchars = true
local xx = 700
local yy = 360
local xx2 = 1000
local yy2 = 760
local ofs = 30

function onCreate()
	-- background shit
	makeLuaSprite('back', 'back', 50, 350);
	scaleObject('back', 1, 0)
	addLuaSprite('back', false);

	makeAnimatedLuaSprite('vintage', 'vintage', 0, 0)
	addAnimationByPrefix('vintage', 'vintage', 'idle',16,true)
	addLuaSprite('vintage',true)
	setProperty('vintage.alpha', 0)
	objectPlayAnimation('vintage', 'vintage')
	setBlendMode('vintage', 'add')
	scaleObject('vintage', 3, 3)

	makeLuaSprite('front', 'front', -350, -200);
	addLuaSprite('front', true);

	addVCREffect('camGame',0.075,true,true,true)

end

function onStartCountdown()
	setProperty('dad.alpha', 0)
	setProperty('boyfriend.alpha', 0)
	setProperty('gf.alpha', 0)
	return Function_Continue
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

function onSongStart()
	doTweenY('line', 'back.scale', 0.6, 0.8, 'circInOut')
end

function onTweenCompleted(tag)
	if tag == 'line' then doTweenAlpha('vintage', 'vintage', 1, 0.6, 'linear'); doTweenAlpha('dad', 'dad', 1, 0.6, 'linear') end
end