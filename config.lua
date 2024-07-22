--[[ ===================================================== ]]--
--[[             MH Airdrops Script by MaDHouSe            ]]--
--[[ ===================================================== ]]--

Config = {}

Config.MinPlayerOnline = 1 -- the total players online must be above this value before this works.

Config.Notify = "qb-core" -- Default:(qb-core), you can also use (roda-notify/okokNotify)
Config.NotifyTitle = "Airdrops"

Config.Show3DText = true

-- you can only use this if you have (mh-dailyactivities)
Config.UseDailyActivities = true -- only true if you have mh-dailyactivities..
Config.DailyTaskID = 11 -- the `Config.Tasks` from mh-dailyactivities, its the id of the task..

Config.Timer = 60
Config.Cooldown = { min = 30, max = 60 }

Config.Item1 = "airdrop"
Config.Item2 = "airdrop2"

Config.Object = 'prop_drop_armscrate_01'

Config.UseItemsDrop = true
Config.UseRareItemsDrop = false
Config.UseAmmoDrop = false
Config.UseWeaponDrop = false
Config.UseAllDrops = false

Config.whatBooty = 1 -- default 0 (1 is Items 2 is Weapons 3 is ammo, only if you set something above to false)

Config.UseJackpotItem = false
Config.JackpotItem = "coke_brick"
Config.JackpotAmount = math.random(1, 2)

Config.NotAllowedJobs = {
    ["police"] = true,
    ["ambulance"] = true,
    ["mechanic"] = true,
}

-- Locations of where the Airdrops can spawn
Config.Locations = {
    vector3(-447.6982, -2428.0305, 6.0008),
    vector3(-1268.0905, -1915.7034, 5.8616),
    vector3(-1822.5951, -1250.9445, 13.0170),
    vector3(-1615.4368, 191.9840, 60.1503),
    vector3(-930.8085, 392.2703, 82.0327),
    vector3(-351.1358, -163.9146, 49.4998),
    vector3(652.4914, -1094.1017, 25.1683),
    vector3(420.1149, -1333.2314, 46.0538),
    vector3(184.5215, -244.0069, 65.3608),
    vector3(-318.9633, -732.3179, 54.8481),
    vector3(-158.9969, -1075.6898, 42.1392),
    vector3(3.8278, -1105.9996, 38.1562),
    vector3(133.7557, -1316.1652, 29.2030),
    vector3(-24.9402, -1435.8015, 30.6531),
    vector3(-234.9733, -1372.1353, 31.2582),
    vector3(-586.9671, -1634.8248, 19.9258),
    vector3(-812.5975, -1406.8369, 5.0005),
    vector3(-890.6445, -1301.0828, 16.9000),
    vector3(166.8703, -1097.8448, 49.1379),
    vector3(184.9096, -1072.2261, 77.5442),
    vector3(502.4966, -1341.7902, 35.5367),
    vector3(304.2462, -1284.0754, 42.6847),
    vector3(102.0212, -1310.4489, 41.2670),
    vector3(195.1507, -933.7363, 30.6868),
    vector3(161.1503, -1265.7555, 36.3699),
    vector3(-70.3203, -1387.1544, 35.4036),
    vector3(424.6376, -972.8955, 30.7102), -- police pd 1
    vector3(-163.9743, -1126.2053, 68.7087), -- kraan 1
    vector3(-109.3340, -1052.8481, 73.3059), -- kraan 2
    vector3(-409.1090, -1070.3275, 69.2502), -- kraan 3
    vector3(-434.9826, -1008.2653, 69.3494), -- kraan 4
    vector3(-171.7327, -1003.7975, 296.1560), -- kraan 5
    vector3(-102.4416, -967.3010, 296.2135),
}

-- Placeholder (Don't change this)
Config.Items = {  
    ['basic'] = {
        [1] = {name = "iphone"},
        [2] = {name = "samsungphone"},
        [3] = {name = "diamond_ring"},
        [4] = {name = "acetone"},
        [5] = {name = "lithium"},
        [6] = {name = "rubber"},
        [7] = {name = "plastic"},
        [8] = {name = "copper"},
        [9] = {name = "steel"},
        [10] = {name = "iron"},
        [11] = {name = "aluminum"},
        [12] = {name = "metalscrap"},
    },
    ['rare'] = {
        [1] = {name = "meth"},
        [2] = {name = "coke_brick"},
    },
    ['weapons'] = {
        ['pistol'] = {
            ['name'] = "pistol",
            ['model'] = "weapon_pistol",
        }
    },
    ['ammo'] = {
        ['pistol'] = {
            ['name'] = "pistol_ammo",
            ['amount'] = 1,
        },
    },
}
