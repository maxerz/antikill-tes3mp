local AntiKill = {}

AntiKill.scriptName = "AntiKill"

AntiKill.defaultConfig = {
    immortalNPCs = {},
    command = {
        staffRank = 2,
        rankError = "#FF0000[x] #FFFFFFYou're not admin!\n",
        excludeMessage = "#6699FF[i] #FFFFFF\"%s\" is no longer immortal!\n",
        includeMessage = "#6699FF[i] #FFFFFF\"%s\" is immortal now!\n",
        saveMessage = "#6699FF[i] #FFFFFFImmortal NPC data saved!\n",
        unkillableMessage = "#FF0000[x] #FFFFFFYou can't kill \"%s\"!\n",
        listMessage = "#6699FF[i] #FFFFFFImmortal NPC List: "
    }
}

AntiKill.config = DataManager.loadConfiguration(AntiKill.scriptName, AntiKill.defaultConfig)

-- Exclude/Include helper functions
function AntiKill.exclude(npcID)
    AntiKill.config.immortalNPCs[npcID] = nil
end

function AntiKill.include(npcID)
    AntiKill.config.immortalNPCs[npcID] = true
end

-- Save Config
function AntiKill.saveCfg()
	DataManager.saveConfiguration(AntiKill.scriptName, AntiKill.config)
end

function AntiKill.OnServerExit(eventStatus)
    AntiKill.saveCfg()
end

customEventHooks.registerHandler("OnServerExit", AntiKill.OnServerExit)

-- crutch to not being able to get refid and so execute resurrect on onactordeath
function AntiKill.OnContainer(eventStatus, pid, cellDescription)
	tes3mp.ReadReceivedObjectList()
	if tes3mp.GetObjectListContainerSubAction() == 4 then -- called only on death
		local refid = 0
		for index = 0, tes3mp.GetObjectListSize() - 1 do
			refid = tes3mp.GetObjectRefId(index)
			if AntiKill.config.immortalNPCs[refid] then -- if we find any immortal npc, resurrect them
				tes3mp.SendMessage(pid, string.format(AntiKill.config.command.unkillableMessage, refid))
				tes3mp.SetObjectListConsoleCommand('resurrect')
				tes3mp.SendConsoleCommand(true, false)
				return customEventHooks.makeEventStatus(false,false) -- cancel oncontainer
			end
		end
	end
end
customEventHooks.registerValidator("OnContainer", AntiKill.OnContainer)


function AntiKill.Command(pid, cmd)
    if Players[pid].data.settings.staffRank >= AntiKill.config.command.staffRank then
        local npcID = ""
        if cmd[3] ~= nil then
            npcID = table.concat(cmd, " ", 3)
        else
        	npcID = nil
        end
        
        if cmd[2] == "exclude" and npcID ~= nil then
            tes3mp.SendMessage(pid, string.format(AntiKill.config.command.excludeMessage, npcID))
            AntiKill.exclude(npcID)
        elseif cmd[2] == "include" and npcID ~= nil then
            tes3mp.SendMessage(pid, string.format(AntiKill.config.command.includeMessage, npcID))
            AntiKill.include(npcID)
        elseif cmd[2] == "save" then
            AntiKill.saveCfg()
            tes3mp.SendMessage(pid, AntiKill.config.command.saveMessage)
       	elseif cmd[2] == "list" then
       		local list = AntiKill.config.command.listMessage
       		for k, v in pairs(AntiKill.config.immortalNPCs) do
       			list = list .. '"' .. k .. '" '
       		end
       		list = list .. '\n'
       		tes3mp.SendMessage(pid, list)
        else
            tes3mp.SendMessage(pid, "#6699FF[i] #FFFFFFUsage: /antikill <exclude/include/save/list> [NPC ID]\n")
        end
    else
        tes3mp.SendMessage(pid, AntiKill.config.command.rankError)
    end
end
customCommandHooks.registerCommand("antikill", AntiKill.Command)

return AntiKill
