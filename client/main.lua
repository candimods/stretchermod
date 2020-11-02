local labels = {
  { "MENU_AMBO_HELP", "Press ~INPUT_CONTEXT~ to open/close back doors.~n~Press ~INPUT_HUD_SPECIAL~ to extend power-load.~n~Press ~INPUT_FRONTEND_SELECT~ open/close compartments.~n~Press ~INPUT_SKIP_CUTSCENE~ to toggle scene lights." },
  { "MENU_AMBO_HELP2", "Press ~INPUT_CONTEXT~ to open/close back doors.~n~Press ~INPUT_DETONATE~ to take stretcher.~n~Press ~INPUT_HUD_SPECIAL~ to extend power-load.~n~Press ~INPUT_FRONTEND_SELECT~ open/close compartments.~n~Press ~INPUT_SKIP_CUTSCENE~ to toggle scene lights." },
  { "MENU_AMBO_HELP3", "Press ~INPUT_CONTEXT~ to open/close back doors.~n~Press ~INPUT_DETONATE~ to stow stretcher.~n~Press ~INPUT_HUD_SPECIAL~ to extend power-load.~n~Press ~INPUT_SKIP_CUTSCENE~ to toggle scene lights." }
}

prop_amb = false
veh_detect = 0
local ped, pedCoords = PlayerPedId(), GetEntityCoords(PlayerPedId())
local ESX = nil
Citizen.CreateThread(function()
  while ESX == nil do
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    Citizen.Wait(1000)
  end
end)

Citizen.CreateThread(function()
  while true do
    ped = PlayerPedId()
    pedCoords = GetEntityCoords(ped)
    Citizen.Wait(500)
  end
end)

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(10)
    if IsControlJustReleased(0, Config.Press.open_spawner) then
      OpenSpawner()
    end
  end
end)

RegisterNetEvent('stretchermod:SpawnItem')
AddEventHandler('stretchermod:SpawnItem', function(key)
  local v = Config.ItemsVeh[key]
  if v ~= nil then
    local dimension = GetModelDimensions(v.hash, vector3(0,0,0), vector3(5.0,5.0,5.0))
    local pos = pedCoords - GetEntityForwardVector(ped) * dimension.x * 1.5
    local head = GetEntityHeading(ped) + 90.0
    if v.type == 'veh' then
      ESX.Game.SpawnVehicle(v.hash, pos, head)
    elseif v.type == 'prop' then
      pos = pos + vector3(0.0,0.0,-1.0)
      ESX.Game.SpawnObject(v.hash, pos)
    end
  end
end)


local propCoords, propForward, litCoords, sitCoords, pickupCoords, pickupCoords2
local closestObject, Lit = nil, nil
Citizen.CreateThread(function()

  for i = 1, #labels do
    AddTextEntry(labels[i][1], labels[i][2])
  end


  local sleep = 2000
  while true do
    sleep = 2000
    closestObject, Lit = nil, nil
    for k,v in pairs(Config.Lits) do
      closestObject = GetClosestVehicle(pedCoords, 3.0, v.lit, 70)
      if DoesEntityExist(closestObject) then
        Lit = v
        break
      end
    end

    if DoesEntityExist(closestObject) then
      sleep = 5
      propCoords = GetEntityCoords(closestObject)
      propForward = GetEntityForwardVector(closestObject)
      litCoords = (propCoords + propForward)
      sitCoords = (propCoords + propForward * 0.1)
      pickupCoords = (propCoords + propForward * 1.2)
      pickupCoords2 = (propCoords + propForward * - 1.2)

      if not IsEntityAttachedToEntity(closestObject, ped) and not IsEntityPlayingAnim(ped, 'anim@heists@box_carry@', 'idle', 3)
      and (Vdist(pedCoords.x, pedCoords.y, pedCoords.z, pickupCoords.x,  pickupCoords.y,  pickupCoords.z)  <= 1.5)
      or (Vdist(pedCoords.x, pedCoords.y, pedCoords.z, pickupCoords2.x, pickupCoords2.y, pickupCoords2.z) <= 1.5 and prop_amb) then
        hintToDisplay(Config.Language.take_bed)
        -- DrawText3D(0,0,0, Config.language.take_bed, -- waaaaaaa)
        if IsControlJustPressed(0, Config.Press.take_bed) then
          SetVehicleExtra(closestObject, 1, 0)
          SetVehicleExtra(closestObject, 2, 1)
          prendre(closestObject)
        end
      elseif Vdist(pedCoords.x, pedCoords.y, pedCoords.z, litCoords.x, litCoords.y, litCoords.z) <= 5.0 then
        if Vdist(pedCoords.x, pedCoords.y, pedCoords.z, sitCoords.x, sitCoords.y, sitCoords.z) <= 2.0 and not IsEntityPlayingAnim(ped, 'anim@heists@box_carry@', 'idle', 3) then
          hintToDisplay(Config.Language.do_action)
          if IsControlJustPressed(0, Config.Press.do_action) then
            OpenMenu()
          end
        end
      end
    end
    Citizen.Wait(sleep)
  end
end)

Citizen.CreateThread(function()
  prop_exist = 0
  local sleep = 2000
  while true do
    sleep = 2000
    for _,g in pairs(Config.Hash) do
      local _closestObject = GetClosestVehicle(pedCoords, 7.0, g.hash, 18)
      if _closestObject ~= 0 then
        veh_detect = _closestObject
        veh_detection = g.detection
        prop_depth = g.depth
        prop_height = g.height
      end
    end
    if not prop_amb and GetVehiclePedIsIn(ped) == 0 and DoesEntityExist(veh_detect) then
      sleep = 5
      local veh_coords  = GetEntityCoords(veh_detect)
      local veh_forward = GetEntityForwardVector(veh_detect)
      local coords       = veh_coords + veh_forward * - veh_detection
      local coords_spawn = veh_coords + veh_forward * - (veh_detection + 4.0)
      if Vdist(pedCoords.x, pedCoords.y, pedCoords.z, coords.x, coords.y, coords.z) <= 5.0 then
        if not IsEntityPlayingAnim(ped, 'anim@heists@box_carry@', 'idle', 3) and not IsEntityAttachedToAnyVehicle(ped) then
          BeginTextCommandDisplayHelp(labels[1][1])
          EndTextCommandDisplayHelp(0, 0, 1, -1)
          local prop
          for k,v in pairs(Config.Lits) do
            prop = GetClosestVehicle(pedCoords, 4.0, v.lit)
            if prop ~= 0 then
              prop_exist = prop
            end
          end
          if IsEntityAttachedToEntity(prop_exist, ped) ~= 0 or prop_exist ~= 0 then
            if IsControlJustPressed(0, Config.Press.out_vehicle_bed) then
              if IsVehicleDoorFullyOpen(veh_detect, 5) then
                SetVehicleDoorShut(veh_detect, 5, false)
              else
                SetVehicleDoorOpen(veh_detect, 5, false)
              end
            end
            if IsControlJustPressed(0, Config.Press.extend_powerload) then
              if IsVehicleDoorFullyOpen(veh_detect, 4) then
                SetVehicleDoorShut(veh_detect, 4, false)
              else
                SetVehicleDoorOpen(veh_detect, 4, false)
              end
            end
            if IsControlJustPressed(0, Config.Press.lights) then
              if IsVehicleExtraTurnedOn(veh_detect, 11) then
                SetVehicleExtra(veh_detect, 11, 0)
                SetVehicleExtra(veh_detect, 12, 0)
              else
                SetVehicleExtra(veh_detect, 11, 1)
                SetVehicleExtra(veh_detect, 12, 1)
              end
            end
            if IsControlJustPressed(0, Config.Press.extra_1) then
              if IsVehicleExtraTurnedOn(veh_detect, 10) then
                SetVehicleExtra(veh_detect, 10, 1)
                SetVehicleExtra(veh_detect, 9, 0)
                SetVehicleExtra(veh_detect, 11, 0)
                SetVehicleExtra(veh_detect, 12, 0)
                SetVehicleExtra(veh_detect, 8, 0)
              else
                SetVehicleExtra(veh_detect, 10, 0)
                SetVehicleExtra(veh_detect, 9, 1)
                SetVehicleExtra(veh_detect, 11, 1)
                SetVehicleExtra(veh_detect, 12, 1)
                SetVehicleExtra(veh_detect, 8, 1)
              end
            end
          end
        end
      end
    end
    Citizen.Wait(sleep)
  end
end)

function prendre(propObject, hash)
  NetworkRequestControlOfEntity(propObject)

  LoadAnim("anim@heists@box_carry@")

  AttachEntityToEntity(propObject, ped, ped, -0.05, 1.3, -0.4 , 180.0, 180.0, 180.0, 0.0, false, false, false, false, 2, true)

  while IsEntityAttachedToEntity(propObject, ped) do

    Citizen.Wait(5)

    if not IsEntityPlayingAnim(ped, 'anim@heists@box_carry@', 'idle', 3) then
      TaskPlayAnim(ped, 'anim@heists@box_carry@', 'idle', 8.0, 8.0, -1, 50, 0, false, false, false)
    end

    if IsPedDeadOrDying(ped) then
      ClearPedTasksImmediately(ped)
      SetVehicleExtra(propObject, 1, 1)
      SetVehicleExtra(propObject, 2, 0)
      DetachEntity(propObject, true, true)
      SetVehicleOnGroundProperly(propObject)
    end
    local veh_coords = GetEntityCoords(veh_detect)
    if Vdist(pedCoords.x, pedCoords.y, pedCoords.z, veh_coords.x, veh_coords.y, veh_coords.z) <= 9.0 then
      BeginTextCommandDisplayHelp(labels[3][1])
      EndTextCommandDisplayHelp(0, 0, 1, -1)
      if IsControlJustPressed(0, Config.Press.take_stow_stretcher) then
        ClearPedTasksImmediately(ped)
        SetVehicleExtra(propObject, 1, 1)
        SetVehicleExtra(propObject, 2, 0)
        DetachEntity(propObject, true, true)
        prop_amb = true
        in_ambulance(propObject, veh_detect, prop_depth, prop_height)
      end
      if IsControlJustPressed(0, Config.Press.open_close_doors) then
        if IsVehicleDoorFullyOpen(veh_detect, 5) then
          SetVehicleDoorShut(veh_detect, 5, false)
        else
          SetVehicleDoorOpen(veh_detect, 5, false)
        end
      end
      if IsControlJustPressed(0, Config.Press.extend_powerload) then
        if IsVehicleDoorFullyOpen(veh_detect, 4) then
          SetVehicleDoorShut(veh_detect, 4, false)
        else
          SetVehicleDoorOpen(veh_detect, 4, false)
        end
      end
    else
      hintToDisplay(Config.Language.release_bed)
    end

    if IsControlJustPressed(0, Config.Press.release_bed) then
      ClearPedTasksImmediately(ped)
      SetVehicleExtra(propObject, 1, 1)
      SetVehicleExtra(propObject, 2, 0)
      DetachEntity(propObject, true, false)
      SetVehicleOnGroundProperly(propObject)
    end

  end
end

function in_ambulance(propObject, amb, depth, height)
  veh_detect = 0
  NetworkRequestControlOfEntity(amb)

  AttachEntityToEntity(propObject, amb, GetEntityBoneIndexByName(amb, "bonnet"), 0.0, depth, height, 0.0, 0.0, 0.0, 0.0, false, false, true, false, 2, true)

  while IsEntityAttachedToEntity(propObject, amb) do
    Citizen.Wait(5)

    if GetVehiclePedIsIn(ped) == 0 then
      local veh_coords2 = GetEntityCoords(amb)
      if Vdist(pedCoords.x, pedCoords.y, pedCoords.z, veh_coords2.x, veh_coords2.y, veh_coords2.z) <= 7.0 then
        BeginTextCommandDisplayHelp(labels[2][1])
        EndTextCommandDisplayHelp(0, 0, 1, -1)
        if IsControlJustPressed(0, Config.Press.take_stow_stretcher) then
          DetachEntity(propObject, true, true)
          prop_amb = false
          SetEntityHeading(ped, GetEntityHeading(ped) - 180.0)
          SetVehicleExtra(propObject, 1, 0)
          SetVehicleExtra(propObject, 2, 1)
          prendre(propObject)
        end
        if IsControlJustPressed(0, Config.Press.out_vehicle_bed) then
          if IsVehicleDoorFullyOpen(amb, 5) then
            SetVehicleDoorShut(amb, 5, false)
          else
            SetVehicleDoorOpen(amb, 5, false)
          end
        end
        if IsControlJustPressed(0, Config.Press.extend_powerload) then
          if IsVehicleDoorFullyOpen(amb, 4) then
            SetVehicleDoorShut(amb, 4, false)
          else
            SetVehicleDoorOpen(amb, 4, false)
          end
        end

        if IsControlJustPressed(0, Config.Press.lights) then
          if IsVehicleExtraTurnedOn(veh_detect, 11) then
            SetVehicleExtra(veh_detect, 11, 1)
            SetVehicleExtra(veh_detect, 12, 1)
            SetVehicleExtra(veh_detect, 8, 1)
          else
            SetVehicleExtra(veh_detect, 11, 0)
            SetVehicleExtra(veh_detect, 12, 0)
            SetVehicleExtra(veh_detect, 8, 0)
          end
        end

        if IsControlJustPressed(0, Config.Press.extra_1) then
          if IsVehicleExtraTurnedOn(veh_detect, 10) then
            SetVehicleExtra(veh_detect, 10, 1)
            SetVehicleExtra(veh_detect, 9, 0)
            SetVehicleExtra(veh_detect, 11, 0)
            SetVehicleExtra(veh_detect, 12, 0)
            SetVehicleExtra(veh_detect, 8, 0)
          else
            SetVehicleExtra(veh_detect, 10, 0)
            SetVehicleExtra(veh_detect, 9, 1)
            SetVehicleExtra(veh_detect, 11, 1)
            SetVehicleExtra(veh_detect, 12, 1)
            SetVehicleExtra(veh_detect, 8, 1)
          end
        end
      end
    end
  end
end

function LoadAnim(dict)
  while not HasAnimDictLoaded(dict) do
    RequestAnimDict(dict)
    Citizen.Wait(1)
  end
end

function hintToDisplay(text)
  BeginTextCommandDisplayHelp("STRING")
  AddTextComponentString(text)
  DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

function DrawText3D(coords, text, size)

  local onScreen,_x,_y=World3dToScreen2d(coords.x,coords.y,coords.z + 1.0)
  local px,py,pz=table.unpack(GetGameplayCamCoords())

  SetTextScale(0.35, 0.35)
  SetTextFont(4)
  SetTextProportional(1)
  SetTextColour(255, 255, 255, 215)
  SetTextEntry("STRING")
  SetTextCentre(1)
  AddTextComponentString(text)
  DrawText(_x,_y)
  local factor = (string.len(text)) / 370
  DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 41, 11, 41, 68)
end

function OpenSpawner()
  local elements = {}
  for k,v in pairs(Config.ItemsVeh) do
    local name = GetLabelText(GetDisplayNameFromVehicleModel(v.hash))
    table.insert(elements, {
      label = name ~= 'NULL' and name or v.item,
      key  = k,
    })
  end
  ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'bank_actions', {
    title    = "FiveEMS - CandiMods",
    align    = 'top-left',
    elements = elements
  }, function(data, menu)
    TriggerEvent('stretchermod:SpawnItem', data.current.key)
    menu.close()
  end, function(data, menu)
    menu.close()
  end)
end

function OpenMenu()
  local elements = {
    {label = Config.Language.toggle_iv},
    {label = Config.Language.toggle_lp15},
    {label = Config.Language.toggle_lucas},
    {label = Config.Language.toggle_backboard},
    {label = Config.Language.toggle_scoop},
    {label = Config.Language.toggle_seat},
    {label = Config.Language.go_out_bed},
    {label = Config.Language.fold_bed},
  }
  if Lit ~= nil then
    for k2,v2 in pairs(Lit.anims) do
      table.insert(elements, {
        label = v2.name
      })
    end
  end

  ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'bank_actions', {
    title    = "FiveEMS - CandiMods",
    align    = 'top-left',
    elements = elements
  }, function(data, menu)
    if Lit ~= nil then
      for k2,v2 in pairs(Lit.anims) do
        if data.current.label == v2.name then
          LoadAnim(v2.anim)
          AttachEntityToEntity(ped, closestObject, ped, v2.x, v2.y, v2.z, 0.0, 0.0, v2.r, 0.0, false, false, false, false, 2, true)
          TaskPlayAnim(ped, v2.anim, v2.lib, 8.0, 8.0, -1, 1, 0, false, false, false)
        end
      end
    end

    if data.current.label == Config.Language.toggle_iv then
      toggle = not toggle
      if toggle then
        SetVehicleExtra(closestObject, 5, 0)
      else
        SetVehicleExtra(closestObject, 5, 1)
      end
    end

    if data.current.label == Config.Language.toggle_lp15 then
      toggle = not toggle
      if toggle then
        SetVehicleExtra(closestObject, 3, 1)
      else
        SetVehicleExtra(closestObject, 3, 0)
      end
    end

    if data.current.label == Config.Language.toggle_lucas then
      toggle = not toggle
      if toggle then
        SetVehicleExtra(closestObject, 6, 0)
      else
        SetVehicleExtra(closestObject, 6, 1)
      end
    end

    if data.current.label == Config.Language.toggle_backboard then
      toggle = not toggle
      if toggle then
        SetVehicleExtra(closestObject, 4, 0)
      else
        SetVehicleExtra(closestObject, 4, 1)
      end
    end

    if data.current.label == Config.Language.toggle_scoop then
      toggle = not toggle
      if toggle then
        SetVehicleExtra(closestObject, 7, 0)
      else
        SetVehicleExtra(closestObject, 7, 1)
      end
    end

    if data.current.label == Config.Language.toggle_seat then
      if IsVehicleDoorFullyOpen(closestObject, 4) then
        SetVehicleDoorShut(closestObject, 4, false)
      else
        SetVehicleDoorOpen(closestObject, 4, false)
      end
    end

    if data.current.label == Config.Language.go_out_bed then
      DetachEntity(ped, true, true)
      SetEntityCoords(ped, propCoords + propForward * - Lit.distance_stop)
    end

    if data.current.label == Config.Language.fold_bed then
      local can = false
      local model = GetEntityModel(closestObject)
      for k2,v2 in pairs(Config.ItemsVeh) do
        if model == v2.hash then
          can = k
          break
        end
      end
      if can ~= false then
        ESX.Game.DeleteVehicle(closestObject)
        TriggerServerEvent('stretchermod:DeleteVeh', can)
      end
    end
  end, function(data, menu)
    menu.close()
  end)
end
