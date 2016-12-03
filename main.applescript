tell application "FileMaker Pro Advanced"
	tell database "Atelier"
		set ClientID to cell "ADR_CodeClient" of current record
		if (ClientID = "") then display alert "Cette fiche n'a pas de Code Client..." as critical buttons {"Done"} cancel button "Done"
	end tell
	tell database "ADRESSES"
		tell application "System Events" to keystroke "j" using command down
	end tell
	tell (every record whose cell "Code" is equal to ClientID)
		set FirstName to cell "Nom"
		set Lastname to cell "Prénom"
		set NPA to cell "NPA"
		set Ville to cell "Ville"
		set Rue to cell "Adresse"
		set Num to cell "TEL mobile"
		set Mail to cell "e mail"
		if (Num = "") then set Num to cell "TEL prof. 1"
		if (Num = "") then set Num to cell "TEL domicile"
	end tell
end tell
set cleanedNumber to CleanTheNumber(Num)
on CleanTheNumber(Num)
	set theDigits to {"0", "1", "2", "3", "4", "5", "6", "7", "8", "9"}
	set cleanedNumber to ""
	repeat with i from 1 to length of Num
		set j to (character i of Num)
		if j = "+" then set cleanedNumber to cleanedNumber & "00"
		if j is in theDigits then set cleanedNumber to cleanedNumber & j
	end repeat
	return cleanedNumber
end CleanTheNumber

tell application "Safari"
	activate
	do JavaScript "document.forms['repairFormBean']['firstname'].value = '" & FirstName & "'" in document 1
	do JavaScript "document.forms['repairFormBean']['email'].value = '" & Mail & "'" in document 1
	do JavaScript "document.forms['repairFormBean']['lastname'].value = '" & Lastname & "'" in document 1
	do JavaScript "document.forms['repairFormBean']['phone'].value = '" & cleanedNumber & "'" in document 1
	do JavaScript "document.forms['repairFormBean']['address1'].value = '" & Rue & "'" in document 1
	do JavaScript "document.forms['repairFormBean']['city'].value = '" & Ville & "'" in document 1
	do JavaScript "document.forms['repairFormBean']['zipcode'].value = '" & NPA & "'" in document 1
	do JavaScript "document.forms['repairFormBean']['add_to_add_book'].click()" in document 1
	do JavaScript "document.forms['repairFormBean']['stateListForNtf'].value = 'VD' " in document 1
end tell
