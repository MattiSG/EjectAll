(*EjectAll
*This script allows one to eject all the mounted DMGs, or even all the mounted volumes, on one's system.
*It is particularly useful after having downloaded lots of apps from the internet and you have a dozen mounted DMGs.
*
*Author : Matti Schneider
*)

property lastLaunch : 0
property launchCount : 0
property appName : "EjectAll 3"
--set the iconFile to path to resource "EjectAll3.icns"
--set the descriptionFile to path to resource "description.rtfd" --"Manuel.rtfd"
set currentTime to time of (current date)

------Dialogs------
property d_force : "Force eject"
property d_ok : "Ok"

if (currentTime - lastLaunch) is greater than 40 * days then
	activate me
	set result to display dialog "EjectAll est un utilitaire permettant d'éjecter toutes les images disques montées sur un système, voire tous les médias éjectables." & return & return & "• pour éjecter les images disque, cliquez une fois sur l'icône" & return & "• pour éjecter tous les médias éjectable (disques durs, CD…), cliquez à nouveau sur l'icône" & return & "• pour forcer l'éjection d'un média récalcitrant, cliquez encore une fois" with title appName with icon iconFile buttons {"Manuel", "Lancer"} default button 2
	if result is {button returned:"Manuel"} then
		tell application "Finder"
			open descriptionFile
		end tell
		quit me
	end if
end if

if (currentTime - lastLaunch) is greater than 20 then --if the script is launched twice at a short interval, we assume that the user wants to eject really EVERY ejectable media. Else, it'll eject only the mounted DMGs
	set launchCount to 0
	displayUnejectable(ejectDMGs())
else
	if (launchCount = 1) then
		displayUnejectable(ejectEverything())
	else
		forceEject(getList())
	end if
end if

set lastLaunch to currentTime
set launchCount to launchCount + 1

--quit me

(*FUNCTIONS*)
on getList()
	--	tell application "System Events"
	--		return name of every disk
	--	end tell
	set theList to do shell script "ls /Volumes/"
	return every paragraph of theList
end getList

on displayUnejectable(unejectables)
	if unejectables is {} then return
	set theDialog to "The following volumes could not be ejected: "
	repeat with d in unejectables
		set theDialog to theDialog & return & "- " & d
	end repeat
	set theDialog to theDialog & return & return & "This usually happens because a file is in use on the volume."
	set choice to display dialog theDialog buttons {d_force, d_ok} default button d_ok
	if button returned of choice is d_force then
		forceEject(unejectables)
	end if
end displayUnejectable

on ejectDMGs()
	set notEjectedList to {}
	repeat with aDisk in getList()
		if aDisk contains "'" then
			set theDiskIsDMG to "1"
		else
			set theDiskIsDMG to do shell script "hdiutil info | egrep -q '^/dev/.*/Volumes/" & aDisk & "$'; echo $?" --"[\\ ]?[1-9]?[0-9]*$'; echo $?" --this is silly, but the Finder is much faster to eject disks then hdiutil (at least through AppleScript)…
		end if
		if theDiskIsDMG is "0" then
			set finderName to do shell script "echo " & aDisk & " | sed 's/ [1-9][0-9]*$//'"
			try
				tell application "Finder"
					eject finderName
				end tell
			on error
				set notEjectedList to notEjectedList & aDisk
			end try
		end if
	end repeat
	return notEjectedList
end ejectDMGs

on ejectEverything()
	set notEjectedList to {}
	repeat with aDisk in getList()
		try
			tell application "Finder"
				eject aDisk
			end tell
		on error
			set finderName to do shell script "echo " & aDisk & " | sed 's/ [1-9][0-9]*$//'"
			try
				tell application "Finder"
					eject finderName
				end tell
			on error
				set notEjectedList to notEjectedList & aDisk
			end try
		end try
	end repeat
	return notEjectedList
end ejectEverything

on forceEject(toEject)
	activate me
	set toEject to choose from list toEject with prompt "Please choose the disk(s) to force eject." & return & "WARNING: this may harm your devices !" with title appName & " - force ejection" with multiple selections allowed without empty selection allowed
	if class of toEject is not list then return
	repeat with d in toEject
		set choice to display dialog "Please wait a few seconds while disk \"" & d & "\" is being forced to eject, or cancel the forced ejection." giving up after 5 with title appName
		if button returned of choice is "Ok" or gave up of choice then
			set diskId to do shell script "diskutil unmountDisk force '/Volumes/" & d & "' | cut -d ' ' -f 7"
			do shell script "diskutil eject '/dev/" & diskId & "'" --eject can't be forced, so we have to unmount first
		end if
	end repeat
end forceEject
