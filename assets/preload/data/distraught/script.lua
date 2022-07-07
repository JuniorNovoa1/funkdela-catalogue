function onCreatePost() -- this here only happens once, that's what creation does
	for i= 0, 3 do
		setPropertyFromGroup('playerStrums', i, 'texture', 'markNote_Assets') -- change 'playerStrums' to 'opponentStrums' for DD notes
    end
    for b = 0, getProperty('unspawnNotes.length') - 1 do
		if getPropertyFromGroup('unspawnNotes', b, 'mustPress') then -- change 'if' to 'if not' for DD notes
			setPropertyFromGroup('playerStrums', b, 'texture', 'markNote_Assets')
		end
	end

    for i= 0, 3 do
		setPropertyFromGroup('opponentStrums', i, 'texture', 'intruderNote_Assets') -- change 'playerStrums' to 'opponentStrums' for DD notes
    end
    for b = 0, getProperty('unspawnNotes.length') - 1 do
		if not getPropertyFromGroup('unspawnNotes', b, 'mustPress') then -- change 'if' to 'if not' for DD notes
			setPropertyFromGroup('opponentStrums', b, 'texture', 'intruderNote_Assets')
		end
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
			setPropertyFromGroup('unspawnNotes', i, 'texture', 'intruderNote_Assets');
		end
	end
end