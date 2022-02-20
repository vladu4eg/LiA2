require('top')

Stats = Stats or {}
local dedicatedServerKey = GetDedicatedServerKeyV2("1")
local checkResult = {}
MIN_RATING_PLAYER = 1

function Stats.SubmitMatchData(winner,callback)
	if GameRules.startTime == nil then
		GameRules.startTime = 1
	end
	if not GameRules.isTesting  then
		if GameRules:IsCheatMode() then 
			GameRules:SetGameWinner(winner)
			SetResourceValues()
			return 
		end
	end
	local data = {}
	
	for pID=0,DOTA_MAX_TEAM_PLAYERS do
		if PlayerResource:IsValidPlayerID(pID) and PlayerResource:GetTeam(pID) ~= 5 then
			if GameRules.scores[pID] == nil then
				GameRules.scores[pID] = {easy = 0, normal = 0, hard = 0 }
				GameRules.scores[pID].easy = 0
				GameRules.scores[pID].normal = 0
				GameRules.scores[pID].hard = 0
			end
			DebugPrint("pID " .. pID )
			if GameRules.Bonus[pID] == nil then
				GameRules.Bonus[pID] = 0
			end
			if checkResult[pID] == nil then
				checkResult[pID] = 1
			else
				goto continue
			end
			if PlayerResource:GetDeaths(pID) >= 10 then 
				GameRules.Bonus[pID] = GameRules.Bonus[pID] - 2
			end 
		end
	end
	if GameRules.BonusPercent  >  0.77 then
		GameRules.BonusPercent = 0.77
	end
	if GameRules.PlayersCount >= MIN_RATING_PLAYER then
		for pID=0,DOTA_MAX_TEAM_PLAYERS do
			if PlayerResource:IsValidPlayerID(pID) and PlayerResource:GetTeam(pID) ~= 5 then
				data.MatchID = tostring(GameRules:Script_GetMatchID() or 0)
				data.Gem = 0
				data.Team = "2"
				if string.find(GetMapName(),"extreme") then
					data.Team = "3"
				elseif string.find(GetMapName(),"light") then
					data.Team = "1"
				end
				
				--data.duration = GameRules:GetGameTime() - GameRules.startTime
				data.Map = GetMapName()
				local hero = PlayerResource:GetSelectedHeroEntity(pID)
				data.SteamID = tostring(PlayerResource:GetSteamID(pID) or 0)
				data.Time = tostring(tonumber(GameRules:GetGameTime() - GameRules.startTime)/60 or 0)
				data.GoldGained = tostring(PlayerResource:GetCreepKills(pID))
				data.GoldGiven = tostring(PlayerResource:GetBossKills(pID))
				data.LumberGained =  tostring(PlayerResource:GetUpgradesPercent(pID))
				data.LumberGiven = tostring((GameRules.scores[pID].easy + GameRules.scores[pID].normal + GameRules.scores[pID].hard) == 0 and tonumber(data.Score))
				data.Kill = tostring(PlayerResource:GetKills(pID) or 0)
				data.Death = tostring(PlayerResource:GetDeaths(pID) or 0)
				
				data.Nick = tostring(PlayerResource:GetPlayerName(pID))
				data.GPS = tostring(hero:GetLevel())
				data.LPS = "0"
				
				data.GetScoreBonusRank = "0"
				data.GetScoreBonusGoldGained = "0"
				data.GetScoreBonusGoldGiven = "0"
				data.GetScoreBonusLumberGained = "0"
				data.GetScoreBonusLumberGiven = "0"	

				if hero then
					data.Type = tostring(DOTAGameManager:GetHeroIDByName(hero:GetUnitName()) or "null")
					if PlayerResource:GetConnectionState(pID) == 2 then
						if PlayerResource:GetTeam(pID) == winner then
							data.Score = tostring(math.floor(20 + GameRules.Bonus[pID]) - PlayerResource:GetDeaths(pID))
						elseif PlayerResource:GetTeam(pID) ~= winner then
							data.Score = tostring(math.floor(-10 + GameRules.Bonus[pID]) - PlayerResource:GetDeaths(pID))
						end 
					elseif PlayerResource:GetConnectionState(pID) ~= 2 and PlayerResource:GetTeam(pID) == winner then
						data.Score = tostring(math.floor(-20 + GameRules.Bonus[pID]) - PlayerResource:GetDeaths(pID))
					else
						data.Score = tostring(math.floor(-40))
					end
					if (GameRules.scores[pID].easy + GameRules.scores[pID].normal + GameRules.scores[pID].hard) == 0 and tonumber(data.Score) < 0 then
						data.Score = "0"
						data.Type = "NEWBIE"
					end
					if tonumber(data.Score) >= 0 then
						data.Score = tostring(math.floor(tonumber(data.Score) *  (1 + GameRules.BonusPercent)))
						data.Gem = tonumber(math.floor(tonumber(data.Score)/10)) + 1
					else 
						data.Score = tostring(math.floor(tonumber(data.Score) *  (1 - GameRules.BonusPercent)))
						data.Gem = tonumber(1)
					end
				else
					data.Type = "HERO KICK"
					data.Score = tostring(-15)
					data.Team = tostring(2)
				end
				data.Key = dedicatedServerKey
				data.BonusPercent = tostring(GameRules.BonusPercent)
				local text = tostring(PlayerResource:GetPlayerName(pID)) .. " got " .. data.Score
				GameRules.Score[pID] = data.Score
				CustomNetTables:SetTableValue("scorestats", tostring(pID), { playerScoreEasy = tostring(GameRules.scores[pID].easy), 
																	playerScoreNormal = tostring(GameRules.scores[pID].normal), 
																	playerScoreHard = tostring(GameRules.scores[pID].hard),
																	playerScoreEnd = tostring(data.Score)})
				GameRules:SendCustomMessage(text, 1, 1)
				Stats.SendData(data,callback)
				if data.Gem > 0 then
					data.EndGame = 1
					Shop.GetGem(data)
				end
			end 
		end
	end
	::continue::
	Timers:CreateTimer(5, function() 
		GameRules:SetGameWinner(winner)
	end)
end

function Stats.SendData(data,callback)
	local req = CreateHTTPRequestScriptVM("POST",GameRules.server)
	local encData = json.encode(data)
	DebugPrint("***********************************************")
	DebugPrint(GameRules.server)
	DebugPrint(encData)
	DebugPrint("***********************************************")
	req:SetHTTPRequestHeaderValue("Dedicated-Server-Key", dedicatedServerKey)
	req:SetHTTPRequestRawPostBody("application/json", encData)
	req:Send(function(res)
		DebugPrint("***********************************************")
		DebugPrint(res.Body)
		DebugPrint("Response code: " .. res.StatusCode)
		DebugPrint("***********************************************")
		if res.StatusCode ~= 200 then
			GameRules:SendCustomMessage("Error connecting", 1, 1)
			DebugPrint("Error connecting")
		end
		
		if callback then
			local obj,pos,err = json.decode(res.Body)
			callback(obj)
		end
		
	end)
end

function Stats.RequestData(pId, callback)
	local req = CreateHTTPRequestScriptVM("GET",GameRules.server .. tostring(PlayerResource:GetSteamID(pId)))
	req:SetHTTPRequestHeaderValue("Dedicated-Server-Key", dedicatedServerKey)
	DebugPrint("***********************************************")
	
	GameRules.scores[pId] = {easy = 0, normal = 0, hard = 0, endGame = 0}
	GameRules.scores[pId].easy = 0
	GameRules.scores[pId].normal = 0
	GameRules.scores[pId].hard = 0
	GameRules.scores[pId].endGame = 1

	req:Send(function(res)
		if res.StatusCode ~= 200 then
			DebugPrint("Connection failed! Code: ".. res.StatusCode)
			DebugPrint(res.Body)
			return -1
		end
		local obj,pos,err = json.decode(res.Body)
		DebugPrint(obj.steamID)
		DebugPrint("***********************************************"  .. #obj)
		DebugPrintTable(obj)

		for id=1,#obj do
			if obj[id].team == "1" then
				GameRules.scores[pId].easy = obj[id].score
			elseif obj[id].team == "2" then
				GameRules.scores[pId].normal = obj[id].score
			elseif obj[id].team == "3" then
				GameRules.scores[pId].hard = obj[id].score
			end
		end

		CustomNetTables:SetTableValue("scorestats", tostring(pId), { playerScoreEasy = tostring(GameRules.scores[pId].easy), 
																	playerScoreNormal = tostring(GameRules.scores[pId].normal), 
																	playerScoreHard = tostring(GameRules.scores[pId].hard),
																	playerScoreEnd = tostring(GameRules.scores[pId].endGame)})
		return obj
	end)
end

function Stats.RequestDataTop10(idTop, callback)
	local req = CreateHTTPRequestScriptVM("GET",GameRules.server .. "all/" .. idTop)
	req:SetHTTPRequestHeaderValue("Dedicated-Server-Key", dedicatedServerKey)
	DebugPrint("***********************************************")
	req:Send(function(res)
		if res.StatusCode ~= 200 then
			DebugPrint("Connection failed! Code: ".. res.StatusCode)
			DebugPrint(res.Body)
			return -1
		end
		
		local obj,pos,err = json.decode(res.Body)
		--DeepPrintTable(obj)
		DebugPrint("***********************************************")
		top:OnLoadTop(obj,idTop)
		---CustomNetTables:SetTableValue("stats", tostring( pId ), { steamID = obj.steamID, score = obj.score })
		return obj
		
	end)
end
