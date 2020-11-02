fx_version 'adamant'
game 'gta5'

description 'by CandiMods Dev Team discord.io/candimods'

files {
	-- 'data/vehicles.meta',


	'ui/html/ui.html',
	'ui/html/css/app.css',
  'ui/html/js/mustache.min.js',
	'ui/html/js/app.js',
	'ui/html/js/wrapper.js',
	'ui/html/fonts/pdown.ttf',
	'ui/html/fonts/bankgothic.ttf'
}

-- data_file 'VEHICLE_METADATA_FILE' 'data/vehicles.meta'

client_scripts {
	'config.lua',
 	'client/main.lua',
  'ui/client/es_extended.lua', -- ui
  'ui/client/main.lua', -- ui
}

ui_page {
	'ui/html/ui.html'
}

server_scripts {
  'config.lua',
  'server/main.lua',
}
