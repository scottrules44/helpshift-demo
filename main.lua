local helpshift = require("plugin.helpshift")
helpshift.init("API_KEY", "DOMAIN","APP_ID")

--setup notification
local notifications = require( "plugin.notifications" )
notifications.registerForPushNotifications()
local pushToken
local json = require("json")
local function notificationListener( event )

	if ( event.type == "remoteRegistration" ) then 
        pushToken = event.token
    else -- handle data
    	print( json.prettify( event.custom))
    end
end
local launchArgs = ...

if ( launchArgs and launchArgs.notification ) then
    notificationListener( launchArgs.notification )
end



local bg = display.newRect( display.contentCenterX, display.contentCenterY, display.actualContentWidth, display.actualContentHeight )
bg:setFillColor( .1,1,.1 )
local logo = display.newImage( "helpshift.png", 0,0 )
logo:scale( .3, .3 )
logo.x, logo.y = 150, 60

local widget = require( "widget" )

local function helpshiftButtons( e )
	if (e.phase == "ended") then
		if (e.target.id == "showConversation") then
			helpshift.showConversation({requireEmail = "YES"})
		end
		if (e.target.id == "showFaqSection") then
			helpshift.showFaqSection("1", {enableContactUs = "NEVER"})
		end
		if (e.target.id == "showFaq") then
			helpshift.showFaqs({enableContactUs = "NEVER"})
		end
		if (e.target.id == "registerDeviceToken") then
			Runtime:addEventListener( "notification", notificationListener )
			if (pushToken) then
				helpshift.registerDeviceToken(pushToken)
			else
				print( "no token" )
			end
		end
	end
end

local showConversationButton = widget.newButton( {
	label = "showConversation",
	id = "showConversation",
	onEvent = helpshiftButtons
} )
showConversationButton.x, showConversationButton.y = display.contentCenterX, display.contentCenterY-50

local showFaqSectionButton = widget.newButton( {
	label = "showFaqSection",
	id = "showFaqSection",
	onEvent = helpshiftButtons
} )
showFaqSectionButton.x, showFaqSectionButton.y = display.contentCenterX, display.contentCenterY

local showFaqButton = widget.newButton( {
	label = "showFaq",
	id = "showFaq",
	onEvent = helpshiftButtons
} )
showFaqButton.x, showFaqButton.y = display.contentCenterX, display.contentCenterY +50

local registerDeviceTokenButton = widget.newButton( {
	label = "registerDeviceToken",
	id = "registerDeviceToken",
	onEvent = helpshiftButtons
} )
registerDeviceTokenButton.x, registerDeviceTokenButton.y = display.contentCenterX, display.contentCenterY+100