--[[ ===================================================== ]]--
--[[             MH Airdrops Script by MaDHouSe            ]]--
--[[ ===================================================== ]]--

fx_version 'cerulean'
game 'gta5'

description 'MH Airdrops'
version '1.0'

shared_scripts {
    '@qb-core/shared/locale.lua',
    'locales/en.lua',
    'config.lua'
}

client_scripts {
    'client/main.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/main.lua',
    'server/update.lua',
}

lua54 'yes'
