local following = true
local offsets = {
	["dad"] = 32,
	["boyfriend"] = 32}
local manual = {
	["dad"] = {800, 300},
	["boyfriend"] = {360, 480},
	
	["enabled"] = true
}

--[[ internal stuffs ]]
local anims = {
	["singL"] = true,
	["singD"] = false,
	["singU"] = false,
	["singR"] = true
}
local singing = {
	["dad"] = false,
	["boyfriend"] = false
}

local function get_pos(char)
	if manual["enabled"] then
		return manual[char]
	else
		local mid, pos = {getMidpointX(char), getMidpointY(char)}, getProperty(char .. ".cameraPosition")
		local offset = getProperty((mustHitSection and char or "opponent") .. "CameraOffset")
		return {
			mid[1] + (mustHitSection and -100 or 150) + (mustHitSection and -pos[1] or pos[1]) + offset[1],
			mid[2] - 100 + pos[2] + offset[2]
		}
	end
end
local function follow(char)
	local anim, pos, offset = getProperty(char .. ".animation.curAnim.name"):sub(1, 5), get_pos(char), offsets[char]
	local pos_clone, horizontal = {pos[1], pos[2]}, anims[anim]
	if following then
		if horizontal then
			pos_clone[1] = pos_clone[1] + (anim == "singL" and -offset or offset)
		elseif horizontal == false then
			pos_clone[2] = pos_clone[2] + (anim == "singU" and -offset or offset)
		end
	end
	setProperty("camFollow.x", pos_clone[1])
	setProperty("camFollow.y", pos_clone[2])
end
function onStartCountdown()
	setProperty("isCameraOnForcedPos", true)
	follow("boyfriend")
end
function onBeatHit()
	if curBeat % 4 == 0 then
		follow(mustHitSection and "boyfriend" or "dad")
	end
end
local function check_idle(char)
	local anim = getProperty(char .. ".animation.curAnim.name")
	if anim == "idle" then
		if singing[char] then
			follow(char)
		end
		singing[char] = false
	end
end
function onTimerCompleted(tag)
	if mustHitSection then
		if tag == "follow_boyfriend_idle" then
			check_idle("boyfriend")
		end
	elseif tag == "follow_dad_idle" then
		check_idle("dad")
	end
end
local function follow_note(note_type, sustained)
	if note_type ~= "No Animation" then 
		local char = mustHitSection and "boyfriend" or "dad"
		if not sustained then
			follow(char)
		end
		singing[char] = true
		runTimer("follow_" .. char .. "_idle", (stepCrochet * getProperty(char .. ".singDuration") + 30) / 1000)
	end
end
function goodNoteHit(id, direction, note_type, sustained)
	follow_note(note_type, sustained)
end
function opponentNoteHit(id, direction, note_type, sustained)
	follow_note(note_type, sustained)
end

function onCreate()
    runTimer('invisTime', 118.91, 1)
	makeLuaSprite('thedeathofmarkheathcliff', 'thedeathofmarkheathcliff', -550, 50);
	addLuaSprite('thedeathofmarkheathcliff', true);
	scaleObject('thedeathofmarkheathcliff', 2.4, 8.4);
	doTweenAlpha('thedeathofmarkheathcliff', 'thedeathofmarkheathcliff', 0, 0.00001, 'linear')

	makeLuaText('dead', '3:33', '300', 590, 19)
    setTextAlignment('dead', 'left')
    setTextSize('dead', '34')
    setObjectCamera('dead', 'camHud')
	addLuaText('dead', true)
	doTweenAlpha('dead', 'dead', 0, 0.00001, 'linear')

	makeLuaText('error', 'ERRORCODE: 333 | Combo Breaks: 333 | Accuracy: 3.33%', '700', 300, 675)
    setTextAlignment('error', 'left')
    setTextSize('error', '20')
    setObjectCamera('error', 'camHud')
	addLuaText('error', true)
	doTweenAlpha('error', 'error', 0, 0.00001, 'linear')

	makeAnimatedLuaSprite('vintage', 'vintage', 0, 0)
	addAnimationByPrefix('vintage', 'vintage', 'idle', 16,true)
	addLuaSprite('vintage',true)
	objectPlayAnimation('vintage', 'vintage')
	setBlendMode('vintage', 'add')
	setProperty('vintage.alpha', .2)
	scaleObject('vintage', 3, 3)
	setObjectCamera('vintage', 'camHud')

	makeLuaSprite('alert', 'warning', 700, 0);
	addLuaSprite('alert', true);
	setObjectCamera('alert', 'camHud')

	--setProperty('healthBar.flipX', true)
	--setProperty('healthBarBG.flipX', true)
	--setProperty('iconP1.flipX', true)
	--setProperty('iconP2.flipX', true)
end

function onCreatePost()
	runTimer('invisTime', 118.91, 1)
	setProperty('gf.visible', false)
    for i= 0, 3 do
		setPropertyFromGroup('playerStrums', i, 'texture', 'markNote_Assets') -- change 'playerStrums' to 'opponentStrums' for DD notes
    end
    for b = 0, getProperty('unspawnNotes.length') - 1 do
		if getPropertyFromGroup('unspawnNotes', b, 'mustPress') then -- change 'if' to 'if not' for DD notes
			setPropertyFromGroup('playerStrums', b, 'texture', 'markNote_Assets')
		end
	end

    for i= 0, 3 do
		setPropertyFromGroup('opponentStrums', i, 'texture', 'alternateNote_Assets') -- change 'playerStrums' to 'opponentStrums' for DD notes
    end
    for b = 0, getProperty('unspawnNotes.length') - 1 do
		if not getPropertyFromGroup('unspawnNotes', b, 'mustPress') then -- change 'if' to 'if not' for DD notes
			setPropertyFromGroup('opponentStrums', b, 'texture', 'alternateNote_Assets')
		end
	end
end

function onTimerCompleted(tag, loops, loopsLeft)
    if tag == 'invisTime' then
		setProperty('timeTxt.visible', false)
		setProperty('scoreTxt.visible', false)
	end
end

function onUpdatePost(elapsed)
	for i = 0, getProperty('unspawnNotes.length') - 1 do
		if getPropertyFromGroup('unspawnNotes', i, 'mustPress') then -- same deal with b
			setPropertyFromGroup('unspawnNotes', i, 'texture', 'markNote_Assets');
		end
	end

    for i = 0, getProperty('unspawnNotes.length') - 1 do
		if not getPropertyFromGroup('unspawnNotes', i, 'mustPress') then -- same deal with b
			setPropertyFromGroup('unspawnNotes', i, 'texture', 'alternateNote_Assets');
		end
	end
end
function onUpdate()
    --Player Notes

    noteTweenX(defaultPlayerStrumX0, 4, defaultPlayerStrumX0 - 650, 0.025)
    noteTweenX(defaultPlayerStrumX1, 5, defaultPlayerStrumX1 - 650, 0.025)
    noteTweenX(defaultPlayerStrumX2, 6, defaultPlayerStrumX2 - 650, 0.025)
    noteTweenX(defaultPlayerStrumX3, 7, defaultPlayerStrumX3 - 650, 0.025)

    --Opponent Notes

    noteTweenX(defaultOpponentStrumX0, 0, defaultOpponentStrumX0 + 650, 0.025)
    noteTweenX(defaultOpponentStrumX1, 1, defaultOpponentStrumX1 + 650, 0.025)
    noteTweenX(defaultOpponentStrumX2, 2, defaultOpponentStrumX2 + 650, 0.025)
    noteTweenX(defaultOpponentStrumX3, 3, defaultOpponentStrumX3 + 650, 0.025)
end

function onStepHit()
	if curStep == 20 then
	doTweenX('alert', 'alert', 0, 2.3, 'expoInOut')
	elseif curStep == 75 then
	doTweenX('alert', 'alert', 700, 1.5, 'expoInOut')
	elseif curStep == 1280 then
	doTweenAlpha('thedeathofmarkheathcliff', 'thedeathofmarkheathcliff', 1, 0.00001, 'linear')
	doTweenAlpha('dead', 'dead', 1, 0.00001, 'linear')
	doTweenAlpha('error', 'error', 1, 0.00001, 'linear')
	end
end