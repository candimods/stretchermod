ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

for k,v in pairs(Config.ItemsVeh) do
  ESX.RegisterUsableItem(v.item, function(source)
    if v.remove ~= nil and v.remove > 0 then
      local xPlayer = ESX.GetPlayerFromId(source)
      xPlayer.removeInventoryItem(v.item, v.remove)
    end
    TriggerClientEvent('stretchermod:SpawnVeh', source, v.hash)
  end)
end
