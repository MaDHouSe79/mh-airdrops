--[[ ===================================================== ]] --
--[[             MH Airdrops Script by MaDHouSe            ]] --
--[[ ===================================================== ]] --
local QBCore = exports['qb-core']:GetCoreObject()
local cooldown = math.random(Config.Cooldown.min, Config.Cooldown.max)

local function NotifyPlayers(src)
    for k, id in pairs(QBCore.Functions.GetPlayers()) do
        if id ~= src then
            local target = QBCore.Functions.GetPlayer(id)
            if not Config.NotAllowedJobs[target.PlayerData.job.name] then
                TriggerClientEvent('mh-airdrops:client:notify', id, Lang:t('notify.airprop_caught'), "success", 5000)
            end
        end
    end
end

local function UnlockCrate()
    SetTimeout(Config.UnlockTime * 1000, function()
        TriggerClientEvent('mh-airdrops:client:unlockcrate', -1)
    end)
end

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
            -- print(string.format('%s Minuten tot de volgende Airdrop Spawn', cooldown))
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

QBCore.Functions.CreateUseableItem(Config.Item, function(source, item)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    Player.Functions.RemoveItem(Config.Item, 1, false)
    TriggerClientEvent('qb-inventory:client:ItemBox', src, QBCore.Shared.Items[Config.Item], 'remove', 1)
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

RegisterNetEvent('mh-airdrops:server:unlock', function()
    UnlockCrate()
end)

RegisterNetEvent('mh-airdrops:server:getloot', function(ObjNetId)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    TriggerClientEvent('mh-airdrops:client:deleteObj', -1, ObjNetId)
    NotifyPlayers(src)

    if Config.UseItems then
        local whatBooty = Config.whatBooty
        if Config.UseItemsDrop then whatBooty = 1 end
        if Config.UseRareItemsDrop then whatBooty = math.random(1, 2) end
        if Config.UseAmmoDrop then whatBooty = math.random(1, 2) end
        if Config.UseWeaponDrop then whatBooty = math.random(1, 3) end
        if Config.UseAllDrops then whatBooty = math.random(1, 4) end

        if whatBooty == 1 then
            local item = Config.Items.basic[math.random(1, #Config.Items.basic)]
            if QBCore.Shared.Items[item.name] then
                local random = math.random(10, 15)
                Player.Functions.AddItem(item.name, random, false)
                TriggerClientEvent('qb-inventory:client:ItemBox', src, QBCore.Shared.Items[item.name], 'add', random)
            else
                print(item.name..' does not exsist in qb-core/shared/items.lua file...')
            end
        end

        if whatBooty == 2 then
            local random = math.random(1, #Config.Items.rare)
            local item = Config.Items.rare[random]
            if QBCore.Shared.Items[item.name] then
                for _ = 1, math.random(5, 10), 1 do
                    Player.Functions.AddItem(item.name, random, false)
                    TriggerClientEvent('qb-inventory:client:ItemBox', src, QBCore.Shared.Items[item.name], 'add', random)
                end
            else
                print(item.name..' does not exsist in qb-core/shared/items.lua file...')
            end
        end

        if whatBooty == 3 then
            local ammo = Config.Items['ammo'][math.random(1, #Config.Items['ammo'])]
            Player.Functions.AddItem(ammo.name, ammo.amount, false)
            TriggerClientEvent('qb-inventory:client:ItemBox', src, QBCore.Shared.Items[ammo.amount], 'add', ammo.amount)
        end

        if whatBooty == 4 then
            local weapon = Config.Items['weapons'][math.random(1, #Config.Items['weapons'])]
            Player.Functions.AddItem(weapon.model, 1, false, nil)
            TriggerClientEvent('qb-inventory:client:ItemBox', src, QBCore.Shared.Items[weapon.model], 'add', 1)
        end
    end

    if Config.UseMarkedbills then
        local chance = math.random(1, 100)
        if chance < 25 then
            local amount = math.random(1, 3)
            local info = { worth = math.random(Config.Markedbills.min, Config.Markedbills.max) }
            Player.Functions.AddItem('markedbills', amount, false, info)
            TriggerClientEvent('qb-inventory:client:ItemBox', src, QBCore.Shared.Items['markedbills'], 'add', amount)
        end
    else
        local chance = math.random(1, 100)
        if chance < 25 then
            local amount = math.random(Config.Cash.min, Config.Cash.max)
            Player.Functions.AddMoney(Config.CashItem, amount, nil)
        end
    end

    if Config.UseJackpotItem then
        local chance = math.random(1, 100)
        if chance < 7 then
            Player.Functions.AddItem(Config.JackpotItem, Config.JackpotAmount, false)
            TriggerClientEvent('qb-inventory:client:ItemBox', src, QBCore.Shared.Items[Config.JackpotItem], 'add', Config.JackpotAmount)
        end
    end

end)
