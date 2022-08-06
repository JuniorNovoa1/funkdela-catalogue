local eyeCount = 1
local anims = {'eyeidle', 'open', 'close'}; local loops = {true, false, false}
local eyeChecks = {}

function onCreate()
	precacheImage('eyemechani9c')
	setPropertyFromClass('flixel.FlxG', 'mouse.visible', true)
end

function onDestroy()
	setPropertyFromClass('flixel.FlxG', 'mouse.visible', false)
end

function onEvent(name, value1, value2)
	if name == 'eye' then eye() end
end

function eye()
	makeAnimatedLuaSprite('eye'..eyeCount, 'eyemechani9c', getRandomInt(200, 1100), getRandomInt(200, 600))
	for i = 1,3 do addAnimationByPrefix('eye'..eyeCount, anims[i], anims[i], 20, loops[i]) end
	setObjectCamera('eye'..eyeCount, 'camHud'); scaleObject('eye'..eyeCount, 1.2, 1.2)
	objectPlayAnimation('eye'..eyeCount, 'open')
	setProperty('eye'..eyeCount..'.alpha', 0.99)
	addLuaSprite('eye'..eyeCount, true)

	doTweenAlpha('eye'..eyeCount,'eye'..eyeCount, 1, 0.47, 'linear')
	runTimer('eye'..eyeCount, 3)
	eyeChecks[eyeCount] = true

	eyeCount = eyeCount + 1
end

function onTweenCompleted(tag)
	if tag:startswith('eye') then objectPlayAnimation(tag, 'eyeidle') end
	if tag:endswith('close') then setProperty(butch(tag)..'.alpha', 0) end
end

function onTimerCompleted(tag, loops, loopsLeft)
	if tag:startswith('eye') then setProperty('health', 1.99) end
end


function string:startswith(start)
    return self:sub(1, #start) == start
end

function string:endswith(ending)
    return ending == "" or self:sub(-#ending) == ending
end

function butch(str)
	local result = {}; local num = 1
	local ret = ''

	for i in string.gmatch(str, "%S+") do
	   table.insert(result, num, i)
	   num = num + 1
	end

	ret = result[1]..result[2]
	return ret
end

function onUpdate()
	if mouseClicked('left') then
		for i = 1,eyeCount do
			local eyeX = getProperty('eye'..i..'.x'); local eyeY = getProperty('eye'..i..'.y')
			local mouseX = getMouseX('hud'); local mouseY = getMouseY('hud')

			if (mouseX - eyeX) >= 0 and (mouseX - eyeX) <= 144 and (mouseY - eyeY) >= 0 and (mouseY - mouseY) <= 96 and eyeChecks[i] == true then
				setProperty('eye'..i..'.alpha', 0)
				objectPlayAnimation('eye'..i, 'close')
				eyeChecks[i] = false
				cancelTimer('eye'..i)
				doTweenAlpha('eye '..i..' close','eye'..i, 1, 0.47, 'linear')
			end
		end
	end
end