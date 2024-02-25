--[[ ===================================================== ]] --
--[[             MH Airdrops Script by MaDHouSe            ]] --
--[[ ===================================================== ]] --
local QBCore = exports['qb-core']:GetCoreObject()
local PlayerData = {}
local airdrops = {}
local airdropBlips = {}
local dropLocation = nil
local targetBlip = nil
local crate = nil
local particle = nil
local enable = false
local isLoggedIn = false

local function deletedrops()
    for k, drop in pairs(airdrops) do
        if DoesEntityExist(drop) then
            DeleteObject(drop)
        end
    end
    airdrops = {}
    if DoesEntityExist(crate) then
        DeleteObject(crate)
        crate = nil
    end
end

local function deleteBlips()
    for k, blip in pairs(airdropBlips) do
        if DoesBlipExist(blip) then
            RemoveBlip(blip)
        end
    end
    airdropBlips = {}
end

local function Notify(message, type, time)
    if Config.Notify == "okokNotify" then
        exports['okokNotify']:Alert(Config.NotifyTitle, message, time, type)
    elseif Config.Notify == "qb-core" then
        if type == "info" then type = "primary" end
        QBCore.Functions.Notify({text = Config.NotifyTitle, caption = message }, type, time)
    elseif Config.Notify == "roda-notify" then
        exports['Roda_Notifications']:showNotify(Config.NotifyTitle, message, type, time)
    else
        print("mh-parking: Your type of notify choice is not supported")
    end
end

local function AddObjBlip(coords)
    if not Config.NotAllowedJobs[PlayerData.job.name] then
        local transG = 250
        local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
        local blip2 = AddBlipForCoord(coords.x, coords.y, coords.z)
        SetBlipRoute(blip, false)
        BeginTextCommandSetBlipName("STRING")
        SetBlipSprite(blip, 550)
        SetBlipSprite(blip2, 161)
        SetBlipColour(blip, 46)
        SetBlipColour(blip2, 46)
        SetBlipDisplay(blip, 4)
        SetBlipDisplay(blip2, 8)
        SetBlipAlpha(blip, transG)
        SetBlipAlpha(blip2, transG)
        SetBlipScale(blip, 0.8)
        SetBlipScale(blip2, 2.0)
        SetBlipAsShortRange(blip, false)
        SetBlipAsShortRange(blip2, false)
        PulseBlip(blip2)
        AddTextComponentString('Airdrop')
        EndTextCommandSetBlipName(blip)
        airdropBlips[#airdropBlips + 1] = blip
        airdropBlips[#airdropBlips + 1] = blip2
    end
end

local function LootCrate(entity)
    TriggerServerEvent("mh-airdrops:server:getloot", NetworkGetNetworkIdFromEntity(entity))
    if DoesEntityExist(entity) then
        DeleteObject(entity)
        deletedrops()
    end
end

local function spawnAirdrop(coords)
    if Config.NotAllowedJobs[PlayerData.job.name] and PlayerData.job.onduty then
    else
        deletedrops()
        local model = GetHashKey(Config.Object)
        RequestModel(model)
        while not HasModelLoaded(model) do Citizen.Wait(10) end
        crate = CreateObject(model, coords.x, coords.y, coords.z - 1, true, true, false)
        AddObjBlip(coords)
        dropLocation = vector3(coords.x, coords.y, coords.z)
        SetEntityLodDist(crate, 1000)
        FreezeEntityPosition(crate, true)
        exports['qb-target']:AddTargetEntity(crate, {
            options = {{
                type = "client",
                icon = 'fas fa-caret-right',
                label = Lang:t('target.label'),
                targeticon = 'fas fa-book-reader',
                action = function(entity)
                    if IsPedAPlayer(entity) then return false end
                    if Config.NotAllowedJobs[PlayerData.job.name] and PlayerData.job.onduty then return false end
                    LootCrate(entity)
                end,
                canInteract = function(entity, distance, data)
                    if IsPedAPlayer(entity) then return false end
                    if Config.NotAllowedJobs[PlayerData.job.name] and PlayerData.job.onduty then return false end
                    return true
                end
            }},
            distance = 2.5
        })
        airdrops[#airdrops + 1] = ObjToNet(crate)
    end
end

local function DrawText3D(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local px, py, pz = table.unpack(GetGameplayCamCoords())
    SetTextScale(0.28, 0.28)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 245)
    SetTextOutline(true)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x, _y)
end

RegisterNetEvent('mh-airdrops:client:AddTargetBlip', function(targetID)
    targetBlip = AddBlipForEntity(targetID)
end)

RegisterNetEvent('mh-airdrops:client:RemoveTargetBlip', function(objNetId)
    RemoveBlip(targetBlip)
end)

RegisterNetEvent('mh-airdrops:client:spawnVehicle', function(vehicle)
    print(vehicle)
end)

RegisterNetEvent('mh-airdrops:client:deleteObj', function(objNetId)
    dropLocation = nil
    deletedrops()
    deleteBlips()
end)

RegisterNetEvent('mh-airdrops:client:airdrop', function(random)
    spawnAirdrop(Config.Locations[random])
end)

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    PlayerData = QBCore.Functions.GetPlayerData()
    isLoggedIn = true
end)

RegisterNetEvent('QBCore:Player:SetPlayerData', function(data)
    PlayerData = data
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate', function(job)
    PlayerData.job = job
end)

AddEventHandler('onResourceStart', function(resourceName)
    if resourceName == GetCurrentResourceName() then
        PlayerData = QBCore.Functions.GetPlayerData()
        isLoggedIn = true
    end
end)

RegisterNetEvent("mh-airdrops:client:notify", function(message, type, time)
    Notify(message, type, time)
end)

Citizen.CreateThread(function()
    while true do
        local sleep = 1000
        if dropLocation ~= nil then
            local pos = GetEntityCoords(PlayerPedId())
            if #(dropLocation - pos) < 5 then
                if Config.NotAllowedJobs[PlayerData.job.name] and PlayerData.job.onduty then
                else
                    if #(dropLocation - pos) < 2 then text = Lang:t('info.drawtext') end
                    sleep = 1
                    DrawText3D(dropLocation.x, dropLocation.y, dropLocation.z + 1, text)
                end
            end
        end
        Citizen.Wait(sleep)
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        if isLoggedIn then
            if Config.NotAllowedJobs[PlayerData.job.name] and PlayerData.job.onduty then
            else
                if dropLocation ~= nil and crate ~= nil then
                    local playerPed = PlayerPedId()
                    local playerCoords = GetEntityCoords(playerPed)
                    local distance = GetDistanceBetweenCoords(playerCoords, dropLocation.x, dropLocation.y, dropLocation.z, true)
                    if distance < 200.0 then
                        if not enable then
                            RequestNamedPtfxAsset('core')
                            while not HasNamedPtfxAssetLoaded('core') do Citizen.Wait(1) end
                            UseParticleFxAssetNextCall('core')
                            local scale = 0.5
                            local cratePosition = GetEntityCoords(crate)
                            particle = StartParticleFxLoopedAtCoord('exp_grd_flare', dropLocation.x, dropLocation.y, dropLocation.z - 1.5, 0.0, 0.0, 0.0, scale, false, false, false, 0)
                            enable = true
                        end
                    else
                        if enable then
                            StopParticleFxLooped(particle, false)
                            particle = nil
                            enable = false
                        end
                    end
                end
                if dropLocation == nil then
                    StopParticleFxLooped(particle, false)
                    particle = nil
                    enable = false
                end
            end
        end
        Citizen.Wait(500)
    end
end)
