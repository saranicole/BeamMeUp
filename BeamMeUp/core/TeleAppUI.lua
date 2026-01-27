local BMU = BMU --INS251229 Baertram Performancee gain, not searching _G for BMU each time again!

local LAM2 = BMU.LAM
local SI = BMU.SI ---- used for localization

local teleporterVars    = BMU.var
local appName           = teleporterVars.appName
local wm                = WINDOW_MANAGER
local sm				= SCENE_MANAGER
local worldMapManager 	= WORLD_MAP_MANAGER
local guildBrowserManager = GUILD_BROWSER_MANAGER
local chatSystem 		= CHAT_SYSTEM
local SOUNDS 			= SOUNDS
local CSA 				= CENTER_SCREEN_ANNOUNCE
local ESO_Dialogs 		= ESO_Dialogs

-- -v- INS251229 Baertram BEGIN 0
--Performance reference
----variables (defined now, as they were loaded before this file -> see manifest .txt)
--ZOs variables
local string 								= string
local string_lower 							= string.lower
local string_len							= string.len
local string_format							= string.format
local string_sub							= string.sub
local table 								= table
local table_insert 							= table.insert
local table_remove 							= table.remove
local worldName 							= GetWorldName()

local typeFunc = "function"


local zo_Menu                               = ZO_Menu     --ZO_Menu speed-up variable (so _G is not searched each time context menus are used)
local zo_WorldMapZoneStoryTopLevel_Keyboard = ZO_WorldMapZoneStoryTopLevel_Keyboard
local zo_ChatWindow                         = ZO_ChatWindow
local ClearCustomScrollableMenu 							= ClearCustomScrollableMenu
local ShowCustomScrollableMenu 								= ShowCustomScrollableMenu
--Other addon variables
---v- INS BEARTRAM 20260125 LibScrollableMenu
local LSM_ENTRY_TYPE_NORMAL 		= LSM_ENTRY_TYPE_NORMAL
local LSM_ENTRY_TYPE_CHECKBOX 		= LSM_ENTRY_TYPE_CHECKBOX
local LSM_ENTRY_TYPE_RADIOBUTTON	= LSM_ENTRY_TYPE_RADIOBUTTON
local LSM_UPDATE_MODE_MAINMENU 		= LSM_UPDATE_MODE_MAINMENU

local ClearCustomScrollableMenu 		= ClearCustomScrollableMenu
local AddCustomScrollableMenuDivider    = AddCustomScrollableMenuDivider
local AddCustomScrollableMenuCheckbox 	= AddCustomScrollableMenuCheckbox
local RefreshCustomScrollableMenu 		= RefreshCustomScrollableMenu
local AddCustomScrollableSubMenuEntry 	= AddCustomScrollableSubMenuEntry
local ShowCustomScrollableMenu 			= ShowCustomScrollableMenu

--The default options for a LSM contextMenu
---Item filters
local LSMVars = teleporterVars.LSMVars
local LSM_itemFilterContextMenuOptions = LSMVars.itemFilterContextMenuOptions
local LSM_dungeonFilterContextMenuOptions = LSMVars.dungeonFilterContextMenuOptions
---^- INS BEARTRAM 20260125 LibScrollableMenu


--BMU variables
local BMU_textures                          = BMU.textures
local colorGreen 							= "green"
local colorRed 								= "red"
local fontPattern							= "%s|$(KB_%s)|%s"
local textPattern 							= "%s: %d   %s: %d   %s: %d   %s: %d   %s: %d   %s: %d   %s: %d   %s: %d"
local subType_Alchemist 					= "alchemist"
local subType_Enchanter 					= "enchanter"
local subType_Woodworker 					= "woodworker"
local subType_Blacksmith 					= "blacksmith"
local subType_Clothier 						= "clothier"
local subType_Jewelry 						= "jewelry"
local subType_Treasure 						= "treasure"
local subType_Leads 						= "leads"
local surveyTypes 							= {subType_Alchemist, subType_Enchanter, subType_Woodworker, subType_Blacksmith, subType_Clothier, subType_Jewelry}
local surveyAppendixStrPattern 				= " (%d/%d)"
local maxSurveyTypes 						= #surveyTypes --Currently 6, add the new entries to table surveyTypes to increase this if new survey types get added (new crafting profession types that got surveys)


----functions
--ZOs functions
local zoPlainStrFind = zo_plainstrfind
local zo_IsTableEmpty = ZO_IsTableEmpty
local zo_CheckButton_IsChecked = ZO_CheckButton_IsChecked
local zo_CheckButton_SetCheckState = ZO_CheckButton_SetCheckState
local zo_CheckButton_IsEnabled = ZO_CheckButton_IsEnabled
local zo_CheckButton_SetChecked = ZO_CheckButton_SetChecked
--BMU functions
local BMU_SI_get                            = SI.get
local BMU_colorizeText                      = BMU.colorizeText
local BMU_round                             = BMU.round
local BMU_mergeTables						= BMU.mergeTables
local BMU_tooltipTextEnter					= BMU.tooltipTextEnter

local WorldMapZoneStoryTopLevel = ZO_WorldMapZoneStoryTopLevel_Keyboard

if BMU.IsNotKeyboard() then
  WorldMapZoneStoryTopLevel = ZO_WorldMapZoneStoryTopLevel_Gamepad
end

----variables (defined inline in code below, upon first usage, as they are still nil at this line)
--BMU UI variables
local BMU_chatButtonTex, teleporterWin_appTitle, teleporterWin_Main_Control, teleporterWin_zoneGuideSwapTexture, teleporterWin_feedbackTexture,
	teleporterWin_guildTexture, teleporterWin_MapOpen, teleporterWin_guildHouseTexture, teleporterWin_fixWindowTexture, teleporterWin_anchorTexture,
	teleporterWin_closeTexture, teleporterWin_SearchTexture, teleporterWin_SearchBG, teleporterWin_Searcher_Player_Placeholder,teleporterWin_Searcher_Player,
	teleporterWin_SearchBG_Player, teleporterWin_Searcher_Zone_Placeholder, teleporterWin_Searcher_Zone, teleporterWin_Main_Control_RefreshTexture,
	teleporterWin_Main_Control_portalToAllTexture, teleporterWin_Main_Control_SettingsTexture, teleporterWin_Main_Control_PTFTexture,
	teleporterWin_Main_Control_OwnHouseTexture, teleporterWin_Main_Control_QuestTexture, teleporterWin_Main_Control_ItemTexture, BMU_counterPanel,
	teleporterWin_Main_Control_OnlyYourzoneTexture, teleporterWin_Main_Control_DelvesTexture, teleporterWin_Main_Control_DungeonTexture,

-------functions (defined inline in code below, upon first usage, as they are still nil at this line)
local BMU_getItemTypeIcon, BMU_getDataMapInfo, BMU_OpenTeleporter, BMU_updateContextMenuEntrySurveyAll,
      BMU_getContextMenuEntrySurveyAllAppendix, BMU_clearInputFields, BMU_createTable,
      BMU_createTableDungeons, BMU_createTableGuilds, BMU_numOfSurveyTypesChecked, 	BMU_updateCheckboxSurveyMap,
 	  BMU_createTableHouses, BMU_getCurrentDungeonDifficulty, BMU_setDungeonDifficulty, BMU_PortalToPlayer, BMU_printToChat,
	  BMU_has_value
-- -^- INS251229 Baertram END 0

-- list of tuples (guildId & displayname) for invite queue (only for admin)
local inviteQueue = {}


---v- INS BEARTRAM 20260125 LibScrollableMenu helpers
local LSM_ENTRY_TYPE_NORMAL 		= LSM_ENTRY_TYPE_NORMAL
--local LSM_ENTRY_TYPE_DIVIDER 		= LSM_ENTRY_TYPE_DIVIDER
--local LSM_ENTRY_TYPE_HEADER 		= LSM_ENTRY_TYPE_HEADER
local LSM_ENTRY_TYPE_SUBMENU 		= LSM_ENTRY_TYPE_SUBMENU
local LSM_ENTRY_TYPE_CHECKBOX 		= LSM_ENTRY_TYPE_CHECKBOX
--local LSM_ENTRY_TYPE_BUTTON 		= LSM_ENTRY_TYPE_BUTTON
local LSM_ENTRY_TYPE_RADIOBUTTON	= LSM_ENTRY_TYPE_RADIOBUTTON
--local LSM_ENTRY_TYPE_EDITBOX 		= LSM_ENTRY_TYPE_EDITBOX
--local LSM_ENTRY_TYPE_SLIDER 		= LSM_ENTRY_TYPE_SLIDER


--Context menu dynamic helpers for LibScrollableMenu entries
local function getValueOrCallback(variableOrFunc, ...)
	return (type(variableOrFunc) == typeFunc and variableOrFunc(...)) or variableOrFunc
end

---Helper function to check if the checkbox/radio button should be checked, based on the SavedVariables table, and SV option name
local function isCheckedHelperFunc(p_SVsettings, p_SVsettingName, p_isCheckedValueOrFunc, p_additionalData)
	--Check if we got a value or a function returning a value
	local isCheckedValue = getValueOrCallback(p_isCheckedValueOrFunc, p_additionalData)
	--Comapre the SavedVariables to the determined value
	return p_SVsettings[p_SVsettingName] == isCheckedValue
end

--Write LSM's entryType passed in value to the the SV table now
local function updateSVFromLSMEntryNow(p_SVsettings, p_SVsettingName, p_value)
	if p_SVsettings == nil or p_SVsettingName == nil then return end
	p_SVsettings[p_SVsettingName] = p_value
end

--OnClick helper function, updating the SavedVariables table and SV option name based on the checked state of the checkbox or radioButton
local function LSMEntryTypeCheckboxOrRadioButtonClickedHelperFunc(p_SVsettings, p_SVsettingName, p_isCheckedValueOrFunc, p_additionalData, comboBox, itemName, item, checked, data)
	--DefaultTab change is prepared? Check if the checkbox was checked, and if not pass in the default tab BMU.indexListMain (not the checkbox's checked state)
	local newChecked = checked
	if p_SVsettingName == "defaultTab" then
		newChecked = BMU.indexListMain
		if p_isCheckedValueOrFunc ~= nil then
			newChecked = getValueOrCallback(p_isCheckedValueOrFunc, p_additionalData)
		end
	end
	updateSVFromLSMEntryNow(p_SVsettings, p_SVsettingName, newChecked)
end

--OnClick helper function, updating the SavedVariables table and SV option name based on the passed in value of the LSM entryType
--[[
local function OtherLSMEntryTypeClickedHelperFunc(p_SVsettings, p_SVsettingName, p_value, comboBox, itemName, item, selectionChanged, oldItem)
	updateSVFromLSMEntryNow(p_SVsettings, p_SVsettingName, p_value)
end
]]


--Dynamically add LSM entries to a LSM contextMenu
local function addDynamicLSMContextMenuEntry(entryType, entryText, SVsettings, SVsettingName, onClickFunc, isCheckedValueOrFunc, additionalData)
	entryType = entryType or LSM_ENTRY_TYPE_NORMAL
	--Create references which do not get changed later
	local p_entryText = entryText
	local settingsProvided = (SVsettings ~= nil and SVsettingName ~= nil and true) or false
	local p_onClickFunc = (type(onClickFunc) == typeFunc and onClickFunc) or nil
	local p_isCheckedValueOrFunc = isCheckedValueOrFunc
	local p_additionalData = additionalData

	--EntryType checks
	local isCheckBox = entryType == LSM_ENTRY_TYPE_CHECKBOX
	local isRadioButton = entryType == LSM_ENTRY_TYPE_CHECKBOX

	--If no explicit "checked" function or value was passed in and we are creating a checkBox or radioButton:
	--Just create an anonymous function returning the passed in SV table and it's "current value" (as the function get's
	--called from the open contextMenu as the entry get's created)
	if p_isCheckedValueOrFunc == nil and (isCheckBox or isRadioButton) and settingsProvided then
		p_isCheckedValueOrFunc = function()
			return SVsettings[SVsettingName]
		end
	end

	--Add the LSM checkbox entry
	if isCheckBox then
		AddCustomScrollableMenuCheckbox(p_entryText,
				function(...)					--toggle function of checkbox, params ... = comboBox, itemName, item, checked, data
					if p_onClickFunc ~= nil then
						return p_onClickFunc(...)
					end
					LSMEntryTypeCheckboxOrRadioButtonClickedHelperFunc(SVsettings, SVsettingName, p_isCheckedValueOrFunc, p_additionalData, ...)
				end,
				function()
					return isCheckedHelperFunc(SVsettings, SVsettingName, p_isCheckedValueOrFunc, p_additionalData)
				end, 																--is checked function
				p_additionalData													--additionally passed in data
		)

	--Add the LSM radio button entry (only entries with the same buttonGroup specified in additionalData table belong to the same group)
	---Radiobuttons are similar to checkboxes, but within 1 group there can only always be 1 radioButton checked.
	elseif isRadioButton then
		local buttonGroup = (p_additionalData ~= nil and p_additionalData.buttonGroup) or 1
		AddCustomScrollableMenuRadioButton(p_entryText,
				function(...)					--toggle function of checkbox, params ... = comboBox, itemName, item, checked, data
					if p_onClickFunc ~= nil then
						return p_onClickFunc(...)
					end
					--The OnClick function can be used to update the SavedVariables for the clicked radioButton control of a radioButton group
					--But you could also pass in the additionalData.buttonGroupOnSelectionChangedCallback(control, previousControl) which fires as any radioButton in the same group was really changed
					--(and not only clicked), and update the SVs based on control.data or any other information then.
					LSMEntryTypeCheckboxOrRadioButtonClickedHelperFunc(SVsettings, SVsettingName, p_isCheckedValueOrFunc, p_additionalData, ...)
				end,
				function()
					return isCheckedHelperFunc(SVsettings, SVsettingName, p_isCheckedValueOrFunc, p_additionalData)
				end, 																--is checked function
				buttonGroup,														--the button group ID where this radiobutton should be added to. Attention: If left empty it will always be 1
				p_additionalData													--additionally passed in data (may contain buttonGroupOnSelectionChangedCallback function(control, previousControl) which is executed as any radioButton in teh same group was changed)
		)
	end
end
---^- INS BEARTRAM 20260125 LibScrollableMenu helpers



function BMU.getStringIsInstalledLibrary(addonName)
	local stringInstalled = BMU_colorizeText("installed and enabled", colorGreen)
	local stringNotInstalled = BMU_colorizeText("not installed or disabled", colorRed)
	local lowerAddonName = string_lower(addonName)

    local teleporterWin     = BMU.win


    local panelData = {
            type 				= 'panel',
            name 				= index,
            displayName 		= BMU_colorizeText(index, "gold"),                      --CHG251229 Baertram
            author 				= BMU_colorizeText(teleporterVars.author, "teal"),      --CHG251229 Baertram
            version 			= BMU_colorizeText(teleporterVars.version, "teal"),     --CHG251229 Baertram -> Also changed in this function at another 48 places! No comments were added there, onlya t the first of the 48 ;-)
            website             = teleporterVars.website,
            feedback            = teleporterVars.feedback,
            registerForRefresh  = true,
            registerForDefaults = true,
        }


    BMU.SettingsPanel = LAM2:RegisterAddonPanel(appName .. "Options", panelData) -- for quick access


	-- retreive most ported zones for statistic
	local portCounterPerZoneSorted = {}
	for index, value in pairs(BMU_SVAcc.portCounterPerZone) do
		table.insert(portCounterPerZoneSorted, {["zoneId"]=index, ["count"]=value})
	end
	-- sort by counts
	table.sort(portCounterPerZoneSorted, function(a, b) return a["count"] > b["count"] end)
	-- build text block
	local mostPortedZonesText = ""
	for i=1, 10 do
		if portCounterPerZoneSorted[i] == nil then
			mostPortedZonesText = mostPortedZonesText .. "\n"
		else
			mostPortedZonesText = mostPortedZonesText .. BMU.formatName(GetZoneNameById(portCounterPerZoneSorted[i]["zoneId"])) .. " (" .. portCounterPerZoneSorted[i]["count"] .. ")\n"
		end
	end

    local optionsData = {
	     {
              type = "description",
              text = "Get the most out of BeamMeUp by using it together with the following addons.",
			  submenu = "deps",
         },
		 {
              type = "divider",
			  submenu = "deps",
         },
	     {
              type = "description",
              title = "Port to Friend's House",
			  text = BMU.getStringIsInstalledLibrary("ptf"),
			  width = "half",
			  submenu = "deps",
         },
		 {
              type = "button",
              name = "Open addon website",
			  func = function() RequestOpenUnsafeURL("https://www.esoui.com/downloads/info1758-PorttoFriendsHouse.html") end,
			  width = "half",
			  submenu = "deps",
         },
	     {
              type = "description",
              text = "Access your houses and guild halls directly through BeamMeUp. Your houses that are set in PTF will be displayed in a separate list.",
			  submenu = "deps",
         },
		 {
              type = "divider",
			  submenu = "deps",
         },
	     {
              type = "description",
			  title = "LibSets",
              text = BMU.getStringIsInstalledLibrary("libsets"),
			  width = "half",
			  submenu = "deps",
         },
		 {
              type = "button",
              name = "Open addon website",
			  func = function() RequestOpenUnsafeURL("https://www.esoui.com/downloads/info2241-LibSetsAllsetitemsingameexcellua.html") end,
			  width = "half",
			  submenu = "deps",
         },
	     {
              type = "description",
              text = "Check your collection progress of set items in BeamMeUp and sort your fast travel options. The number of the collected set items is displayed in the tooltip of the zone names. Furthermore, you can sort your results according to the number of missing set items.",
			  submenu = "deps",
         },
		 {
              type = "divider",
			  submenu = "deps",
         },
	     {
              type = "description",
			  title = "LibMapPing",
              text = BMU.getStringIsInstalledLibrary("libmapping"),
			  width = "half",
			  submenu = "deps",
         },
		 {
              type = "button",
              name = "Open addon website",
			  func = function() RequestOpenUnsafeURL("https://www.esoui.com/downloads/info1302-LibMapPing.html") end,
			  width = "half",
			  submenu = "deps",
         },
	     {
              type = "description",
              text = "Use pings on the map (rally points) instead of zooming when you click on specific zone names or group members. An option in the 'Extra Features' allows you to toggle between the map ping and the zoom & pan feature.",
			  submenu = "deps",
         },
		 {
              type = "divider",
			  submenu = "deps",
         },
	     {
              type = "description",
			  title = "LibSlashCommander",
              text = BMU.getStringIsInstalledLibrary("lsc"),
			  width = "half",
			  submenu = "deps",
         },
		 {
              type = "button",
              name = "Open addon website",
			  func = function() RequestOpenUnsafeURL("https://www.esoui.com/downloads/info1508-LibSlashCommander.html") end,
			  width = "half",
			  submenu = "deps",
         },
	     {
              type = "description",
              text = "Get comprehensive auto-completion, color coding and short description for chat commands.",
			  submenu = "deps",
         },
		 {
              type = "divider",
			  submenu = "deps",
         },
	     {
              type = "description",
			  title = "LibChatMenuButton",
              text = BMU.getStringIsInstalledLibrary("lcmb"),
			  width = "half",
			  submenu = "deps",
         },
		 {
              type = "button",
              name = "Open addon website",
			  func = function() RequestOpenUnsafeURL("https://www.esoui.com/downloads/info3805-LibChatMenuButton.html") end,
			  width = "half",
			  submenu = "deps",
         },
	     {
              type = "description",
              text = "Leave the positioning of the BMU chat button to an external library. Support the concept of libraries. But you will lose the option to set an individual offset.",
			  submenu = "deps",
         },
		 {
              type = "divider",
			  submenu = "deps",
         },
	     {
              type = "description",
              title = "|cFF00FFIsJusta|r Beam Me Up Gamepad Plugin",
			  text = BMU.getStringIsInstalledLibrary("gamepad"),
			  width = "half",
			  submenu = "deps",
         },
		 {
              type = "button",
              name = "Open addon website",
			  func = function() RequestOpenUnsafeURL("https://www.esoui.com/downloads/info3624-IsJustaBeamMeUpGamepadPlugin.html") end,
			  width = "half",
			  submenu = "deps",
         },
	     {
              type = "description",
              text = "Use BeamMeUp in the gamepad mode. Finally, BeamMeUp gets a dedicated gamepad support. |cFF00FFIsJusta|r Beam Me Up Gamepad Plugin integrates the features of BeamMeUp in the gamepad interface and allows you to travel more comfortable than ever before.",
			  submenu = "deps",
         },
		 {
              type = "slider",
              name = BMU_SI_get(SI.TELE_SETTINGS_NUMBER_LINES),
              tooltip = BMU_SI_get(SI.TELE_SETTINGS_NUMBER_LINES_TOOLTIP) .. " [DEFAULT: " .. BMU_DefaultsPerAccount["numberLines"] .. "]",
              min = 6,
              max = 16,
              getFunc = function() return BMU_SVAcc.numberLines end,
              setFunc = function(value) BMU_SVAcc.numberLines = value
							teleporterWin.Main_Control:SetHeight(BMU.calculateListHeight())
							-- add also current height of the counter panel
							teleporterWin.Main_Control.bd:SetHeight(BMU.calculateListHeight() + 280*BMU_SVAcc.Scale + select(2, BMU.counterPanel:GetTextDimensions()))
				end,
			  default = BMU_DefaultsPerAccount["numberLines"],
			  submenu = "ui",
         },
         {
              type = "checkbox",
              name = BMU_SI_get(SI.TELE_SETTINGS_SHOW_ON_MAP_OPEN),
              tooltip = BMU_SI_get(SI.TELE_SETTINGS_SHOW_ON_MAP_OPEN_TOOLTIP) .. " [DEFAULT: " .. tostring(BMU_DefaultsPerAccount["ShowOnMapOpen"]) .. "]",
              getFunc = function() return BMU_SVAcc.ShowOnMapOpen end,
              setFunc = function(value) BMU_SVAcc.ShowOnMapOpen = value end,
			  default = BMU_DefaultsPerAccount["ShowOnMapOpen"],
			  submenu = "ui",
         },
         {
              type = "checkbox",
              name = BMU_SI_get(SI.TELE_SETTINGS_HIDE_ON_MAP_CLOSE),
              tooltip = BMU_SI_get(SI.TELE_SETTINGS_HIDE_ON_MAP_CLOSE_TOOLTIP) .. " [DEFAULT: " .. tostring(BMU_DefaultsPerAccount["HideOnMapClose"]) .. "]",
              getFunc = function() return BMU_SVAcc.HideOnMapClose end,
              setFunc = function(value) BMU_SVAcc.HideOnMapClose = value end,
			  default = BMU_DefaultsPerAccount["HideOnMapClose"],
			  submenu = "ui",
         },
		 {
              type = "checkbox",
              name = BMU_SI_get(SI.TELE_SETTINGS_CLOSE_ON_PORTING),
              tooltip = BMU_SI_get(SI.TELE_SETTINGS_CLOSE_ON_PORTING_TOOLTIP) .. " [DEFAULT: " .. tostring(BMU_DefaultsPerAccount["closeOnPorting"]) .. "]",
              getFunc = function() return BMU_SVAcc.closeOnPorting end,
              setFunc = function(value) BMU_SVAcc.closeOnPorting = value end,
			  default = BMU_DefaultsPerAccount["closeOnPorting"],
			  submenu = "ui",
		 },
		 {
              type = "checkbox",
              name = BMU_SI_get(SI.TELE_SETTINGS_WINDOW_STAY),
              tooltip = BMU_SI_get(SI.TELE_SETTINGS_WINDOW_STAY_TOOLTIP) .. " [DEFAULT: " .. tostring(BMU_DefaultsPerAccount["windowStay"]) .. "]",
              getFunc = function() return BMU_SVAcc.windowStay end,
              setFunc = function(value) BMU_SVAcc.windowStay = value end,
			  default = BMU_DefaultsPerAccount["windowStay"],
			  submenu = "ui",
		 },
		 {
              type = "checkbox",
              name = BMU_SI_get(SI.TELE_SETTINGS_FOCUS_ON_MAP_OPEN),
              tooltip = BMU_SI_get(SI.TELE_SETTINGS_FOCUS_ON_MAP_OPEN_TOOLTIP) .. " [DEFAULT: " .. tostring(BMU_DefaultsPerAccount["focusZoneSearchOnOpening"]) .. "]",
              getFunc = function() return BMU_SVAcc.focusZoneSearchOnOpening end,
              setFunc = function(value) BMU_SVAcc.focusZoneSearchOnOpening = value end,
			  default = BMU_DefaultsPerAccount["focusZoneSearchOnOpening"],
			  submenu = "ui",
         },
		 {
              type = "slider",
              name = BMU_SI_get(SI.TELE_SETTINGS_AUTO_PORT_FREQ),
              tooltip = BMU_SI_get(SI.TELE_SETTINGS_AUTO_PORT_FREQ_TOOLTIP) .. " [DEFAULT: " .. BMU_DefaultsPerAccount["AutoPortFreq"] .. "]",
              min = 50,
              max = 500,
              getFunc = function() return BMU_SVAcc.AutoPortFreq end,
              setFunc = function(value) BMU_SVAcc.AutoPortFreq = value end,
			  default = BMU_DefaultsPerAccount["AutoPortFreq"],
			  submenu = "ui",
         },
		 {
              type = "divider",
			  submenu = "ui",
         },
		 {
              type = "checkbox",
              name = BMU_SI_get(SI.TELE_SETTINGS_SHOW_BUTTON_ON_MAP),
              tooltip = BMU_SI_get(SI.TELE_SETTINGS_SHOW_BUTTON_ON_MAP_TOOLTIP) .. " [DEFAULT: " .. tostring(BMU_DefaultsPerAccount["showOpenButtonOnMap"]) .. "]",
              requiresReload = true,
			  getFunc = function() return BMU_SVAcc.showOpenButtonOnMap end,
              setFunc = function(value) BMU_SVAcc.showOpenButtonOnMap = value end,
			  default = BMU_DefaultsPerAccount["showOpenButtonOnMap"],
			  submenu = "ui",
         },
		 {
              type = "checkbox",
              name = BMU_SI_get(SI.TELE_SETTINGS_SHOW_CHAT_BUTTON),
              tooltip = BMU_SI_get(SI.TELE_SETTINGS_SHOW_CHAT_BUTTON_TOOLTIP) .. " [DEFAULT: " .. tostring(BMU_DefaultsPerAccount["chatButton"]) .. "]",
              requiresReload = true,
			  getFunc = function() return BMU_SVAcc.chatButton end,
              setFunc = function(value) BMU_SVAcc.chatButton = value end,
			  default = BMU_DefaultsPerAccount["chatButton"],
			  submenu = "ui",
         },
		 {
              type = "slider",
              name = BMU_SI_get(SI.TELE_SETTINGS_SCALE),
			  tooltip = BMU_SI_get(SI.TELE_SETTINGS_SCALE_TOOLTIP) .. " [DEFAULT: " .. BMU_DefaultsPerAccount["Scale"] .. "]",
			  min = 0.7,
			  max = 1.4,
			  step = 0.05,
			  decimals = 2,
			  requiresReload = true,
              getFunc = function() return BMU_SVAcc.Scale end,
              setFunc = function(value) BMU_SVAcc.Scale = value end,
			  default = BMU_DefaultsPerAccount["Scale"],
			  submenu = "ui",
         },
		 {
              type = "slider",
              name = BMU_SI_get(SI.TELE_SETTINGS_CHAT_BUTTON_OFFSET),
              tooltip = BMU_SI_get(SI.TELE_SETTINGS_CHAT_BUTTON_OFFSET_TOOLTIP) .. " [DEFAULT: " .. BMU_DefaultsPerAccount["chatButtonHorizontalOffset"] .. "]",
              min = 0,
              max = 200,
              getFunc = function() return BMU_SVAcc.chatButtonHorizontalOffset end,
              setFunc = function(value) BMU_SVAcc.chatButtonHorizontalOffset = value
							BMU.chatButtonTex:SetAnchor(TOPRIGHT, ZO_ChatWindow, TOPRIGHT, -40 - BMU_SVAcc.chatButtonHorizontalOffset, 6)
						end,
			  default = BMU_DefaultsPerAccount["chatButtonHorizontalOffset"],
			  submenu = "ui",
			  disabled = function() return not BMU_SVAcc.chatButton or not BMU.chatButtonTex end,
         },
		 {
              type = "slider",
              name = BMU_SI_get(SI.TELE_SETTINGS_MAP_DOCK_OFFSET_HORIZONTAL),
              tooltip = BMU_SI_get(SI.TELE_SETTINGS_MAP_DOCK_OFFSET_HORIZONTAL_TOOLTIP) .. " [DEFAULT: " .. BMU_DefaultsPerAccount["anchorMapOffset_x"] .. "]",
			  min = -100,
              max = 100,
              getFunc = function() return BMU_SVAcc.anchorMapOffset_x end,
              setFunc = function(value) BMU_SVAcc.anchorMapOffset_x = value end,
			  default = BMU_DefaultsPerAccount["anchorMapOffset_x"],
			  submenu = "ui",
         },
		 {
              type = "slider",
              name = BMU_SI_get(SI.TELE_SETTINGS_MAP_DOCK_OFFSET_VERTICAL),
			  tooltip = BMU_SI_get(SI.TELE_SETTINGS_MAP_DOCK_OFFSET_VERTICAL_TOOLTIP) .. " [DEFAULT: " .. BMU_DefaultsPerAccount["anchorMapOffset_y"] .. "]",
			  min = -150,
			  max = 150,
              getFunc = function() return BMU_SVAcc.anchorMapOffset_y end,
              setFunc = function(value) BMU_SVAcc.anchorMapOffset_y = value end,
			  default = BMU_DefaultsPerAccount["anchorMapOffset_y"],
			  submenu = "ui",
         },
		 {
              type = "button",
              name = BMU_SI_get(SI.TELE_SETTINGS_RESET_UI),
			  tooltip = BMU_SI_get(SI.TELE_SETTINGS_RESET_UI_TOOLTIP),
			  func = function() 
                                BMU_SVAcc.Scale = BMU_DefaultsPerAccount["Scale"]
								BMU_SVAcc.chatButtonHorizontalOffset = BMU_DefaultsPerAccount["chatButtonHorizontalOffset"]
								BMU_SVAcc.anchorMapOffset_x = BMU_DefaultsPerAccount["anchorMapOffset_x"]
								BMU_SVAcc.anchorMapOffset_y = BMU_DefaultsPerAccount["anchorMapOffset_y"]
								BMU_SVAcc.pos_MapScene_x = BMU_DefaultsPerAccount["pos_MapScene_x"]
								BMU_SVAcc.pos_MapScene_y = BMU_DefaultsPerAccount["pos_MapScene_y"]
								BMU_SVAcc.pos_x = BMU_DefaultsPerAccount["pos_x"]
								BMU_SVAcc.pos_y = BMU_DefaultsPerAccount["pos_y"]
								BMU_SVAcc.anchorOnMap = BMU_DefaultsPerAccount["anchorOnMap"]
								ReloadUI()
						end,
			  width = "half",
			  warning = "This will automatically reload your UI!",
			  submenu = "ui",
         },
		 {
              type = "checkbox",
              name = BMU_SI_get(SI.TELE_SETTINGS_AUTO_REFRESH),
              tooltip = BMU_SI_get(SI.TELE_SETTINGS_AUTO_REFRESH_TOOLTIP) .. " [DEFAULT: " .. tostring(BMU_DefaultsPerAccount["autoRefresh"]) .. "]",
              getFunc = function() return BMU_SVAcc.autoRefresh end,
              setFunc = function(value) BMU_SVAcc.autoRefresh = value end,
			  default = BMU_DefaultsPerAccount["autoRefresh"],
			  submenu = "rec",
         },
		 {
              type = "dropdown",
              name = BMU_SI_get(SI.TELE_SETTINGS_SORTING),
              tooltip = BMU_SI_get(SI.TELE_SETTINGS_SORTING_TOOLTIP) .. " [DEFAULT: " .. BMU.dropdownSortChoices[BMU_DefaultsPerCharacter["sorting"]] .. "]",
			  choices = BMU.dropdownSortChoices,
			  choicesValues = BMU.dropdownSortValues,
              getFunc = function() return BMU.savedVarsChar.sorting end,
			  setFunc = function(value) BMU.savedVarsChar.sorting = value end,
			  default = BMU_DefaultsPerCharacter["sorting"],
			  warning = BMU_colorizeText(BMU_SI_get(SI.TELE_SETTINGS_INFO_CHARACTER_DEPENDING), "red"), --CHG251229 Baertram All following changed enties below are not commented anymore now!
			  submenu = "rec",
        },
		{
			type = "dropdown",
			name = BMU_SI_get(SI.TELE_SETTINGS_DEFAULT_TAB),
			tooltip = BMU_SI_get(SI.TELE_SETTINGS_DEFAULT_TAB_TOOLTIP) .. " [DEFAULT: " .. BMU.dropdownDefaultTabChoices[BMU.getIndexFromValue(BMU.dropdownDefaultTabValues, BMU_DefaultsPerCharacter["defaultTab"])] .. "]",
			choices = BMU.dropdownDefaultTabChoices,
			choicesValues = BMU.dropdownDefaultTabValues,
			getFunc = function() return BMU.savedVarsChar.defaultTab end,
			setFunc = function(value) BMU.savedVarsChar.defaultTab = value end,
			default = BMU_DefaultsPerCharacter["defaultTab"],
			warning = BMU_colorizeText(BMU_SI_get(SI.TELE_SETTINGS_INFO_CHARACTER_DEPENDING), "red"),
			disabled = function() return not BMU_SVAcc.autoRefresh end,
			submenu = "rec",
		 },
         {
              type = "checkbox",
              name = BMU_SI_get(SI.TELE_SETTINGS_SHOW_NUMBER_PLAYERS),
              tooltip = BMU_SI_get(SI.TELE_SETTINGS_SHOW_NUMBER_PLAYERS_TOOLTIP) .. " [DEFAULT: " .. tostring(BMU_DefaultsPerAccount["showNumberPlayers"]) .. "]",
              getFunc = function() return BMU_SVAcc.showNumberPlayers end,
              setFunc = function(value) BMU_SVAcc.showNumberPlayers = value end,
			  default = BMU_DefaultsPerAccount["showNumberPlayers"],
			  submenu = "rec",
		 },
         {
              type = "checkbox",
              name = BMU_SI_get(SI.TELE_SETTINGS_SEARCH_CHARACTERNAMES),
              tooltip = BMU_SI_get(SI.TELE_SETTINGS_SEARCH_CHARACTERNAMES_TOOLTIP) .. " [DEFAULT: " .. tostring(BMU_DefaultsPerAccount["searchCharacterNames"]) .. "]",
              getFunc = function() return BMU_SVAcc.searchCharacterNames end,
              setFunc = function(value) BMU_SVAcc.searchCharacterNames = value end,
			  default = BMU_DefaultsPerAccount["searchCharacterNames"],
			  submenu = "rec",
		 },		 
         {
              type = "checkbox",
              name = BMU_SI_get(SI.TELE_SETTINGS_ZONE_ONCE_ONLY),
              tooltip = BMU_SI_get(SI.TELE_SETTINGS_ZONE_ONCE_ONLY_TOOLTIP) .. " [DEFAULT: " .. tostring(BMU_DefaultsPerAccount["zoneOnceOnly"]) .. "]",
              getFunc = function() return BMU_SVAcc.zoneOnceOnly end,
              setFunc = function(value) BMU_SVAcc.zoneOnceOnly = value end,
			  default = BMU_DefaultsPerAccount["zoneOnceOnly"],
			  submenu = "rec",
		 },
		 {
              type = "checkbox",
              name = BMU_SI_get(SI.TELE_SETTINGS_CURRENT_ZONE_ALWAYS_TOP),
              tooltip = BMU_SI_get(SI.TELE_SETTINGS_CURRENT_ZONE_ALWAYS_TOP_TOOLTIP) .. " [DEFAULT: " .. tostring(BMU_DefaultsPerAccount["currentZoneAlwaysTop"]) .. "]",
              getFunc = function() return BMU_SVAcc.currentZoneAlwaysTop end,
              setFunc = function(value) BMU_SVAcc.currentZoneAlwaysTop = value end,
			  default = BMU_DefaultsPerAccount["currentZoneAlwaysTop"],
			  submenu = "rec",
		 },
		 {
              type = "checkbox",
              name = BMU_SI_get(SI.TELE_SETTINGS_VIEWED_ZONE_ALWAYS_TOP),
              tooltip = BMU_SI_get(SI.TELE_SETTINGS_VIEWED_ZONE_ALWAYS_TOP_TOOLTIP) .. " [DEFAULT: " .. tostring(BMU_DefaultsPerAccount["currentViewedZoneAlwaysTop"]) .. "]",
              getFunc = function() return BMU_SVAcc.currentViewedZoneAlwaysTop end,
              setFunc = function(value) BMU_SVAcc.currentViewedZoneAlwaysTop = value end,
			  default = BMU_DefaultsPerAccount["currentViewedZoneAlwaysTop"],
			  submenu = "rec",
		 },
		 {
              type = "checkbox",
              name = BMU_SI_get(SI.TELE_SETTINGS_FORMAT_ZONE_NAME),
              tooltip = BMU_SI_get(SI.TELE_SETTINGS_FORMAT_ZONE_NAME_TOOLTIP) .. " [DEFAULT: " .. tostring(BMU_DefaultsPerAccount["formatZoneName"]) .. "]",
              getFunc = function() return BMU_SVAcc.formatZoneName end,
              setFunc = function(value) BMU_SVAcc.formatZoneName = value end,
			  default = BMU_DefaultsPerAccount["formatZoneName"],
			  submenu = "rec",
         },
		 {
              type = "slider",
              name = BMU_SI_get(SI.TELE_SETTINGS_AUTO_REFRESH_FREQ),
              tooltip = BMU_SI_get(SI.TELE_SETTINGS_AUTO_REFRESH_FREQ_TOOLTIP) .. " [DEFAULT: " .. BMU_DefaultsPerAccount["autoRefreshFreq"] .. "]",
              min = 0,
              max = 15,
              getFunc = function() return BMU_SVAcc.autoRefreshFreq end,
              setFunc = function(value) BMU_SVAcc.autoRefreshFreq = value end,
			  default = BMU_DefaultsPerAccount["autoRefreshFreq"],
			  submenu = "rec",
         },
		 {
              type = "checkbox",
              name = BMU_SI_get(SI.TELE_SETTINGS_SHOW_ZONES_WITHOUT_PLAYERS),
              tooltip = BMU_SI_get(SI.TELE_SETTINGS_SHOW_ZONES_WITHOUT_PLAYERS_TOOLTIP) .. " [DEFAULT: " .. tostring(BMU_DefaultsPerAccount["showZonesWithoutPlayers2"]) .. "]",
              getFunc = function() return BMU_SVAcc.showZonesWithoutPlayers2 end,
              setFunc = function(value) BMU_SVAcc.showZonesWithoutPlayers2 = value end,
			  default = BMU_DefaultsPerAccount["showZonesWithoutPlayers2"],
			  submenu = "bl",
         },
		 {
              type = "checkbox",
              name = BMU_SI_get(SI.TELE_SETTINGS_ONLY_MAPS),
              tooltip = BMU_SI_get(SI.TELE_SETTINGS_ONLY_MAPS_TOOLTIP) .. " [DEFAULT: " .. tostring(BMU_DefaultsPerAccount["onlyMaps"]) .. "]",
              getFunc = function() return BMU_SVAcc.onlyMaps end,
              setFunc = function(value) BMU_SVAcc.onlyMaps = value end,
			  default = BMU_DefaultsPerAccount["onlyMaps"],
			  submenu = "bl",
         },
		 {
              type = "checkbox",
              name = BMU_SI_get(SI.TELE_SETTINGS_HIDE_OTHERS),
              tooltip = BMU_SI_get(SI.TELE_SETTINGS_HIDE_OTHERS_TOOLTIP) .. " [DEFAULT: " .. tostring(BMU_DefaultsPerAccount["hideOthers"]) .. "]",
              getFunc = function() return BMU_SVAcc.hideOthers end,
              setFunc = function(value) BMU_SVAcc.hideOthers = value end,
			  disabled = function() return BMU_SVAcc.onlyMaps end,
			  default = BMU_DefaultsPerAccount["hideOthers"],
			  submenu = "bl",
         },
		 {
              type = "checkbox",
              name = BMU_SI_get(SI.TELE_SETTINGS_HIDE_PVP),
              tooltip = BMU_SI_get(SI.TELE_SETTINGS_HIDE_PVP_TOOLTIP) .. " [DEFAULT: " .. tostring(BMU_DefaultsPerAccount["hidePVP"]) .. "]",
              getFunc = function() return BMU_SVAcc.hidePVP end,
              setFunc = function(value) BMU_SVAcc.hidePVP = value end,
			  disabled = function() return BMU_SVAcc.onlyMaps end,
			  default = BMU_DefaultsPerAccount["hidePVP"],
			  submenu = "bl",
         },
		 {
              type = "checkbox",
              name = BMU_SI_get(SI.TELE_SETTINGS_HIDE_CLOSED_DUNGEONS),
              tooltip = BMU_SI_get(SI.TELE_SETTINGS_HIDE_CLOSED_DUNGEONS_TOOLTIP) .. " [DEFAULT: " .. tostring(BMU_DefaultsPerAccount["hideClosedDungeons"]) .. "]",
              getFunc = function() return BMU_SVAcc.hideClosedDungeons end,
              setFunc = function(value) BMU_SVAcc.hideClosedDungeons = value end,
			  disabled = function() return BMU_SVAcc.onlyMaps end,
			  default = BMU_DefaultsPerAccount["hideClosedDungeons"],
			  submenu = "bl",
         },
		 {
              type = "checkbox",
              name = BMU_SI_get(SI.TELE_SETTINGS_HIDE_DELVES),
              tooltip = BMU_SI_get(SI.TELE_SETTINGS_HIDE_DELVES_TOOLTIP) .. " [DEFAULT: " .. tostring(BMU_DefaultsPerAccount["hideDelves"]) .. "]",
              getFunc = function() return BMU_SVAcc.hideDelves end,
              setFunc = function(value) BMU_SVAcc.hideDelves = value end,
			  disabled = function() return BMU_SVAcc.onlyMaps end,
			  default = BMU_DefaultsPerAccount["hideDelves"],
			  submenu = "bl",
         },
		 {
              type = "checkbox",
              name = BMU_SI_get(SI.TELE_SETTINGS_HIDE_PUBLIC_DUNGEONS),
              tooltip = BMU_SI_get(SI.TELE_SETTINGS_HIDE_PUBLIC_DUNGEONS_TOOLTIP) .. " [DEFAULT: " .. tostring(BMU_DefaultsPerAccount["hidePublicDungeons"]) .. "]",
              getFunc = function() return BMU_SVAcc.hidePublicDungeons end,
              setFunc = function(value) BMU_SVAcc.hidePublicDungeons = value end,
			  disabled = function() return BMU_SVAcc.onlyMaps end,
			  default = BMU_DefaultsPerAccount["hidePublicDungeons"],
			  submenu = "bl",
         },
		 {
              type = "checkbox",
              name = BMU_SI_get(SI.TELE_SETTINGS_HIDE_HOUSES),
              tooltip = BMU_SI_get(SI.TELE_SETTINGS_HIDE_HOUSES_TOOLTIP) .. " [DEFAULT: " .. tostring(BMU_DefaultsPerAccount["hideHouses"]) .. "]",
              getFunc = function() return BMU_SVAcc.hideHouses end,
              setFunc = function(value) BMU_SVAcc.hideHouses = value end,
			  disabled = function() return BMU_SVAcc.onlyMaps end,
			  default = BMU_DefaultsPerAccount["hideHouses"],
			  submenu = "bl",
         },
		 {
              type = "checkbox",
              name = BMU_SI_get(SI.TELE_SETTINGS_HIDE_OWN_HOUSES),
              tooltip = BMU_SI_get(SI.TELE_SETTINGS_HIDE_OWN_HOUSES_TOOLTIP) .. " [DEFAULT: " .. tostring(BMU_DefaultsPerAccount["hideOwnHouses"]) .. "]",
              getFunc = function() return BMU_SVAcc.hideOwnHouses end,
              setFunc = function(value) BMU_SVAcc.hideOwnHouses = value end,
			  default = BMU_DefaultsPerAccount["hideOwnHouses"],
			  submenu = "bl",
         },
		 {
              type = "description",
              text = BMU_SI_get(SI.TELE_SETTINGS_PRIORITIZATION_DESCRIPTION),
			  submenu = "prio",
         },
         {
              type = "dropdown",
			  width = "half",
              name = "PRIO 1",
              tooltip = "",
			  choices = BMU.dropdownPrioSourceChoices,
			  choicesValues = BMU.dropdownPrioSourceValues,
              getFunc = function() return BMU.savedVarsServ.prioritizationSource[1] end,
			  setFunc = function(value)
				-- swap positions
				local index = BMU.getIndexFromValue(BMU.savedVarsServ.prioritizationSource, value)
				BMU.savedVarsServ.prioritizationSource[index] = BMU.savedVarsServ.prioritizationSource[1]
				BMU.savedVarsServ.prioritizationSource[1] = value
			  end,
			  default = BMU.DefaultsServer["prioritizationSource"][1],
			  submenu = "prio",
        },
		{
              type = "dropdown",
			  width = "half",
              name = "PRIO 2",
              tooltip = "",
			  choices = BMU.dropdownPrioSourceChoices,
			  choicesValues = BMU.dropdownPrioSourceValues,
              getFunc = function() return BMU.savedVarsServ.prioritizationSource[2] end,
			  setFunc = function(value)
				-- swap positions
				local index = BMU.getIndexFromValue(BMU.savedVarsServ.prioritizationSource, value)
				BMU.savedVarsServ.prioritizationSource[index] = BMU.savedVarsServ.prioritizationSource[2]
				BMU.savedVarsServ.prioritizationSource[2] = value
			  end,
			  disabled = function()
				if #BMU.dropdownPrioSourceValues >= 2 then
					return false
				else
					return true
				end
			  end,
			  default = BMU.DefaultsServer["prioritizationSource"][2],
			  submenu = "prio",
        },
		{
              type = "dropdown",
			  width = "half",
              name = "PRIO 3",
              tooltip = "",
			  choices = BMU.dropdownPrioSourceChoices,
			  choicesValues = BMU.dropdownPrioSourceValues,
              getFunc = function() return BMU.savedVarsServ.prioritizationSource[3] end,
			  setFunc = function(value)
			  	-- swap positions
				local index = BMU.getIndexFromValue(BMU.savedVarsServ.prioritizationSource, value)
				BMU.savedVarsServ.prioritizationSource[index] = BMU.savedVarsServ.prioritizationSource[3]
				BMU.savedVarsServ.prioritizationSource[3] = value
			  end,
			  disabled = function()
				if #BMU.dropdownPrioSourceValues >= 3 then
					return false
				else
					return true
				end
			  end,
			  default = BMU.DefaultsServer["prioritizationSource"][3],
			  submenu = "prio",
        },
		{
              type = "dropdown",
			  width = "half",
              name = "PRIO 4",
              tooltip = "",
			  choices = BMU.dropdownPrioSourceChoices,
			  choicesValues = BMU.dropdownPrioSourceValues,
              getFunc = function() return BMU.savedVarsServ.prioritizationSource[4] end,
			  setFunc = function(value)
				-- swap positions
				local index = BMU.getIndexFromValue(BMU.savedVarsServ.prioritizationSource, value)
				BMU.savedVarsServ.prioritizationSource[index] = BMU.savedVarsServ.prioritizationSource[4]
				BMU.savedVarsServ.prioritizationSource[4] = value
			  end,
			  disabled = function()
				if #BMU.dropdownPrioSourceValues >= 4 then
					return false
				else
					return true
				end
			  end,
			  default = BMU.DefaultsServer["prioritizationSource"][4],
			  submenu = "prio",
        },
		{
              type = "dropdown",
			  width = "half",
              name = "PRIO 5",
              tooltip = "",
			  choices = BMU.dropdownPrioSourceChoices,
			  choicesValues = BMU.dropdownPrioSourceValues,
              getFunc = function() return BMU.savedVarsServ.prioritizationSource[5] end,
			  setFunc = function(value)
			  			  	-- swap positions
				local index = BMU.getIndexFromValue(BMU.savedVarsServ.prioritizationSource, value)
				BMU.savedVarsServ.prioritizationSource[index] = BMU.savedVarsServ.prioritizationSource[5]
				BMU.savedVarsServ.prioritizationSource[5] = value
			  end,
			  disabled = function()
				if #BMU.dropdownPrioSourceValues >= 5 then
					return false
				else
					return true
				end
			  end,
			  default = BMU.DefaultsServer["prioritizationSource"][5],
			  submenu = "prio",
        },
		{
              type = "dropdown",
			  width = "half",
              name = "PRIO 6",
              tooltip = "",
			  choices = BMU.dropdownPrioSourceChoices,
			  choicesValues = BMU.dropdownPrioSourceValues,
              getFunc = function() return BMU.savedVarsServ.prioritizationSource[6] end,
			  setFunc = function(value)
			  	-- swap positions
				local index = BMU.getIndexFromValue(BMU.savedVarsServ.prioritizationSource, value)
				BMU.savedVarsServ.prioritizationSource[index] = BMU.savedVarsServ.prioritizationSource[6]
				BMU.savedVarsServ.prioritizationSource[6] = value
			  end,
			  disabled = function()
				if #BMU.dropdownPrioSourceValues >= 6 then
					return false
				else
					return true
				end
			  end,
			  default = BMU.DefaultsServer["prioritizationSource"][6],
			  submenu = "prio",
        },
		 {
              type = "checkbox",
              name = BMU_SI_get(SI.TELE_SETTINGS_SHOW_TELEPORT_ANIMATION),
              tooltip = BMU_SI_get(SI.TELE_SETTINGS_SHOW_TELEPORT_ANIMATION_TOOLTIP) .. " [DEFAULT: " .. tostring(BMU_DefaultsPerAccount["showTeleportAnimation"]) .. "]",
              getFunc = function() return BMU_SVAcc.showTeleportAnimation end,
              setFunc = function(value) BMU_SVAcc.showTeleportAnimation = value end,
			  default = BMU_DefaultsPerAccount["showTeleportAnimation"],
			  submenu = "adv",
         },
		 {
              type = "divider",
			  submenu = "adv",
         },
		 {
              type = "checkbox",
              name = BMU_SI_get(SI.TELE_SETTINGS_USE_PAN_AND_ZOOM),
              tooltip = BMU_SI_get(SI.TELE_SETTINGS_USE_PAN_AND_ZOOM_TOOLTIP) .. " [DEFAULT: " .. tostring(BMU_DefaultsPerAccount["usePanAndZoom"]) .. "]",
              getFunc = function() return BMU_SVAcc.usePanAndZoom end,
              setFunc = function(value) BMU_SVAcc.usePanAndZoom = value end,
			  default = BMU_DefaultsPerAccount["usePanAndZoom"],
			  submenu = "adv",
         },
		 {
              type = "checkbox",
              name = BMU_SI_get(SI.TELE_SETTINGS_USE_RALLY_POINT),
              tooltip = BMU_SI_get(SI.TELE_SETTINGS_USE_RALLY_POINT_TOOLTIP) .. " [DEFAULT: " .. tostring(BMU_DefaultsPerAccount["useMapPing"]) .. "]",
              getFunc = function() return BMU_SVAcc.useMapPing end,
              setFunc = function(value) BMU_SVAcc.useMapPing = value end,
			  disabled = function() return not BMU.LibMapPing end,
			  default = BMU_DefaultsPerAccount["useMapPing"],
			  submenu = "adv",
         },
		 {
              type = "divider",
			  submenu = "adv",
         },
         {
              type = "dropdown",
              name = BMU_SI_get(SI.TELE_SETTINGS_SECOND_SEARCH_LANGUAGE),
              tooltip = BMU_SI_get(SI.TELE_SETTINGS_SECOND_SEARCH_LANGUAGE_TOOLTIP) .. " [DEFAULT: " .. BMU.dropdownSecLangChoices[BMU_DefaultsPerAccount["secondLanguage"]] .. "]",
			  choices = BMU.dropdownSecLangChoices,
			  choicesValues = BMU.dropdownSecLangValues,
              getFunc = function() return BMU_SVAcc.secondLanguage end,
			  setFunc = function(value) BMU_SVAcc.secondLanguage = value end,
			  default = BMU_DefaultsPerAccount["secondLanguage"],
			  submenu = "adv",
        },
		 {
              type = "divider",
			  submenu = "adv",
         },
		 {
              type = "checkbox",
              name = BMU_SI_get(SI.TELE_SETTINGS_NOTIFICATION_PLAYER_FAVORITE_ONLINE),
              tooltip = BMU_SI_get(SI.TELE_SETTINGS_NOTIFICATION_PLAYER_FAVORITE_ONLINE_TOOLTIP) .. " [DEFAULT: " .. tostring(BMU_DefaultsPerAccount["FavoritePlayerStatusNotification"]) .. "]",
              getFunc = function() return BMU_SVAcc.FavoritePlayerStatusNotification end,
              setFunc = function(value) BMU_SVAcc.FavoritePlayerStatusNotification = value end,
			  default = BMU_DefaultsPerAccount["FavoritePlayerStatusNotification"],
			  requiresReload = true,
			  submenu = "adv",
         },
		 {
              type = "divider",
			  submenu = "adv",
         },
		 {
              type = "checkbox",
              name = BMU_SI_get(SI.TELE_SETTINGS_SURVEY_MAP_NOTIFICATION),
              tooltip = BMU_SI_get(SI.TELE_SETTINGS_SURVEY_MAP_NOTIFICATION_TOOLTIP) .. " [DEFAULT: " .. tostring(BMU_DefaultsPerAccount["surveyMapsNotification"]) .. "]",
              getFunc = function() return BMU_SVAcc.surveyMapsNotification end,
              setFunc = function(value) BMU_SVAcc.surveyMapsNotification = value end,
			  default = BMU_DefaultsPerAccount["surveyMapsNotification"],
			  requiresReload = true,
			  width = "half",
			  submenu = "adv",
         },
		 {
              type = "checkbox",
              name = BMU_SI_get(SI.TELE_SETTINGS_SURVEY_MAP_NOTIFICATION_SOUND),
              tooltip = BMU_SI_get(SI.TELE_SETTINGS_SURVEY_MAP_NOTIFICATION_SOUND_TOOLTIP) .. " [DEFAULT: " .. tostring(BMU_DefaultsPerAccount["surveyMapsNotificationSound"]) .. "]",
              getFunc = function() return BMU_SVAcc.surveyMapsNotificationSound end,
              setFunc = function(value) BMU_SVAcc.surveyMapsNotificationSound = value end,
			  default = BMU_DefaultsPerAccount["surveyMapsNotificationSound"],
			  disabled = function() return not BMU_SVAcc.surveyMapsNotification end,
			  width = "half",
			  submenu = "adv",
         },
		 {
              type = "divider",
			  submenu = "adv",
         },
		 {
              type = "checkbox",
              name = BMU_SI_get(SI.TELE_SETTINGS_AUTO_CONFIRM_WAYSHRINE_TRAVEL),
              tooltip = BMU_SI_get(SI.TELE_SETTINGS_AUTO_CONFIRM_WAYSHRINE_TRAVEL_TOOLTIP) .. " [DEFAULT: " .. tostring(BMU_DefaultsPerAccount["wayshrineTravelAutoConfirm"]) .. "]",
              getFunc = function() return BMU_SVAcc.wayshrineTravelAutoConfirm end,
              setFunc = function(value) BMU_SVAcc.wayshrineTravelAutoConfirm = value end,
			  default = BMU_DefaultsPerAccount["wayshrineTravelAutoConfirm"],
			  requiresReload = true,
			  submenu = "adv",
         },
		 {
              type = "divider",
			  submenu = "adv",
         },
		 {
              type = "checkbox",
              name = BMU_SI_get(SI.TELE_SETTINGS_OFFLINE_NOTE),
              tooltip = BMU_SI_get(SI.TELE_SETTINGS_OFFLINE_NOTE_TOOLTIP) .. " [DEFAULT: " .. tostring(BMU_DefaultsPerAccount["showOfflineReminder"]) .. "]",
              getFunc = function() return BMU_SVAcc.showOfflineReminder end,
              setFunc = function(value) BMU_SVAcc.showOfflineReminder = value end,
			  default = BMU_DefaultsPerAccount["showOfflineReminder"],
			  requiresReload = true,
			  submenu = "adv",
         },
		 {
              type = "divider",
			  submenu = "adv",
         },
		 {
			  type = "checkbox",
			  name = BMU_SI_get(SI.TELE_SETTINGS_OUTPUT_FAST_TRAVEL),
			  tooltip = BMU_SI_get(SI.TELE_SETTINGS_OUTPUT_FAST_TRAVEL_TOOLTIP) .. " [DEFAULT: " .. tostring(BMU_DefaultsPerAccount["chatOutputFastTravel"]) .. "]",
			  getFunc = function() return BMU_SVAcc.chatOutputFastTravel end,
			  setFunc = function(value) BMU_SVAcc.chatOutputFastTravel = value end,
			  default = BMU_DefaultsPerAccount["chatOutputFastTravel"],
			  submenu = "co",
	     },
	     {
			  type = "checkbox",
			  name = BMU_SI_get(SI.TELE_SETTINGS_OUTPUT_ADDITIONAL),
			  tooltip = BMU_SI_get(SI.TELE_SETTINGS_OUTPUT_ADDITIONAL_TOOLTIP) .. " [DEFAULT: " .. tostring(BMU_DefaultsPerAccount["chatOutputAdditional"]) .. "]",
			  getFunc = function() return BMU_SVAcc.chatOutputAdditional end,
			  setFunc = function(value) BMU_SVAcc.chatOutputAdditional = value end,
			  default = BMU_DefaultsPerAccount["chatOutputAdditional"],
			  submenu = "co",
   		 },
   		 {
			  type = "checkbox",
			  name = BMU_SI_get(SI.TELE_SETTINGS_OUTPUT_UNLOCK),
		 	  tooltip = BMU_SI_get(SI.TELE_SETTINGS_OUTPUT_UNLOCK_TOOLTIP) .. " [DEFAULT: " .. tostring(BMU_DefaultsPerAccount["chatOutputUnlock"]) .. "]",
			  getFunc = function() return BMU_SVAcc.chatOutputUnlock end,
			  setFunc = function(value) BMU_SVAcc.chatOutputUnlock = value end,
			  default = BMU_DefaultsPerAccount["chatOutputUnlock"],
			  submenu = "co",
		 },
		 {
			  type = "checkbox",
			  name = BMU_SI_get(SI.TELE_SETTINGS_OUTPUT_DEBUG),
			  tooltip = BMU_SI_get(SI.TELE_SETTINGS_OUTPUT_DEBUG_TOOLTIP),
			  getFunc = function() return BMU.debugMode end,
			  setFunc = function(value) BMU.debugMode = value end,
			  default = false,
			  warning = "This option can not be set permanently.",
			  submenu = "co",
	     },
		 {
              type = "button",
              name = BMU_colorizeText(BMU_SI_get(SI.TELE_SETTINGS_RESET_ALL_COUNTERS), "red"),
			  tooltip = BMU_SI_get(SI.TELE_SETTINGS_RESET_ALL_COUNTERS_TOOLTIP),
			  func = function() for zoneId, _ in pairs(BMU_SVAcc.portCounterPerZone) do
									BMU_SVAcc.portCounterPerZone[zoneId] = nil
								end
								BMU.printToChat("ALL COUNTERS RESETTET!")
						end,
			  width = "half",
			  warning = "All zone counters are reset. Therefore, the sorting by most used and your personal statistics are reset.",
			  submenu = "adv",
         },
	     {
              type = "description",
              text = "Port to specific zone\n(Hint: when you start typing /<zone name> the auto completion will appear on top)\n" .. BMU_colorizeText("/bmutp/<zone name>\n", "gold") .. BMU_colorizeText("Example: /bmutp/deshaan", "lgray"),
			  submenu = "cc",
         },
	     {
              type = "description",
              text = "Port to group leader\n" .. BMU_colorizeText("/bmutp/leader", "gold"),
			  submenu = "cc",
         },
	     {
              type = "description",
              text = "Port to currently focused quest\n" .. BMU_colorizeText("/bmutp/quest", "gold"),
			  submenu = "cc",
         },
	     {
              type = "description",
              text = "Port into primary residence\n" .. BMU_colorizeText("/bmutp/house", "gold"),
			  submenu = "cc",
         },
	     {
              type = "description",
              text = "Port outside primary residence\n" .. BMU_colorizeText("/bmutp/house_out", "gold"),
			  submenu = "cc",
         },
	     {
              type = "description",
              text = "Port to current zone\n" .. BMU_colorizeText("/bmutp/current_zone", "gold"),
			  submenu = "cc",
         },
		 {
              type = "divider",
			  submenu = "cc",
         },
	     {
			type = "description",
			text = "Add zone favorite manually\n" .. BMU_colorizeText("/bmu/favorites/add/zone <fav slot> <zoneName or zoneId> \n", "gold") .. BMU_colorizeText("Example: /bmu/favorites/add/zone 1 Deshaan", "lgray"),
			submenu = "cc",
	   	 },
	     {
              type = "description",
              text = "Add player favorite manually\n" .. BMU_colorizeText("/bmu/favorites/add/player <fav slot> <player name>\n", "gold") .. BMU_colorizeText("Example: /bmu/favorites/add/player 1 @DeadSoon", "lgray"),
			  submenu = "cc",
         },
	     {
			  type = "description",
			  text = "Add wayshrine favorite\nOnce executed, you must interact (`E`) with your favorite wayshrine within 10 seconds. You can assign hotkeys for your favorite wayshrines.\n" .. BMU_colorizeText("/bmu/favorites/add/wayshrine <fav slot>\n", "gold") .. BMU_colorizeText("Example: /bmu/favorites/add/wayshrine 1", "lgray"),
			  submenu = "cc",
	     },
	     {
			  type = "divider",
			  submenu = "cc",
	     },
	     {
              type = "description",
              text = "Add house favorite for zoneID\n" .. BMU_colorizeText("/bmu/house/set/zone <zoneID> <houseID>\n", "gold") .. BMU_colorizeText("Example: /bmu/house/set/zone 1086 68", "lgray"),
			  submenu = "cc",
         },
	     {
              type = "description",
              text = "Add house favorite for current zone\n" .. BMU_colorizeText("/bmu/house/set/current_zone <houseID>\n", "gold") .. BMU_colorizeText("Example: /bmu/house/set/current_zone 68", "lgray"),
			  submenu = "cc",
         },
	     {
              type = "description",
              text = "Add current house as favorite for current zone\n" .. BMU_colorizeText("/bmu/house/set/current_house\n", "gold"),
			  submenu = "cc",
         },
	     {
              type = "description",
              text = "Clear house favorite for current zone\n" .. BMU_colorizeText("/bmu/house/clear/current_zone\n", "gold"),
			  submenu = "cc",
         },
	     {
              type = "description",
              text = "Clear house for zone\n" .. BMU_colorizeText("/bmu/house/clear/zone <zoneID>\n", "gold") .. BMU_colorizeText("Example: /bmu/house/clear/zone 1086", "lgray"),
			  submenu = "cc",
         },
	     {
              type = "description",
              text = "List house favorites\n" .. BMU_colorizeText("/bmu/house/list\n", "gold"),
			  submenu = "cc",
         },
	     {
			  type = "divider",
			  submenu = "cc",
	     },
	     {
              type = "description",
              text = "Start custom vote in group (100% are necessary)\n" .. BMU_colorizeText("/bmu/vote/custom_vote_unanimous <your text>\n", "gold") .. BMU_colorizeText("Example: /bmu/vote/custom_vote_unanimous Do you like BeamMeUp?", "lgray"),
			  submenu = "cc",
         },
	     {
              type = "description",
              text = "Start custom vote in group (>=60% are necessary)\n" .. BMU_colorizeText("/bmu/vote/custom_vote_supermajority <your text>", "gold"),
			  submenu = "cc",
         },
	     {
              type = "description",
              text = "Start custom vote in group (>50% are necessary)\n" .. BMU_colorizeText("/bmu/vote/custom_vote_simplemajority <your text>", "gold"),
			  submenu = "cc",
         },
		 {
              type = "divider",
			  submenu = "cc",
         },
	     {
              type = "description",
              text = "Promote BeamMeUp by printing short advertising text in the chat\n" .. BMU_colorizeText("/bmu/misc/advertise", "gold"),
			  submenu = "cc",
         },
	     {
			type = "description",
			text = "Get current zone id (where the player actually is)\n" .. BMU_colorizeText("/bmu/misc/current_zone_id", "gold"),
			submenu = "cc",
	   	 },
	     {
              type = "description",
              text = "Switch client language (instant reload!)\n" .. BMU_colorizeText("/bmu/misc/lang", "gold"),
			  submenu = "cc",
         },
	     {
              type = "description",
              text = "Enable debug mode\n" .. BMU_colorizeText("/bmu/misc/debug", "gold"),
			  submenu = "cc",
         },
	     {
              type = "description",
              text = BMU_SI_get(SI.TELE_SETTINGS_INSTALLED_SCINCE),
			  width = "half",
			  submenu = "stats",
         },
	     {
              type = "description",
              text = tostring(os.date('%Y/%m/%d', BMU_SVAcc.initialTimeStamp)),
			  width = "half",
			  submenu = "stats",
         },
	     {
              type = "description",
              text = BMU_SI_get(SI.TELE_UI_TOTAL_PORTS),
			  width = "half",
			  submenu = "stats",
         },
	     {
              type = "description",
			-- NOTE: "text" parameter must always be string since LAM2 do not handle integer values correctly 
              text = tostring(BMU.formatGold(BMU_SVAcc.totalPortCounter)),
			  width = "half",
			  submenu = "stats",
         },
	     {
              type = "description",
              text = BMU_SI_get(SI.TELE_UI_GOLD),
			  width = "half",
			  submenu = "stats",
         },
	     {
              type = "description",
              text = tostring(BMU.formatGold(BMU_SVAcc.savedGold)),
			  width = "half",
			  submenu = "stats",
         },
	     {
              type = "description",
              text = BMU_SI_get(SI.TELE_SETTINGS_MOST_PORTED_ZONES),
			  width = "half",
			  submenu = "stats",
         },
	     {
              type = "description",
              text = mostPortedZonesText,
			  width = "half",
			  submenu = "stats",
         },
    }
	
	--LAM2:RegisterOptionControls(appName .. "Options", optionsData)
	
	-- group options by submenu
	local optionsBySubmenu = {}
	for _, option in ipairs(optionsData) do
		if option.submenu ~= nil then
			if optionsBySubmenu[option.submenu] == nil then
				optionsBySubmenu[option.submenu] = {}
			end
			table.insert(optionsBySubmenu[option.submenu], option)
		end
	end
	
	-- create submenus
	local submenu1 = {
		type = "submenu",
		name = "Addon Extensions",
		controls = optionsBySubmenu["deps"],
	}
	local submenu2 = {
		type = "submenu",
		name = BMU_SI_get(SI.TELE_SETTINGS_HEADER_UI),
		controls = optionsBySubmenu["ui"],
	}
	local submenu3 = {
		type = "submenu",
		name = BMU_SI_get(SI.TELE_SETTINGS_HEADER_RECORDS),
		controls = optionsBySubmenu["rec"],
	}
	local submenu4 = {
		type = "submenu",
		name = BMU_SI_get(SI.TELE_SETTINGS_HEADER_BLACKLISTING),
		controls = optionsBySubmenu["bl"],
	}
	local submenu5 = {
		type = "submenu",
		name = BMU_SI_get(SI.TELE_SETTINGS_HEADER_PRIO),
		controls = optionsBySubmenu["prio"],
	}
	local submenu6 = {
		type = "submenu",
		name = BMU_SI_get(SI.TELE_SETTINGS_HEADER_ADVANCED),
		controls = optionsBySubmenu["adv"],
	}
	local submenu7 = {
		type = "submenu",
		name = BMU_SI_get(SI.TELE_SETTINGS_HEADER_CHAT_OUTPUT),
		controls = optionsBySubmenu["co"],
	}
	local submenu8 = {
		type = "submenu",
		name = BMU_SI_get(SI.TELE_SETTINGS_HEADER_CHAT_COMMANDS),
		controls = optionsBySubmenu["cc"],
	}
	local submenu9 = {
		type = "submenu",
		name = BMU_SI_get(SI.TELE_SETTINGS_HEADER_STATS),
		controls = optionsBySubmenu["stats"],
	}
	
	-- register all submenus with options
	-- TODO: add submenu1
	LAM2:RegisterOptionControls(appName .. "Options", {submenu1, submenu2, submenu3, submenu4, submenu5, submenu6, submenu7, submenu8, submenu9})
end

---Helper function to check if the checkbox/radio button should be checked, based on the SavedVariables table, and SV option name
local function isCheckedHelperFunc(p_SVsettings, p_SVsettingName, p_isCheckedValueOrFunc, p_additionalData)
	if p_SVsettings == nil or p_SVsettings[p_SVsettingName] == nil then return false end
	--Check if we got a value or a function returning a value
	local isCheckedValue = getValueOrCallback(p_isCheckedValueOrFunc, p_additionalData)
	--Comapre the SavedVariables to the determined value
	return p_SVsettings[p_SVsettingName] == isCheckedValue
end

--Write LSM's entryType passed in value to the the SV table now
local function updateSVFromLSMEntryNow(p_SVsettings, p_SVsettingName, p_value)
	if p_SVsettings == nil or p_SVsettingName == nil then return end
	p_SVsettings[p_SVsettingName] = p_value
end

--OnClick helper function, updating the SavedVariables table and SV option name based on the checked state of the checkbox or radioButton
local function LSMEntryTypeCheckboxOrRadioButtonClickedHelperFunc(p_SVsettings, p_SVsettingName, p_isCheckedValueOrFunc, p_additionalData, onClickedFuncWasProvided, comboBox, itemName, item, checked, data)
	--DefaultTab change is prepared? Check if the checkbox was checked, and if not pass in the default tab BMU.indexListMain (not the checkbox's checked state)
	local newChecked = checked
	--Special case: Default tab selection for the lists:
	if not onClickedFuncWasProvided and p_SVsettingName == "defaultTab" then
		--Reset the defaultTab to the base list first
		newChecked = BMU.indexListMain
		--If any checkbox for the defaultTab was checked, get that list's value from p_isCheckedValueOrFunc variable/function now
		if checked and p_isCheckedValueOrFunc ~= nil then
			newChecked = getValueOrCallback(p_isCheckedValueOrFunc, p_additionalData)
		end
	end
	updateSVFromLSMEntryNow(p_SVsettings, p_SVsettingName, newChecked)
end

--OnClick helper function, updating the SavedVariables table and SV option name based on the passed in value of the LSM entryType
--[[
local function OtherLSMEntryTypeClickedHelperFunc(p_SVsettings, p_SVsettingName, p_value, comboBox, itemName, item, selectionChanged, oldItem)
	updateSVFromLSMEntryNow(p_SVsettings, p_SVsettingName, p_value)
end
]]


--Dynamically add LSM entries to a LSM contextMenu.
--Currently only for checkboxes and radiobuttons
--Special cases: Happens inside function "LSMEntryTypeCheckboxOrRadioButtonClickedHelperFunc"
local function addDynamicLSMContextMenuEntry(entryType, entryText, SVsettings, SVsettingName, onClickFunc, isCheckedValueOrFunc, additionalData)
	entryType = entryType or LSM_ENTRY_TYPE_NORMAL
	--Create references which do not get changed later
	local p_entryText = entryText
	local p_settingsProvided = (SVsettings ~= nil and SVsettingName ~= nil and true) or false
	local p_onClickFunc = (type(onClickFunc) == typeFunc and onClickFunc) or nil
	local p_isCheckedValueOrFunc = isCheckedValueOrFunc
	local p_additionalData = additionalData

	--EntryType checks
	local isCheckBox = entryType == LSM_ENTRY_TYPE_CHECKBOX
	local isRadioButton = entryType == LSM_ENTRY_TYPE_CHECKBOX

	--If no explicit "checked" function or value was passed in and we are creating a checkBox or radioButton:
	--Just create an anonymous function returning the passed in SV table and it's "current value" (as the function get's
	--called from the open contextMenu, when the entry get's created)
	if p_isCheckedValueOrFunc == nil and (isCheckBox or isRadioButton) and p_settingsProvided then
		p_isCheckedValueOrFunc = function()
			return SVsettings[SVsettingName]
		end
	end

	--Add the LSM checkbox entry
	if isCheckBox then
		AddCustomScrollableMenuCheckbox(p_entryText,
				function(...)					--toggle function of checkbox, params ... = comboBox, itemName, item, checked, data
					local onClickedFuncProvided = p_onClickFunc ~= nil
					if p_settingsProvided then
						LSMEntryTypeCheckboxOrRadioButtonClickedHelperFunc(SVsettings, SVsettingName, p_isCheckedValueOrFunc, p_additionalData, onClickedFuncProvided, ...)
					end
					if onClickedFuncProvided then
						return p_onClickFunc(...)
					end
				end,
				function()
					return isCheckedHelperFunc(SVsettings, SVsettingName, p_isCheckedValueOrFunc, p_additionalData)
				end, 																--is checked function
				p_additionalData													--additionally passed in data
		)

	--Add the LSM radio button entry (only entries with the same buttonGroup specified in additionalData table belong to the same group)
	---Radiobuttons are similar to checkboxes, but within 1 group there can only always be 1 radioButton checked.
	elseif isRadioButton then
		local buttonGroup = (p_additionalData ~= nil and p_additionalData.buttonGroup) or 1
		AddCustomScrollableMenuRadioButton(p_entryText,
				function(...)					--toggle function of checkbox, params ... = comboBox, itemName, item, checked, data
					local onClickedFuncProvided = p_onClickFunc ~= nil
					if p_settingsProvided then
						--The OnClick function can be used to update the SavedVariables for the clicked radioButton control of a radioButton group
						--But you could also pass in the additionalData.buttonGroupOnSelectionChangedCallback(control, previousControl) which fires as any radioButton in the same group was really changed
						--(and not only clicked), and update the SVs based on control.data or any other information then.
						LSMEntryTypeCheckboxOrRadioButtonClickedHelperFunc(SVsettings, SVsettingName, p_isCheckedValueOrFunc, p_additionalData, onClickedFuncProvided, ...)
					end
					if onClickedFuncProvided then
						return p_onClickFunc(...)
					end
				end,
				function()
					return isCheckedHelperFunc(SVsettings, SVsettingName, p_isCheckedValueOrFunc, p_additionalData)
				end, 																--is checked function
				buttonGroup,														--the button group ID where this radiobutton should be added to. Attention: If left empty it will always be 1
				p_additionalData													--additionally passed in data (may contain buttonGroupOnSelectionChangedCallback function(control, previousControl) which is executed as any radioButton in teh same group was changed)
		)
	end
end

--Reset the actual main list filter to "All"
local function resetMainListFilterToAll()
	teleporterVars.choosenListPlayerFilter = BMU_SOURCE_INDEX_ALL
end
BMU.ResetMainListFilterToAll = resetMainListFilterToAll
---^- INS BEARTRAM 20260125 LibScrollableMenu helpers


local stringInstalled = BMU_colorizeText( BMU_SI_Get(SI_TELE_LIB_INSTALLED), colorGreen)
local stringNotInstalled = BMU_colorizeText(BMU_SI_Get(SI_TELE_LIB_NOT_INSTALLED), colorRed)
function BMU.getStringIsInstalledLibrary(addonName)
	local stringInstalled = BMU_colorizeText("installed and enabled", "green")
	local stringNotInstalled = BMU_colorizeText("not installed or disabled", "red")
	
	-- PortToFriendsHouse
	if lowerAddonName== "ptf" then
		local PortToFriend = PortToFriend	 --INS251229 Baertram
		if PortToFriend and PortToFriend.GetFavorites then
			return stringInstalled
		else
			return stringNotInstalled
		end
	end

	-- LibSets
	if lowerAddonName== "libsets" then
		local BMU_LibSets = BMU.LibSets --INS251229 Baertram
		if BMU_LibSets and BMU_LibSets.GetNumItemSetCollectionZoneUnlockedPieces then
			return stringInstalled
		else
			return stringNotInstalled
		end
	end
	
	-- LibMapPing
	if lowerAddonName== "libmapping" then
		if BMU.LibMapPing then
			return stringInstalled
		else
			return stringNotInstalled
		end
	end

	-- LibSlashCommander
	if lowerAddonName== "lsc" then
		if BMU.LSC then
			return stringInstalled
		else
			return stringNotInstalled
		end
	end

	-- LibChatMenuButton
	if lowerAddonName== "lcmb" then
		if BMU.LCMB then
			return stringInstalled
		else
			return stringNotInstalled
		end
	end
	
	-- GamePadMode "IsJustaBmuGamepadPlugin"
	if lowerAddonName== "gamepad" then
		if IsJustaBmuGamepadPlugin or IJA_BMU_GAMEPAD_PLUGIN then
			return stringInstalled
		else
			return stringNotInstalled
		end
	end
	
	-- return empty string if addonName cant bne matched
	return ""
end


-- update content and position of the counter panel
-- display the sum of each related item type without any filter consideration
local textPattern = "%s: %d   %s: %d   %s: %d   %s: %d   %s: %d   %s: %d   %s: %d   %s: %d" --INS251229 Baertram Memory and performance improvement: Do not redefine same string again and again on each function call!
function BMU.updateRelatedItemsCounterPanel()
	local counterPanel = BMU.counterPanel   --INS251229 Baertram
    local svAcc = BMU.savedVarsAcc          --INS251229 Baertram
    local scale = svAcc.Scale               --INS251229 Baertram
    BMU_getDataMapInfo = BMU_getDataMapInfo or BMU.getDataMapInfo --INS251229 Baertram calling same function in 2x nested loop below -> Significant performance improvement!
    BMU_getItemTypeIcon = BMU_getItemTypeIcon or BMU.getItemTypeIcon --INS251229 Baertram Performance reference for multiple same used function below

	local counter_table = {
		[subType_Alchemist] = 0,
		[subType_Enchanter] = 0,
		[subType_Woodworker] = 0,
		[subType_Blacksmith] = 0,
		[subType_Clothier] = 0,
		[subType_Jewelry] = 0,
		[subType_Treasure] = 0,
		[subType_Leads] = 0,
	}

	-- count treasure and survey maps
	local bags = {BAG_BACKPACK, BAG_BANK, BAG_SUBSCRIBER_BANK}
    -- go over all bags and bank
	for _, bagId in ipairs(bags) do
		local lastSlot = GetBagSize(bagId)
		for slotIndex = 0, lastSlot, 1 do
			--local itemName = GetItemName(bagId, slotIndex) --CHG251229 Baertram Not used variable, performance gain
			--local itemType, specializedItemType = GetItemType(bagId, slotIndex) --CHG251229 Baertram Not used variable, performance gain
			local itemId = GetItemId(bagId, slotIndex)
			local _, itemCount, _, _, _, _, _, _ = GetItemInfo(bagId, slotIndex)
            local subType, _ = BMU_getDataMapInfo(itemId)          --CHG251229 Baertram
				
			-- check if item is known from internal data table
			if subType and counter_table[subType] ~= nil then
				counter_table[subType] = counter_table[subType] + itemCount
			end
		end
	end

	-- count leads
	local antiquityId = GetNextAntiquityId()
	while antiquityId do
		if DoesAntiquityHaveLead(antiquityId) then
			counter_table[subType_Leads] = counter_table[subType_Leads] + 1
		end
		antiquityId = GetNextAntiquityId(antiquityId)
	end

	-- set dimension of the icons accordingly to the scale level
	local dimension = 28 * scale --CHG251229 Baertram

	-- build argument list
	local arguments_list = {
		BMU_getItemTypeIcon("alchemist", dimension), counter_table["alchemist"],    --CHG251229 Baertram
		BMU_getItemTypeIcon("enchanter", dimension), counter_table["enchanter"],    --CHG251229 Baertram
		BMU_getItemTypeIcon("woodworker", dimension), counter_table["woodworker"],  --CHG251229 Baertram
		BMU_getItemTypeIcon("blacksmith", dimension), counter_table["blacksmith"],  --CHG251229 Baertram
		BMU_getItemTypeIcon("clothier", dimension), counter_table["clothier"],      --CHG251229 Baertram
		BMU_getItemTypeIcon("jewelry", dimension), counter_table["jewelry"],        --CHG251229 Baertram
		BMU_getItemTypeIcon("treasure", dimension), counter_table["treasure"],      --CHG251229 Baertram
		BMU_getItemTypeIcon("leads", dimension), counter_table["leads"]             --CHG251229 Baertram
	}
	
	local text = string.format(textPattern, unpack(arguments_list))                 --CHG251229 Baertram
	counterPanel:SetText(text)                                                      --CHG251229 Baertram
	-- update position (number of lines may have changed)
	counterPanel:ClearAnchors()                                                     --CHG251229 Baertram
	counterPanel:SetAnchor(TOP, BMU.win.Main_Control, TOP, 1*scale, (90*scale)+((svAcc.numberLines*40)*scale))  --CHG251229 Baertram
end

--------------------------------------------------------------------------------------------------------------------
-- -v- SetupUI
--------------------------------------------------------------------------------------------------------------------
local function SetupUI()
    local BMU_svAcc = BMU.savedVarsAcc                                  							--INS251229 Baertram
    local scale = BMU_svAcc.Scale                                       							--INS251229 Baertram
    BMU_clearInputFields = BMU_clearInputFields or BMU.clearInputFields 							--INS251229 Baertram
	BMU_createTable = BMU_createTable or BMU.createTable											--INS251229 Baertram
	BMU_createTableGuilds = BMU_createTableGuilds or BMU.createTableGuilds							--INS251229 Baertram
	BMU_createTableDungeons = BMU_createTableDungeons or BMU.createTableDungeons					--INS251229 Baertram
	BMU_numOfSurveyTypesChecked = BMU_numOfSurveyTypesChecked or BMU.numOfSurveyTypesChecked   	    --INS251229 Baertram
	BMU_createTableHouses = BMU_createTableHouses or BMU.createTableHouses 	   	    				--INS251229 Baertram
	BMU_setDungeonDifficulty = BMU_setDungeonDifficulty or BMU.setDungeonDifficulty							--INS260125 Baertram
	BMU_getCurrentDungeonDifficulty = BMU_getCurrentDungeonDifficulty or BMU.getCurrentDungeonDifficulty	--INS260125 Baertram

	-----------------------------------------------
	-- Fonts
	
	-- default font
	local fontSize = BMU_round(17*scale, 0)   --CHG251229 Baertram
	local fontStyle = ZoFontGame:GetFontInfo()
	local fontWeight = "soft-shadow-thin"
	BMU.font1 = string_format(fontPattern, fontStyle, fontSize, fontWeight)
	
	-- font of statistics
	fontSize = BMU_round(13*scale, 0)       --CHG251229 Baertram
	fontStyle = ZoFontBookTablet:GetFontInfo()
	--fontStyle = "EsoUI/Common/Fonts/consola.ttf"
	fontWeight = "soft-shadow-thin"
	BMU.font2 = string_format(fontPattern, fontStyle, fontSize, fontWeight)
	
	-----------------------------------------------
    local teleporterWin = BMU.win

    --------------------------------------------------------------------------------------------------------------------
	-- Button on Chat Window
	if BMU.savedVarsAcc.chatButton then
        local BMU_textures_wayshrineBtn = BMU_textures.wayshrineBtn --INS251229 Baertram performance improvement for multiple used variable reference
        local BMU_textures_wayshrineBtnOver = BMU_textures.wayshrineBtnOver --INS251229 Baertram performance improvement for multiple used variable reference
        BMU_OpenTeleporter = BMU_OpenTeleporter or BMU.OpenTeleporter --INS251229 Baertram performance improvement for multiple used variable reference

		if BMU.LCMB then
			-- LibChatMenuButton is enabled
			-- register chat button via library
			-- NOTE: Since BMU.chatButtonTex is not defined, the option for the offset is disabled automatically (positioning is handled by the lib)
			BMU.chatButtonLCMB = BMU.LCMB.addChatButton("!!!BMUChatButton", {BMU_textures_wayshrineBtn, BMU_textures_wayshrineBtnOver}, appName, function() BMU_OpenTeleporter(true) end) --CHG251229 Baertram Performance improvement by using defined local
		else
			-- do it the old way
			-- Texture
			BMU_chatButtonTex = wm:CreateControl("Teleporter_CHAT_MENU_BUTTON", zo_ChatWindow, CT_TEXTURE) --CHG251229 Baertram Performance improvedment for multiple used variable
            BMU.chatButtonTex = BMU_chatButtonTex --INS251229 Baertram
			BMU_chatButtonTex:SetDimensions(33, 33)  --CHG251229 Baertram
			BMU_chatButtonTex:SetAnchor(TOPRIGHT, zo_ChatWindow, TOPRIGHT, -40 - BMU.savedVarsAcc.chatButtonHorizontalOffset, 6) --CHG251229 Baertram
			BMU_chatButtonTex:SetTexture(BMU_textures_wayshrineBtn) --CHG251229 Baertram
			BMU_chatButtonTex:SetMouseEnabled(true) --CHG251229 Baertram
			BMU_chatButtonTex:SetDrawLayer(2) --CHG251229 Baertram
			--Handlers
			BMU_chatButtonTex:SetHandler("OnMouseUp", function() --CHG251229 Baertram
				if button ~= MOUSE_BUTTON_INDEX_LEFT then return end  --INS BAERTRAM20260124
				BMU_OpenTeleporter(true)
			end)
			
			BMU_chatButtonTex:SetHandler("OnMouseEnter", function(chatButtonTexCtrl) --CHG251229 Baertram
				chatButtonTexCtrl:SetTexture(BMU_textures_wayshrineBtnOver) --CHG251229 Baertram
				BMU_tooltipTextEnter(BMU, chatButtonTexCtrl, appName) --CHG251229 Baertram Performance improvement for multiple called same function, respecting : notation (1st passed in param must be the BMU table then)
			end)
		
			BMU_chatButtonTex:SetHandler("OnMouseExit", function(chatButtonTexCtrl) --CHG251229 Baertram
				chatButtonTexCtrl:SetTexture(BMU_textures_wayshrineBtn) --CHG251229 Baertram
				BMU_tooltipTextEnter(BMU, chatButtonTexCtrl) --CHG251229 Baertram Performance improvement for multiple called same function, respecting : notation (1st passed in param must be the BMU table then)
			end)
		end
	end
	
    --------------------------------------------------------------------------------------------------------------------
	-- Bandits Integration -> Add custom button to the side bar (with delay to ensure, that BUI is loaded)
    --------------------------------------------------------------------------------------------------------------------
	zo_callLater(function()
        local BUI = BUI --INS251229 Baertram Performance improvement for multiple called same variable
		if BUI and BUI.PanelAdd then
            BMU_OpenTeleporter = BMU_OpenTeleporter or BMU.OpenTeleporter --INS251229 Baertram performance improvement for multiple used variable reference
			local content = {
					{	
						icon = BMU_textures.wayshrineBtn,
						tooltip	= appName, --CHG251229 Baertram Performance improvement by using defined local
						func = function() BMU_OpenTeleporter(true) end,
						enabled	= true
					},
					--	{icon="",tooltip="",func=function()end,enabled=true},	-- Button 2, etc.
				}
		
			-- add custom button to side bar (Allowing of custom side bar buttons must be activated in BUI settings)
			BUI.PanelAdd(content)
		end
	end,1000)

  --------------------------------------------------------------------------------------------------------------
  --Main Controller. Please notice that teleporterWin comes from our globals variables, as does wm
  --------------------------------------------------------------------------------------------------------------
  teleporterWin_Main_Control = wm:CreateTopLevelWindow("Teleporter_Location_MainController") --INS251229 Baertram performance improvement for multiple used variable reference
  teleporterWin.Main_Control = teleporterWin_Main_Control --INS251229 Baertram

  teleporterWin_Main_Control:SetMouseEnabled(true) --CHG251229 Baertram
  teleporterWin_Main_Control:SetDimensions(500*scale,400*scale) --CHG251229 Baertram
  teleporterWin_Main_Control:SetHidden(true) --CHG251229 Baertram

  local teleporterWin_appTitle = wm:CreateControl("Teleporter_appTitle", teleporterWin_Main_Control, CT_LABEL) --CHG251229 Baertram
  teleporterWin.appTitle = teleporterWin_appTitle
  teleporterWin_appTitle:SetFont(BMU.font1) --CHG251229 Baertram
  teleporterWin_appTitle:SetColor(255, 255, 255, 1) --CHG251229 Baertram
  teleporterWin_appTitle:SetText(BMU_colorizeText(appName, "gold") .. BMU_colorizeText(" - Teleporter", "white")) --CHG251229 Baertram
  --teleporterWin_appTitle:SetAnchor(TOP, teleporterWin_Main_Control, TOP, -31*BMU_svAcc.Scale, -62*BMU_svAcc.Scale) --CHG251229 Baertram
  teleporterWin_appTitle:SetAnchor(CENTER, teleporterWin_Main_Control, TOP, nil, -62*scale) --CHG251229 Baertram
  
  ----- This is where we create the list element for TeleUnicorn/ List
  BMU.TeleporterList = BMU.ListView.new(teleporterWin_Main_Control,  {
    width = 750*scale, --CHG251229 Baertram
    height = 500*scale, --CHG251229 Baertram
  })

  ---------


  --------------------------------------------------------------------------------------------------------------------
  -- Switch BUTTON ON ZoneGuide window
  teleporterWin_zoneGuideSwapTexture = wm:CreateControl(nil, zo_WorldMapZoneStoryTopLevel_Keyboard, CT_TEXTURE) --CHG251229 Baertram Performance improvement
  teleporterWin.zoneGuideSwapTexture = teleporterWin_zoneGuideSwapTexture --CHG251229 Baertram Performance improvement
  teleporterWin_zoneGuideSwapTexture:SetDimensions(50*scale, 50*scale) --CHG251229 Baertram Performance improvement
  teleporterWin_zoneGuideSwapTexture:SetAnchor(TOPRIGHT, zo_WorldMapZoneStoryTopLevel_Keyboard, TOPRIGHT, TOPRIGHT -10*scale, -35*scale) --CHG251229 Baertram Performance improvement
  teleporterWin_zoneGuideSwapTexture:SetTexture(BMU_textures.swapBtn) --CHG251229 Baertram Performance improvement
  teleporterWin_zoneGuideSwapTexture:SetMouseEnabled(true) --CHG251229 Baertram Performance improvement
  
  teleporterWin_zoneGuideSwapTexture:SetHandler("OnMouseUp", function()
	  if button ~= MOUSE_BUTTON_INDEX_LEFT then return end  --INS BAERTRAM20260124
      BMU_OpenTeleporter = BMU_OpenTeleporter or BMU.OpenTeleporter --INS251229 Baertram performance improvement for multiple used variable reference
	  BMU_OpenTeleporter(true) ----CHG251229 Baertram Performance improvement by using local
	end)

  teleporterWin_zoneGuideSwapTexture:SetHandler("OnMouseEnter", function(teleporterWinZoneGuideSwapTextureCtrl) --CHG251229 Baertram Performance improvement
      teleporterWinZoneGuideSwapTextureCtrl:SetTexture(BMU_textures.swapBtnOver) --CHG251229 Baertram Performance improvement
      BMU_tooltipTextEnter(BMU, teleporterWinZoneGuideSwapTextureCtrl,
          BMU_SI_get(SI.TELE_UI_BTN_TOGGLE_ZONE_GUIDE)) --CHG251229 Baertram Performance improvement
  end)

  teleporterWin_zoneGuideSwapTexture:SetHandler("OnMouseExit", function(teleporterWinZoneGuideSwapTextureCtrl) --CHG251229 Baertram Performance improvement
      teleporterWinZoneGuideSwapTextureCtrl:SetTexture(BMU_textures.swapBtn) --CHG251229 Baertram Performance improvement
      BMU_tooltipTextEnter(BMU, teleporterWinZoneGuideSwapTextureCtrl) --CHG251229 Baertram Performance improvement
  end)

  ---------------------------------------------------------------------------------------------------------------
    -------------------------------------------------------------------
  -- Feedback BUTTON
  teleporterWin_feedbackTexture = wm:CreateControl(nil, teleporterWin_Main_Control, CT_TEXTURE)  --INS251229 Baertram
  teleporterWin.feedbackTexture = teleporterWin_feedbackTexture --INS251229 Baertram
  teleporterWin_feedbackTexture:SetDimensions(50*scale, 50*scale) --CHG251229 Baertram
  teleporterWin_feedbackTexture:SetAnchor(TOPLEFT, teleporterWin_Main_Control, TOPLEFT, TOPLEFT-35*scale, -75*scale) --CHG251229 Baertram
  teleporterWin_feedbackTexture:SetTexture(BMU_textures.feedbackBtn) --CHG251229 Baertram
  teleporterWin_feedbackTexture:SetMouseEnabled(true) --CHG251229 Baertram
  
  teleporterWin_feedbackTexture:SetHandler("OnMouseUp", function() --CHG251229 Baertram
      if button ~= MOUSE_BUTTON_INDEX_LEFT then return end  --INS BAERTRAM20260124
      BMU.createMail(teleporterVars.feedbackContact, "Feedback - BeamMeUp", "") --CHG251229 Baertram
	end)
	  
  teleporterWin_feedbackTexture:SetHandler("OnMouseEnter", function(teleporterWin_feedbackTextureCtrl) --CHG251229 Baertram
      teleporterWin_feedbackTextureCtrl:SetTexture(BMU_textures.feedbackBtnOver) --CHG251229 Baertram
      BMU_tooltipTextEnter(BMU, teleporterWin_feedbackTextureCtrl, --CHG251229 Baertram
          GetString(SI_CUSTOMER_SERVICE_SUBMIT_FEEDBACK))
  end)

  teleporterWin_feedbackTexture:SetHandler("OnMouseExit", function(teleporterWin_feedbackTextureCtrl) --CHG251229 Baertram
      teleporterWin_feedbackTextureCtrl:SetTexture(BMU_textures.feedbackBtn) --CHG251229 Baertram
      BMU_tooltipTextEnter(BMU, teleporterWin_feedbackTextureCtrl) --CHG251229 Baertram
  end)

  --------------------------------------------------------------------------------------------------------------------
  -- Guild BUTTON
  -- display button only if guilds are available on players game server
	if teleporterVars.BMUGuilds[worldName] ~= nil then --CHG251229 Baertram
		teleporterWin_guildTexture = wm:CreateControl(nil, teleporterWin_Main_Control, CT_TEXTURE)
        teleporterWin.guildTexture = teleporterWin_guildTexture
		teleporterWin_guildTexture:SetDimensions(40*scale, 40*scale)
		teleporterWin_guildTexture:SetAnchor(TOPLEFT, teleporterWin_Main_Control, TOPLEFT, TOPLEFT+10*scale, -75*scale)
		teleporterWin_guildTexture:SetTexture(BMU_textures.guildBtn)
		teleporterWin_guildTexture:SetMouseEnabled(true)
	  
		teleporterWin_guildTexture:SetHandler("OnMouseUp", function(self, button)
			if button ~= MOUSE_BUTTON_INDEX_LEFT then return end  --INS BAERTRAM20260124
			if not BMU.isCurrentlyRequestingGuildData then
				BMU.requestGuildData()
			end
            BMU_clearInputFields()
			zo_callLater(function() BMU.createTableGuilds() end, 350)
		end)
			  
		teleporterWin_guildTexture:SetHandler("OnMouseEnter", function(self)
		  teleporterWin_guildTexture:SetTexture(BMU_textures.guildBtnOver)
		  BMU:tooltipTextEnter(teleporterWin_guildTexture,
			BMU_SI_get(SI.TELE_UI_BTN_GUILD_BMU))
		end)

		teleporterWin_guildTexture:SetHandler("OnMouseExit", function(self)
		  BMU:tooltipTextEnter(teleporterWin_guildTexture)
		  if BMU.state ~= BMU.indexListGuilds then
			teleporterWin_guildTexture:SetTexture(BMU_textures.guildBtn)
		  end
		end)
	end


  --------------------------------------------------------------------------------------------------------------------
  -- Guild House BUTTON
  -- display button only if guild house is available on players game server
  if teleporterVars.guildHouse[worldName] ~= nil then
	  teleporterWin_guildHouseTexture = wm:CreateControl(nil, teleporterWin_Main_Control, CT_TEXTURE)
	  teleporterWin.guildHouseTexture = teleporterWin_guildHouseTexture
	  teleporterWin_guildHouseTexture:SetDimensions(40*scale, 40*scale)
	  teleporterWin_guildHouseTexture:SetAnchor(TOPLEFT, teleporterWin_Main_Control, TOPLEFT, TOPLEFT+55*scale, -75*scale)
	  teleporterWin_guildHouseTexture:SetTexture(BMU_textures.guildHouseBtn)
	  teleporterWin_guildHouseTexture:SetMouseEnabled(true)

	  teleporterWin_guildHouseTexture:SetHandler("OnMouseUp", function(self, button)
    	  if button ~= MOUSE_BUTTON_INDEX_LEFT then return end  --INS BAERTRAM20260124
		  BMU.portToBMUGuildHouse()
		end)
		  
	  teleporterWin.guildHouseTexture:SetHandler("OnMouseEnter", function(self)
		  teleporterWin.guildHouseTexture:SetTexture(BMU_textures.guildHouseBtnOver)
		  BMU:tooltipTextEnter(teleporterWin.guildHouseTexture,
			  BMU_SI_get(SI.TELE_UI_BTN_GUILD_HOUSE_BMU))
	  end)

	  teleporterWin.guildHouseTexture:SetHandler("OnMouseExit", function(self)
		  teleporterWin.guildHouseTexture:SetTexture(BMU_textures.guildHouseBtn)
		  BMU:tooltipTextEnter(teleporterWin.guildHouseTexture)
	  end)
  end


    --------------------------------------------------------------------------------------------------------------------
	-- Lock/Fix window BUTTON
    --------------------------------------------------------------------------------------------------------------------
	local lockTexture
	teleporterWin_fixWindowTexture = wm:CreateControl(nil, teleporterWin_Main_Control, CT_TEXTURE)
	teleporterWin.fixWindowTexture = teleporterWin_fixWindowTexture
	teleporterWin_fixWindowTexture:SetDimensions(50*scale, 50*scale)
	teleporterWin_fixWindowTexture:SetAnchor(TOPRIGHT, teleporterWin_Main_Control, TOPRIGHT, TOPRIGHT-65*scale, -75*scale)
	-- decide which texture to show
	if BMU.savedVarsAcc.fixedWindow == true then
		lockTexture = BMU_textures.lockClosedBtn
	else
		lockTexture = BMU_textures.lockOpenBtn
	end
	teleporterWin_fixWindowTexture:SetTexture(lockTexture)
	teleporterWin_fixWindowTexture:SetMouseEnabled(true)

	teleporterWin_fixWindowTexture:SetHandler("OnMouseUp", function(teleporterWin_fixWindowTextureCtrl, button)
   	    if button ~= MOUSE_BUTTON_INDEX_LEFT then return end  --INS BAERTRAM20260124
		-- change setting
		BMU_svAcc.fixedWindow = not BMU_svAcc.fixedWindow
		-- fix/unfix window
		BMU.control_global.bd:SetMovable(not BMU_svAcc.fixedWindow)
		-- change texture
		if BMU_svAcc.fixedWindow then
			-- show closed lock over
			lockTexture = BMU_textures.lockClosedBtnOver
		else
			-- show open lock over
			lockTexture = BMU_textures.lockOpenBtnOver
		end
		teleporterWin.fixWindowTexture:SetTexture(lockTexture)
	end)
	
	teleporterWin.fixWindowTexture:SetHandler("OnMouseEnter", function(self)
		if BMU.savedVarsAcc.fixedWindow then
			-- show closed lock over
			lockTexture = BMU_textures.lockClosedBtnOver
		else
			-- show open lock over
			lockTexture = BMU_textures.lockOpenBtnOver
		end
		teleporterWin.fixWindowTexture:SetTexture(lockTexture)
		BMU:tooltipTextEnter(teleporterWin.fixWindowTexture,BMU_SI_get(SI.TELE_UI_BTN_FIX_WINDOW))
	end)

	teleporterWin_fixWindowTexture:SetHandler("OnMouseEnter", function(teleporterWin_fixWindowTextureCtrl)
		if BMU_svAcc.fixedWindow then
			-- show closed lock over
			lockTexture = BMU_textures.lockClosedBtnOver
		else
			-- show open lock over
			lockTexture = BMU_textures.lockOpenBtnOver
		end
		teleporterWin_fixWindowTextureCtrl:SetTexture(lockTexture)
		BMU_tooltipTextEnter(BMU, teleporterWin_fixWindowTextureCtrl,BMU_SI_Get(SI_TELE_UI_BTN_FIX_WINDOW))
	end)

	teleporterWin_fixWindowTexture:SetHandler("OnMouseExit", function(teleporterWin_fixWindowTextureCtrl)
		if BMU_svAcc.fixedWindow then
			-- show closed lock
			lockTexture = BMU_textures.lockClosedBtn
		else
			-- show open lock
			lockTexture = BMU_textures.lockOpenBtn
		end
		teleporterWin_fixWindowTextureCtrl:SetTexture(lockTexture)
		BMU_tooltipTextEnter(BMU, teleporterWin_fixWindowTextureCtrl)
	end)


  --------------------------------------------------------------------------------------------------------------------
  -- ANCHOR BUTTON
  teleporterWin_anchorTexture = wm:CreateControl(nil, teleporterWin_Main_Control, CT_TEXTURE)
  teleporterWin.anchorTexture = teleporterWin_anchorTexture
  teleporterWin_anchorTexture:SetDimensions(50*scale, 50*scale)
  teleporterWin_anchorTexture:SetAnchor(TOPRIGHT, teleporterWin_Main_Control, TOPRIGHT, TOPRIGHT-20*scale, -75*scale)
  teleporterWin_anchorTexture:SetTexture(BMU_textures.anchorMapBtn)
  teleporterWin_anchorTexture:SetMouseEnabled(true)

  teleporterWin_anchorTexture:SetHandler("OnMouseUp", function(self, button)
 	if button ~= MOUSE_BUTTON_INDEX_LEFT then return end  --INS BAERTRAM20260124
	BMU_svAcc.anchorOnMap = not BMU_svAcc.anchorOnMap
    BMU.updatePosition()
  end)
	  
  teleporterWin.anchorTexture:SetHandler("OnMouseEnter", function(self)
	teleporterWin.anchorTexture:SetTexture(BMU_textures.anchorMapBtnOver)
      BMU:tooltipTextEnter(teleporterWin.anchorTexture,
          BMU_SI_get(SI.TELE_UI_BTN_ANCHOR_ON_MAP))
  end)

  teleporterWin.anchorTexture:SetHandler("OnMouseExit", function(self)
	if not BMU.savedVarsAcc.anchorOnMap then
		teleporterWin.anchorTexture:SetTexture(BMU_textures.anchorMapBtn)
	end
      BMU_tooltipTextEnter(BMU, teleporterWin_anchorTextureCtrl)
  end)


  --------------------------------------------------------------------------------------------------------------------
  -- CLOSE / SWAP BUTTON
  teleporterWin_closeTexture = wm:CreateControl(nil, teleporterWin_Main_Control, CT_TEXTURE)
  teleporterWin.closeTexture = teleporterWin_closeTexture
  teleporterWin_closeTexture:SetDimensions(50*scale, 50*scale)
  teleporterWin_closeTexture:SetAnchor(TOPRIGHT, teleporterWin_Main_Control, TOPRIGHT, TOPRIGHT+25*scale, -75*scale)
  teleporterWin_closeTexture:SetTexture(BMU_textures.closeBtn)
  teleporterWin_closeTexture:SetMouseEnabled(true)
  teleporterWin_closeTexture:SetDrawLayer(2)

  teleporterWin_closeTexture:SetHandler("OnMouseUp", function(self, button)
 	  if button ~= MOUSE_BUTTON_INDEX_LEFT then return end  --INS BAERTRAM20260124
      BMU.HideTeleporter()
  end)

  teleporterWin.closeTexture:SetHandler("OnMouseUp", function()
      BMU.HideTeleporter()  end)
	  
  teleporterWin.closeTexture:SetHandler("OnMouseEnter", function(self)
	teleporterWin.closeTexture:SetTexture(BMU_textures.closeBtnOver)
      BMU:tooltipTextEnter(teleporterWin.closeTexture,
          GetString(SI_DIALOG_CLOSE))
  end)

  teleporterWin_closeTexture:SetHandler("OnMouseExit", function(teleporterWin_closeTextureCtrl)
      BMU_tooltipTextEnter(BMU, teleporterWin_closeTextureCtrl)
  end)


  --------------------------------------------------------------------------------------------------------------------
  -- OPEN BUTTON ON MAP (upper left corner)
  --------------------------------------------------------------------------------------------------------------------
	if BMU_svAcc.showOpenButtonOnMap then
		teleporterWin_MapOpen = CreateControlFromVirtual("TeleporterReopenButon", ZO_WorldMap, "ZO_DefaultButton")
		teleporterWin.MapOpen = teleporterWin_MapOpen
		teleporterWin_MapOpen:SetAnchor(TOPLEFT)
		teleporterWin_MapOpen:SetWidth(200)
		teleporterWin_MapOpen:SetText(appName)
		teleporterWin_MapOpen:SetHidden(true)

		teleporterWin_MapOpen:SetHandler("OnClicked",function()
			BMU.OpenTeleporter(true)
		end)
	end

   ---------------------------------------------------------------------------------------------------------------
   -- Search Symbol (no button)
  teleporterWin_SearchTexture = wm:CreateControl(nil, teleporterWin_Main_Control, CT_TEXTURE)
  teleporterWin.SearchTexture = teleporterWin_SearchTexture
  teleporterWin_SearchTexture:SetDimensions(25*scale, 25*scale)
  teleporterWin_SearchTexture:SetAnchor(TOPLEFT, teleporterWin_Main_Control, TOPLEFT, TOPLEFT-35*scale, -10*scale)

  teleporterWin.SearchTexture:SetTexture(BMU_textures.searchBtn)
  
  ---------------------------------------------------------------------------------------------------------------
  -- Searcher (Search for Players)
   teleporterWin_Searcher_Player = CreateControlFromVirtual("Teleporter_SEARCH_EDITBOX",  teleporterWin_Main_Control, "ZO_DefaultEditForBackdrop")
   teleporterWin.Searcher_Player = teleporterWin_Searcher_Player
   teleporterWin_Searcher_Player:SetParent(teleporterWin_Main_Control)
   teleporterWin_Searcher_Player:SetSimpleAnchorParent(10*scale,-10*scale)
   teleporterWin_Searcher_Player:SetDimensions(105*scale,25*scale)
   teleporterWin_Searcher_Player:SetResizeToFitDescendents(false)
   teleporterWin_Searcher_Player:SetFont(BMU.font1)

	-- Placeholder
	teleporterWin_Searcher_Player_Placeholder = wm:CreateControl("Teleporter_SEARCH_EDITBOX_Placeholder", teleporterWin_Searcher_Player, CT_LABEL)
  	teleporterWin_Searcher_Player.Placeholder = teleporterWin_Searcher_Player_Placeholder
    teleporterWin_Searcher_Player_Placeholder:SetSimpleAnchorParent(4*scale,0)
	teleporterWin_Searcher_Player_Placeholder:SetFont(BMU.font1)
	teleporterWin_Searcher_Player_Placeholder:SetText(BMU_colorizeText(GetString(SI_PLAYER_MENU_PLAYER), "lgray"))
    
  -- BackGround
  teleporterWin_SearchBG = wm:CreateControlFromVirtual(" teleporterWin.SearchBG",  teleporterWin_Searcher_Player, "ZO_DefaultBackdrop")
  teleporterWin.SearchBG = teleporterWin_SearchBG
  teleporterWin_SearchBG:ClearAnchors()
  teleporterWin_SearchBG:SetAnchorFill(teleporterWin_Searcher_Player)
  teleporterWin_SearchBG:SetDimensions(teleporterWin_Searcher_Player:GetWidth(),  teleporterWin_Searcher_Player:GetHeight())
  teleporterWin_SearchBG.controlType = CT_CONTROL
  teleporterWin_SearchBG.system = SETTING_TYPE_UI
  teleporterWin_SearchBG:SetHidden(false)
  teleporterWin_SearchBG:SetMouseEnabled(false)
  teleporterWin_SearchBG:SetMovable(false)
  teleporterWin_SearchBG:SetClampedToScreen(true)

  -- Handlers
  ZO_PreHookHandler(teleporterWin_Searcher_Player, "OnTextChanged", function(teleporterWin_Searcher_PlayerCtrl)
	  if teleporterWin_Searcher_PlayerCtrl:HasFocus() then
		  local searchPlayerText = teleporterWin_Searcher_PlayerCtrl:GetText()
		  if (searchPlayerText ~= "" or BMU.state == BMU.indexListSearchPlayer) then
			  -- make sure player placeholder is hidden
			  teleporterWin_Searcher_Player_Placeholder:SetHidden(true)
			  -- clear zone input field
			  teleporterWin_Searcher_Zone:SetText("")
			  -- show zone placeholder
			  teleporterWin_Searcher_Zone.Placeholder:SetHidden(false)
			  BMU_createTable({index=BMU.indexListSearchPlayer, inputString=searchPlayerText})
		  end
	end
  end)

  teleporterWin_Searcher_Player:SetHandler("OnFocusGained", function(self)
	teleporterWin_Searcher_Player_Placeholder:SetHidden(true)
  end)

  teleporterWin_Searcher_Player:SetHandler("OnFocusLost", function(teleporterWin_Searcher_PlayerCtrl)
	if teleporterWin_Searcher_PlayerCtrl:GetText() == "" then
		teleporterWin_Searcher_Player_Placeholder:SetHidden(false)
	end
  end)

  --------------------------------------------------------------------------------------------------------------------
  -- Searcher (Search for zones)
  teleporterWin_Searcher_Zone = CreateControlFromVirtual("Teleporter_Searcher_Player_EDITBOX1",  teleporterWin_Main_Control, "ZO_DefaultEditForBackdrop")
  teleporterWin.Searcher_Zone = teleporterWin_Searcher_Zone
  teleporterWin_Searcher_Zone:SetParent(teleporterWin_Main_Control)
  teleporterWin_Searcher_Zone:SetSimpleAnchorParent(140*scale,-10*scale)
  teleporterWin_Searcher_Zone:SetDimensions(105*scale,25*scale)
  teleporterWin_Searcher_Zone:SetResizeToFitDescendents(false)
  teleporterWin_Searcher_Zone:SetFont(BMU.font1)

  teleporterWin.Searcher_Zone = CreateControlFromVirtual("Teleporter_Searcher_Player_EDITBOX1",  teleporterWin_Main_Control, "ZO_DefaultEditForBackdrop")
  teleporterWin.Searcher_Zone:SetParent(teleporterWin_Main_Control)
  teleporterWin.Searcher_Zone:SetSimpleAnchorParent(140*scale,-10*scale)
  teleporterWin.Searcher_Zone:SetDimensions(105*scale,25*scale)
  teleporterWin.Searcher_Zone:SetResizeToFitDescendents(false)
  teleporterWin.Searcher_Zone:SetFont(BMU.font1)
  
  -- Placeholder
  teleporterWin_Searcher_Zone_Placeholder = wm:CreateControl("TTeleporter_Searcher_Player_EDITBOX1_Placeholder", teleporterWin_Searcher_Zone, CT_LABEL)
  teleporterWin_Searcher_Zone.Placeholder = teleporterWin_Searcher_Zone_Placeholder
  teleporterWin_Searcher_Zone_Placeholder:SetSimpleAnchorParent(4*scale,0*scale)
  teleporterWin_Searcher_Zone_Placeholder:SetFont(BMU.font1)
  teleporterWin_Searcher_Zone_Placeholder:SetText(BMU_colorizeText(GetString(SI_CHAT_CHANNEL_NAME_ZONE), "lgray"))

  -- BG
  teleporterWin_SearchBG_Player = wm:CreateControlFromVirtual(" teleporterWin_SearchBG_Zone",  teleporterWin_Searcher_Zone, "ZO_DefaultBackdrop")
  teleporterWin.SearchBG_Player = teleporterWin_SearchBG_Player
  teleporterWin_SearchBG_Player:ClearAnchors()
  teleporterWin_SearchBG_Player:SetAnchorFill(teleporterWin_Searcher_Zone)
  teleporterWin_SearchBG_Player:SetDimensions(teleporterWin_Searcher_Zone:GetWidth(), teleporterWin_Searcher_Zone:GetHeight())
  teleporterWin_SearchBG_Player.controlType = CT_CONTROL
  teleporterWin_SearchBG_Player.system = SETTING_TYPE_UI
  teleporterWin_SearchBG_Player:SetHidden(false)
  teleporterWin_SearchBG_Player:SetMouseEnabled(false)
  teleporterWin_SearchBG_Player:SetMovable(false)
  teleporterWin_SearchBG_Player:SetClampedToScreen(true)

  -- Handlers
	--Editbox for search (zone search, dungeon search, survey search, lead search, house search, etc.)
	-->Entries in this table below will update the list if the search editBox is having an empty "" text
	local searchEditBoxStatesThatShouldUpdateListIfEditboxEmptry = {
		[BMU.indexListSearchZone] = true,
		[BMU.indexListDungeons] = true,
	}
    ZO_PreHookHandler(teleporterWin_Searcher_Zone, "OnTextChanged", function(teleporterWin_Searcher_ZoneCtrl)
		if teleporterWin_Searcher_ZoneCtrl:HasFocus() then
			local BMU_state = BMU.state
			local searchZoneText = teleporterWin_Searcher_ZoneCtrl:GetText()
			if (searchZoneText ~= "" or searchEditBoxStatesThatShouldUpdateListIfEditboxEmptry[BMU_state]) then
				-- make sure zone placeholder is hidden
				teleporterWin_Searcher_Zone_Placeholder:SetHidden(true)
				-- clear player input field
				teleporterWin_Searcher_Player:SetText("")
				-- show player placeholder
				teleporterWin_Searcher_Player_Placeholder:SetHidden(false)
				if BMU_state == BMU.indexListDungeons then
					BMU_createTableDungeons({inputString=searchZoneText})
				else
					BMU_createTable({index=BMU.indexListSearchZone, inputString=searchZoneText})
				end
			end
		end
	end)

	teleporterWin_Searcher_Zone:SetHandler("OnFocusGained", function(teleporterWin_Searcher_ZoneCtrl)
		teleporterWin_Searcher_Zone_Placeholder:SetHidden(true)
	end)

	teleporterWin_Searcher_Zone:SetHandler("OnFocusLost", function(teleporterWin_Searcher_ZoneCtrl)
		if teleporterWin_Searcher_ZoneCtrl:GetText() == "" then
			teleporterWin_Searcher_Zone_Placeholder:SetHidden(false)
		end
	end)


  --------------------------------------------------------------------------------------------------------------------
  -- Refresh Button
  teleporterWin_Main_Control_RefreshTexture = wm:CreateControl(nil, teleporterWin_Main_Control, CT_TEXTURE)
  teleporterWin_Main_Control.RefreshTexture = teleporterWin_Main_Control_RefreshTexture
  teleporterWin_Main_Control_RefreshTexture:SetDimensions(50*scale, 50*scale)
  teleporterWin_Main_Control_RefreshTexture:SetAnchor(TOPRIGHT, teleporterWin_Main_Control, TOPRIGHT, -80*scale, -5*scale)
  teleporterWin_Main_Control_RefreshTexture:SetTexture(BMU_textures.refreshBtn)
  teleporterWin_Main_Control_RefreshTexture:SetMouseEnabled(true)
  teleporterWin_Main_Control_RefreshTexture:SetDrawLayer(2)

  teleporterWin_Main_Control_RefreshTexture:SetHandler("OnMouseUp", function(self, button)
 	    if button ~= MOUSE_BUTTON_INDEX_LEFT then return end  --INS BAERTRAM20260124
		if BMU.state == BMU.indexListMain then
			-- dont reset slider if user stays already on main list
			BMU_createTable({index=BMU.indexListMain, dontResetSlider=true})
		else
			BMU_createTable({index=BMU.indexListMain})
		end
	  	resetMainListFilterToAll()
  end)
  
  teleporterWin_Main_Control.RefreshTexture:SetHandler("OnMouseEnter", function(self)
      BMU:tooltipTextEnter(teleporterWin_Main_Control.RefreshTexture,
          BMU_SI_get(SI.TELE_UI_BTN_REFRESH_ALL))
      teleporterWin_Main_Control.RefreshTexture:SetTexture(BMU_textures.refreshBtnOver)end)

  teleporterWin_Main_Control.RefreshTexture:SetHandler("OnMouseExit", function(self)
      BMU:tooltipTextEnter(teleporterWin_Main_Control.RefreshTexture)
      teleporterWin_Main_Control.RefreshTexture:SetTexture(BMU_textures.refreshBtn)end)


  --------------------------------------------------------------------------------------------------------------------
  -- Unlock wayshrines
  teleporterWin_Main_Control_portalToAllTexture = wm:CreateControl(nil, teleporterWin_Main_Control, CT_TEXTURE)
  teleporterWin_Main_Control.portalToAllTexture = teleporterWin_Main_Control_portalToAllTexture
  teleporterWin_Main_Control_portalToAllTexture:SetDimensions(50*scale, 50*scale)
  teleporterWin_Main_Control_portalToAllTexture:SetAnchor(TOPRIGHT, teleporterWin_Main_Control, TOPRIGHT, -40*scale, -5*scale)
  teleporterWin_Main_Control_portalToAllTexture:SetTexture(BMU_textures.wayshrineBtn2)
  teleporterWin_Main_Control_portalToAllTexture:SetMouseEnabled(true)
  teleporterWin_Main_Control_portalToAllTexture:SetDrawLayer(2)

	teleporterWin_Main_Control_portalToAllTexture:SetHandler("OnMouseUp", function(self, button)
		if button ~= MOUSE_BUTTON_INDEX_LEFT then return end  --INS BAERTRAM20260124
		BMU.showDialogAutoUnlock()
	end)
  
  teleporterWin_Main_Control.portalToAllTexture:SetHandler("OnMouseEnter", function(self)
	teleporterWin_Main_Control.portalToAllTexture:SetTexture(BMU_textures.wayshrineBtnOver2)
		local tooltipTextCompletion = ""
		if BMU.isZoneOverlandZone() then
			-- add wayshrine discovery info from ZoneGuide
			-- Attention: if the user is in Artaeum, he will see the total number of wayshrines (inclusive Summerset)
			-- however, when starting the auto unlock the function getZoneWayshrineCompletion() will check which wayshrines are really located on this map
			local zoneWayhsrineDiscoveryInfo, zoneWayshrineDiscovered, zoneWayshrineTotal = BMU.getZoneGuideDiscoveryInfo(GetZoneId(GetUnitZoneIndex("player")), ZONE_COMPLETION_TYPE_WAYSHRINES)
			if zoneWayhsrineDiscoveryInfo ~= nil then
				tooltipTextCompletion = "(" .. zoneWayshrineDiscovered .. "/" .. zoneWayshrineTotal .. ")"
				if zoneWayshrineDiscovered >= zoneWayshrineTotal then
					tooltipTextCompletion = BMU_colorizeText(tooltipTextCompletion, "green")
				end
			end
		end
		-- display number of unlocked wayshrines in current zone
		BMU:tooltipTextEnter(teleporterWin_Main_Control.portalToAllTexture, BMU_SI_get(SI.TELE_UI_BTN_UNLOCK_WS) .. " " .. tooltipTextCompletion)
	end)

  teleporterWin_Main_Control.portalToAllTexture:SetHandler("OnMouseExit", function(self)
	teleporterWin_Main_Control.portalToAllTexture:SetTexture(BMU_textures.wayshrineBtn2)
	BMU:tooltipTextEnter(teleporterWin_Main_Control.portalToAllTexture)
  end)
  
  
  ---------------------------------------------------------------------------------------------------------------
  -- Settings
  teleporterWin_Main_Control_SettingsTexture = wm:CreateControl(nil, teleporterWin_Main_Control, CT_TEXTURE)
  teleporterWin_Main_Control.SettingsTexture = teleporterWin_Main_Control_SettingsTexture
  teleporterWin_Main_Control_SettingsTexture:SetDimensions(50*scale, 50*scale)
  teleporterWin_Main_Control_SettingsTexture:SetAnchor(TOPRIGHT, teleporterWin_Main_Control, TOPRIGHT, 0, -5*scale)
  teleporterWin_Main_Control_SettingsTexture:SetTexture(BMU_textures.settingsBtn)
  teleporterWin_Main_Control_SettingsTexture:SetMouseEnabled(true)
  teleporterWin_Main_Control_SettingsTexture:SetDrawLayer(2)

  teleporterWin_Main_Control_SettingsTexture:SetHandler("OnMouseUp", function(self, button)
	if button ~= MOUSE_BUTTON_INDEX_LEFT then return end  --INS BAERTRAM20260124
	BMU.HideTeleporter()
	LAM2:OpenToPanel(BMU.SettingsPanel)
  end)
  
  teleporterWin_Main_Control.SettingsTexture:SetHandler("OnMouseEnter", function(self)
      BMU:tooltipTextEnter(teleporterWin_Main_Control.SettingsTexture,
          GetString(SI_GAME_MENU_SETTINGS))
      teleporterWin_Main_Control.SettingsTexture:SetTexture(BMU_textures.settingsBtnOver)
  end)

  teleporterWin_Main_Control.SettingsTexture:SetHandler("OnMouseExit", function(self)
      BMU:tooltipTextEnter(teleporterWin_Main_Control.SettingsTexture)
      teleporterWin_Main_Control.SettingsTexture:SetTexture(BMU_textures.settingsBtn)
  end)


  --------------------------------------------------------------------------------------------------------------------
  -- "Port to Friends House" Integration
  teleporterWin_Main_Control_PTFTexture = wm:CreateControl(nil, teleporterWin_Main_Control, CT_TEXTURE)
  teleporterWin_Main_Control_PTFTexture = teleporterWin_Main_Control_PTFTexture
  teleporterWin_Main_Control_PTFTexture:SetDimensions(50*scale, 50*scale)
  teleporterWin_Main_Control_PTFTexture:SetAnchor(TOPRIGHT, teleporterWin_Main_Control, TOPRIGHT, -250*scale, 40*scale)
  teleporterWin_Main_Control_PTFTexture:SetTexture(BMU_textures.ptfHouseBtn)
  teleporterWin_Main_Control_PTFTexture:SetMouseEnabled(true)
  teleporterWin_Main_Control_PTFTexture:SetDrawLayer(2)
    local PortToFriend = PortToFriend --INS251229 Baertram performance improvement for 2 same used global variables
	if PortToFriend and PortToFriend.GetFavorites then
		-- enable tab
		teleporterWin_Main_Control_PTFTexture:SetHandler("OnMouseUp", function(ctrl, button, upInside) --CHG251229 Baertram Usage of upInside to properly check the user releaased the mouse on the control!!!
			ClearCustomScrollableMenu()
			if upInside and button == MOUSE_BUTTON_INDEX_RIGHT then --CHG251229 Baertram Usage of upInside to properly check the user releaased the mouse on the control!!!
				-- toggle between zone names and house names
				addDynamicLSMContextMenuEntry(LSM_ENTRY_TYPE_CHECKBOX, BMU_SI_get(SI.TELE_UI_TOOGLE_ZONE_NAME), BMU.savedVarsChar, "ptfHouseZoneNames", nil, nil, nil)

				ShowCustomScrollableMenu(ctrl, nil)
			else
                BMU_clearInputFields()
				BMU.createTablePTF()
			end
		end)
  
		teleporterWin_Main_Control.PTFTexture:SetHandler("OnMouseEnter", function(self)
			BMU:tooltipTextEnter(teleporterWin_Main_Control.PTFTexture,
				BMU_SI_get(SI.TELE_UI_BTN_PTF_INTEGRATION) .. BMU_SI_get(SI.TELE_UI_BTN_TOOLTIP_CONTEXT_MENU))
			teleporterWin_Main_Control.PTFTexture:SetTexture(BMU_textures.ptfHouseBtnOver)
		end)

		teleporterWin_Main_Control.PTFTexture:SetHandler("OnMouseExit", function(self)
			BMU:tooltipTextEnter(teleporterWin_Main_Control.PTFTexture)
			if BMU.state ~= BMU.indexListPTFHouses then
				teleporterWin_Main_Control.PTFTexture:SetTexture(BMU_textures.ptfHouseBtn)
			end
		end)
	else
		-- disable tab
		teleporterWin_Main_Control_PTFTexture:SetAlpha(0.4)

		teleporterWin_Main_Control_PTFTexture:SetHandler("OnMouseUp", function(self, button)
 	        if button ~= MOUSE_BUTTON_INDEX_LEFT then return end  --INS BAERTRAM20260124
			BMU.showDialogSimple("PTFIntegrationMissing", BMU_SI_get(SI.TELE_DIALOG_PTF_INTEGRATION_MISSING_TITLE), BMU_SI_get(SI.TELE_DIALOG_PTF_INTEGRATION_MISSING_BODY), function() RequestOpenUnsafeURL("https://www.esoui.com/downloads/info1758-PorttoFriendsHouse.html") end, nil)
		end)
		
		teleporterWin_Main_Control.PTFTexture:SetHandler("OnMouseEnter", function(self)
			BMU:tooltipTextEnter(teleporterWin_Main_Control.PTFTexture, BMU_SI_get(SI.TELE_UI_BTN_PTF_INTEGRATION))
		end)
		
		teleporterWin_Main_Control.PTFTexture:SetHandler("OnMouseExit", function(self)
			BMU:tooltipTextEnter(teleporterWin_Main_Control.PTFTexture)
		end)
	end
	  
  ---------------------------------------------------------------------------------------------------------------
  -- Own Houses
  teleporterWin_Main_Control_OwnHouseTexture = wm:CreateControl(nil, teleporterWin_Main_Control, CT_TEXTURE)
  teleporterWin_Main_Control.OwnHouseTexture = teleporterWin_Main_Control_OwnHouseTexture
  teleporterWin_Main_Control_OwnHouseTexture:SetDimensions(50*scale, 50*scale)
  teleporterWin_Main_Control_OwnHouseTexture:SetAnchor(TOPRIGHT, teleporterWin_Main_Control, TOPRIGHT, -205*scale, 40*scale)
  teleporterWin_Main_Control_OwnHouseTexture:SetTexture(BMU_textures.houseBtn)
  teleporterWin_Main_Control_OwnHouseTexture:SetMouseEnabled(true)
  teleporterWin_Main_Control_OwnHouseTexture:SetDrawLayer(2)

  teleporterWin_Main_Control_OwnHouseTexture:SetHandler("OnMouseUp", function(ctrl, button)
	ClearCustomScrollableMenu()
	if button == MOUSE_BUTTON_INDEX_RIGHT then
		-- toggle between nicknames and standard names
		addDynamicLSMContextMenuEntry(LSM_ENTRY_TYPE_CHECKBOX, BMU_SI_get(SI.TELE_UI_TOGGLE_HOUSE_NICKNAME), BMU.savedVarsChar , "houseNickNames", nil, nil, nil)

		-- divider
		AddCustomScrollableMenuDivider()

		-- make default tab
		addDynamicLSMContextMenuEntry(LSM_ENTRY_TYPE_CHECKBOX, BMU_SI_get(SI.TELE_SETTINGS_DEFAULT_TAB), BMU.savedVarsChar, "defaultTab", nil, BMU.indexListOwnHouses, nil)

		ShowCustomScrollableMenu(ctrl, nil)
	else
        BMU_clearInputFields( )
		BMU_createTableHouses()
	end
  end)
  
  teleporterWin_Main_Control.OwnHouseTexture:SetHandler("OnMouseEnter", function(self)
    BMU:tooltipTextEnter(teleporterWin_Main_Control.OwnHouseTexture,
		BMU_SI_get(SI.TELE_UI_BTN_PORT_TO_OWN_HOUSE) .. BMU_SI_get(SI.TELE_UI_BTN_TOOLTIP_CONTEXT_MENU))
    teleporterWin_Main_Control.OwnHouseTexture:SetTexture(BMU_textures.houseBtnOver)
  end)

  teleporterWin_Main_Control.OwnHouseTexture:SetHandler("OnMouseExit", function(self)
    BMU:tooltipTextEnter(teleporterWin_Main_Control.OwnHouseTexture)
	if BMU.state ~= BMU.indexListOwnHouses then
		teleporterWin_Main_Control.OwnHouseTexture:SetTexture(BMU_textures.houseBtn)
	end
  end)

  
    ---------------------------------------------------------------------------------------------------------------
  -- Related Quests
  teleporterWin_Main_Control_QuestTexture = wm:CreateControl(nil, teleporterWin_Main_Control, CT_TEXTURE)
  teleporterWin_Main_Control.QuestTexture = teleporterWin_Main_Control_QuestTexture
  teleporterWin_Main_Control_QuestTexture:SetDimensions(50*scale, 50*scale)
  teleporterWin_Main_Control_QuestTexture:SetAnchor(TOPRIGHT, teleporterWin_Main_Control, TOPRIGHT, -160*scale, 40*scale)
  teleporterWin_Main_Control_QuestTexture:SetTexture(BMU_textures.questBtn)
  teleporterWin_Main_Control_QuestTexture:SetMouseEnabled(true)
  teleporterWin_Main_Control_QuestTexture:SetDrawLayer(2)

  teleporterWin_Main_Control_QuestTexture:SetHandler("OnMouseUp", function(ctrl, button)
	ClearCustomScrollableMenu()
	if button == MOUSE_BUTTON_INDEX_RIGHT then
		-- show context menu
		local BMU_savedVarsChar = BMU.savedVarsChar  --INS251229 Baertram
		-- make default tab
		addDynamicLSMContextMenuEntry(LSM_ENTRY_TYPE_CHECKBOX, BMU_SI_get(SI.TELE_SETTINGS_DEFAULT_TAB), BMU_savedVarsChar, "defaultTab", nil, BMU.indexListQuests, nil)

		ShowCustomScrollableMenu(ctrl, nil)
	else
		BMU_createTable({index=BMU.indexListQuests})
	end
  end)
  
  teleporterWin_Main_Control.QuestTexture:SetHandler("OnMouseEnter", function(self)
    BMU:tooltipTextEnter(teleporterWin_Main_Control.QuestTexture,
		GetString(SI_JOURNAL_MENU_QUESTS) .. BMU_SI_get(SI.TELE_UI_BTN_TOOLTIP_CONTEXT_MENU))
    teleporterWin_Main_Control.QuestTexture:SetTexture(BMU_textures.questBtnOver)
  end)

  teleporterWin_Main_Control.QuestTexture:SetHandler("OnMouseExit", function(self)
    BMU:tooltipTextEnter(teleporterWin_Main_Control.QuestTexture)
	if BMU.state ~= BMU.indexListQuests then
		teleporterWin_Main_Control.QuestTexture:SetTexture(BMU_textures.questBtn)
	end
  end)
 
 
 ---------------------------------------------------------------------------------------------------------------
  -- Related Items
  teleporterWin_Main_Control_ItemTexture = wm:CreateControl(nil, teleporterWin_Main_Control, CT_TEXTURE)
  teleporterWin_Main_Control.ItemTexture = teleporterWin_Main_Control_ItemTexture
  teleporterWin_Main_Control_ItemTexture:SetDimensions(50*scale, 50*scale)
  teleporterWin_Main_Control_ItemTexture:SetAnchor(TOPRIGHT, teleporterWin_Main_Control, TOPRIGHT, -120*scale, 40*scale)
  teleporterWin_Main_Control_ItemTexture:SetTexture(BMU_textures.relatedItemsBtn)
  teleporterWin_Main_Control_ItemTexture:SetMouseEnabled(true)
  teleporterWin_Main_Control_ItemTexture:SetDrawLayer(2)

  -- -v- INS251229 Baertram BEGIN 1 Variables for the relevant submenu opening controls
  local submenuIndicesToAddCallbackTo = {}
  local BMU_ItemTexture
  --reference variables for performance etc.
  local BMU_updateCheckboxSurveyMap
  local function BMU_CreateTable_IndexListItems() --local function which is not redefined each contextMenu open again and again and again -> memory and performance drain!
    BMU.createTable({index=BMU.indexListItems})
  end
  -- -^- INS251229 Baertram END 1
  teleporterWin_Main_Control.ItemTexture:SetHandler("OnMouseUp", function(self, button)
      BMU_ItemTexture = BMU_ItemTexture or teleporterWin_Main_Control.ItemTexture               --INS251229 Baertram
      BMU_updateCheckboxSurveyMap = BMU_updateCheckboxSurveyMap or BMU.updateCheckboxSurveyMap  --INS251229 Baertram
	  submenuIndicesToAddCallbackTo = {}                                                        --INS251229 Baertram
	  local BMU_savedVarsChar = BMU.savedVarsChar												--INS251229 Baertram

	  ClearCustomScrollableMenu()
	  if button == MOUSE_BUTTON_INDEX_RIGHT then
		  ClearCustomScrollableMenu()
		  -- show filter menu

		  -- Add submenu for antiquity leads
		  -- Add submenu dynamically for all lead types: Each lead type = 1 filter checkbox
		  local leadTypesSubmenuEntries = {}
		  for leadTypeIndex, leadType in ipairs(leadTypes) do
			  local leadTypeName         = leadTypeNames[leadTypeIndex] or leadType
			  local leadTypeSubmenuEntry = {
				  label = leadTypeName,
				  callback = function(comboBox, itemName, item, checked, data)
					  BMU.savedVarsChar.displayAntiquityLeads[leadType] = checked
					  refreshLeadsMainMenu(comboBox)
				  end,
				  entryType = LSM_ENTRY_TYPE_CHECKBOX,
				  checked = function() return BMU.savedVarsChar.displayAntiquityLeads[leadType] end,
			  }
			  leadTypesSubmenuEntries[#leadTypesSubmenuEntries +1] = leadTypeSubmenuEntry
		  end

		  AddCustomScrollableSubMenuEntry(function() return BMU_updateContextMenuEntryAntiquityAll() end, --INS251229 Baertram Antiquity/Lead filters
				  leadTypesSubmenuEntries,
			    function(comboBox, itemName, item, selectionChanged, oldItem)
				  --d("Clicked Leads submenu openingControl")
					  allLeadFiltersEnabled = not allLeadFiltersEnabled
					  -- check all subTypes (1) or uncheck all subtypes (2)
					  BMU_updateCheckboxLeadsMap(allLeadFiltersEnabled and 1 or 2)
					  refreshLeadsMainMenu(comboBox)
			    end,
				{ --additionalData
					tooltip = BMU_SI_get(SI.CONSTANT_LSM_CLICK_SUBMENU_TOGGLE_ALL),
				}
		  )

			--[[
		  AddCustomScrollableSubMenuEntry(GetString(SI_GAMEPAD_VENDOR_ANTIQUITY_LEAD_GROUP_HEADER), --INS251229 Baertram
				  {
					  {
						  label = GetString(SI_ANTIQUITY_SCRYABLE),
						  callback = function(comboBox, itemName, item, checked, data)
							  BMU_savedVarsChar.displayAntiquityLeads.srcyable = checked
							  BMU_CreateTable_IndexListItems() end,
						  entryType = LSM_ENTRY_TYPE_CHECKBOX,
						  checked = function() return BMU_savedVarsChar.displayAntiquityLeads.srcyable end,
					  },
					  {
						  label = GetString(SI_ANTIQUITY_SUBHEADING_IN_PROGRESS),
						  callback = function(comboBox, itemName, item, checked, data)
							  BMU_savedVarsChar.displayAntiquityLeads.scried = checked
							  BMU_CreateTable_IndexListItems() end,
						  entryType = LSM_ENTRY_TYPE_CHECKBOX,
						  checked = function() return BMU_savedVarsChar.displayAntiquityLeads.scried end,
					  },
					  {
						  label = GetString(SI_SCREEN_NARRATION_ACHIEVEMENT_EARNED_ICON_NARRATION) .. " (" .. GetString(SI_ANTIQUITY_LOG_BOOK) .. ")",
						  callback = function(comboBox, itemName, item, checked, data)
							  BMU_savedVarsChar.displayAntiquityLeads.completed = checked
							  BMU_CreateTable_IndexListItems() end,
						  entryType = LSM_ENTRY_TYPE_CHECKBOX,
						  checked = function() return BMU_savedVarsChar.displayAntiquityLeads.completed end,
					  },
				  }, nil, nil, nil, 5
		  )

		  -- Clues
		  addDynamicLSMContextMenuEntry(LSM_ENTRY_TYPE_CHECKBOX, GetString(SI_SPECIALIZEDITEMTYPE113), BMU.savedVarsChar.displayMaps, "clue", nil, nil, nil)

		  -- Treasure Maps
		  addDynamicLSMContextMenuEntry(LSM_ENTRY_TYPE_CHECKBOX, GetString(SI_SPECIALIZEDITEMTYPE100), BMU.savedVarsChar.displayMaps, "treasure", nil, nil, nil)

		  -- All Survey Maps
		  addDynamicLSMContextMenuEntry(LSM_ENTRY_TYPE_CHECKBOX, GetString(SI_SPECIALIZEDITEMTYPE100), BMU.savedVarsChar.displayMaps, "treasure", nil, nil, nil)

		  BMU_getContextMenuEntrySurveyAllAppendix = BMU_getContextMenuEntrySurveyAllAppendix or BMU.getContextMenuEntrySurveyAllAppendix --INS251229 Baertram
		  BMU_numOfSurveyTypesChecked = BMU_numOfSurveyTypesChecked or BMU.numOfSurveyTypesChecked 										  --INS251229 Baertram
		  addDynamicLSMContextMenuEntry(LSM_ENTRY_TYPE_CHECKBOX, function() return BMU_updateContextMenuEntrySurveyAll() end, nil, nil,
				  function(comboBox, itemName, item, checked, data)
					  -- check all subTypes (1) or uncheck all subtypes (2)
					  BMU_updateCheckboxSurveyMap(allSurveyFiltersEnabled and 1 or 2)
					  refreshSurveyMapMainMenu(comboBox)
			    end,
				{ --additionalData
					tooltip = BMU_SI_get(SI.CONSTANT_LSM_CLICK_SUBMENU_TOGGLE_ALL),
				}
		  )

		  -- divider
		  AddCustomScrollableMenuDivider()

		  -- include bank items
		  addDynamicLSMContextMenuEntry(LSM_ENTRY_TYPE_CHECKBOX, GetString(SI_CRAFTING_INCLUDE_BANKED), BMU.savedVarsChar, "scanBankForMaps", nil, nil, nil)

		  -- enable/disable counter panel
		  addDynamicLSMContextMenuEntry(LSM_ENTRY_TYPE_CHECKBOX, GetString(SI_ENDLESS_DUNGEON_BUFF_TRACKER_SWITCH_TO_SUMMARY_KEYBIND), BMU.savedVarsChar, "displayCounterPanel", nil, nil, nil)

		  -- divider
		  AddCustomScrollableMenuDivider()

		  -- make default tab
		  addDynamicLSMContextMenuEntry(LSM_ENTRY_TYPE_CHECKBOX, BMU_SI_get(SI.TELE_SETTINGS_DEFAULT_TAB), BMU.savedVarsChar, "defaultTab", nil, BMU.indexListItems, nil)

		  ShowCustomScrollableMenu()
	  else
		  BMU_CreateTable_IndexListItems()
		  BMU.showNotification(true)
	  end
  end)
  -- -v- INS251229 Baertram BEGIN 2 - Variables for the submenu OnMouseUp click handler -> Clicking the submenu opening controls toggles all checkboxes in the submenu to checked/unchecked
  --[[
  --Called from ZO_Menu_OnHide callback
  local function cleanUpzo_MenuItemsSubmenuSpecialCallbacks()
--d("[BMU]cleanUpzo_MenuItemsSubmenuSpecialCallbacks")
      if zo_IsTableEmpty(submenuIndicesToAddCallbackTo) or zo_IsTableEmpty(zo_MenuSubmenuItemsHooked) then return end
      submenuIndicesToAddCallbackTo = {}
      zo_MenuSubmenuItemsHooked = {}
  end

  --Check if LibCustomMenuSubmenu is shown and if any enabled and shown checkboxes are in the submenu, then change the clicked state of them
  --> Called from clicking the ZO_Menu entry which opens the submenu
  local function checkIfLibCustomMenuSubmenuShownAndToggleCheckboxes(itemCtrl, mouseButton, upInside)
--d("[BMU]checkIfLibCustomMenuSubmenuShownAndToggleCheckboxes-mouseButton: " .. tostring(mouseButton) .. ", upInside: " ..tostring(upInside))
      --LibCustomMenuSubmenu got entries?
      if not upInside or mouseButton ~= MOUSE_BUTTON_INDEX_LEFT or not libCustomMenuSubmenu or zo_MenuSubmenuItemsHooked[itemCtrl] == nil then return end
      --Get the current state of the submenu (if not set yet it is assumed to be "all unchecked")
      local checkboxesAtSubmenuNewState = checkboxesAtSubmenuCurrentState[itemCtrl] or false
      --and invert it (on -> off / off -> on)
      checkboxesAtSubmenuNewState = not checkboxesAtSubmenuNewState

      --Check all child controls of the submenu for any checkbox entry and set the new state and calling the toggle function of the checkbox
      for childIndex=1, libCustomMenuSubmenu:GetNumChildren(), 1 do
        local childCtrl = libCustomMenuSubmenu:GetChild(childIndex)
--d(">found childCtrl: " ..tostring(childCtrl:GetName()))
          --Child is a subMenuItem?
          if childCtrl ~= nil then
            local checkBox = childCtrl.checkbox
            if childCtrl.IsHidden and childCtrl.IsMouseEnabled and not childCtrl:IsHidden() and childCtrl:IsMouseEnabled()
                  and checkBox and checkBox.toggleFunction and zo_CheckButton_IsEnabled(checkBox)
                  and childCtrl.GetName and zoPlainStrFind(childCtrl:GetName(), LCM_SubmenuEntryNamePrefix) ~= nil then
--d(">>set new state to: " ..tostring(checkboxesAtSubmenuNewState))
              zo_CheckButton_SetCheckState(checkBox, (checkboxesAtSubmenuNewState == false and BSTATE_NORMAL) or BSTATE_PRESSED)
              checkBox:toggleFunction(checkboxesAtSubmenuNewState)
            end
          end
      end
  end

  --Add the PreHook for handler OnMouseUp, on the submenu opening ZO_Menu item control row
  local function AddToggleAllSubmenuCheckboxEntriesCallback(submenuIndex)
      --d("[BMU]AddToggleAllSubmenuCheckboxEntriesCallback-index: " .. tostring(submenuIndex))
      if not submenuIndex then return end
      local submenuItem = zo_Menu.items[submenuIndex]
      local itemCtrl = submenuItem and submenuItem.item or nil
      --d(">found the itemCtrl: " .. tostring(itemCtrl))
      --Found the zo_Menu submenu opening control?
      if not itemCtrl then return end
      --Add the OnEffectivelyShown handler to the submenu opening control of zo_Menu (if not already in it)
      if zo_MenuSubmenuItemsHooked[itemCtrl] ~= nil then return end
      zo_MenuSubmenuItemsHooked[itemCtrl] = true
      ZO_PreHookHandler(itemCtrl, "OnMouseUp", checkIfLibCustomMenuSubmenuShownAndToggleCheckboxes)
  end

  --Add a prehook to the OnMouseUp handler of the relevant submenu opening ZO_Menu controls (saved into table submenuIndicesToAddCallbackTo)
   ZO_PostHook("ShowMenu", function(owner, initialRefCount, menuType)
      owner = owner or moc()
      menuType = menuType or MENU_TYPE_DEFAULT
--d("[BMU]ShowMenu-owner: " .. tostring(owner) .. "/" .. tostring(BMU_ItemTexture) .. "; menuType: " ..tostring(menuType))
      --Check if the menu is our at the BMU panel's itemTexture, if it got entries, if special submenu items have been defined -> Else abort
      if menuType ~= MENU_TYPE_DEFAULT or (owner == nil or owner ~= BMU_ItemTexture) or zo_IsTableEmpty(submenuIndicesToAddCallbackTo)
              or next(zo_Menu.items) == nil then return end
      zo_MenuSubmenuItemsHooked = {}
      --Add the OnMouseUp handler to the submenu's "opening control" so clicking them will enable/disable (toggle) all the checkboxes inside the submenu
      for _, indexToAddTo in ipairs(submenuIndicesToAddCallbackTo) do
          AddToggleAllSubmenuCheckboxEntriesCallback(indexToAddTo)
      end
      --Called at zo_Menu_OnHide, and cleaned automatically at ClearMenu()
      SetMenuHiddenCallback(cleanUpzo_MenuItemsSubmenuSpecialCallbacks)
  end)
  ]]
  -- -^- INS251229 Baertram - END 2
  
  teleporterWin_Main_Control.ItemTexture:SetHandler("OnMouseEnter", function(self)
	-- set tooltip accordingly to the selected filter
	local tooltip = ""
    local BMU_savedVarsChar = BMU.savedVarsChar --INS251229 Baertram
	if BMU_savedVarsChar.displayAntiquityLeads.scried or BMU_savedVarsChar.displayAntiquityLeads.srcyable then
		tooltip = GetString(SI_ANTIQUITY_LEAD_TOOLTIP_TAG)
	end
	if BMU_savedVarsChar.displayMaps.clue then
		if tooltip ~= "" then
			tooltip = tooltip .. " + " .. GetString(SI_SPECIALIZEDITEMTYPE113)
		else
			tooltip = GetString(SI_SPECIALIZEDITEMTYPE113)
		end
	end
	if BMU_savedVarsChar.displayMaps.treasure then
		if tooltip ~= "" then
			tooltip = tooltip .. " + " .. GetString(SI_SPECIALIZEDITEMTYPE100)
		else
			tooltip = GetString(SI_SPECIALIZEDITEMTYPE100)
		end
	end
	if BMU_numOfSurveyTypesChecked() > 0 then
		if tooltip ~= "" then
			tooltip = tooltip .. " + " .. GetString(SI_SPECIALIZEDITEMTYPE101)
		else
			tooltip = GetString(SI_SPECIALIZEDITEMTYPE101)
		end
	end
	-- add right-click info
	tooltip = tooltip .. BMU_SI_get(SI.TELE_UI_BTN_TOOLTIP_CONTEXT_MENU)
	
	-- show tooltip
    BMU:tooltipTextEnter(teleporterWin_Main_Control.ItemTexture, tooltip)
    -- button highlight
	teleporterWin_Main_Control.ItemTexture:SetTexture(BMU_textures.relatedItemsBtnOver)
  end)

  teleporterWin_Main_Control.ItemTexture:SetHandler("OnMouseExit", function(self)
    BMU:tooltipTextEnter(teleporterWin_Main_Control.ItemTexture)
	if BMU.state ~= BMU.indexListItems then
		teleporterWin_Main_Control.ItemTexture:SetTexture(BMU_textures.relatedItemsBtn)
	end
  end)

  --------------------------------------------------------------------------------------------------------------------
  -- Create counter panel that displays the counter for each type
  BMU_counterPanel = WINDOW_MANAGER:CreateControl(nil, BMU.win.Main_Control, CT_LABEL)
  BMU.counterPanel = BMU_counterPanel
  BMU_counterPanel:SetFont(BMU.font1)
  BMU_counterPanel:SetHidden(true)

  --------------------------------------------------------------------------------------------------------------------
  -- Only current zone
  teleporterWin_Main_Control_OnlyYourzoneTexture = wm:CreateControl(nil, teleporterWin_Main_Control, CT_TEXTURE)
  teleporterWin_Main_Control.OnlyYourzoneTexture = teleporterWin_Main_Control_OnlyYourzoneTexture
  teleporterWin_Main_Control_OnlyYourzoneTexture:SetDimensions(50*scale, 50*scale)
  teleporterWin_Main_Control_OnlyYourzoneTexture:SetAnchor(TOPRIGHT, teleporterWin_Main_Control, TOPRIGHT, -80*scale, 40*scale)
  teleporterWin_Main_Control_OnlyYourzoneTexture:SetTexture(BMU_textures.currentZoneBtn)
  teleporterWin_Main_Control_OnlyYourzoneTexture:SetMouseEnabled(true)
  teleporterWin_Main_Control_OnlyYourzoneTexture:SetDrawLayer(2)

	teleporterWin_Main_Control_OnlyYourzoneTexture:SetHandler("OnMouseUp", function(ctrl, button)
		ClearCustomScrollableMenu()
		if button == MOUSE_BUTTON_INDEX_RIGHT then
			-- show context menu
			local BMU_savedVarsChar = BMU.savedVarsChar   --INS251229 Baertram
			-- make default tab
			addDynamicLSMContextMenuEntry(LSM_ENTRY_TYPE_CHECKBOX, BMU_SI_get(SI.TELE_SETTINGS_DEFAULT_TAB), BMU_savedVarsChar, "defaultTab", nil, BMU.indexListCurrentZone, nil)

			ShowCustomScrollableMenu(ctrl, nil)
		else
			BMU.createTable({index=BMU.indexListCurrentZone})
		end
	end)
  
    teleporterWin_Main_Control.OnlyYourzoneTexture:SetHandler("OnMouseEnter", function(self)
		BMU:tooltipTextEnter(teleporterWin_Main_Control.OnlyYourzoneTexture,
			GetString(SI_ANTIQUITY_SCRYABLE_CURRENT_ZONE_SUBCATEGORY) .. BMU_SI_get(SI.TELE_UI_BTN_TOOLTIP_CONTEXT_MENU))
		teleporterWin_Main_Control.OnlyYourzoneTexture:SetTexture(BMU_textures.currentZoneBtnOver)
	end)
	
	teleporterWin_Main_Control.OnlyYourzoneTexture:SetHandler("OnMouseExit", function(self)
		BMU:tooltipTextEnter(teleporterWin_Main_Control.OnlyYourzoneTexture)
		if BMU.state ~= BMU.indexListCurrentZone then
			teleporterWin_Main_Control.OnlyYourzoneTexture:SetTexture(BMU_textures.currentZoneBtn)
		end
	end)
	
	
  ---------------------------------------------------------------------------------------------------------------
  -- Delves in current zone
  teleporterWin_Main_Control_DelvesTexture = wm:CreateControl(nil, teleporterWin_Main_Control, CT_TEXTURE)
  teleporterWin_Main_Control.DelvesTexture = teleporterWin_Main_Control_DelvesTexture
  teleporterWin_Main_Control_DelvesTexture:SetDimensions(50*scale, 50*scale)
  teleporterWin_Main_Control_DelvesTexture:SetAnchor(TOPRIGHT, teleporterWin_Main_Control, TOPRIGHT, -40*scale, 40*scale)
  teleporterWin_Main_Control_DelvesTexture:SetTexture(BMU_textures.delvesBtn)
  teleporterWin_Main_Control_DelvesTexture:SetMouseEnabled(true)
  teleporterWin_Main_Control_DelvesTexture:SetDrawLayer(2)

  teleporterWin_Main_Control_DelvesTexture:SetHandler("OnMouseUp", function(ctrl, button)
	ClearCustomScrollableMenu()
	if button == MOUSE_BUTTON_INDEX_RIGHT then
		-- show context menu
		local BMU_savedVarsChar = BMU.savedVarsChar  --INS251229 Baertram
		-- show all or only in current zone
	  	addDynamicLSMContextMenuEntry(LSM_ENTRY_TYPE_CHECKBOX, GetString(SI_GAMEPAD_GUILD_HISTORY_SUBCATEGORY_ALL), BMU.savedVarsChar, "showAllDelves", nil, nil)

		-- divider
		AddCustomScrollableMenuDivider()

		-- make default tab
		addDynamicLSMContextMenuEntry(LSM_ENTRY_TYPE_CHECKBOX, BMU_SI_get(SI.TELE_SETTINGS_DEFAULT_TAB), BMU.savedVarsChar, "defaultTab", nil, BMU.indexListDelves, nil)

		ShowCustomScrollableMenu(ctrl, nil)
	else
		BMU_createTable({index=BMU.indexListDelves})
	end
  end)
  
  teleporterWin_Main_Control.DelvesTexture:SetHandler("OnMouseEnter", function(self)
	local text = GetString(SI_ZONECOMPLETIONTYPE5)
	if not BMU.savedVarsChar.showAllDelves then
		text = text .. " - " .. GetString(SI_ANTIQUITY_SCRYABLE_CURRENT_ZONE_SUBCATEGORY)
	end
	BMU:tooltipTextEnter(teleporterWin_Main_Control.DelvesTexture,
		text .. BMU_SI_get(SI.TELE_UI_BTN_TOOLTIP_CONTEXT_MENU))
    teleporterWin_Main_Control.DelvesTexture:SetTexture(BMU_textures.delvesBtnOver)
  end)

  teleporterWin_Main_Control.DelvesTexture:SetHandler("OnMouseExit", function(self)
    BMU:tooltipTextEnter(teleporterWin_Main_Control.DelvesTexture)
	if BMU.state ~= BMU.indexListDelves then
		teleporterWin_Main_Control.DelvesTexture:SetTexture(BMU_textures.delvesBtn)
	end
  end)
  
  
    ---------------------------------------------------------------------------------------------------------------
  -- DUNGEON FINDER
  teleporterWin_Main_Control_DungeonTexture = wm:CreateControl(nil, teleporterWin_Main_Control, CT_TEXTURE)
  teleporterWin_Main_Control.DungeonTexture = teleporterWin_Main_Control_DungeonTexture
  teleporterWin_Main_Control_DungeonTexture:SetDimensions(50*scale, 50*scale)
  teleporterWin_Main_Control_DungeonTexture:SetAnchor(TOPRIGHT, teleporterWin_Main_Control, TOPRIGHT, 0*scale, 40*scale)
  teleporterWin_Main_Control_DungeonTexture:SetTexture(BMU_textures.soloArenaBtn)
  teleporterWin_Main_Control_DungeonTexture:SetMouseEnabled(true)
  teleporterWin_Main_Control_DungeonTexture:SetDrawLayer(2)

  teleporterWin_Main_Control_DungeonTexture:SetHandler("OnMouseUp", function(self, button)
	ClearCustomScrollableMenu()
	if button == MOUSE_BUTTON_INDEX_RIGHT then

		-- show filter menu
		-- add filters
		AddCustomScrollableSubMenuEntry(GetString(SI_GAMEPAD_BANK_FILTER_HEADER),
			{
				{
					label = BMU_SI_get(SI.TELE_UI_TOGGLE_ENDLESS_DUNGEONS),
					callback = function(comboBox, itemName, item, checked, data) BMU.savedVarsChar.dungeonFinder.showEndlessDungeons = checked BMU_createTableDungeons() end,
					entryType = LSM_ENTRY_TYPE_CHECKBOX,
					checked = function() return BMU.savedVarsChar.dungeonFinder.showEndlessDungeons end,
				},
				{
					label = BMU_SI_get(SI.TELE_UI_TOGGLE_ARENAS),
					callback = function(comboBox, itemName, item, checked, data) BMU.savedVarsChar.dungeonFinder.showArenas = checked BMU_createTableDungeons() end,
					entryType = LSM_ENTRY_TYPE_CHECKBOX,
					checked = function() return BMU.savedVarsChar.dungeonFinder.showArenas end,
				},
				{
					label = BMU_SI_get(SI.TELE_UI_TOGGLE_GROUP_ARENAS),
					callback = function(comboBox, itemName, item, checked, data) BMU.savedVarsChar.dungeonFinder.showGroupArenas = checked BMU_createTableDungeons() end,
					entryType = LSM_ENTRY_TYPE_CHECKBOX,
					checked = function() return BMU.savedVarsChar.dungeonFinder.showGroupArenas end,
				},
				{
					label = BMU_SI_get(SI.TELE_UI_TOGGLE_TRIALS),
					callback = function(comboBox, itemName, item, checked, data) BMU.savedVarsChar.dungeonFinder.showTrials = checked BMU_createTableDungeons() end,
					entryType = LSM_ENTRY_TYPE_CHECKBOX,
					checked = function() return BMU.savedVarsChar.dungeonFinder.showTrials end,
				},
				{
					label = BMU_SI_get(SI.TELE_UI_TOGGLE_GROUP_DUNGEONS),
					callback = function(comboBox, itemName, item, checked, data) BMU.savedVarsChar.dungeonFinder.showDungeons = checked BMU_createTableDungeons() end,
					entryType = LSM_ENTRY_TYPE_CHECKBOX,
					checked = function() return BMU.savedVarsChar.dungeonFinder.showDungeons end,
				},
			},
		  	function()
				--d("Clicked filters submenu openingControl")
				--todo enable/disable all checkboxes in submenu
		  	end,
			{ --additionalData
				tooltip = BMU_SI_get(SI.CONSTANT_LSM_CLICK_SUBMENU_TOGGLE_ALL),
			}
		)

		-- sorting (release or acronym)
		-- checkbox does not rely behave like a toogle in this case, enforce 3 possible statuses
		AddCustomScrollableSubMenuEntry(GetString(SI_GAMEPAD_SORT_OPTION),
			{
				-- sort by release: from old (top of list) to new
				{
					label = BMU_SI_get(SI.TELE_UI_TOGGLE_SORT_RELEASE) .. BMU_textures.arrowUp,
					callback = function(comboBox, itemName, item, checked, data)
						local dungeonFinderCharSV = BMU.savedVarsChar.dungeonFinder
						dungeonFinderCharSV.sortByReleaseASC = true
						dungeonFinderCharSV.sortByReleaseDESC = false
						dungeonFinderCharSV.sortByAcronym = false
						BMU_clearInputFields()
						BMU_createTableDungeons() end,
					entryType = LSM_ENTRY_TYPE_RADIOBUTTON,
					buttonGroup = 1,
					checked = function() return BMU.savedVarsChar.dungeonFinder.sortByReleaseASC end,
				  	icon = function() return BMU_checkIfContextMenuIconShouldShow("arrowUp") end,
				},
				-- sort by release: from new (top of list) to old
				{
					label = BMU_SI_get(SI.TELE_UI_TOGGLE_SORT_RELEASE) .. BMU_textures.arrowDown,
					callback = function(comboBox, itemName, item, checked, data)
						local dungeonFinderCharSV = BMU.savedVarsChar.dungeonFinder
						dungeonFinderCharSV.sortByReleaseASC = false
						dungeonFinderCharSV.sortByReleaseDESC = true
						dungeonFinderCharSV.sortByAcronym = false
						BMU_clearInputFields()
						BMU_createTableDungeons() end,
					entryType = LSM_ENTRY_TYPE_RADIOBUTTON,
					buttonGroup = 1,
					checked = function() return BMU.savedVarsChar.dungeonFinder.sortByReleaseDESC end,
				  	icon = function() return BMU_checkIfContextMenuIconShouldShow("arrowDown") end,
				},
				-- sort by acronym
				{
					label = BMU_SI_get(SI.TELE_UI_TOGGLE_SORT_ACRONYM),
					callback = function(comboBox, itemName, item, checked, data)
						local dungeonFinderCharSV = BMU.savedVarsChar.dungeonFinder
						dungeonFinderCharSV.sortByReleaseASC = false
						dungeonFinderCharSV.sortByReleaseDESC = false
						dungeonFinderCharSV.sortByAcronym = true
						BMU_clearInputFields()
						BMU_createTableDungeons() end,
					entryType = LSM_ENTRY_TYPE_RADIOBUTTON,
					buttonGroup = 1,
					checked = function() return BMU.savedVarsChar.dungeonFinder.sortByAcronym end,
					icon = function() return BMU_checkIfContextMenuIconShouldShow("abbreviate") end
				},
			},
			nil,
			{ icon = function() return BMU_checkIfContextMenuIconShouldShow("sortHeader") end }
		)

		-- display options (update name or acronym) (dungeon name or zone name)
		AddCustomScrollableSubMenuEntry(GetString(SI_GRAPHICS_OPTIONS_VIDEO_CATEGORY_DISPLAY),
			{
				{
					label = BMU_SI_get(SI.TELE_UI_TOGGLE_UPDATE_NAME),
					callback = function(comboBox, itemName, item, checked, data) BMU.savedVarsChar.dungeonFinder.toggleShowAcronymUpdateName = checked BMU_clearInputFields() BMU_createTableDungeons() end,
					entryType = LSM_ENTRY_TYPE_CHECKBOX,
					checked = function() return not BMU.savedVarsChar.dungeonFinder.toggleShowAcronymUpdateName end,
				},
				{
					label = BMU_SI_get(SI.TELE_UI_TOGGLE_ACRONYM),
					callback = function(comboBox, itemName, item, checked, data) BMU.savedVarsChar.dungeonFinder.toggleShowAcronymUpdateName = checked BMU_clearInputFields() BMU_createTableDungeons() end,
					entryType = LSM_ENTRY_TYPE_CHECKBOX,
					checked = function() return BMU.savedVarsChar.dungeonFinder.toggleShowAcronymUpdateName end,
				},
				{
					label = "-",
				},
				{
					label = BMU_SI_get(SI.TELE_UI_TOOGLE_DUNGEON_NAME),
					callback = function(comboBox, itemName, item, checked, data) BMU.savedVarsChar.dungeonFinder.toggleShowZoneNameDungeonName = checked BMU_clearInputFields() BMU_createTableDungeons() end,
					entryType = LSM_ENTRY_TYPE_CHECKBOX,
					checked = function() return not BMU.savedVarsChar.dungeonFinder.toggleShowZoneNameDungeonName end,
				},
				{
					label = BMU_SI_get(SI.TELE_UI_TOOGLE_ZONE_NAME),
					callback = function(comboBox, itemName, item, checked, data) BMU.savedVarsChar.dungeonFinder.toggleShowZoneNameDungeonName = checked BMU_clearInputFields() BMU_createTableDungeons() end,
					entryType = LSM_ENTRY_TYPE_CHECKBOX,
					checked = function() return BMU.savedVarsChar.dungeonFinder.toggleShowZoneNameDungeonName end,
				},
			},
			nil,
			{ icon = function() return BMU_checkIfContextMenuIconShouldShow("display") end } --additionalData
		)

		-- add dungeon difficulty toggle
		addDynamicLSMContextMenuEntry(LSM_ENTRY_TYPE_CHECKBOX, BMU_textures.dungeonDifficultyVeteran .. GetString(SI_DUNGEONDIFFICULTY2), nil, nil, nil,
				function(comboBox, itemName, item, checked, data)
					BMU_setDungeonDifficulty(not BMU_getCurrentDungeonDifficulty())
					zo_callLater(function() BMU.createTableDungeons() end, 300)
				end,
				function() return BMU_getCurrentDungeonDifficulty() end,
				{ enabled = function() return CanPlayerChangeGroupDifficulty() end } --additionalData.enabled
		)

		-- divider
		AddCustomScrollableMenuDivider()

		-- make default tab
		addDynamicLSMContextMenuEntry(LSM_ENTRY_TYPE_CHECKBOX, BMU_SI_get(SI.TELE_SETTINGS_DEFAULT_TAB), BMU.savedVarsChar, "defaultTab", nil, BMU.indexListDungeons, nil)

		ShowCustomScrollableMenu(ctrl, LSM_dungeonFilterContextMenuOptions)
	else
		BMU_clearInputFields()
		BMU.createTableDungeons()
	end
  end)
  
  teleporterWin_Main_Control_DungeonTexture:SetHandler("OnMouseEnter", function(teleporterWin_Main_Control_DungeonTextureCtrl)
	BMU_tooltipTextEnter(BMU, teleporterWin_Main_Control_DungeonTextureCtrl,
		BMU_SI_get(SI.TELE_UI_BTN_DUNGEON_FINDER) .. BMU_SI_get(SI.TELE_UI_BTN_TOOLTIP_CONTEXT_MENU))
    teleporterWin_Main_Control_DungeonTextureCtrl:SetTexture(BMU_textures.soloArenaBtnOver)
  end)

  teleporterWin_Main_Control_DungeonTexture:SetHandler("OnMouseExit", function(teleporterWin_Main_Control_DungeonTextureCtrl)
    BMU_tooltipTextEnter(BMU, teleporterWin_Main_Control_DungeonTextureCtrl)
	if BMU.state ~= BMU.indexListDungeons then
		teleporterWin_Main_Control_DungeonTextureCtrl:SetTexture(BMU_textures.soloArenaBtn)
	end
  end)
	  
end
--------------------------------------------------------------------------------------------------------------------
-- -^- SetupUI
--------------------------------------------------------------------------------------------------------------------

--Surveys
function BMU.updateCheckboxSurveyMap(action)
	if action == 3 then
		-- check if at least one of the subTypes is checked
		if BMU_numOfSurveyTypesChecked() > 0 then
			--Not needed anymore with LSM. Done in the entry's "checked" function itsself
			---zo_CheckButton_SetChecked(zo_Menu.items[BMU.menuIndexSurveyAll].checkbox)
		else
			-- no survey type is checked
			--Not needed anymore with LSM. Done in the entry's "checked" function itsself
			---ZO_CheckButton_SetUnchecked(zo_Menu.items[BMU.menuIndexSurveyAll].checkbox)
		end
	else
		-- if action == 1 --> all are checked
		-- else (action == 2) --> all are unchecked
		for _, subType in pairs(surveyTypes) do
			BMU.savedVarsChar.displayMaps[subType] = (action == 1)
		end
	end
	BMU_updateContextMenuEntrySurveyAll = BMU_updateContextMenuEntrySurveyAll or BMU.updateContextMenuEntrySurveyAll --INS251229 Baertram
    BMU_updateContextMenuEntrySurveyAll() --CHG251229 Baertram
end
BMU_updateCheckboxSurveyMap = BMU.updateCheckboxSurveyMap


function BMU.numOfSurveyTypesChecked()
	local surveySVTab = typeToSVTableName[subType_Surveys] --displayMaps
	local displayMaps = BMU.savedVarsChar[surveySVTab]
	local num = 0
	for _, subType in pairs(surveyTypes) do
		if BMU.savedVarsChar.displayMaps[subType] then
			num = num + 1
		end
	end
	return num
end
BMU_numOfSurveyTypesChecked = BMU.numOfSurveyTypesChecked --INS251229 Baertram


function BMU.updateContextMenuEntrySurveyAll()
	BMU_getContextMenuEntrySurveyAllAppendix = BMU_getContextMenuEntrySurveyAllAppendix or BMU.getContextMenuEntrySurveyAllAppendix --INS251229 Baertram
	BMU_numOfSurveyTypesChecked = BMU_numOfSurveyTypesChecked or BMU.numOfSurveyTypesChecked   	    --INS251229 Baertram
	return GetString(SI_SPECIALIZEDITEMTYPE101) .. BMU_getContextMenuEntrySurveyAllAppendix()
end
BMU_updateContextMenuEntrySurveyAll = BMU.updateContextMenuEntrySurveyAll


function BMU.getContextMenuEntrySurveyAllAppendix()
	local num = BMU_numOfSurveyTypesChecked()
	local appendix = string_format(surveyAppendixStrPattern, num, maxSurveyTypes)
	return appendix
end
BMU_getContextMenuEntrySurveyAllAppendix = BMU.getContextMenuEntrySurveyAllAppendix --INS251229 Baertram


function BMU.updatePosition()
    local teleporterWin     = BMU.win
	if sm:IsShowing("worldMap") then
	
		-- show anchor button
		teleporterWin.anchorTexture:SetHidden(false)
		-- show swap button
		BMU.closeBtnSwitchTexture(true)
		
		if BMU.savedVarsAcc.anchorOnMap then
			-- anchor to map
			BMU.control_global.bd:ClearAnchors()
			--BMU.control_global.bd:SetAnchor(TOPLEFT, ZO_WorldMap, TOPLEFT, BMU.savedVarsAcc.anchorMap_x, BMU.savedVarsAcc.anchorMap_y)
			BMU.control_global.bd:SetAnchor(TOPRIGHT, ZO_WorldMap, TOPLEFT, BMU.savedVarsAcc.anchorMapOffset_x, (-70*BMU.savedVarsAcc.Scale) + BMU.savedVarsAcc.anchorMapOffset_y)
			-- fix position
			BMU.control_global.bd:SetMovable(false)
			-- hide fix/unfix button
			teleporterWin.fixWindowTexture:SetHidden(true)
			-- set anchor button texture
			teleporterWin.anchorTexture:SetTexture(BMU_textures.anchorMapBtnOver)
		else
			-- use saved pos when map is open
			BMU.control_global.bd:ClearAnchors()
			BMU.control_global.bd:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, LEFT + BMU.savedVarsAcc.pos_MapScene_x, BMU.savedVarsAcc.pos_MapScene_y)
			-- set fix/unfix state
			BMU.control_global.bd:SetMovable(not BMU.savedVarsAcc.fixedWindow)
			-- show fix/unfix button
			teleporterWin.fixWindowTexture:SetHidden(false)
			-- set anchor button texture
			teleporterWin.anchorTexture:SetTexture(BMU_textures.anchorMapBtn)
		end
	else
		-- hide anchor button
		teleporterWin_anchorTexture:SetHidden(true)
		-- hide swap button
		BMU.closeBtnSwitchTexture(false)
		
		-- use saved pos when map is NOT open
		BMU.control_global.bd:ClearAnchors()
		BMU.control_global.bd:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, LEFT + BMU.savedVarsAcc.pos_x, BMU.savedVarsAcc.pos_y)
		-- set fix/unfix state
		BMU.control_global.bd:SetMovable(not BMU.savedVarsAcc.fixedWindow)
		-- show fix/unfix button
		teleporterWin.fixWindowTexture:SetHidden(false)
	end
end


function BMU.closeBtnSwitchTexture(flag)
    local teleporterWin     = BMU.win
	if flag then
		-- show swap button
		-- set texture and handlers
		teleporterWin.closeTexture:SetTexture(BMU_textures.swapBtn)
		teleporterWin.closeTexture:SetHandler("OnMouseEnter", function(self)
			teleporterWin.closeTexture:SetTexture(BMU_textures.swapBtnOver)
			BMU:tooltipTextEnter(teleporterWin.closeTexture,
				BMU_SI_get(SI.TELE_UI_BTN_TOGGLE_BMU))
		end)
		teleporterWin.closeTexture:SetHandler("OnMouseExit", function(self)
			BMU:tooltipTextEnter(teleporterWin.closeTexture)
			teleporterWin.closeTexture:SetTexture(BMU_textures.swapBtn)
		end)
		
	else
		-- show normal close button
		-- set textures and handlers
		teleporterWin.closeTexture:SetTexture(BMU_textures.closeBtn)
		teleporterWin.closeTexture:SetHandler("OnMouseEnter", function(self)
		teleporterWin.closeTexture:SetTexture(BMU_textures.closeBtnOver)
			BMU:tooltipTextEnter(teleporterWin.closeTexture,
				GetString(SI_DIALOG_CLOSE))
		end)
		teleporterWin.closeTexture:SetHandler("OnMouseExit", function(self)
			BMU:tooltipTextEnter(teleporterWin.closeTexture)
			teleporterWin.closeTexture:SetTexture(BMU_textures.closeBtn)
		end)
	end
end


function BMU.clearInputFields()
    local teleporterWin = BMU.win
	-- Clear Input Field Player
	teleporterWin_Searcher_Player:SetText("")
	-- Show Placeholder
	teleporterWin_Searcher_Player_Placeholder:SetHidden(false)
	-- Clear Input Field Zone
	teleporterWin_Searcher_Zone:SetText("")
	-- Show Placeholder
	teleporterWin_Searcher_Zone_Placeholder:SetHidden(false)
end
BMU_clearInputFields = BMU.clearInputFields



-- display the correct persistent MouseOver depending on Button
-- also set global state for auto refresh
function BMU.changeState(index)

	BMU.printToChat("Changed - state: " .. tostring(index), BMU.MSG_DB)
    
	local teleporterWin = BMU.win

	-- first disable all MouseOver
    --local teleporterWin_Main_Control = teleporterWin.Main_Control                           --INS251229 Baertram
	teleporterWin_Main_Control_ItemTexture:SetTexture(BMU_textures.relatedItemsBtn)
	teleporterWin_Main_Control_OnlyYourzoneTexture:SetTexture(BMU_textures.currentZoneBtn)
	teleporterWin_Main_Control_DelvesTexture:SetTexture(BMU_textures.delvesBtn)
	teleporterWin_SearchTexture:SetTexture(BMU_textures.searchBtn)
	teleporterWin_Main_Control_QuestTexture:SetTexture(BMU_textures.questBtn)
	teleporterWin_Main_Control_OwnHouseTexture:SetTexture(BMU_textures.houseBtn)
	teleporterWin_Main_Control_PTFTexture:SetTexture(BMU_textures.ptfHouseBtn)
	teleporterWin_Main_Control_DungeonTexture:SetTexture(BMU_textures.soloArenaBtn)
	teleporterWin_guildTexture = teleporterWin.guildTexture
    if teleporterWin_guildTexture then                                                      --INS251229 Baertram
		teleporterWin_guildTexture:SetTexture(BMU_textures.guildBtn)                        --INS251229 Baertram
	end
	-- hide counter panel for related items tab
	BMU_counterPanel:SetHidden(true)
	
	teleporterWin_Searcher_Player:SetHidden(false)

	-- check new state
	if index == BMU.indexListItems then
		-- related Items
		teleporterWin_Main_Control.ItemTexture:SetTexture(BMU_textures.relatedItemsBtnOver)
		if BMU.savedVarsChar.displayCounterPanel then
			BMU_counterPanel:SetHidden(false)
		end
	elseif index == BMU.indexListCurrentZone then
		-- current zone
		teleporterWin_Main_Control.OnlyYourzoneTexture:SetTexture(BMU_textures.currentZoneBtnOver)
	elseif index == BMU.indexListDelves then
		-- current zone delves
		teleporterWin_Main_Control.DelvesTexture:SetTexture(BMU_textures.delvesBtnOver)
	elseif index == BMU.indexListSearchPlayer or index == BMU.indexListSearchZone then
		-- serach by player name or zone name
		teleporterWin.SearchTexture:SetTexture(BMU_textures.searchBtnOver)
	elseif index == BMU.indexListQuests then
		-- related quests
		teleporterWin_Main_Control.QuestTexture:SetTexture(BMU_textures.questBtnOver)
	elseif index == BMU.indexListOwnHouses then
		-- own houses
		teleporterWin_Main_Control.OwnHouseTexture:SetTexture(BMU_textures.houseBtnOver)
	elseif index == BMU.indexListPTFHouses then
		-- PTF houses
		teleporterWin_Main_Control.PTFTexture:SetTexture(BMU_textures.ptfHouseBtnOver)
	elseif index == BMU.indexListGuilds then
		-- guilds
		if teleporterWin_guildTexture then
			teleporterWin_guildTexture:SetTexture(BMU_textures.guildBtnOver)
		end
	elseif index == BMU.indexListDungeons then
		-- dungeon finder
		teleporterWin_Main_Control_DungeonTexture:SetTexture(BMU_textures.soloArenaBtnOver)
		teleporterWin_Searcher_Player:SetHidden(true)
	end
	
	BMU.state = index
end


------------------------

-- register and show basic dialogs
function BMU.showDialogSimple(dialogName, dialogTitle, dialogBody, callbackYes, callbackNo)
	local dialogInfo = {
		canQueue = true,
		title = {text=dialogTitle},
		mainText = {align=TEXT_ALIGN_LEFT, text=dialogBody},
	}
	
	if callbackYes or callbackNo then
		dialogInfo.buttons = {
			{
				text = SI_DIALOG_CONFIRM,
				keybind = "DIALOG_PRIMARY",
				callback = callbackYes,
			},
			{
				text = SI_DIALOG_CANCEL,
				keybind = "DIALOG_NEGATIVE",
				callback = callbackNo,
			},
		}
	else
		-- show only one button if both callbacks are nil
		dialogInfo.buttons = {
			{
				text = SI_DIALOG_CLOSE,
				keybind = "DIALOG_NEGATIVE",
			},
		}
	end
	
	return BMU.showDialogCustom(dialogName, dialogInfo)
end


-- register and show custom dialogs with given dialogInfo
function BMU.showDialogCustom(dialogName, dialogInfoObject)
	local dialogInfo = dialogInfoObject
	
	-- register dialog globally
	local globalDialogName = appName .. dialogName
	
	ESO_Dialogs[globalDialogName] = dialogInfo
	local dialogReference = ZO_Dialogs_ShowDialog(globalDialogName)
	
	return globalDialogName, dialogReference
end

------------------------


function BMU.TeleporterSetupUI(addOnName)
	if appName ~= addOnName then return end
		addOnName = appName .. " - Teleporter"
		SetupOptionsMenu(addOnName)
		SetupUI()
end


function BMU.journalUpdated()
	BMU.questDataChanged = true
end


-- HOUSING_FURNISHING_LIMIT_TYPE_HIGH_IMPACT_COLLECTIBLE
-- HOUSING_FURNISHING_LIMIT_TYPE_HIGH_IMPACT_ITEM
-- HOUSING_FURNISHING_LIMIT_TYPE_LOW_IMPACT_COLLECTIBLE
-- HOUSING_FURNISHING_LIMIT_TYPE_LOW_IMPACT_ITEM

-- update own houses furniture count
function BMU.updateHouseFurnitureCount(eventCode, option1, option2)
	-- the player entered a new zone or event furniture count updated
	local houseId = GetCurrentZoneHouseId()
	if houseId ~= nil and IsOwnerOfCurrentHouse() then
		-- player is in an own house
		if eventCode == EVENT_HOUSE_FURNITURE_COUNT_UPDATED and option1 ~= houseId then
			-- abort if furniture count was updated but different house
			return
		end

		local currentFurnitureCount_LII = GetNumHouseFurnishingsPlaced(HOUSING_FURNISHING_LIMIT_TYPE_LOW_IMPACT_ITEM)
		if currentFurnitureCount_LII ~= nil then
			-- save value to savedVars
			BMU.savedVarsServ.houseFurnitureCount_LII[houseId] = currentFurnitureCount_LII
		end
	end
end


-- handles event when player clicks on a chat link
	-- 1. for sharing teleport destination to the group (built-in type with drive-by data)
	-- 2. for wayshrine map ping (custom link)
function BMU.handleChatLinkClick(rawLink, mouseButton, linkText, linkStyle, linkType, data1, data2, data3, data4) -- can contain more data fields
	BMU_printToChat = BMU_printToChat or BMU.printToChat
	BMU_PortalToPlayer = BMU_PortalToPlayer or BMU.PortalToPlayer

	local number_to_bool ={ [0]=false, [1]=true }
	-- sharing
	if linkType == "book" then
		local bookId = data1
		local signature = tostring(data2)
		
		-- sharing player
		if signature == "BMU_S_P" then
			local playerFrom = tostring(data3)
			local playerTo = tostring(data4)
			if playerFrom ~= nil and playerTo ~= nil then
				-- try to find the destination player
				local result = BMU_createTable({index=BMU.indexListSearchPlayer, inputString=playerTo, dontDisplay=true})
				local firstRecord = result[1]
				if firstRecord.displayName == "" then
					-- player not found
					BMU_printToChat(playerTo .. " - " .. GetString(SI_FASTTRAVELKEEPRESULT9))
				else
					BMU_printToChat(BMU_SI_get(SI.TELE_CHAT_SHARING_FOLLOW_LINK), BMU.MSG_AD)
					BMU_PortalToPlayer(firstRecord.displayName, firstRecord.sourceIndexLeading, firstRecord.zoneName, firstRecord.zoneId, firstRecord.category, true, false, true)
				end
				return true
			end
			
		-- sharing house
		elseif signature == "BMU_S_H" then
			local player = tostring(data3)
			local houseId = tonumber(data4)
			if player ~= nil and houseId ~= nil then
				-- try to port to the house of the player
				BMU_printToChat(BMU_SI_get(SI.TELE_CHAT_SHARING_FOLLOW_LINK), BMU.MSG_AD)
				CancelCast()
				JumpToSpecificHouse(player, houseId)
			end
			return true
		end
	
	
	-- custom link (wayshrine map ping)
	elseif linkType == "BMU" then
		local signature = tostring(data1)
		local mapIndex = tonumber(data2)
		local coorX = tonumber(data3)
		local coorY = tonumber(data4)
		
		-- check if link is for map pings
		if signature == "BMU_P" and mapIndex ~= nil and coorX ~= nil and coorY ~= nil then
			-- valid map ping
			-- switch to Tamriel and back to specific map in order to reset any subzone or zoom
			worldMapManager:SetMapByIndex(1)
			worldMapManager:SetMapByIndex(mapIndex)
			-- start ping
			if not sm:IsShowing("worldMap") then sm:Show("worldMap") end
			PingMap(MAP_PIN_TYPE_RALLY_POINT, MAP_TYPE_LOCATION_CENTERED, coorX, coorY)
		end
		
		-- return true in any case because not handled custom link leads to UI error
		return true
	end
end


-- click on guild button
function BMU.redirectToBMUGuild()
	for _, guildId in pairs(teleporterVars.BMUGuilds[worldName]) do
		local guildData = guildBrowserManager:GetGuildData(guildId)
		if guildId and guildData and guildData.size and guildData.size < 495 then
			ZO_LinkHandler_OnLinkClicked("|H1:guild:" .. guildId .. "|hBeamMeUp Guild|h", 1, nil)
			return
		end
	end
	-- just redirect to latest BMU guild
	ZO_LinkHandler_OnLinkClicked("|H1:guild:" .. BMU.var.BMUGuilds[worldName][#BMU.var.BMUGuilds[worldName]] .. "|hBeamMeUp Guild|h", 1, nil)
end


-------------------------------------------------------------------
-- EXTRAS
-------------------------------------------------------------------

-- Show Notification when favorite player goes online
function BMU.FavoritePlayerStatusNotification(eventCode, option1, option2, option3, option4, option5) --GUILD:(eventCode, guildID, displayName, prevStatus, curStatus) FRIEND:(eventCode, displayName, characterName, prevStatus, curStatus)
	local displayName = ""
	local prevStatus = option3
	local curStatus = option4
	
	-- in case of EVENT_GUILD_MEMBER_PLAYER_STATUS_CHANGED first option is guildID instead of displayName
	if eventCode == EVENT_GUILD_MEMBER_PLAYER_STATUS_CHANGED then
		-- EVENT_GUILD_MEMBER_PLAYER_STATUS_CHANGED
		displayName = option2
	else
		-- EVENT_FRIEND_PLAYER_STATUS_CHANGED
		displayName = option1
	end
	
	if BMU.savedVarsAcc.FavoritePlayerStatusNotification and BMU.isFavoritePlayer(displayName) and prevStatus == 4 and curStatus ~= 4 then
		CSA:AddMessage(0, CSA_CATEGORY_MAJOR_TEXT, SOUNDS.DEFER_NOTIFICATION, "Favorite Player Switched Status", BMU_colorizeText(displayName, "gold") .. " " .. BMU_colorizeText(BMU_SI_get(SI.TELE_CENTERSCREEN_FAVORITE_PLAYER_ONLINE), "white"), "esoui/art/mainmenu/menubar_social_up.dds", "EsoUI/Art/Achievements/achievements_iconBG.dds", nil, nil, 4000)
	end
end

--[[
-- Show Note, when player sends a whisper message and is offline -> player cannot receive any whisper messages
function BMU.HintOfflineWhisper(eventCode, messageType, from, test, isFromCustomerService, _)
	if BMU.savedVarsAcc.HintOfflineWhisper and messageType == CHAT_CHANNEL_WHISPER_SENT and GetPlayerStatus() == PLAYER_STATUS_OFFLINE then
		BMU.printToChat(BMU_colorizeText(BMU_SI_get(SI.TELE_CHAT_WHISPER_NOTE), "red"))
	end
end
--]]

function BMU.surveyMapUsed(bagId, slotIndex, slotData)
	if bagId ~= nil and slotData ~= nil then
		if bagId == BAG_BACKPACK and slotData.specializedItemType == SPECIALIZED_ITEMTYPE_TROPHY_SURVEY_REPORT and not IsBankOpen() then
			-- d("Item Name: " .. BMU.formatName(slotData.rawName, false))
			-- d("Anzahl übrig: " .. slotData.stackCount - 1)
			if slotData.stackCount > 1 then
				-- still more available -> Show center screen message
				local sound = nil
				if BMU.savedVarsAcc.surveyMapsNotificationSound then
					-- set sound
					sound = SOUNDS.GUILD_WINDOW_OPEN  -- SOUNDS.DUEL_START
				end
				zo_callLater(function()
					CSA:AddMessage(0, CSA_CATEGORY_MAJOR_TEXT, sound, "Survey Maps Note", string_format(BMU_SI_get(SI.TELE_CENTERSCREEN_SURVEY_MAPS), slotData.stackCount-1), "esoui/art/icons/quest_scroll_001.dds", "EsoUI/Art/Achievements/achievements_iconBG.dds", nil, nil, 5000)
				end, 12000)
			end
		end
	end
end


function BMU.activateWayshrineTravelAutoConfirm()
		ESO_Dialogs["RECALL_CONFIRM"]={
			gamepadInfo={dialogType=GAMEPAD_DIALOGS.BASIC},
			title={text=SI_PROMPT_TITLE_FAST_TRAVEL_CONFIRM},
			mainText={text=SI_FAST_TRAVEL_DIALOG_MAIN_TEXT},
			updateFn=function(dialog)
					FastTravelToNode(dialog.data.nodeIndex)
					sm:ShowBaseScene()
					ZO_Dialogs_ReleaseDialog("RECALL_CONFIRM")
			end
		}
		ESO_Dialogs["FAST_TRAVEL_CONFIRM"]={
			gamepadInfo={dialogType=GAMEPAD_DIALOGS.BASIC},
			title={text=SI_PROMPT_TITLE_FAST_TRAVEL_CONFIRM},
			mainText={text=SI_FAST_TRAVEL_DIALOG_MAIN_TEXT},
			updateFn=function(dialog)
					FastTravelToNode(dialog.data.nodeIndex)
					ZO_Dialogs_ReleaseDialog("FAST_TRAVEL_CONFIRM")
			end
		}
end


-- request all guilds in queue
local BMU_requestGuildDataRecursive
function BMU.requestGuildDataRecursive(guildIds)
	BMU_requestGuildDataRecursive = BMU_requestGuildDataRecursive or BMU.requestGuildDataRecursive
	if #guildIds > 0 then
		guildBrowserManager:RequestGuildData(table_remove(guildIds))
		zo_callLater(function() BMU_requestGuildDataRecursive(guildIds) end, 800)
	else
		BMU.isCurrentlyRequestingGuildData = false
	end
end
BMU_requestGuildDataRecursive = BMU.requestGuildDataRecursive

--Request all BMU and partner guilds information
function BMU.requestGuildData()
	BMU.isCurrentlyRequestingGuildData = true
	local guildsQueue = {}
	-- official guilds
	if BMU.var.BMUGuilds[worldName] ~= nil then
		guildsQueue = BMU.var.BMUGuilds[worldName]
	end
	-- partner guilds
	if teleporterVars.partnerGuilds[worldName] ~= nil then
		guildsQueue = BMU_mergeTables(guildsQueue, teleporterVars.partnerGuilds[worldName])
	end

	BMU_requestGuildDataRecursive(guildsQueue)
end


--------------------------------------------------
-- GUILD ADMINISTRATION TOOL
--------------------------------------------------

function BMU.AdminAddContextMenuToGuildRoster()
	-- add context menu to guild roster
	local GUILD_ROSTER_KEYBOARD = GUILD_ROSTER_KEYBOARD
	local GUILD_ROSTER_MANAGER = GUILD_ROSTER_MANAGER
	local GuildRosterRow_OnMouseUp = GUILD_ROSTER_KEYBOARD.GuildRosterRow_OnMouseUp --ZO_GuildRecruitment_ApplicationsList_Keyboard.Row_OnMouseUp
	GUILD_ROSTER_KEYBOARD.GuildRosterRow_OnMouseUp = function(self, control, button, upInside)
		ClearCustomScrollableMenu()
		local data = ZO_ScrollList_GetData(control)
		GuildRosterRow_OnMouseUp(self, control, button, upInside)
		
		local currentGuildId = GUILD_ROSTER_MANAGER:GetGuildId()
		if (button ~= MOUSE_BUTTON_INDEX_RIGHT --[[and not upInside]]) or data == nil or not BMU.AdminIsBMUGuild(currentGuildId) then
			return
		end
		
		local isAlreadyMember, memberStatusText = BMU.AdminIsAlreadyInGuild(data.displayName)
		
		local entries = {}
		
		-- welcome message
		table_insert(entries, {label = "Willkommensnachricht",
								callback = function(state)
									local guildId = currentGuildId
									local guildIndex = BMU.AdminGetGuildIndexFromGuildId(guildId)
									StartChatInput("Welcome on the bridge " .. data.displayName, _G["CHAT_CHANNEL_GUILD_" .. guildIndex])
								end,
								})
								
		-- new message
		table_insert(entries, {label = "Neue Nachricht",
								callback = function(state) BMU.createMail(data.displayName, "", "") BMU.printToChat("Nachricht erstellt an: " .. data.displayName) end,
								})
								
		-- copy account name
		table_insert(entries, {label = "Account-ID kopieren",
								callback = function(state) BMU.AdminCopyTextToChat(data.displayName) end,
								})
		
		-- invite to BMU guilds
		if teleporterVars.BMUGuilds[worldName] ~= nil then
			for _, guildId in pairs(teleporterVars.BMUGuilds[worldName]) do
				if IsPlayerInGuild(guildId) and not GetGuildMemberIndexFromDisplayName(guildId, data.displayName) then
					table_insert(entries, {label = "Einladen in: " .. GetGuildName(guildId),
											callback = function(state) BMU.AdminInviteToGuilds(guildId, data.displayName) end,
											})
				end
			end
		end
		
		-- invite to partner guilds
		if teleporterVars.partnerGuilds[worldName] ~= nil then
			for _, guildId in pairs(teleporterVars.partnerGuilds[worldName]) do
				if IsPlayerInGuild(guildId) and not GetGuildMemberIndexFromDisplayName(guildId, data.displayName) then
					table_insert(entries, {label = "Einladen in: " .. GetGuildName(guildId),
											callback = function(state) BMU.AdminInviteToGuilds(guildId, data.displayName) end,
											})
				end
			end
		end
		
		-- check if the player is also in other BMU guilds and add info
		table_insert(entries, {label = memberStatusText,
								callback = function(state) end,
								})
		
		AddCustomScrollableSubMenuEntry("BMU Admin", entries)
		self:ShowCustomScrollableMenu(control)
	end
end


function BMU.AdminAddContextMenuToGuildApplicationRoster()
	-- add context menu to guild recruitment application roster (if player is already in a one of the BMU guilds + redirection to the other guilds)
	local GUILD_ROSTER_MANAGER = GUILD_ROSTER_MANAGER
	local ZO_GuildRecruitment_ApplicationsList_Keyboard = ZO_GuildRecruitment_ApplicationsList_Keyboard
	local Row_OnMouseUp = ZO_GuildRecruitment_ApplicationsList_Keyboard.Row_OnMouseUp
	ZO_GuildRecruitment_ApplicationsList_Keyboard.Row_OnMouseUp = function(self, control, button, upInside)
		ClearCustomScrollableMenu()
		local data = ZO_ScrollList_GetData(control)
		Row_OnMouseUp(self, control, button, upInside)
	
		local currentGuildId = GUILD_ROSTER_MANAGER:GetGuildId()
		if (button ~= MOUSE_BUTTON_INDEX_RIGHT --[[and not upInside]]) or data == nil or not BMU.AdminIsBMUGuild(currentGuildId) then
			return
		end
		
		local isAlreadyMember, memberStatusText = BMU.AdminIsAlreadyInGuild(data.name)

		local entries = {}
		
		-- new message
		table_insert(entries, {label = "Neue Nachricht",
								callback = function(state) BMU.createMail(data.name, "", "") BMU.printToChat("Nachricht erstellt an: " .. data.name) end,
								})
								
		-- copy account name
		table_insert(entries, {label = "Account-ID kopieren",
								callback = function(state) BMU.AdminCopyTextToChat(data.name) end,
								})
		
		-- invite to BMU guilds
		if teleporterVars.BMUGuilds[worldName] ~= nil then
			for _, guildId in pairs(teleporterVars.BMUGuilds[worldName]) do
				if IsPlayerInGuild(guildId) and not GetGuildMemberIndexFromDisplayName(guildId, data.name) then
					table_insert(entries, {label = "Einladen in: " .. GetGuildName(guildId),
											callback = function(state) BMU.AdminInviteToGuilds(guildId, data.name) end,
											})
				end
			end
		end
		
		-- invite to partner guilds
		if teleporterVars.partnerGuilds[worldName] ~= nil then
			for _, guildId in pairs(teleporterVars.partnerGuilds[worldName]) do
				if IsPlayerInGuild(guildId) and not GetGuildMemberIndexFromDisplayName(guildId, data.name) then
					table_insert(entries, {label = "Einladen in: " .. GetGuildName(guildId),
											callback = function(state) BMU.AdminInviteToGuilds(guildId, data.name) end,
											})
				end
			end
		end
		
		-- check if the player is also in other BMU guilds and add info
		table_insert(entries, {label = memberStatusText,
								callback = function(state) end,
								})
		
		AddCustomScrollableSubMenuEntry("BMU Admin", entries)
		self:ShowCustomScrollableMenu(control)
	end
end

function BMU.AdminAddTooltipInfoToGuildApplicationRoster()
	-- add info to the tooltip in guild recruitment application roster
	local ZO_GuildRecruitment_ApplicationsList_Keyboard = ZO_GuildRecruitment_ApplicationsList_Keyboard
	local GUILD_ROSTER_MANAGER = GUILD_ROSTER_MANAGER
	local Row_OnMouseEnter = ZO_GuildRecruitment_ApplicationsList_Keyboard.Row_OnMouseEnter
	ZO_GuildRecruitment_ApplicationsList_Keyboard.Row_OnMouseEnter = function(self, control)
		
		local data = ZO_ScrollList_GetData(control)
		local currentGuildId = GUILD_ROSTER_MANAGER:GetGuildId()
		
		if data ~= nil and not data.BMUInfo and BMU.AdminIsBMUGuild(currentGuildId) then
			local isAlreadyMember, memberStatusText = BMU.AdminIsAlreadyInGuild(data.name)
			data.message = data.message .. "\n\n" .. memberStatusText
			data.BMUInfo = true
		end
	
		Row_OnMouseEnter(self, control)		
	end
end

function BMU.AdminGetGuildIndexFromGuildId(guildId)
	for i = 1, GetNumGuilds() do
		if GetGuildId(i) == guildId then
			return i
		end
	end
	return 0
end
local BMU_AdminGetGuildIndexFromGuildId = BMU.AdminGetGuildIndexFromGuildId

function BMU.AdminCopyTextToChat(message)
	-- Max of input box is 351 chars
	if string_len(message) < 351 then
		local chatTextEntrey = chatSystem.textEntry
		if chatTextEntrey:GetText() == "" then
			chatTextEntrey:Open(message)
			ZO_ChatWindowTextEntryEditBox:SelectAll()
		end
	end
end

function BMU.AdminAutoWelcome(eventCode, guildId, displayName, result)
	-- only for BMU guilds
	if not BMU.AdminIsBMUGuild(guildId) then
		return
	end
	
	zo_callLater(function()
		if result == 0 then
			local guildIndex = BMU_AdminGetGuildIndexFromGuildId(guildId)
			local totalGuildMembers = GetNumGuildMembers(guildId)
			
			-- find new guild member
			for j = 0, totalGuildMembers do
				local displayName_info, note, guildMemberRankIndex, status, secsSinceLogoff = GetGuildMemberInfo(guildId, j)
				if displayName_info == displayName and status ~= PLAYER_STATUS_OFFLINE then
					-- new guild member is online -> write welcome message to chat
					StartChatInput("Welcome on the bridge " .. displayName, _G["CHAT_CHANNEL_GUILD_" .. guildIndex])
				end
			end
		end
	end, 1300)
end

function BMU.AdminIsAlreadyInGuild(displayName)
	local text = ""
	local BMU_guildsOfServer = teleporterVars.BMUGuilds[worldName]  								--INS251229 Baertram
	if GetGuildMemberIndexFromDisplayName(BMU_guildsOfServer[1], displayName) then
		text = text .. " 1 "
	end
	if GetGuildMemberIndexFromDisplayName(BMU_guildsOfServer[2], displayName) then
		text = text .. " 2 "
	end
	if GetGuildMemberIndexFromDisplayName(BMU_guildsOfServer[3], displayName) then
		text = text .. " 3 "
	end
	if GetGuildMemberIndexFromDisplayName(BMU_guildsOfServer[4], displayName) then
		text = text .. " 4 "
	end
	
	if text ~= "" then
		-- already member
		return true, BMU_colorizeText("Bereits Mitglied in " .. text, colorRed)
	else
		-- not a member or admin is not member of the BMU guilds
		return false, BMU_colorizeText("Neues Mitglied", colorGreen)
	end
end

function BMU.AdminIsBMUGuild(guildId)
	BMU_has_value = BMU.has_value or BMU.has_value
	if BMU_has_value(teleporterVars.BMUGuilds[worldName], guildId) then
		return true
	else
		return false
	end
end

local BMU_AdminInviteToGuildsQueue
function BMU.AdminInviteToGuildsQueue()
	BMU_AdminInviteToGuildsQueue = BMU_AdminInviteToGuildsQueue or BMU.AdminInviteToGuildsQueue
	if #inviteQueue > 0 then
		-- get first element and send invite
		local first = inviteQueue[1]
		GuildInvite(first[1], first[2])
		PlaySound(SOUNDS.BOOK_OPEN)
		-- restart to check for other elements
		zo_callLater(function() table_remove(inviteQueue, 1) BMU_AdminInviteToGuildsQueue() end, 16000)
	end
end
BMU_AdminInviteToGuildsQueue = BMU.AdminInviteToGuildsQueue

function BMU.AdminInviteToGuilds(guildId, displayName)
	-- add tuple to queue
	table_insert(inviteQueue, {guildId, displayName})
	if #inviteQueue == 1 then
		BMU_AdminInviteToGuildsQueue()
	end
end
local BMU_AdminInviteToGuilds = BMU.AdminInviteToGuilds

function BMU.AdminIsAlreadyInGuild(displayName)
	local text = ""
	local BMU_guildsOfServer = teleporterVars.BMUGuilds[worldName]  								--INS251229 Baertram
	if GetGuildMemberIndexFromDisplayName(BMU_guildsOfServer[1], displayName) then
		text = text .. " 1 "
	end
	if GetGuildMemberIndexFromDisplayName(BMU_guildsOfServer[2], displayName) then
		text = text .. " 2 "
	end
	if GetGuildMemberIndexFromDisplayName(BMU_guildsOfServer[3], displayName) then
		text = text .. " 3 "
	end
	if GetGuildMemberIndexFromDisplayName(BMU_guildsOfServer[4], displayName) then
		text = text .. " 4 "
	end

	if text ~= "" then
		-- already member
		return true, BMU_colorizeText("Bereits Mitglied in " .. text, colorRed)
	else
		-- not a member or admin is not member of the BMU guilds
		return false, BMU_colorizeText("Neues Mitglied", colorGreen)
	end
end
local BMU_AdminIsAlreadyInGuild = BMU.AdminIsAlreadyInGuild

function BMU.AdminIsBMUGuild(guildId)
	BMU_has_value = BMU.has_value or BMU.has_value
	if BMU_has_value(teleporterVars.BMUGuilds[worldName], guildId) then
		return true
	else
		return false
	end
end
local BMU_AdminIsBMUGuild = BMU.AdminIsBMUGuild

function BMU.AdminAddContextMenuToGuildRoster()
	-- add context menu to guild roster
	LCM = LCM or BMU.LCM
	if not LCM then return end --Only with LibCustomMenu enabled!

	local GUILD_ROSTER_KEYBOARD = GUILD_ROSTER_KEYBOARD
	local GUILD_ROSTER_MANAGER = GUILD_ROSTER_MANAGER
	local GuildRosterRow_OnMouseUp = GUILD_ROSTER_KEYBOARD.GuildRosterRow_OnMouseUp --ZO_GuildRecruitment_ApplicationsList_Keyboard.Row_OnMouseUp
	GUILD_ROSTER_KEYBOARD.GuildRosterRow_OnMouseUp = function(self, control, button, upInside)
		ClearMenu()
		local data = ZO_ScrollList_GetData(control)
		GuildRosterRow_OnMouseUp(self, control, button, upInside)
		
		local currentGuildId = GUILD_ROSTER_MANAGER:GetGuildId()
		if (button ~= MOUSE_BUTTON_INDEX_RIGHT --[[and not upInside]]) or data == nil or not BMU_AdminIsBMUGuild(currentGuildId) then
			return
		end
		
		local isAlreadyMember, memberStatusText = BMU_AdminIsAlreadyInGuild(data.displayName)
		
		local entries = {}
		
		-- welcome message
		table_insert(entries, {label = "Willkommensnachricht",
								callback = function()
									local guildId = currentGuildId
									local guildIndex = BMU.AdminGetGuildIndexFromGuildId(guildId)
									StartChatInput("Welcome on the bridge " .. data.displayName, _G["CHAT_CHANNEL_GUILD_" .. guildIndex])
								end,
								})
								
		-- new message
		table_insert(entries, {label = "Neue Nachricht",
								callback = function() BMU.createMail(data.displayName, "", "") BMU.printToChat("Nachricht erstellt an: " .. data.displayName) end,
								})
								
		-- copy account name
		table_insert(entries, {label = "Account-ID kopieren",
								callback = function() BMU.AdminCopyTextToChat(data.displayName) end,
								})
		
		-- invite to BMU guilds
		if BMU.var.BMUGuilds[worldName] ~= nil then
			for _, guildId in pairs(BMU.var.BMUGuilds[worldName]) do
				if IsPlayerInGuild(guildId) and not GetGuildMemberIndexFromDisplayName(guildId, data.displayName) then
					table_insert(entries, {label = "Einladen in: " .. GetGuildName(guildId),
											callback = function() BMU_AdminInviteToGuilds(guildId, data.displayName) end,
											})
				end
			end
		end
		
		-- invite to partner guilds
		if BMU.var.partnerGuilds[worldName] ~= nil then
			for _, guildId in pairs(BMU.var.partnerGuilds[worldName]) do
				if IsPlayerInGuild(guildId) and not GetGuildMemberIndexFromDisplayName(guildId, data.displayName) then
					table_insert(entries, {label = "Einladen in: " .. GetGuildName(guildId),
											callback = function() BMU_AdminInviteToGuilds(guildId, data.displayName) end,
											})
				end
			end
		end
		
		-- check if the player is also in other BMU guilds and add info
		table_insert(entries, {label = memberStatusText,
								callback = function() end,
								})
		
		AddCustomSubMenuItem(BMU_AdminContextMenuStr, entries)
		self:ShowMenu(control)
	end
end


function BMU.AdminAddContextMenuToGuildApplicationRoster()
	-- add context menu to guild recruitment application roster (if player is already in a one of the BMU guilds + redirection to the other guilds)
	LCM = LCM or BMU.LCM
	if not LCM then return end --Only with LibCustomMenu enabled!

	local GUILD_ROSTER_MANAGER = GUILD_ROSTER_MANAGER
	local ZO_GuildRecruitment_ApplicationsList_Keyboard = ZO_GuildRecruitment_ApplicationsList_Keyboard
	local Row_OnMouseUp = ZO_GuildRecruitment_ApplicationsList_Keyboard.Row_OnMouseUp
	ZO_GuildRecruitment_ApplicationsList_Keyboard.Row_OnMouseUp = function(self, control, button, upInside)
		ClearMenu()
		local data = ZO_ScrollList_GetData(control)
		Row_OnMouseUp(self, control, button, upInside)

		local currentGuildId = GUILD_ROSTER_MANAGER:GetGuildId()
		if (button ~= MOUSE_BUTTON_INDEX_RIGHT --[[and not upInside]]) or data == nil or not BMU_AdminIsBMUGuild(currentGuildId) then
			return
		end

		local isAlreadyMember, memberStatusText = BMU_AdminIsAlreadyInGuild(data.name)

		local entries = {}

		-- new message
		table_insert(entries, {label = "Neue Nachricht",
							   callback = function() BMU.createMail(data.name, "", "") BMU.printToChat("Nachricht erstellt an: " .. data.name) end,
		})

		-- copy account name
		table_insert(entries, {label = "Account-ID kopieren",
							   callback = function() BMU.AdminCopyTextToChat(data.name) end,
		})

		-- invite to BMU guilds
		if BMU.var.BMUGuilds[worldName] ~= nil then
			for _, guildId in pairs(BMU.var.BMUGuilds[worldName]) do
				if IsPlayerInGuild(guildId) and not GetGuildMemberIndexFromDisplayName(guildId, data.name) then
					table_insert(entries, {label = "Einladen in: " .. GetGuildName(guildId),
										   callback = function() BMU_AdminInviteToGuilds(guildId, data.name) end,
					})
				end
			end
		end

		-- invite to partner guilds
		if BMU.var.partnerGuilds[worldName] ~= nil then
			for _, guildId in pairs(BMU.var.partnerGuilds[worldName]) do
				if IsPlayerInGuild(guildId) and not GetGuildMemberIndexFromDisplayName(guildId, data.name) then
					table_insert(entries, {label = "Einladen in: " .. GetGuildName(guildId),
										   callback = function() BMU_AdminInviteToGuilds(guildId, data.name) end,
					})
				end
			end
		end

		-- check if the player is also in other BMU guilds and add info
		table_insert(entries, {label = memberStatusText,
							   callback = function() end,
		})

		AddCustomSubMenuItem(BMU_AdminContextMenuStr, entries)
		self:ShowMenu(control)
	end
end

function BMU.AdminAddTooltipInfoToGuildApplicationRoster()
	-- add info to the tooltip in guild recruitment application roster
	local ZO_GuildRecruitment_ApplicationsList_Keyboard = ZO_GuildRecruitment_ApplicationsList_Keyboard
	local GUILD_ROSTER_MANAGER = GUILD_ROSTER_MANAGER
	local Row_OnMouseEnter = ZO_GuildRecruitment_ApplicationsList_Keyboard.Row_OnMouseEnter
	ZO_GuildRecruitment_ApplicationsList_Keyboard.Row_OnMouseEnter = function(self, control)
		
		local data = ZO_ScrollList_GetData(control)
		local currentGuildId = GUILD_ROSTER_MANAGER:GetGuildId()
		
		if data ~= nil and not data.BMUInfo and BMU_AdminIsBMUGuild(currentGuildId) then
			local isAlreadyMember, memberStatusText = BMU_AdminIsAlreadyInGuild(data.name)
			data.message = data.message .. "\n\n" .. memberStatusText
			data.BMUInfo = true
		end
	
		Row_OnMouseEnter(self, control)		
	end
end

function BMU.AdminGetGuildIndexFromGuildId(guildId)
	for i = 1, GetNumGuilds() do
		if GetGuildId(i) == guildId then
			return i
		end
	end
	return 0
end
local BMU_AdminGetGuildIndexFromGuildId = BMU.AdminGetGuildIndexFromGuildId

function BMU.AdminCopyTextToChat(message)
	-- Max of input box is 351 chars
	if string_len(message) < 351 then
		local chatTextEntrey = chatSystem.textEntry
		if chatTextEntrey:GetText() == "" then
			chatTextEntrey:Open(message)
			ZO_ChatWindowTextEntryEditBox:SelectAll()
		end
	end
end

function BMU.AdminAutoWelcome(eventCode, guildId, displayName, result)
	-- only for BMU guilds
	if not BMU_AdminIsBMUGuild(guildId) then
		return
	end
	
	zo_callLater(function()
		if result == 0 then
			local guildIndex = BMU_AdminGetGuildIndexFromGuildId(guildId)
			local totalGuildMembers = GetNumGuildMembers(guildId)
			
			-- find new guild member
			for j = 0, totalGuildMembers do
				local displayName_info, note, guildMemberRankIndex, status, secsSinceLogoff = GetGuildMemberInfo(guildId, j)
				if displayName_info == displayName and status ~= PLAYER_STATUS_OFFLINE then
					-- new guild member is online -> write welcome message to chat
					StartChatInput("Welcome on the bridge " .. displayName, _G["CHAT_CHANNEL_GUILD_" .. guildIndex])
				end
			end
		end
	end, 1300)
end

function BMU.AdminIsAlreadyInGuild(displayName)
	local text = ""
	
	if GetGuildMemberIndexFromDisplayName(BMU.var.BMUGuilds[worldName][1], displayName) then
		text = text .. " 1 "
	end
	if GetGuildMemberIndexFromDisplayName(BMU.var.BMUGuilds[worldName][2], displayName) then
		text = text .. " 2 "
	end
	if GetGuildMemberIndexFromDisplayName(BMU.var.BMUGuilds[worldName][3], displayName) then
		text = text .. " 3 "
	end
	if GetGuildMemberIndexFromDisplayName(BMU.var.BMUGuilds[worldName][4], displayName) then
		text = text .. " 4 "
	end
	
	if text ~= "" then
		-- already member
		return true, BMU_colorizeText("Bereits Mitglied in " .. text, "red")
	else
		-- not a member or admin is not member of the BMU guilds
		return false, BMU_colorizeText("Neues Mitglied", "green")
	end
end

function BMU.AdminIsBMUGuild(guildId)
	if BMU.has_value(BMU.var.BMUGuilds[worldName], guildId) then
		return true
	else
		return false
	end
end

function BMU.AdminInviteToGuilds(guildId, displayName)
	-- add tuple to queue
	table.insert(inviteQueue, {guildId, displayName})
	if #inviteQueue == 1 then
		BMU.AdminInviteToGuildsQueue()
	end
end

function BMU.AdminInviteToGuildsQueue()
	if #inviteQueue > 0 then
		-- get first element and send invite
		local first = inviteQueue[1]
		GuildInvite(first[1], first[2])
		PlaySound(SOUNDS.BOOK_OPEN)
		-- restart to check for other elements
		zo_callLater(function() table.remove(inviteQueue, 1) BMU.AdminInviteToGuildsQueue() end, 16000)
	end		
end

function BMU.AdminAddAutoFillToDeclineApplicationDialog()
	local confirmDeclineDialogKeyboard = ZO_ConfirmDeclineApplicationDialog_Keyboard				--INS251229 Baertram
	local confirmDeclineEdit = ZO_ConfirmDeclineApplicationDialog_KeyboardDeclineMessageEdit		--INS251229 Baertram
	local font = string_format(fontPattern, ZoFontGame:GetFontInfo(), 21, "soft-shadow-thin")
	-- default message
	local autoFill_1 = WINDOW_MANAGER:CreateControl(nil, confirmDeclineDialogKeyboard, CT_LABEL)
	autoFill_1:SetAnchor(TOPRIGHT, confirmDeclineDialogKeyboard, TOPRIGHT, -5, 10)
	autoFill_1:SetFont(font)
	autoFill_1:SetText(BMU_colorizeText("BMU_AM", "gold"))
	autoFill_1:SetMouseEnabled(true)
	autoFill_1:SetHandler("OnMouseUp", function(self, button)
 	    if button ~= MOUSE_BUTTON_INDEX_LEFT then return end  --INS BAERTRAM20260124
		confirmDeclineEdit:SetText("You are already a member of one of our other BMU guilds. Sorry, but we only allow joining one guild. You are welcome to join and support our partner guilds (flag button in the upper left corner).")
	end)
	-- message when player is already in 5 guilds
	local autoFill_2 = WINDOW_MANAGER:CreateControl(nil, confirmDeclineDialogKeyboard, CT_LABEL)
	autoFill_2:SetAnchor(TOPRIGHT, confirmDeclineDialogKeyboard, TOPRIGHT, -5, 40)
	autoFill_2:SetFont(font)
	autoFill_2:SetText(BMU_colorizeText("BMU_5G", "gold"))
	autoFill_2:SetMouseEnabled(true)
	autoFill_2:SetHandler("OnMouseUp", function(self, button)
 	    if button ~= MOUSE_BUTTON_INDEX_LEFT then return end  --INS BAERTRAM20260124
		confirmDeclineEdit:SetText("We cannot accpect your application because you have already joined 5 other guilds (which is the maximum). If you want to join us, please submit a new application with free guild slot.")
	end)
end

