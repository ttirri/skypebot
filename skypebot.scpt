on run	idleend runon idle	doBotWork()	return 900end idleon sendMessageToSkypeClient(message)	local returnValue		tell application "Skype"		set returnValue to send command message script name "skypebot"	end tell	return returnValueend sendMessageToSkypeClienton buildResponseMessage(missedChats)	local chatId, chatMessage		set chatId to text ((offset of "#" in missedChats)) thru -1 of missedChats	set chatMessage to "CHATMESSAGE " & chatId & " this is a skype bot, the answer is 42."	return chatMessageend buildResponseMessageon doBotWork()	local userStatus, missedChats, screenSaverActivated, responseMessage		set userStatus to sendMessageToSkypeClient("get USERSTATUS")		if userStatus = "USERSTATUS OFFLINE" then -- if status offline, go hidden and check for messages			sendMessageToSkypeClient("SET USERSTATUS INVISIBLE")				delay 20 -- give slack 				set missedChats to sendMessageToSkypeClient("SEARCH MISSEDCHATS")				if missedChats is not "CHATS " then -- if unread messages, go online 			sendMessageToSkypeClient("SET USERSTATUS ONLINE")						tell application "System Events" to set the screenSaverActivated to (exists process "ScreenSaverEngine")			if screenSaverActivated then -- nobody using Mac, send bot response				set responseMessage to buildResponseMessage(missedChats)				sendMessageToSkypeClient(responseMessage)			end if		else			sendMessageToSkypeClient("SET USERSTATUS OFFLINE")		end if	end ifend doBotWork