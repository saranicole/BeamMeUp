------------------------------------------------------------
-- BMU NAMESPACE & CONFIG
------------------------------------------------------------

local BMU = BMU or {}

BMU.TABLE_CHUNK_SIZE   = BMU.TABLE_CHUNK_SIZE or 50
BMU.GUILD_CACHE_TTL    = BMU.GUILD_CACHE_TTL or 5

BMU.GuildCache = BMU.GuildCache or {}

local TeleportAllPlayersTable = BMU.TeleportAllPlayersTable or {}

local SI = BMU.SI
local BMU_indexListSource 					= BMU.indexListSource
local tos = tostring
local numberType = "number"
local stringType = "string"
local tableType = "table"
local BMU_SI_Get                            = SI.get
local BMU_colorizeText 						= BMU.colorizeText
local BMU_printToChat 						= BMU.printToChat
local BMU_isFavoriteZone 					= BMU.isFavoriteZone
local BMU_isFavoritePlayer 					= BMU.isFavoritePlayer
local BMU_updateRelatedItemsCounterPanel 	= BMU.updateRelatedItemsCounterPanel

local BMU_SOURCE_INDEX_FRIEND 				= BMU.SOURCE_INDEX_FRIEND
local BMU_SOURCE_INDEX_GROUP   				= BMU.SOURCE_INDEX_GROUP
local BMU_SOURCE_INDEX_GUILD     			= BMU.SOURCE_INDEX_GUILD
local BMU_SOURCE_INDEX_OWNHOUSES 			= BMU.SOURCE_INDEX_OWNHOUSES

local BMU_indexListCurrentZone 				= BMU.indexListCurrentZone
local BMU_indexListSearchPlayer 			= BMU.indexListSearchPlayer
local BMU_indexListSearchZone 				= BMU.indexListSearchZone

local table_insert = table.insert
local table_remove = table.remove
local table_sort = table.sort

------------------------------------------------------------
-- TIME HELPER
------------------------------------------------------------

local function Now()
    return GetFrameTimeSeconds()
end


------------------------------------------------------------
-- GUILD CACHE HELPERS (PER GUILD, SAFE FOR 5 GUILDS)
------------------------------------------------------------

local function IsGuildCacheValid(guildId)
    local cache = BMU.GuildCache[guildId]
    if not cache then return false end
    return (Now() - cache.timestamp) < BMU.GUILD_CACHE_TTL
end


function BMU:GetGuildMemberStatusTable(guildId)
    if IsGuildCacheValid(guildId) then
        return BMU.GuildCache[guildId].members
    end

    local members    = {}
    local numMembers = GetNumGuildMembers(guildId)

    for i = 1, numMembers do
        local displayName, _, _, _, _, status = GetGuildMemberInfo(guildId, i)
        members[displayName] = (status ~= PLAYER_STATUS_OFFLINE)
    end

    BMU.GuildCache[guildId] =
    {
        timestamp = Now(),
        members   = members,
    }

    return members
end


-- =====================
-- Guild Cache Helpers
-- =====================
BMU.guildCache = BMU.guildCache or {}
BMU.guildCacheExpiry = BMU.guildCacheExpiry or 5 -- seconds

function BMU.getGuildMembersCached(guildId)
    local cache = BMU.guildCache[guildId]
    local now = GetGameTimeMilliseconds() / 1000
    if cache and (now - cache.timestamp <= BMU.guildCacheExpiry) then
        return cache.members
    end

    -- Rebuild cache
    local total = GetNumGuildMembers(guildId)
    local members = {}
    for i = 1, total do
        members[i] = {infoIndex = i} -- store index for later lookup
    end

    BMU.guildCache[guildId] = {members = members, timestamp = now}
    return members
end

------------------------------------------------------------
-- FINALIZATION (SORT + UI INSERT)
------------------------------------------------------------

local function finalizeTable(index, portalPlayers, dontDisplay, dontResetSlider)
    index        = index or 0
    local BMU_savedVarsAcc = BMU.savedVarsAcc
    local BMU_savedVarsChar = BMU.savedVarsChar
    dontDisplay = dontDisplay or false
    dontResetSlider = dontResetSlider or false
    BMU_getMapIndex = BMU_getMapIndex or BMU.getMapIndex
    BMU_getParentZoneId = BMU_getParentZoneId or BMU.getParentZoneId
    BMU_checkOnceOnly = BMU_checkOnceOnly or BMU.checkOnceOnly
    BMU_has_value = BMU_has_value or BMU.has_value
    BMU_has_value_special = BMU_has_value_special or BMU.has_value_special
    BMU_addInfo_1 = BMU_addInfo_1 or BMU.addInfo_1
    BMU_addInfo_2 = BMU_addInfo_2 or BMU.addInfo_2
    BMU_filterAndDecide = BMU_filterAndDecide or BMU.filterAndDecide
    BMU_sortByStringFindPosition = BMU_sortByStringFindPosition or BMU.sortByStringFindPosition
    BMU_syncWithItems = BMU_syncWithItems or BMU.syncWithItems
    BMU_syncWithQuests = BMU_syncWithQuests or BMU.syncWithQuests
    BMU_createNoResultsInfo = BMU_createNoResultsInfo or BMU.createNoResultsInfo
    BMU_addNumberPlayers = BMU_addNumberPlayers or BMU.addNumberPlayers
    BMU_decidePrioDisplay = BMU_decidePrioDisplay or BMU.decidePrioDisplay
    BMU_getParentZoneId = BMU_getParentZoneId or BMU.getParentZoneId

	-- display number of hits (port alternatives)
	-- not needed in case of only current zone and favorite zoneId
	if BMU_savedVarsAcc.showNumberPlayers and not (index == BMU_indexListCurrentZone or index == BMU_indexListZoneHidden or index == BMU_indexListZone) then
		portalPlayers = BMU_addNumberPlayers(portalPlayers)
	end

	---------------------------------------------------------------------------------------------------
	--Results list building & Sorting
	if index == BMU_indexListItems then
		-- related items
		portalPlayers = BMU_syncWithItems(portalPlayers) -- returns already sorted list
	elseif index == BMU_indexListQuests then
		-- related quests
		portalPlayers = BMU_syncWithQuests(portalPlayers) -- returns already sorted list
	elseif index == BMU_indexListSearchPlayer then
		-- search by player name
		-- sort by string match position (displayName and characterName)
		portalPlayers = BMU_sortByStringFindPosition(portalPlayers, inputString, "displayName", "characterName")
	elseif index == BMU_indexListSearchZone then
		-- search by zone name
		-- sort by string match position (zoneName, zoneNameSecondLanguage)
		portalPlayers = BMU_sortByStringFindPosition(portalPlayers, inputString, "zoneName", "zoneNameSecondLanguage")
	else
		-- SORTING
		if BMU_savedVarsChar.sorting == 2 then
			-- sort by prio, category, zoneName, prio by source
			table_sort(portalPlayers, function(a, b)
				-- prio
				if a.prio ~= b.prio then
					return a.prio < b.prio
				end
				-- category
				if BMU.sortingByCategory[a.category] ~= BMU.sortingByCategory[b.category] then
					return BMU.sortingByCategory[a.category] < BMU.sortingByCategory[b.category]
				end
				-- zoneName
				if a.zoneName ~= b.zoneName then
					return a.zoneName < b.zoneName
				end
				-- prio by source
				return BMU_decidePrioDisplay(a, b)
			end)

		elseif BMU_savedVarsChar.sorting == 3 then
			-- sort by prio, most used, zoneName, prio by source
			table_sort(portalPlayers, function(a, b)
				-- prio
				if a.prio ~= b.prio then
					return a.prio < b.prio
				end
				-- most used
				local num1 = BMU_savedVarsAcc.portCounterPerZone[a.zoneId] or 0
				local num2 = BMU_savedVarsAcc.portCounterPerZone[b.zoneId] or 0
				if num1 ~= num2 then
					return num1 > num2
				end
				-- zoneName
				if a.zoneName ~= b.zoneName then
					return a.zoneName < b.zoneName
				end
				-- prio by source
				return BMU_decidePrioDisplay(a, b)
			end)

		elseif BMU_savedVarsChar.sorting == 4 then
			-- sort by prio, most used, category, zoneName, prio by source
			table_sort(portalPlayers, function(a, b)
				-- prio
				if a.prio ~= b.prio then
					return a.prio < b.prio
				end
				-- most used
				local num1 = BMU_savedVarsAcc.portCounterPerZone[a.zoneId] or 0
				local num2 = BMU_savedVarsAcc.portCounterPerZone[b.zoneId] or 0
				if num1 ~= num2 then
					return num1 > num2
				end
				-- category
				if BMU.sortingByCategory[a.category] ~= BMU.sortingByCategory[b.category] then
					return BMU.sortingByCategory[a.category] < BMU.sortingByCategory[b.category]
				end
				-- zoneName
				if a.zoneName ~= b.zoneName then
					return a.zoneName < b.zoneName
				end
				-- prio by source
				return BMU_decidePrioDisplay(a, b)
			end)

		elseif BMU_savedVarsChar.sorting == 5 then
			-- sort by prio, number players, zoneName, prio by source
			table_sort(portalPlayers, function(a, b)
				-- prio
				if a.prio ~= b.prio then
					return a.prio < b.prio
				end
				-- number players
				local numP1 = a.numberPlayers or 1
				local numP2 = b.numberPlayers or 1
				if numP1 ~= numP2 then
					return numP1 > numP2
				end
				-- zoneName
				if a.zoneName ~= b.zoneName then
					return a.zoneName < b.zoneName
				end
				-- prio by source
				return BMU_decidePrioDisplay(a, b)
			end)

		elseif BMU_savedVarsChar.sorting == 6 then
			-- sort by prio, number of undiscovered wayshrines, zone category, zoneName, prio by source
			table_sort(portalPlayers, function(a, b)
				-- prio
				if a.prio ~= b.prio then
					return a.prio < b.prio
				end
				-- number of undiscovered wayshrines
				if not (a.zoneWayshrineTotal == nil and b.zoneWayshrineTotal == nil) then
					if a.zoneWayshrineTotal ~= nil and b.zoneWayshrineTotal == nil then
						return true
					elseif a.zoneWayshrineTotal == nil and b.zoneWayshrineTotal ~= nil then
						return false
					elseif (a.zoneWayshrineTotal - a.zoneWayshrineDiscovered) ~= (b.zoneWayshrineTotal - b.zoneWayshrineDiscovered) then
						return (a.zoneWayshrineTotal - a.zoneWayshrineDiscovered) > (b.zoneWayshrineTotal - b.zoneWayshrineDiscovered)
					end
				end
				-- category
				if BMU.sortingByCategory[a.category] ~= BMU.sortingByCategory[b.category] then
					return BMU.sortingByCategory[a.category] < BMU.sortingByCategory[b.category]
				end
				-- zoneName
				if a.zoneName ~= b.zoneName then
					return a.zoneName < b.zoneName
				end
				-- prio by source
				return BMU_decidePrioDisplay(a, b)
			end)

		elseif BMU_savedVarsChar.sorting == 7 then
			-- sort by prio, number of undiscovered skyshards, zone category, zoneName, prio by source
			table_sort(portalPlayers, function(a, b)
				-- prio
				if a.prio ~= b.prio then
					return a.prio < b.prio
				end
				-- number of undiscovered skyshards
				if not (a.zoneSkyshardTotal == nil and b.zoneSkyshardTotal == nil) then
					if a.zoneSkyshardTotal ~= nil and b.zoneSkyshardTotal == nil then
						return true
					elseif a.zoneSkyshardTotal == nil and b.zoneSkyshardTotal ~= nil then
						return false
					elseif (a.zoneSkyshardTotal - a.zoneSkyshardDiscovered) ~= (b.zoneSkyshardTotal - b.zoneSkyshardDiscovered) then
						return (a.zoneSkyshardTotal - a.zoneSkyshardDiscovered) > (b.zoneSkyshardTotal - b.zoneSkyshardDiscovered)
					end
				end
				-- category
				if BMU.sortingByCategory[a.category] ~= BMU.sortingByCategory[b.category] then
					return BMU.sortingByCategory[a.category] < BMU.sortingByCategory[b.category]
				end
				-- zoneName
				if a.zoneName ~= b.zoneName then
					return a.zoneName < b.zoneName
				end
				-- prio by source
				return BMU_decidePrioDisplay(a, b)
			end)

		elseif BMU_savedVarsChar.sorting == 8 then
			-- sort by prio, last used, zoneName, prio by source
			table_sort(portalPlayers, function(a, b)
				-- prio
				if a.prio ~= b.prio then
					return a.prio < b.prio
				end
				-- last used
				local pos1 = BMU_has_value(BMU_savedVarsAcc.lastPortedZones, a.zoneId) or 99
				local pos2 = BMU_has_value(BMU_savedVarsAcc.lastPortedZones, b.zoneId) or 99
				if pos1 ~= pos2 then
					return pos1 < pos2
				end
				-- zoneName
				if a.zoneName ~= b.zoneName then
					return a.zoneName < b.zoneName
				end
				-- prio by source
				return BMU_decidePrioDisplay(a, b)
			end)

		elseif BMU_savedVarsChar.sorting == 9 then
			-- sort by prio, last used, category, zoneName, prio by source
			table_sort(portalPlayers, function(a, b)
				-- prio
				if a.prio ~= b.prio then
					return a.prio < b.prio
				end
				-- last used
				local pos1 = BMU_has_value(BMU_savedVarsAcc.lastPortedZones, a.zoneId) or 99
				local pos2 = BMU_has_value(BMU_savedVarsAcc.lastPortedZones, b.zoneId) or 99
				if pos1 ~= pos2 then
					return pos1 < pos2
				end
				-- category
				if BMU.sortingByCategory[a.category] ~= BMU.sortingByCategory[b.category] then
					return BMU.sortingByCategory[a.category] < BMU.sortingByCategory[b.category]
				end
				-- zoneName
				if a.zoneName ~= b.zoneName then
					return a.zoneName < b.zoneName
				end
				-- prio by source
				return BMU_decidePrioDisplay(a, b)
			end)

		elseif BMU_savedVarsChar.sorting == 10 then
			-- sort by prio, number of missing set items, category, zoneName, prio by source
			table_sort(portalPlayers, function(a, b)
				-- prio
				if a.prio ~= b.prio then
					return a.prio < b.prio
				end
				-- missing set items
				local numUnlocked1, numTotal1, _ = BMU.getNumSetCollectionProgressPieces(a.zoneId, a.category, a.parentZoneId)
				local numUnlocked2, numTotal2, _ = BMU.getNumSetCollectionProgressPieces(b.zoneId, b.category, b.parentZoneId)
				if (numUnlocked1 and numTotal1) or (numUnlocked2 and numTotal2) then
					-- if at least one side
					if (numUnlocked1 and numTotal1) and not (numUnlocked2 and numTotal2) then
						-- only a
						return true
					elseif not (numUnlocked1 and numTotal1) and (numUnlocked2 and numTotal2) then
						-- only b
						return false
					elseif (numTotal1-numUnlocked1) ~= (numTotal2-numUnlocked2) then
						-- a and b
						return (numTotal1-numUnlocked1) > (numTotal2-numUnlocked2)
					end
				end
				-- category
				if BMU.sortingByCategory[a.category] ~= BMU.sortingByCategory[b.category] then
					return BMU.sortingByCategory[a.category] < BMU.sortingByCategory[b.category]
				end
				-- zoneName
				if a.zoneName ~= b.zoneName then
					return a.zoneName < b.zoneName
				end
				-- prio by source
				return BMU_decidePrioDisplay(a, b)
			end)

		elseif BMU_savedVarsChar.sorting == 11 then
			-- sort by prio, category, zones without players, zoneName, prio by source
			table_sort(portalPlayers, function(a, b)
				-- prio
				if a.prio ~= b.prio then
					return a.prio < b.prio
				end
				-- category
				if BMU.sortingByCategory[a.category] ~= BMU.sortingByCategory[b.category] then
					return BMU.sortingByCategory[a.category] < BMU.sortingByCategory[b.category]
				end
				-- zones without players
				if not a.zoneWithoutPlayer and b.zoneWithoutPlayer then
					return true
				elseif a.zoneWithoutPlayer and not b.zoneWithoutPlayer then
					return false
				end
				-- zoneName
				if a.zoneName ~= b.zoneName then
					return a.zoneName < b.zoneName
				end
				-- prio by source
				return BMU_decidePrioDisplay(a, b)
			end)

		else -- BMU_savedVarsChar.sorting == 1
			-- sort by prio, zoneName, prio by source
			table_sort(portalPlayers, function(a, b)
				-- prio
				if a.prio ~= b.prio then
					return a.prio < b.prio
				end
				-- zoneName
				if a.zoneName ~= b.zoneName then
					return a.zoneName < b.zoneName
				end
				-- prio by source
				return BMU_decidePrioDisplay(a, b)
			end)
		end
	end

	-- in case of no results, add message with information
	if #portalPlayers == 0 then
		table.insert(portalPlayers, BMU_createNoResultsInfo())
	end

	-- display or return result
	if dontDisplay == true then
		return portalPlayers
	else
		BMU.TeleporterList:add_messages(portalPlayers, dontResetSlider)
		if index == BMU_indexListItems and BMU_savedVarsChar.displayCounterPanel then
			-- update counter panel for related items
			BMU_updateRelatedItemsCounterPanel()
		end
	end
end
--
-- local function Slice(tbl, first, last)
--   local sliced = {}
--   for i = first or 1, last or #tbl do
--     sliced[#sliced + 1] = tbl[i]
--   end
--   return sliced
-- end

-- =====================
-- Row Generator
-- =====================
function BMU.createRowForZone(typeInfo, args, consideredPlayers, context)
    local index        = args.index or 0
    local inputString  = args.inputString or ""
    local fZoneId      = args.fZoneId or typeInfo.zoneId
    local filterSource = args.filterSourceIndex or 1
    local currentZoneId = context.currentZoneId
    local playersZoneId = context.playersZoneId
    BMU_getMapIndex = BMU_getMapIndex or BMU.getMapIndex
    BMU_getParentZoneId = BMU_getParentZoneId or BMU.getParentZoneId
    BMU_checkOnceOnly = BMU_checkOnceOnly or BMU.checkOnceOnly
    BMU_has_value = BMU_has_value or BMU.has_value
    BMU_has_value_special = BMU_has_value_special or BMU.has_value_special
    BMU_addInfo_1 = BMU_addInfo_1 or BMU.addInfo_1
    BMU_addInfo_2 = BMU_addInfo_2 or BMU.addInfo_2
    BMU_filterAndDecide = BMU_filterAndDecide or BMU.filterAndDecide
    BMU_sortByStringFindPosition = BMU_sortByStringFindPosition or BMU.sortByStringFindPosition
    BMU_syncWithItems = BMU_syncWithItems or BMU.syncWithItems
    BMU_syncWithQuests = BMU_syncWithQuests or BMU.syncWithQuests
    BMU_createNoResultsInfo = BMU_createNoResultsInfo or BMU.createNoResultsInfo
    BMU_addNumberPlayers = BMU_addNumberPlayers or BMU.addNumberPlayers
    BMU_decidePrioDisplay = BMU_decidePrioDisplay or BMU.decidePrioDisplay
    BMU_getParentZoneId = BMU_getParentZoneId or BMU.getParentZoneId

    if index == BMU_indexListZone and type(fZoneId) ~= numberType then
      return nil
    end

    local row = nil

    if typeInfo.type == "group" then
      local groupUnitTag = typeInfo.unitTag
			local e = {}
			-- gathering information (and prefiltering of offline players and other invalid entries)
			if groupUnitTag ~= nil and GetUnitZoneIndex(groupUnitTag) ~= nil then
				e.displayName = GetUnitDisplayName(groupUnitTag)
				e.characterName = GetUnitName(groupUnitTag)
				e.online = IsUnitOnline(groupUnitTag)
				e.zoneName = GetUnitZone(groupUnitTag)
				e.zoneId = GetZoneId(GetUnitZoneIndex(groupUnitTag))
				e.level = GetUnitLevel(groupUnitTag)
				e.championRank = GetUnitChampionPoints(groupUnitTag)
				e.alliance = GetUnitAlliance(groupUnitTag)
				e.isLeader = IsUnitGroupLeader(groupUnitTag)
				e.groupMemberSameInstance = not IsGroupMemberInRemoteRegion(groupUnitTag)	-- IsGroupMemberInSameInstanceAsPlayer(groupUnitTag)
				-- to ping group members
				e.playerNameClickable = true
				e.groupUnitTag = groupUnitTag
			end

			-- first big layer of filtering, second layer is placed in seperate function (mainly offline players)
			-- consider only: other players ; online users ; valid zone names ; valid player names
			if e.displayName ~= GetDisplayName() and e.online and e.zoneName ~= nil and e.zoneName ~= "" and e.zoneId ~= nil and e.zoneId ~= 0 and e.displayName ~= "" then

				-- save displayName
				consideredPlayers[e.displayName] = true
				-- add bunch of information to the record
				e = BMU_addInfo_1(e, currentZoneId, playersZoneId, BMU_SOURCE_INDEX_GROUP)

				-- second big filter level
				if BMU_filterAndDecide(index, e, inputString, currentZoneId, fZoneId, filterSourceIndex) then
					-- add bunch of information to the record
					e = BMU_addInfo_2(e)
					-- insert into table
          row = e
				end
      else
        return nil
			end
    elseif typeInfo.type == "friend" then
      local j = typeInfo.friendIndex
      -- gathering information
      local e = {}
      e.displayName, e.Note, e.status, e.secsSinceLogoff = GetFriendInfo(j)
      e.hasCharacter, e.characterName, e.zoneName, e.classType, e.alliance, e.level, e.championRank, e.zoneId = GetFriendCharacterInfo(j)

      -- first big layer of filtering, second layer is placed in seperate function
          -- consider only: other players ; online users (state 1,2,3) ; valid zone names ; valid player names
      if e.displayName ~= GetDisplayName() and e.status ~= PLAYER_STATUS_OFFLINE and e.zoneName ~= nil and e.zoneName ~= "" and e.zoneId ~= nil and e.zoneId ~= 0 and e.displayName ~= "" and not consideredPlayers[e.displayName] then

        -- save displayName
        consideredPlayers[e.displayName] = true
        -- do some formating stuff
        e = BMU_addInfo_1(e, currentZoneId, playersZoneId, BMU_SOURCE_INDEX_FRIEND)

        -- second big filter level
        if BMU_filterAndDecide(index, e, inputString, currentZoneId, fZoneId, filterSourceIndex) then
          -- add bunch of information to the record
          e = BMU_addInfo_2(e)
          -- insert into table
          row = e
        end
      else
        return nil
      end
    elseif typeInfo.type == "guild" then
      local guildId = typeInfo.guildId
      local memberIndex = typeInfo.guildMemberIndex
      local e = {}
            e.displayName, e.Note, e.GuildMemberRankIndex, e.status, e.secsSinceLogoff = GetGuildMemberInfo(guildId, memberIndex)
            e.hasCharacter, e.characterName, e.zoneName, e.classType, e.alliance, e.level, e.championRank, e.zoneId = GetGuildMemberCharacterInfo(guildId, memberIndex)
			e.guildIndex = typeInfo.guildIndex

			-- first big layer of filtering, second layer is placed in seperate function
            -- consider only: other players ; online users (state 1,2,3) ; valid zone names ; valid player names

			if e.displayName ~= GetDisplayName() and e.status ~= 4 and e.zoneName ~= nil and e.zoneName ~= "" and e.zoneId ~= nil and e.zoneId ~= 0 and e.displayName ~= "" and not consideredPlayers[e.displayName] then
				-- save displayName
				consideredPlayers[e.displayName] = true
				-- do some formating stuff
				e = BMU_addInfo_1(e, currentZoneId, playersZoneId, BMU_SOURCE_INDEX_GUILD[typeInfo.guildIndex])
				-- second big filter level

				if BMU_filterAndDecide(index, e, inputString, currentZoneId, fZoneId, filterSourceIndex) then
					-- add bunch of information to the record
					e = BMU_addInfo_2(e)
					-- insert into table
          row = e
				end
      else
        return nil
			end

    elseif typeInfo.type == "house" then
      if not house then return nil end
      local houseId = house:GetReferenceId()
			local houseZoneId = GetHouseZoneId(houseId)
			--local mapIndex = BMU_getMapIndex(houseZoneId)
			local parentZoneId = BMU_getParentZoneId(houseZoneId)
			-- check if parent zone not already in result list
			---if not allZoneIds[parentZoneId] then
			local e = {}
			-- add infos
			e.parentZoneId = parentZoneId
			e.parentZoneName = BMU_formatName(GetZoneNameById(e.parentZoneId))
			e.zoneId = e.parentZoneId
			e.displayName = ""
			e.houseId = houseId
			e.isOwnHouse = true
			-- add flag to port outside the house
			e.forceOutside = true
			e.zoneName = GetZoneNameById(e.zoneId)
			e.houseNameUnformatted = GetZoneNameById(houseZoneId)
			e.houseNameFormatted = BMU_formatName(e.houseNameUnformatted)
			e.collectibleId = GetCollectibleIdForHouse(e.houseId)
			e.nickName = BMU_formatName(GetCollectibleNickname(e.collectibleId))
			e.houseTooltip = {e.houseNameFormatted, "\"" .. e.nickName .. "\""}

			e = BMU_addInfo_1(e, currentZoneId, playersZoneId, "")
			if BMU_filterAndDecide(index, e, inputString, currentZoneId, fZoneId, filterSourceIndex) then
				e = BMU_addInfo_2(e)
				-- overwrite
				e.mapIndex = BMU_getMapIndex(houseZoneId)
				e.parentZoneId = BMU_getParentZoneId(houseZoneId)
				-- add manually
				--allZoneIds[e.zoneId] = allZoneIds[e.zoneId] + 1
			end
      row = e
    elseif typeInfo.type == "zone" then
      local overlandZoneId = typeInfo.zoneId
      local e = {}
			e.zoneId = overlandZoneId
			e.displayName = ""
			e.zoneName = GetZoneNameById(overlandZoneId)
			e.zoneWithoutPlayer = true
			e = BMU_addInfo_1(e, currentZoneId, playersZoneId, "")
			if BMU_filterAndDecide(index, e, inputString, currentZoneId, fZoneId, filterSourceIndex) then
				e = BMU_addInfo_2(e)
				e.textColorDisplayName = colorRed
				e.textColorZoneName = colorRed
        row = e
			end
    end
    return row
end

local function Slice(tbl, first, last)
  local sliced = {}
  for i = first or 1, last or #tbl do
    sliced[#sliced + 1] = tbl[i]
  end
  return sliced
end

------------------------------------------------------------
-- OPTIMIZED CREATE TABLE
------------------------------------------------------------

local counter = 1

function BMU.createTableOptimized(args)

	local index = args.index or 0
	local inputString = args.inputString or ""
	local fZoneId = args.fZoneId
	local dontDisplay = args.dontDisplay or false
	local filterSourceIndex = args.filterSourceIndex
	local dontResetSlider = args.dontResetSlider or false
	local noOwnHouses = args.noOwnHouses or false
	local BMU_changeState 						= BMU.changeState
  local currentZoneId = BMU.getCurrentZoneId()
  local playersZoneId = BMU.getPlayersZoneId()
  BMU_getMapIndex = BMU_getMapIndex or BMU.getMapIndex
	BMU_getParentZoneId = BMU_getParentZoneId or BMU.getParentZoneId
	BMU_checkOnceOnly = BMU_checkOnceOnly or BMU.checkOnceOnly
	BMU_has_value = BMU_has_value or BMU.has_value
	BMU_has_value_special = BMU_has_value_special or BMU.has_value_special
	BMU_addInfo_1 = BMU_addInfo_1 or BMU.addInfo_1
	BMU_addInfo_2 = BMU_addInfo_2 or BMU.addInfo_2
	BMU_filterAndDecide = BMU_filterAndDecide or BMU.filterAndDecide
	BMU_sortByStringFindPosition = BMU_sortByStringFindPosition or BMU.sortByStringFindPosition
	BMU_syncWithItems = BMU_syncWithItems or BMU.syncWithItems
	BMU_syncWithQuests = BMU_syncWithQuests or BMU.syncWithQuests
	BMU_createNoResultsInfo = BMU_createNoResultsInfo or BMU.createNoResultsInfo
	BMU_addNumberPlayers = BMU_addNumberPlayers or BMU.addNumberPlayers
	BMU_decidePrioDisplay = BMU_decidePrioDisplay or BMU.decidePrioDisplay
	BMU_getParentZoneId = BMU_getParentZoneId or BMU.getParentZoneId
	local BMU_savedVarsAcc = BMU.savedVarsAcc
	local BMU_savedVarsChar = BMU.savedVarsChar
	local portalPlayers = {}

	-- simple checks
	if type(index) ~= numberType or (index == BMU_indexListSource and type(filterSourceIndex) ~= numberType) then
		return
	end

	local startTime = GetGameTimeMilliseconds() -- get start time

	-- clear input fields
	if index ~= BMU_indexListSearchPlayer and index ~= BMU_indexListSearchZone then
		BMU.clearInputFields()
	end

	-- if filtering by name and inputString is empty -> same as everything
	if (index == BMU_indexListSearchPlayer or index == BMU_indexListSearchZone) and inputString == "" then
		index = BMU_indexListMain
	end

	-- print status (debug)
	BMU_printToChat("Refreshed - state: " .. tos(index) .. " - String: " .. tos(inputString), BMU.MSG_DB)

	-- change state for correct persistent MouseOver and for auto refresh
	if not dontDisplay then -- dont change when result should not be displayed in list
		BMU_changeState(index)
	end

	-- save SourceIndex in global variable
	if index == BMU_indexListSource then
		BMU.stateSourceIndex = filterSourceIndex
	end

	-- save ZoneId in global variable
	if index == BMU_indexListZone then
		BMU.stateZoneId = fZoneId
	end

    --------------------------------------------------------
    -- BUILD GUILD STATUS CACHE SNAPSHOT
    --------------------------------------------------------

    local guildStatuses = {}

    for guildIndex = 1, GetNumGuilds() do
        local guildId = GetGuildId(guildIndex)
        guildStatuses[guildId] = BMU:GetGuildMemberStatusTable(guildId)
    end

    --------------------------------------------------------
    -- CHUNKED PROCESSING
    --------------------------------------------------------

    local chunkSize  = 20
    local consideredPlayers = {}

    local prevIdex

    local function ProcessChunk(iDex, flag)
--       if counter > 100 then
--         return {}
--       end
--       counter = counter + 1
      iDex = iDex or 1
      -- Early exit if display disabled mid-run
      if args.dontDisplay then
          return
      end

      -- Build typeInfo list
      local typesToProcess = {}

      -- 1. Group members
      if IsPlayerInGroup(GetDisplayName()) then
          for j = 1, GetGroupSize() do
              table.insert(typesToProcess, {type="group", unitTag=GetGroupUnitTagByIndex(j)})
          end
      end

      -- 2. Friends
      for j = 1, GetNumFriends() do
          table.insert(typesToProcess, {type="friend", friendIndex=j})
      end

      -- 3. Guilds (cached)
      local numGuilds = GetNumGuilds()
      for i = 1, numGuilds do
          local guildId = GetGuildId(i)
          local members = BMU.getGuildMembersCached(guildId)
          for _, m in ipairs(members) do
              table.insert(typesToProcess, {type="guild", guildId=guildId, guildIndex=i, guildMemberIndex=m.infoIndex})
          end
      end

      -- 4. Own houses
      if not BMU_savedVarsAcc.hideOwnHouses and not noOwnHouses then
          local ownedHouses = ZO_COLLECTIBLE_DATA_MANAGER:GetAllCollectibleDataObjects({ZO_CollectibleCategoryData.IsHousingCategory}, {ZO_CollectibleData.IsUnlocked})
          for _, house in ipairs(ownedHouses) do
              table.insert(typesToProcess, {type="house", house=house})
          end
      end

      -- 5. Overland zones (fZoneId can be single number or table)

      if fZoneId then
          if type(fZoneId) == "table" then
              for zoneId, _ in pairs(fZoneId) do
                  table.insert(typesToProcess, {type="zone", zoneId=zoneId})
              end
          else
              table.insert(typesToProcess, {type="zone", zoneId=fZoneId})
          end
      end

      -- Context for row processing
      local context = {currentZoneId=currentZoneId, playersZoneId=playersZoneId}

      local limit = math.min(1 + chunkSize - 1, #typesToProcess)

      -- Process all types
      local entryRound = Slice(typesToProcess, iDex, iDex + limit)

      for _, typeInfo in ipairs(entryRound) do
        local row = BMU.createRowForZone(typeInfo, args, consideredPlayers, context)

        if row then
            TeleportAllPlayersTable[#TeleportAllPlayersTable + 1] = row
        end
        iDex = iDex + limit + 1
      end

      if not flag and iDex <= #typesToProcess then
        zo_callLater(function()
          ProcessChunk(iDex)
        end, 0)
      else
          portalPlayers = finalizeTable(args.index, TeleportAllPlayersTable, args.dontDisplay, args.dontResetSlider)
          -- get end time and print runtime in milliseconds (debug)
          BMU_printToChat("RunTime: " .. (GetGameTimeMilliseconds() - startTime) .. " ms", BMU.MSG_DB)
      end
    end
    ProcessChunk()
    return portalPlayers
end
