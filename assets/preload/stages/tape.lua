local bruh = true
local alpha = true

function onCreate()
    makeLuaSprite('gray', 'gray', -300, -300)
    addLuaSprite('gray')
    setProperty('gray.alpha', 0.4)

    makeLuaSprite('bg', 'bg', -540, -725)
    addLuaSprite('bg', false)

    makeLuaSprite('layer', 'layer', -540, -725)
    addLuaSprite('layer', true)

    addVCREffect('camGame',0.06,true,true,true)
	close(true); --For performance reasons, close this script once the stage is fully loaded, as this script won't be used anymore after loading the stage
end

