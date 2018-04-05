tell application "FileMaker Pro"
	tell database "Atelier"
		set ClientID to cell "ADR_CodeClient" of current record
		if (ClientID = "") then
			tell application "FileMaker Pro"
				tell database "Atelier"
					tell current record
						set fullAdress to cell "ADR_AdresseSAV"
						set email to cell "ADR_Mail"
						set mobile to cell "ADR_Tel2"
						set telephone to cell "ADR_Tel1"
						set gender to first paragraph of fullAdress
						set fullName to count every word of second paragraph of fullAdress
						set {oldTID, AppleScript's text item delimiters} to {AppleScript's text item delimiters, space}
						set prenom to words 1 thru (fullName - 1) of second paragraph of fullAdress as string
						set AppleScript's text item delimiters to oldTID
						set Nom to last word of second paragraph of fullAdress
						set adresse to third paragraph of fullAdress
						set NPA to first word of fourth paragraph of fullAdress
					end tell
				end tell
				getURL "fmp://172.22.28.12/ADRESSES"
				set theRecordClient to create new record at database "ADRESSES"
				tell theRecordClient
					set cell "Prénom" to prenom
					set cell "Nom" to Nom
					set cell "Adresse" to adresse
					set cell "NPA" to NPA
					set cell "TEL mobile" to mobile
					set cell "TEL prof. 1" to telephone
					set cell "e mail" to email
					set cell "Commentaires" to "Client ART Computer"
					set cell "Genre" to gender
					set uniqueIdAdresse to cell "Code calc"
				end tell
				try
					set cell "ADR_CodeClient" of current record of database "Atelier" to uniqueIdAdresse
				on error
					show database "Atelier.fmp12"
					do menu menu item "changement_rubrique_cible" of menu "Scripts"
					delay 0.5
					set cell "ADR_CodeClient" of current record of database "Atelier" to uniqueIdAdresse
				end try
			end tell
			set ClientID to uniqueIdAdresse
		end if
	end tell
	tell database "ADRESSES"
		show every record
		show (every record whose cell "Code" is equal to ClientID)
		tell current record
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
	do JavaScript "var today = new Date();
	var form = document.forms['repairFormBean'];
	var string = form['calendar'].placeholder;
	var liaison = '.';
	var whatdafak = string.indexOf('.');
	if (whatdafak == -1) {
		var liaison = '/';
	}
	var dd = today.getDate();
	var mm = today.getMonth()+1;
	var yyyy = today.getFullYear();
	var minutes = today.getMinutes();
	var hour = today.getHours();
	if(dd<10) {
		dd='0'+dd
	} 
	if(minutes <10) {
		minutes ='0'+ minutes
	} 
	if(mm<10) {
    		mm='0'+mm
	}
	
	if (form['calendar'].placeholder == 'MM/DD/YY') {
		today = mm+liaison+dd+liaison+yyyy;
		
		if (hour < 12) {
			var timeNow = hour+':'+minutes + ' AM';
		} else if (hour == 12){
			var timeNow = hour+':'+minutes + ' PM';
		} else {
			hour = hour - 12;
			var timeNow = hour+':'+minutes + ' PM'
		}
	
	} else {
		today = dd+liaison+mm+liaison+yyyy;
		var timeNow = hour+':'+minutes;
	}
	
	form['firstname'].value = '" & FirstName & "';
	form['email'].value = '" & Mail & "';
	form['lastname'].value = '" & Lastname & "';
	form['phone'].value = '" & cleanedNumber & "';
	form['address1'].value = '" & Rue & "';
	form['city'].value = '" & Ville & "';
	form['zipcode'].value = '" & NPA & "';
	form['add_to_add_book'].click();
	form['calendar'].value = today;
	form['recTime'].value = timeNow;
	form['stateListForNtf'].value = 'VD';" in document 1
end tell
