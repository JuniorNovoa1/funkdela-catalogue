local tic = 1
local letter = 1
local bruh = true
local alpha = true
local loosing = false
local pos = {190, 850}
local txt = {'one', 'two'}
local allshit = {'gray', 'layer'}
local anims = {'A', 'B', 'C', 'D', 'E'}
local assets = {'revealM', 'revealC', 'Alterlayer', 'Alterlayer2', 'Alterlayer3', 'black', 'eyes', 'markreveal', 'layerNORMAL', 'Alterlayer', 'cesarreveal', 'bighead', 'vintage'}

function IconFilterShit()
    setPropertyFromClass('GameOverSubstate', 'characterName', 'cesar')
    if downscroll then
        makeAnimatedLuaSprite('cIcon', 'cesariconss', 635, 15)
    else
        makeAnimatedLuaSprite('cIcon', 'cesariconss', 635, 580)
    end
    addAnimationByPrefix('cIcon', 'quiet', 'cesarstill', 1, true)
    addAnimationByPrefix('cIcon', 'shakey', 'shakey', 24, true)
    setObjectCamera('cIcon', 'camHud')
    addLuaSprite('cIcon', true)
    objectPlayAnimation('cIcon', 'quiet', true)

    makeAnimatedLuaSprite('vintage', 'vintage', -200, -350)
    scaleObject('vintage', 3, 3)
    addAnimationByPrefix('vintage', 'idle', 'idle', 16, true)
    objectPlayAnimation('vintage', 'idle', true)
    setBlendMode('vintage', 'lighten')
    setObjectCamera('vintage', 'camHud')
    setProperty('vintage.alpha', 0.3)
    addLuaSprite('vintage', true)

    makeAnimatedLuaSprite('eyeV', 'vintage', -200, -350)
    scaleObject('eyeV', 3, 3)
    addAnimationByPrefix('eyeV', 'idle', 'idle', 16, true)
    objectPlayAnimation('eyeV', 'idle', true)
    --setBlendMode('eyeV', 'add')
    setObjectCamera('eyeV', 'camHud')
    setProperty('eyeV.alpha', 0.01)
    addLuaSprite('eyeV', true)
end

function preCacheShit()
    for i = 1,#assets do
        precacheImage(assets[i])
    end
    precacheSound('boomend')
end

function onCreate()
    preCacheShit()
end

function onCreatePost()
    makeLuaText('mark', 'Mark Heathcliff', '424', 140, 90)
    setTextAlignment('mark', 'left')
    setTextSize('mark', '40')
    setObjectCamera('mark', 'camGame')
    setProperty('mark.alpha', 0.01)
    makeLuaText('cesar', 'Cesar Torres', '424', 825, 90)
    setTextAlignment('cesar', 'left')
    setObjectCamera('cesar', 'camGame')
    setTextSize('cesar', '40')
    setProperty('cesar.alpha', 0.01)


    IconFilterShit()

    makeLuaSprite('gray2', 'gray', -300, -300)
    addLuaSprite('gray2', true)
    setProperty('gray2.alpha', 0.08)

    setProperty('iconP1.alpha', 0.01)

    addLuaText('mark')
    addLuaText('cesar')



    --setBlendMode('vintage', 'darken')

    for i = 1,2 do
        makeLuaText('Victim'..i, 'victim ' .. txt[i], 324, pos[i], 100)
        setTextAlignment('Victim'..i, 'left')
        setObjectCamera('Victim'..i, 'camGame')
        setTextSize('Victim'..i, '40')
        setProperty('Victim'..i..'.alpha', 0.01)
        addLuaText('Victim'..i)

    end
end

function onUpdate(elapsed)
    local helth = getProperty('health')

    if bruh == true then
        setProperty('gf.alpha', 0.01)
    end
    if alpha == true then
        for i = 0,7 do
            setPropertyFromGroup('strumLineNotes', i, 'alpha', 0)
        end
    end
    if helth > 2 then helth = 2 end

    setProperty('cIcon.x', 635 - 290 * (helth-1))

    if getProperty('health') < 0.5 and loosing == false then
        objectPlayAnimation('cIcon', 'shakey', false)
        loosing = true
    elseif loosing == true and getProperty('health') >= 0.5 then
        objectPlayAnimation('cIcon', 'quiet', false)
        loosing = false
    end
end

function onSongStart()
    for i = 1,2 do
        doTweenAlpha('appear'..i, 'Victim'..i, 1, 1, 'linear')
        setObjectCamera('Victim', 'camgame')
    end

    runTimer('dissAppear', 2.0)
    runTimer('nameOneAppear', 4.0)
    runTimer('nameTwoAppear', 4.0)
    runTimer('nameOneDisappear', 6.0)
    runTimer('nameTwoDisappear', 6.0)

    bruh = false
    runTimer('alphaSHIT', 4)
end

function onTimerCompleted(tag, loops, loopsLeft)
    if tag == 'alphaSHIT' then
        alpha = false
        for i = 0,7 do
            noteTweenAlpha('noteAppear'..i, i, 0.6, 2, 'linear')
        end
    end

    if tag == 'dissAppear' then
        for i = 1,2 do
            doTweenAlpha('appear'..i, 'Victim'..i, 0, 1, 'linear')
        end
    end

    if tag == 'nameOneAppear' then
            doTweenAlpha('nameOneAppear', 'mark', 1, 1.5, 'linear')
        end

    if tag == 'nameTwoAppear' then
            doTweenAlpha('nameTwoAppear', 'cesar', 1, 1.5, 'linear')
        end

    if tag == 'nameOneDisappear' then
            doTweenAlpha('nameOneDisappear', 'mark', 0, 1, 'linear')
        end

    if tag == 'nameTwoDisappear' then
            doTweenAlpha('nameTwoDisappear', 'cesar', 0, 1, 'linear')
        end

    if tag == 'WHOAREYOU' then
        setProperty('revealC.x', 760)
        setProperty('revealC.y', -160 - 7 * (loops - loopsLeft))
        if tic == 1 then
            setProperty('black.alpha', 1)
            tic = 2
        elseif tic == 2 then
            setProperty('black.alpha', 0.01)
            if letter < 4 then objectPlayAnimation('revealC', anims[letter], true) else setProperty('revealC.alpha', 0.01); setProperty('bighead.alpha', 1) end
            letter = letter + 1
            tic = 1
        end

        if loopsLeft == 0 then
            playSound('boomend')
            setProperty('revealC.x', 730)
            setProperty('revealC.y', -220)
            scaleObject('revealC', 1, 1.3)
            setProperty('Alterlayer.alpha', 0.01)
            setProperty('AlterlayerB.alpha', 1)
            runTimer('eyes', 2.6)
        end
    end

    if tag == 'eyes' then
        setProperty('black.alpha', 1)
        makeLuaSprite('eyes', 'eyes', 740, 30)
        addLuaSprite('eyes', true)
    end
end

function onStepHit()
    if curStep == 1334 then
        nothingIsWorthTheRisk()
    end

end

function nothingIsWorthTheRisk()
    setProperty('camHUD.alpha', 0.01)
    for i = 0,7 do
        setPropertyFromGroup('strumLineNotes', i, 'alpha', 0)
    end

    setProperty('dad.alpha', 0.01)
    setProperty('boyfriend.alpha', 0.01)

    for i = 1,#allshit do
        removeLuaSprite(allshit[i], true)
    end

    makeLuaSprite('revealM', 'markreveal', 100, 100)
    addLuaSprite('revealM', true)

    makeLuaSprite('Alterlayer', 'layerNORMAL', -540, -725)
    addLuaSprite('Alterlayer', true)

    makeLuaSprite('AlterlayerB', 'Alterlayer', -540, -725)
    setProperty('AlterlayerB.alpha', 0.01)
    addLuaSprite('AlterlayerB', true)


    makeAnimatedLuaSprite('revealC', 'cesarreveal', 770, 100)
    for i = 1,4 do
        addAnimationByPrefix('revealC', anims[i], anims[i], 24, true)
    end
    addLuaSprite('revealC', true)
    objectPlayAnimation('revealC', 'A', true)

    makeLuaSprite('bighead', 'bighead', 690, -290)
    scaleObject('bighead', 1, 1.25)
    setProperty('bighead.alpha', 0.01)
    addLuaSprite('bighead', true)


    makeLuaSprite('Alterlayer2', 'Alterlayer2', -540, -725)
    setProperty('Alterlayer2.alpha', 0.01)
    addLuaSprite('Alterlayer2', true)

    makeLuaSprite('Alterlayer3', 'Alterlayer3', -540, -725)
    setProperty('Alterlayer3.alpha', 0.01)
    addLuaSprite('Alterlayer3', true)


    makeLuaSprite('black', 'black', -540, -725)
    scaleObject('black', 2, 2)
    setProperty('black.alpha', 0.01)
    addLuaSprite('black', true)

    runTimer('WHOAREYOU', 0.15, 8)

    makeAnimatedLuaSprite('Vint', 'vintage', -200, -350)
    scaleObject('Vint', 3, 3)
    addAnimationByPrefix('Vint', 'idle', 'idle', 16, true)
    objectPlayAnimation('Vint', 'idle', true)
    setBlendMode('Vint', 'lighten')
    setObjectCamera('Vint', 'camGame')
    setProperty('Vint.alpha', 0.3)
    addLuaSprite('Vint', true)
end

function onGameOver()
    alpha = false
    return Function_Continue;
end