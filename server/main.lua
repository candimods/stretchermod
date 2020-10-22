ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

for k,v in pairs(Config.ItemsVeh) do
  ESX.RegisterUsableItem(v.item, function(source)
    if v.remove ~= nil and v.remove > 0 then
      local xPlayer = ESX.GetPlayerFromId(source)
      xPlayer.removeInventoryItem(v.item, v.remove)
    end
    TriggerClientEvent('stretchermod:SpawnItem', source, k)
  end)
end

RegisterServerEvent('stretchermod:DeleteVeh')
AddEventHandler('stretchermod:DeleteVeh', function(key)
  local xPlayer = ESX.GetPlayerFromId(source)
  local v = Config.ItemsVeh[tonumber(key)]
  if v ~= nil and v.remove ~= nil and v.remove > 0 then
    xPlayer.addInventoryItem(v.item, v.remove)
  end
end)
