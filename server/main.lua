--[[ ===================================================== ]]--
--[[             MH Airdrops Script by MaDHouSe            ]]--
--[[ ===================================================== ]]--

local QBCore = exports['qb-core']:GetCoreObject()
local cooldown = math.random(Config.Cooldown.min, Config.Cooldown.max)

local function SpawnAirdrop()
    if #QBCore.Functions.GetPlayers() >= Config.MinPlayerOnline then
        local randomLocation = math.random(1, #Config.Locations)
        for k, id in pairs(QBCore.Functions.GetPlayers()) do
            local target = QBCore.Functions.GetPlayer(id)
            if not Config.NotAllowedJobs[target.PlayerData.job.name] then 
                TriggerClientEvent('mh-airdrops:client:deleteObj', id)
                TriggerClientEvent('mh-airdrops:client:airdrop', id, randomLocation)
                TriggerClientEvent('mh-airdrops:client:notify', id, Lang:t('notify.airdrop_landed'), "success", 10000)
            end
        end
    else
        TriggerClientEvent('mh-airdrops:client:notify', -1, "There are not enough players online", "error", 5000)
    end
end

local function StartAirdropLoop()
    while true do
        while cooldown > 0 do
            --print(string.format('%s Minuten tot de volgende Airdrop Spawn', cooldown))
            Citizen.Wait(60 * 1000)
            cooldown = cooldown - 1
        end
        cooldown = math.random(Config.Cooldown.min, Config.Cooldown.max)
        if #QBCore.Functions.GetPlayers() >= Config.MinPlayerOnline then
            SpawnAirdrop() 
        end
    end
end

QBCore.Commands.Add("airdrop", "Drop an airdrop", {}, true, function(source)
    SpawnAirdrop()
end, 'admin')

QBCore.Functions.CreateUseableItem(Config.Item1, function(source, item)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    Player.Functions.RemoveItem(Config.Item1, 1, false)
    TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[Config.Item1], 'remove', 1)
    local randomLocation = math.random(1, #Config.Locations)
    TriggerClientEvent('mh-airdrops:client:deleteObj', src)
    TriggerClientEvent('mh-airdrops:client:airdrop', src, randomLocation)
    TriggerClientEvent('mh-airdrops:client:notify', src, Lang:t('notify.airdrop_landed'), "success", 5000)
end)

QBCore.Functions.CreateUseableItem(Config.Item2, function(source, item)
	local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    Player.Functions.RemoveItem(Config.Item2, 1, false)
    TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[Config.Item2], 'remove', 1)
	local randomLocation = math.random(1, #Config.Locations)
    TriggerClientEvent('mh-airdrops:client:deleteObj', src)
    TriggerClientEvent('mh-airdrops:client:airdrop', src, randomLocation)
    TriggerClientEvent('mh-airdrops:client:notify', src, Lang:t('notify.airdrop_landed'), "success", 5000)
end)

AddEventHandler('onResourceStart', function(resourceName)
    if resourceName == GetCurrentResourceName() then
        print(string.format('%s Started Successfully | Server Side', resourceName))
        StartAirdropLoop()
    end
end)

RegisterNetEvent('mh-airdrops:server:getloot', function(ObjNetId)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    TriggerClientEvent('mh-airdrops:client:deleteObj', -1, ObjNetId)
    TriggerClientEvent('mh-airdrops:client:notify', -1, Lang:t('notify.airprop_caught'), "success", 5000)
    
    if Config.UseDailyActivities then TriggerClientEvent('mh-dailyactivities:client:updateTask', src, Config.DailyTaskID) end    
    
    local whatBooty = Config.whatBooty
    if Config.UseItemsDrop then
        whatBooty = 1
    elseif Config.UseRareItemsDrop then
        whatBooty = math.random(1, 2)
    elseif Config.UseAmmoDrop then
        whatBooty = math.random(1, 2)
    elseif Config.UseWeaponDrop then
        whatBooty = math.random(1, 3)
    elseif Config.UseAllDrops then
        whatBooty = math.random(1, 4)
    end

    if whatBooty == 1 then
        local item = Config.Items.basic[math.random(1, #Config.Items.basic)]
        local random = math.random(10, 15)
        Player.Functions.AddItem(item.name, random, false)
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[item.name], 'add', random)

    elseif whatBooty == 2 then
        local item = Config.Items.rare[math.random(1, #Config.Items.rare)]
        for _ = 1, math.random(5, 10), 1 do
            Player.Functions.AddItem(item.name, random, false)
            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[item.name], 'add', random)
        end

    elseif whatBooty == 3 then 
        local ammo = Config.Items['ammo'][math.random(1, #Config.Items['ammo'])]
        Player.Functions.AddItem(ammo.name, ammo.amount, false)
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[ammo.amount], 'add', ammo.amount)

    elseif whatBooty == 4 then  
        local weapon = Config.Items['weapons'][math.random(1, #Config.Items['weapons'])]
        Player.Functions.AddItem(weapon.model, 1, false, nil)
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[weapon.model], 'add', 1)
    end

    if Config.UseJackpotItem then
        local chance = math.random(1, 100)
        if chance < 7 then
            Player.Functions.AddItem(Config.JackpotItem, Config.JackpotAmount, false)
            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[Config.JackpotItem], 'add', Config.JackpotAmount)
        end
    end
end)
