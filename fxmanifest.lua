fx_version 'adamant'
game 'gta5'

description 'SAFD Pack by CandiMods Dev Team discord.io/candimods' 

files {
	'data/vehicles.meta',
}

data_file 'VEHICLE_METADATA_FILE' 'data/vehicles.meta'

client_scripts {
	'warmenu.lua',
	'config.lua',
 	'client/main.lua'
}

server_scripts {
  'config.lua',
  'server/main.lua',
}
