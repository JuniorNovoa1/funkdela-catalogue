local thing = {'NOTHING IS WORTH THE RISK', 'KILL YOURSELF', 'THERE IS NOT ENOUGH ROOM FOR BOTH OF US', 'I AM YOUR TRUE SAVIOR', 'LET ME IN', 'SHE IS DEAD'}

function onCreate()
	--Iterate over all notes
	for i = 0, getProperty('unspawnNotes.length')-1 do
		if getPropertyFromGroup('unspawnNotes', i, 'noteType') == 'eye' then
			setPropertyFromGroup('unspawnNotes', i, 'texture', 'eyenote');

			setPropertyFromGroup('unspawnNotes', i, 'multAlpha', 0.4)
			setPropertyFromGroup('unspawnNotes', i, 'missHealth', 0.45)
			setPropertyFromGroup('unspawnNotes', i, 'hitCausesMiss', true)

			setPropertyFromGroup('unspawnNotes', i, 'noteSplashHue', 0);
			setPropertyFromGroup('unspawnNotes', i, 'noteSplashSat', -20);

			if getPropertyFromGroup('unspawnNotes', i, 'mustPress') then
				setPropertyFromGroup('unspawnNotes', i, 'ignoreNote', true); --Miss has penalties
			end
		end
	end
end

--[[
function goodNoteHit(id, direction, noteType, isSustainNote)
	if noteType == 'eye' then
		debugPrint('bruh')
		local number = getRandomInt(1,2)
		debugPrint(thing[number])
	end
end
]]

function noteMiss(id, direction, noteType, isSustainNote)
	if noteType == 'eye' then
		cancelTween('vintageAlphaDown')
		textshit(getRandomInt(1,1000), thing[getRandomInt(1,6)], getRandomInt(1,4), getRandomInt(200,700), getRandomInt(100,400))
		setProperty('eyeV.alpha', 1)
		doTweenAlpha('vintageAlphaDown', 'eyeV', 0, 4, 'linear')
	end
end

function onTimerCompleted(tag, loops, loopsLeft)
end

function textshit(tag, text, fadeTime, xpos, ypos)
	local width = string.len(text)
	makeLuaText(tag, text, (30 * width)/2 + 50, xpos, ypos)
	setTextAlignment(tag, 'center')
	setTextSize(tag, 50)
	addLuaText(tag)
	doTweenAlpha(tag .. 'alpha', tag, 0, fadeTime, 'circInOut')
	doTweenY(tag .. 'X', tag, ypos + 50, fadeTime, 'linear')
end