FM.utils = {}

---@param src number
---@param message string
---@param type? 'success'|'error'
function FM.utils.notify(src, message, type)
    if not src then return end
    if not message then return end

    if ESX then TriggerClientEvent('esx:showNotification', src, message, type)
    elseif QB then TriggerClientEvent('QBCore:Notify', src, message, type) end
end

---@param filter? { job: string }
function FM.utils.getPlayers(filter)
    local playerSources = GetPlayers()

    local players = {}
    for _, src in pairs(playerSources) do
        local p = FM.player.get(tonumber(src))

        if not filter then
            players[src] = p
        else
            if filter.job then
                if p.getJob().name == filter.job then
                    players[src] = p
                end
            end
        end
    end
    
    return players
end