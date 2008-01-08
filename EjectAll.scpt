(*EjectAll
*This script allows one to eject all the mounted DMGs, or even all the mounted volumes, on one's system.
*It is particularly useful after having downloaded lots of apps from the internet and you have a dozen mounted DMGs.
*
*Author : Matti Schneider
*)

property theList : {}
set the appName to "EjectAll 2"
--set the iconFile to path to resource "icon.icns"
--set descriptionFile to path to resource "Manuel d'EjectAll 2.rtfd"

set test to do shell script "if ls ~/Library/Preferences/com.mattisg.ejectall > /dev/null; then cat ~/Library/Preferences/com.mattisg.ejectall; else date '+%s' > ~/Library/Preferences/com.mattisg.ejectall; echo 0; fi;"

set currentDate to do shell script "date '+%s'"

if (currentDate - test) is greater than 3456000 then --this is 40 days
	activate me
	set result to display dialog "EjectAll est un utilitaire permettant d'éjecter toutes les images disques montées sur un système, voire tous les médias éjectables." & return & return & "• pour éjecter les images disque, cliquez une fois sur l'icône" & return & "• pour éjecter tous les médias éjectable (disques durs, CD…), cliquez à nouveau sur l'icône" with title appName with icon iconFile buttons {"Manuel", "Lancer"} default button 2
	if result is {button returned:"Manuel"} then
		tell application "Finder"
			open descriptionFile
		end tell
		quit
	end if
end if

if (currentDate - test) is greater than 20 then --if the script is launched twice at a short interval, we assume that the user wants to eject really EVERY ejectable media. Else, it'll eject only the mounted DMGs
	ejectDMGs()
else
	ejectEverything()
end if

do shell script "date '+%s' > ~/Library/Preferences/com.mattisg.ejectall" --store the last use date

quit

(*FUNCTIONS*)
on getList()
	tell application "System Events"
		set theList to get the name of every disk
	end tell
	set yad to {}
	repeat with i from 1 to count of theList
		set yad to {item i of theList} & yad
	end repeat
	set theList to yad
	display dialog theList
end getList

on ejectDMGs()
	getList()
	repeat with i from 1 to count of theList
		set theDisk to item i of theList
		set theDiskIsDMG to do shell script "hdiutil info | grep -q '/Volumes/" & theDisk & "'; echo $?"
		if theDiskIsDMG is "0" then
			ignoring application responses --else it stops everything if one of the elements can't be unmounted
				tell application "Finder"
					eject theDisk
				end tell
			end ignoring
		end if
	end repeat
end ejectDMGs

on ejectEverything()
	getList()
	repeat with i from 1 to count of theList
		ignoring application responses --else it stops everything if one of the elements can't be unmounted
			tell application "Finder"
				eject item i of theList
			end tell
		end ignoring
	end repeat
end ejectEverything
