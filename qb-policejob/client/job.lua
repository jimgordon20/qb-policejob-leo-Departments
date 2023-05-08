-- Variables
local currentGarage = 0
local inFingerprint = false
local FingerPrintSessionId = nil
local inStash = false
local inTrash = false
local inArmoury = false
local inHelicopter = false
local inImpound = false
local inGarage = false
local pedstable = {}

AddEventHandler('onResourceStop', function (resource)
    if resource == GetCurrentResourceName() then
        for k,v in pairs(pedstable) do 
            DeletePed(v)
        end
    end
end)

local function loadAnimDict(dict) -- interactions, job,
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Wait(10)
    end
end

local function GetClosestPlayer() -- interactions, job, tracker
    local closestPlayers = QBCore.Functions.GetPlayersFromCoords()
    local closestDistance = -1
    local closestPlayer = -1
    local coords = GetEntityCoords(PlayerPedId())

    for i = 1, #closestPlayers, 1 do
        if closestPlayers[i] ~= PlayerId() then
            local pos = GetEntityCoords(GetPlayerPed(closestPlayers[i]))
            local distance = #(pos - coords)

            if closestDistance == -1 or closestDistance > distance then
                closestPlayer = closestPlayers[i]
                closestDistance = distance
            end
        end
    end

    return closestPlayer, closestDistance
end

local function openFingerprintUI()
    SendNUIMessage({
        type = "fingerprintOpen"
    })
    inFingerprint = true
    SetNuiFocus(true, true)
end

local function SetCarItemsInfo()
	local items = {}
	for _, item in pairs(Config.CarItems) do
		local itemInfo = QBCore.Shared.Items[item.name:lower()]
		items[item.slot] = {
			name = itemInfo["name"],
			amount = tonumber(item.amount),
			info = item.info,
			label = itemInfo["label"],
			description = itemInfo["description"] and itemInfo["description"] or "",
			weight = itemInfo["weight"],
			type = itemInfo["type"],
			unique = itemInfo["unique"],
			useable = itemInfo["useable"],
			image = itemInfo["image"],
			slot = item.slot,
		}
	end
	Config.CarItems = items
end

local function doCarDamage(currentVehicle, veh)
	local smash = false
	local damageOutside = false
	local damageOutside2 = false
	local engine = veh.engine + 0.0
	local body = veh.body + 0.0

	if engine < 200.0 then engine = 200.0 end
    if engine  > 1000.0 then engine = 950.0 end
	if body < 150.0 then body = 150.0 end
	if body < 950.0 then smash = true end
	if body < 920.0 then damageOutside = true end
	if body < 920.0 then damageOutside2 = true end

    Wait(100)
    SetVehicleEngineHealth(currentVehicle, engine)

	if smash then
		SmashVehicleWindow(currentVehicle, 0)
		SmashVehicleWindow(currentVehicle, 1)
		SmashVehicleWindow(currentVehicle, 2)
		SmashVehicleWindow(currentVehicle, 3)
		SmashVehicleWindow(currentVehicle, 4)
	end

	if damageOutside then
		SetVehicleDoorBroken(currentVehicle, 1, true)
		SetVehicleDoorBroken(currentVehicle, 6, true)
		SetVehicleDoorBroken(currentVehicle, 4, true)
	end

	if damageOutside2 then
		SetVehicleTyreBurst(currentVehicle, 1, false, 990.0)
		SetVehicleTyreBurst(currentVehicle, 2, false, 990.0)
		SetVehicleTyreBurst(currentVehicle, 3, false, 990.0)
		SetVehicleTyreBurst(currentVehicle, 4, false, 990.0)
	end

	if body < 1000 then
		SetVehicleBodyHealth(currentVehicle, 985.1)
	end
end

RegisterNetEvent('police:client:TakeOutImpound', function(data)
    local coords = Config.Locations["impound"][data.location]["vehiclespawn"]
    QBCore.Functions.SpawnVehicle(data.vehicle, function(veh)
        QBCore.Functions.TriggerCallback('qb-garage:server:GetVehicleProperties', function(properties)
            QBCore.Functions.SetVehicleProperties(veh, properties)
            SetVehicleNumberPlateText(veh, data.plate)
            SetVehicleDirtLevel(veh, 0.0)
            SetEntityHeading(veh, coords.w)
            exports[Config.FuelScript]:SetFuel(data.vehicle, data.fuel)
            --doCarDamage(veh, data.engine) TODO
            TriggerServerEvent('police:server:TakeOutImpound', data.plate, data.location)
            --closeMenuFull()
            --TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)
            TriggerEvent("vehiclekeys:client:SetOwner", QBCore.Functions.GetPlate(veh))
            SetVehicleEngineOn(veh, true, true)
        end, data.plate)
    end, coords, true)
end)


local function IsArmoryWhitelist() -- being removed
    local retval = false

    if QBCore.Functions.GetPlayerData().job.type == 'leo' then
        retval = true
    end
    return retval
end

local function SetWeaponSeries()
    for k, v in pairs(Config.Items.items) do
        if QBCore.Shared.Items[v.name].type == 'weapon' then
            Config.Items.items[k].info.serie = 'pd-issue_'..tostring(QBCore.Shared.RandomInt(2) .. QBCore.Shared.RandomStr(3) .. QBCore.Shared.RandomInt(1) .. QBCore.Shared.RandomStr(2) .. QBCore.Shared.RandomInt(3) .. QBCore.Shared.RandomStr(4))
        end
    end
end

function closeMenuFull()
    exports['qb-menu']:closeMenu()
end

--NUI Callbacks
RegisterNUICallback('closeFingerprint', function(_, cb)
    SetNuiFocus(false, false)
    inFingerprint = false
    cb('ok')
end)

--Events
RegisterNetEvent('police:client:showFingerprint', function(playerId)
    openFingerprintUI()
    FingerPrintSessionId = playerId
end)

RegisterNetEvent('police:client:showFingerprintId', function(fid)
    SendNUIMessage({
        type = "updateFingerprintId",
        fingerprintId = fid
    })
    PlaySound(-1, "Event_Start_Text", "GTAO_FM_Events_Soundset", 0, 0, 1)
end)

RegisterNUICallback('doFingerScan', function(_, cb)
    TriggerServerEvent('police:server:showFingerprintId', FingerPrintSessionId)
    cb("ok")
end)

RegisterNetEvent('police:client:SendEmergencyMessage', function(coords, message)
    TriggerServerEvent("police:server:SendEmergencyMessage", coords, message)
    TriggerEvent("police:client:CallAnim")
end)

RegisterNetEvent('police:client:EmergencySound', function()
    PlaySound(-1, "Event_Start_Text", "GTAO_FM_Events_Soundset", 0, 0, 1)
end)

RegisterNetEvent('police:client:CallAnim', function()
    local isCalling = true
    local callCount = 5
    loadAnimDict("cellphone@")
    TaskPlayAnim(PlayerPedId(), 'cellphone@', 'cellphone_call_listen_base', 3.0, -1, -1, 49, 0, false, false, false)
    Wait(1000)
    CreateThread(function()
        while isCalling do
            Wait(1000)
            callCount = callCount - 1
            if callCount <= 0 then
                isCalling = false
                StopAnimTask(PlayerPedId(), 'cellphone@', 'cellphone_call_listen_base', 1.0)
            end
        end
    end)
end)

RegisterNetEvent('police:client:ImpoundVehicle', function(fullImpound, price)
    local vehicle = QBCore.Functions.GetClosestVehicle()
    local bodyDamage = math.ceil(GetVehicleBodyHealth(vehicle))
    local engineDamage = math.ceil(GetVehicleEngineHealth(vehicle))
    local totalFuel = exports[Config.FuelScript]:GetFuel(vehicle)
    if vehicle ~= 0 and vehicle then
        local ped = PlayerPedId()
        local pos = GetEntityCoords(ped)
        local vehpos = GetEntityCoords(vehicle)
        if #(pos - vehpos) < 5.0 and not IsPedInAnyVehicle(ped) then
           QBCore.Functions.Progressbar('impound', Lang:t('progressbar.impound'), 5000, false, true, {
                disableMovement = true,
                disableCarMovement = true,
                disableMouse = false,
                disableCombat = true,
            }, {
                animDict = 'missheistdockssetup1clipboard@base',
                anim = 'base',
                flags = 1,
            }, {
                model = 'prop_notepad_01',
                bone = 18905,
                coords = { x = 0.1, y = 0.02, z = 0.05 },
                rotation = { x = 10.0, y = 0.0, z = 0.0 },
            },{
                model = 'prop_pencil_01',
                bone = 58866,
                coords = { x = 0.11, y = -0.02, z = 0.001 },
                rotation = { x = -120.0, y = 0.0, z = 0.0 },
            }, function() -- Play When Done
                local plate = QBCore.Functions.GetPlate(vehicle)
                TriggerServerEvent("police:server:Impound", plate, fullImpound, price, bodyDamage, engineDamage, totalFuel)
                while NetworkGetEntityOwner(vehicle) ~= 128 do  -- Ensure we have entity ownership to prevent inconsistent vehicle deletion
                    NetworkRequestControlOfEntity(vehicle)
                    Wait(100)
                end
                QBCore.Functions.DeleteVehicle(vehicle)
                TriggerEvent('QBCore:Notify', Lang:t('success.impounded'), 'success')
                ClearPedTasks(ped)
            end, function() -- Play When Cancel
                ClearPedTasks(ped)
                TriggerEvent('QBCore:Notify', Lang:t('error.canceled'), 'error')
            end)
        end
    end
end)

RegisterNetEvent('police:client:CheckStatus', function()
    QBCore.Functions.GetPlayerData(function(PlayerData)
        if PlayerData.job.type == "leo" then
            local player, distance = GetClosestPlayer()
            if player ~= -1 and distance < 5.0 then
                local playerId = GetPlayerServerId(player)
                QBCore.Functions.TriggerCallback('police:GetPlayerStatus', function(result)
                    if result then
                        for _, v in pairs(result) do
                            QBCore.Functions.Notify(''..v..'')
                        end
                    end
                end, playerId)
            else
                QBCore.Functions.Notify(Lang:t("error.none_nearby"), "error")
            end
        end
    end)
end)

RegisterNetEvent("police:client:CopterMenu", function(data)
    local heli = Config.Helicopters[QBCore.Functions.GetPlayerData().job.grade.level]
    local copterlist = {}
    copterlist[#copterlist + 1] = { 
        isMenuHeader = true,
        header = Lang:t("menu.heli_garage"),
        icon = 'fa-solid fa-shield'
    }
    if heli == nil then
        QBCore.Functions.Notify(Lang:t("error.not_outhereized_veh"), "error", 5000)
    else
        for k,v in pairs(heli) do 
            copterlist[#copterlist + 1] = { 
                header = k:upper(),
                txt = Lang:t("menu.heli_garage_txt"),
                icon = 'fa-solid fa-helicopter',
                params = {
                    event = 'police:client:TakeOutCopter', 
                    args = {
                        currentSelection = data.spawn,
                        model = v,
                    }
                }
            }
        end
        exports['qb-menu']:openMenu(copterlist) 
    end
end)

RegisterNetEvent("police:client:VehicleMenuHeader", function(data)
    local base = Config.VehicleTable[QBCore.Functions.GetPlayerData().job.name]
    local job = QBCore.Functions.GetPlayerData().job.name
    local Menu = {
        {
            header = Lang:t('menu.garage_title'),
            isMenuHeader = true,
            icon = "fas fa-warehouse",
        }
    }
        for k,v in pairs(base) do
            Menu[#Menu+1] = {
                header = k:upper(),
                txt = "Select category for vehicles",
                icon = "fa-solid fa-shield",
                params = {
                    event = "police:client:veh-category-selected",
                    args = {
                        category = k,
                        location = data.spawn,
                    }
                }
            }
        exports['qb-menu']:openMenu(Menu)
    end
end)

RegisterNetEvent('police:client:veh-category-selected', function(data)
    print(1)
    local newtable = data.category
    QBCore.Debug(newtable)
    local result = Config.VehicleTable[QBCore.Functions.GetPlayerData().job.name][newtable][QBCore.Functions.GetPlayerData().job.grade.level]
    local Menu = {
        {
            header = Lang:t('menu.garage_title'),
            isMenuHeader = true,
            icon = "fas fa-warehouse",
        }
    }
    if result == nil then
        QBCore.Functions.Notify(Lang:t('error.non_outhereized_veh'), 'error', 300)
    else
        for k,v in pairs(result) do
            Menu[#Menu+1] = {
                header = k:upper(),
                txt = "",
                icon = "fa-solid fa-shield",
                params = {
                    event = "police:client:TakeOutVehicle",
                    args = {
                        currentSelection = data.location,
                        model = v,
                    }
                }
            }
        end
        exports['qb-menu']:openMenu(Menu)
    end
end)

RegisterNetEvent("police:client:ImpoundMenuHeader", function (data)
    
    local impoundMenu = {
        {
            header = Lang:t('menu.impound'),
            isMenuHeader = true
        }
    }
    QBCore.Functions.TriggerCallback("police:GetImpoundedVehicles", function(result)
        local shouldContinue = false
        if result == nil then
            QBCore.Functions.Notify(Lang:t("error.no_impound"), "error", 5000)
        else
            shouldContinue = true
            for _ , v in pairs(result) do
                local enginePercent = QBCore.Shared.Round(v.engine / 10, 0)
                local currentFuel = v.fuel
                local vname = QBCore.Shared.Vehicles[v.vehicle].name

                impoundMenu[#impoundMenu+1] = {
                    header = vname.." ["..v.plate.."]",
                    txt =  Lang:t('info.vehicle_info', {value = enginePercent, value2 = currentFuel}),
                    params = {
                        event = "police:client:TakeOutImpound",
                        args = {
                            vehicle = v.vehicle,
                            currentSelection = currentSelection,
                            location = data.spawn,
                            plate = v.plate,
                            engine = v.engine
                        }
                    }
                }
            end
        end


        if shouldContinue then
            impoundMenu[#impoundMenu+1] = {
                header = Lang:t('menu.close'),
                txt = "",
                params = {
                    event = "qb-menu:client:closeMenu"
                }
            }
            exports['qb-menu']:openMenu(impoundMenu)
        end
    end)
end)

RegisterNetEvent("police:client:TakeOutCopter", function(data)
    local VehicleSpawnCoord = Config.Locations["helicopter"][data.currentSelection]["vehiclespawn"]
    local plate = Lang:t("police_plate").. tostring(math.random(000, 999))

    QBCore.Functions.SpawnVehicle(data.model, function(veh)
        SetVehicleNumberPlateText(veh, plate)
        SetEntityHeading(veh, VehicleSpawnCoord.w)
        SetEntityAsMissionEntity(veh, true, true)
        exports[Config.FuelScript]:SetFuel(veh, 100.0)
        SetVehicleLivery(veh, 2) -- Ambulance Livery
        TriggerEvent('vehiclekeys:client:SetOwner', QBCore.Functions.GetPlate(veh))
    end, vector3(VehicleSpawnCoord.x,VehicleSpawnCoord.y,VehicleSpawnCoord.z), true)
end)

RegisterNetEvent('police:client:TakeOutVehicle', function(data)
    print(1)
    local coords = Config.Locations["vehicle"][data.currentSelection]["vehiclespawn"]
    QBCore.Functions.SpawnVehicle(data.model, function(veh)
        print(2)
        local plate = "Polcie" .. math.random(1111, 5555)
        SetVehicleNumberPlateText(veh, plate)
        SetEntityHeading(veh, coords.w)
        SetEntityAsMissionEntity(veh, true, true)
        SetCarItemsInfo()
        exports[Config.FuelScript]:SetFuel(veh, 100.0)
        TriggerEvent('vehiclekeys:client:SetOwner', QBCore.Functions.GetPlate(veh))
        TriggerServerEvent("inventory:server:addTrunkItems", QBCore.Functions.GetPlate(veh), Config.CarItems)
        --TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)
    end, coords, true)

end)

RegisterNetEvent('police:client:returnveh', function()
    local ped = PlayerPedId()
    local coords = GetEntityCoords(PlayerPedId())
    local car = QBCore.Functions.GetClosestVehicle(coords)
        QBCore.Functions.Notify('Vehicle Stored!')
        DeleteVehicle(car)
        DeleteEntity(car)
end)


RegisterNetEvent('police:client:EvidenceStashDrawer', function(data)
    local drawer = exports['qb-input']:ShowInput({
        header = Lang:t('info.evidence_stash'),
        submitText = "open",
        inputs = {
            {
                type = 'number',
                isRequired = true,
                name = 'slot',
                text = Lang:t('info.slot')
            }
        }
    })
    TriggerServerEvent("inventory:server:OpenInventory", "stash", Lang:t('info.current_evidence', {value = currentEvidence, value2 = drawer.slot}), {
        maxweight = 4000000,
        slots = 500,
    })
    TriggerEvent("inventory:client:SetCurrentStash", Lang:t('info.current_evidence', {value = currentEvidence, value2 = drawer.slot}))
end)

RegisterNetEvent('qb-policejob:ToggleDuty', function()
    TriggerServerEvent("QBCore:ToggleDuty")
    TriggerServerEvent("police:server:UpdateCurrentCops")
    TriggerServerEvent("police:server:UpdateBlips")
end)

RegisterNetEvent('qb-police:client:scanFingerPrint', function()
    local player, distance = GetClosestPlayer()
    if player ~= -1 and distance < 2.5 then
        local playerId = GetPlayerServerId(player)
        TriggerServerEvent("police:server:showFingerprint", playerId)
    else
        QBCore.Functions.Notify(Lang:t("error.none_nearby"), "error")
    end
end)

RegisterNetEvent('qb-police:client:openArmoury', function()
    local authorizedItems = {
        label = Lang:t('menu.pol_armory'),
        slots = 30,
        items = {}
    }
    local index = 1
    for _, armoryItem in pairs(Config.Items.items) do
        for i=1, #armoryItem.authorizedJobGrades do
            if armoryItem.authorizedJobs == PlayerJob.name or "leo" and armoryItem.authorizedJobGrades[i] == PlayerJob.grade.level then
                authorizedItems.items[index] = armoryItem
                authorizedItems.items[index].slot = index
                index = index + 1
            end
        end
    end
    SetWeaponSeries()
    TriggerServerEvent("inventory:server:OpenInventory", "shop", "police", authorizedItems)
end)

RegisterNetEvent('qb-police:client:spawnHelicopter', function(k)
    if IsPedInAnyVehicle(PlayerPedId(), false) then
        QBCore.Functions.DeleteVehicle(GetVehiclePedIsIn(PlayerPedId()))
    else
        local coords = Config.Locations["helicopter"][k]
        if not coords then coords = GetEntityCoords(PlayerPedId()) end
        QBCore.Functions.TriggerCallback('QBCore:Server:SpawnVehicle', function(netId)
            local veh = NetToVeh(netId)
            SetVehicleLivery(veh , 0)
            SetVehicleMod(veh, 0, 48)
            SetVehicleNumberPlateText(veh, "ZULU"..tostring(math.random(1000, 9999)))
            SetEntityHeading(veh, coords.w)
            exports[Config.FuelScript]:SetFuel(veh, 100.0)
            closeMenuFull()
            TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)
            TriggerEvent("vehiclekeys:client:SetOwner", QBCore.Functions.GetPlate(veh))
            SetVehicleEngineOn(veh, true, true)
        end, Config.PoliceHelicopter, coords, true)
    end
end)

RegisterNetEvent("qb-police:client:openStash", function()
    TriggerServerEvent("inventory:server:OpenInventory", "stash", "policestash_"..QBCore.Functions.GetPlayerData().citizenid)
    TriggerEvent("inventory:client:SetCurrentStash", "policestash_"..QBCore.Functions.GetPlayerData().citizenid)
end)

RegisterNetEvent('qb-police:client:openTrash', function()
    TriggerServerEvent("inventory:server:OpenInventory", "stash", "policetrash", {
        maxweight = 4000000,
        slots = 300,
    })
    TriggerEvent("inventory:client:SetCurrentStash", "policetrash")
end)

--##### Threads #####--

local dutylisten = false
local function dutylistener()
    dutylisten = true
    CreateThread(function()
        while dutylisten do
            if PlayerJob.type == "leo" then
                if IsControlJustReleased(0, 38) then
                    TriggerServerEvent("QBCore:ToggleDuty")
                    TriggerServerEvent("police:server:UpdateCurrentCops")
                    TriggerServerEvent("police:server:UpdateBlips")
                    dutylisten = false
                    break
                end
            else
                break
            end
            Wait(0)
        end
    end)
end

-- Personal Stash Thread
local function stash()
    CreateThread(function()
        while true do
            Wait(0)
            if inStash and PlayerJob.type == "leo" then
                if PlayerJob.onduty then sleep = 5 end
                if IsControlJustReleased(0, 38) then
                    TriggerServerEvent("inventory:server:OpenInventory", "stash", "policestash_"..QBCore.Functions.GetPlayerData().citizenid)
                    TriggerEvent("inventory:client:SetCurrentStash", "policestash_"..QBCore.Functions.GetPlayerData().citizenid)
                    break
                end
            else
                break
            end
        end
    end)
end

-- Police Trash Thread
local function trash()
    CreateThread(function()
        while true do
            Wait(0)
            if inTrash and PlayerJob.type == "leo" then
                if PlayerJob.onduty then sleep = 5 end
                if IsControlJustReleased(0, 38) then
                    TriggerServerEvent("inventory:server:OpenInventory", "stash", "policetrash", {
                        maxweight = 4000000,
                        slots = 300,
                    })
                    TriggerEvent("inventory:client:SetCurrentStash", "policetrash")
                    break
                end
            else
                break
            end
        end
    end)
end

-- Fingerprint Thread
local function fingerprint()
    CreateThread(function()
        while true do
            Wait(0)
            if inFingerprint and PlayerJob.type == "leo" then
                if PlayerJob.onduty then sleep = 5 end
                if IsControlJustReleased(0, 38) then
                    TriggerEvent("qb-police:client:scanFingerPrint")
                    break
                end
            else
                break
            end
        end
    end)
end

-- Armoury Thread
local function armoury()
    CreateThread(function()
        while true do
            Wait(0)
            if inArmoury and PlayerJob.type == "leo" then
                if PlayerJob.onduty then sleep = 5 end
                if IsControlJustReleased(0, 38) then
                    TriggerEvent("qb-police:client:openArmoury")
                    break
                end
            else
                break
            end
        end
    end)
end

-- Helicopter Thread
local function heli()
    CreateThread(function()
        while true do
            Wait(0)
            if inHelicopter and PlayerJob.type == "leo" then
                if PlayerJob.onduty then sleep = 5 end
                if IsControlJustReleased(0, 38) then
                    TriggerEvent("qb-police:client:spawnHelicopter")
                    break
                end
            else
                break
            end
        end
    end)
end

-- Police Impound Thread
local function impound()
    CreateThread(function()
        while true do
            Wait(0)
            if inImpound and PlayerJob.type == "leo" then
                if PlayerJob.onduty then sleep = 5 end
                if IsPedInAnyVehicle(PlayerPedId(), false) then
                    if IsControlJustReleased(0, 38) then
                        QBCore.Functions.DeleteVehicle(GetVehiclePedIsIn(PlayerPedId()))
                        break
                    end
                end
            else
                break
            end
        end
    end)
end

-- Police Garage Thread
local function garage()
    CreateThread(function()
        while true do
            Wait(0)
            if inGarage and PlayerJob.type == "leo" then
                if PlayerJob.onduty then sleep = 5 end
                if IsPedInAnyVehicle(PlayerPedId(), false) then
                    if IsControlJustReleased(0, 38) then
                        QBCore.Functions.DeleteVehicle(GetVehiclePedIsIn(PlayerPedId()))
                        break
                    end
                end
            else
                break
            end
        end
    end)
end

if Config.UseTarget then
    CreateThread(function()
        -- Toggle Duty

        for k, v in pairs(Config.Locations["duty"]) do
            if Config.EnablePeds then
                QBCore.Functions.LoadModel(Config.DutyPed)
                while not HasModelLoaded(Config.DutyPed) do
                    Wait(100)
                end
                DutyPed = CreatePed(0, Config.DutyPed, v.x, v.y, v.z-1.0, v.w, false, true)
                table.insert(pedstable, DutyPed)
                TaskStartScenarioInPlace(DutyPed, true)
                FreezeEntityPosition(DutyPed, true)
                SetEntityInvincible(DutyPed, true)
                SetBlockingOfNonTemporaryEvents(DutyPed, true)
                TaskStartScenarioInPlace(DutyPed, Config.DutyPedScenario, 0, true) 
            end

            exports['qb-target']:AddBoxZone("PoliceDuty_"..k, vector3(v.x, v.y, v.z-1), 1, 1, {
                name = "PoliceDuty_"..k,
                heading = v.w,
                debugPoly = Config.Debug,
                minZ = v.z - 1,
                maxZ = v.z + 1,
            }, {
                options = {
                    {
                        type = "client",
                        event = "qb-policejob:ToggleDuty",
                        icon = "fas fa-sign-in-alt",
                        label = Lang:t("targeting.duty_lable"),
                        jobType = "leo",
                    },
                },
                distance = 2.5
            })
        end

        -- Personal Stash
        for k, v in pairs(Config.Locations["stash"]) do
            exports['qb-target']:AddBoxZone("PoliceStash_"..k, vector3(v.x, v.y, v.z), 1.5, 1.5, {
                name = "PoliceStash_"..k,
                heading = 11,
                debugPoly = Config.Debug,
                minZ = v.z - 1,
                maxZ = v.z + 1,
            }, {
                options = {
                    {
                        type = "client",
                        event = "qb-police:client:openStash",
                        icon = "fas fa-dungeon",
                        label = Lang:t("targeting.stash_lable"),
                        jobType = "leo",
                    },
                },
                distance = 1.5
            })
        end

        if Config.EnableTrahs then
            -- Police Trash
            for k, v in pairs(Config.Locations["trash"]) do
                exports['qb-target']:AddBoxZone("PoliceTrash_"..k, vector3(v.x, v.y, v.z), 1, 1.75, {
                    name = "PoliceTrash_"..k,
                    heading = 11,
                    debugPoly = Config.Debug,
                    minZ = v.z - 1,
                    maxZ = v.z + 1,
                }, {
                    options = {
                        {
                            type = "client",
                            event = "qb-police:client:openTrash",
                            icon = "fas fa-trash",
                            label = Lang:t("targeting.trash_lable"),
                            jobType = "leo",
                        },
                    },
                    distance = 1.5
                })
            end
        end
        -- Fingerprint
        for k, v in pairs(Config.Locations["fingerprint"]) do
            QBCore.Functions.LoadModel("prop_cs_tablet")
            while not HasModelLoaded("prop_cs_tablet") do
                Wait(100)
            end
            tablet = CreateObject("prop_cs_tablet", v.x, v.y, v.z, false, true, false)
            FreezeEntityPosition(tablet, true)
            SetEntityRotation(tablet, -90.5, 0.0, 1.0, true, false)
                exports['qb-target']:AddTargetEntity(tablet, { -- The specified entity number
                options = {
                    {
                        type = "client",
                        event = "qb-police:client:scanFingerPrint",
                        icon = "fas fa-fingerprint",
                        label = Lang:t("targeting.fingerprint_lable"),
                        jobType = "leo",
                    },
                },
                distance = 1.5, -- This is the distance for you to be at for the target to turn blue, this is in GTA units and has to be a float value
                 })
        end

        -- Armoury
        for k, v in pairs(Config.Locations["armory"]) do
            if Config.EnablePeds then
                QBCore.Functions.LoadModel(Config.ArmoryPed)
                while not HasModelLoaded(Config.ArmoryPed) do
                    Wait(100)
                end
                ArmoryPed = CreatePed(0, Config.ArmoryPed, v.x, v.y, v.z-1.0, v.w, false, true)
                table.insert(pedstable, ArmoryPed)
                TaskStartScenarioInPlace(ArmoryPed, true)
                FreezeEntityPosition(ArmoryPed, true)
                SetEntityInvincible(ArmoryPed, true)
                SetBlockingOfNonTemporaryEvents(ArmoryPed, true)
                TaskStartScenarioInPlace(ArmoryPed, Config.ArmoryPedScenario, 0, true) 
            end

            exports['qb-target']:AddBoxZone("PoliceArmory_"..k, vector3(v.x, v.y, v.z-1), 1, 1, {
                name = "PoliceArmory_"..k,
                heading = v.w,
                debugPoly = Config.Debug,
                minZ = v.z - 1,
                maxZ = v.z + 1,
            }, {
                options = {
                    {
                        type = "client",
                        event = "qb-police:client:openArmoury",
                        icon = "fas fa-swords",
                        label = Lang:t("targeting.armory_lable"),
                        jobType = "leo",
                    },
                },
                distance = 3.0
            })
        end


        -- Impound
        for k, v in pairs(Config.Locations["impound"]) do
            if Config.EnablePeds then
                QBCore.Functions.LoadModel(Config.ImpoundPed)
                while not HasModelLoaded(Config.ImpoundPed) do
                    Wait(100)
                end
                ImpoundPed = CreatePed(0, Config.ImpoundPed, v.vehped.x, v.vehped.y, v.vehped.z-1.0, v.vehped.w, false, true)
                table.insert(pedstable, ImpoundPed)
                TaskStartScenarioInPlace(ImpoundPed, true)
                FreezeEntityPosition(ImpoundPed, true)
                SetEntityInvincible(ImpoundPed, true)
                SetBlockingOfNonTemporaryEvents(ImpoundPed, true)
                TaskStartScenarioInPlace(ImpoundPed, Config.ImpoundPedScenario, 0, true) 
            end

            exports['qb-target']:AddBoxZone("PoliceImpound"..k, vector3(v.vehped.x, v.vehped.y, v.vehped.z-1), 5, 1, {
                name = "PoliceImpound"..k,
                heading = v.vehped.w,
                debugPoly = Config.Debug,
                minZ = v.vehped.z - 1,
                maxZ = v.vehped.z + 1,
            }, {
                options = {
                    {
                        type = "client",
                        event = "police:client:ImpoundMenuHeader",
                        icon = "fas fa-swords",
                        label = Lang:t("targeting.impound_lable"),
                        jobType = "leo",
                        spawn = k

                    },
                },
                distance = 1.5
            })
        end

        --Heli
        for k, v in pairs(Config.Locations["helicopter"]) do
            if Config.EnablePeds then
                QBCore.Functions.LoadModel(Config.HeliPed)
                while not HasModelLoaded(Config.HeliPed) do
                    Wait(100)
                end
                HeliPed = CreatePed(0, Config.HeliPed, v.vehped.x, v.vehped.y, v.vehped.z-1.0, v.vehped.w, false, true)
                table.insert(pedstable, HeliPed)
                TaskStartScenarioInPlace(HeliPed, true)
                FreezeEntityPosition(HeliPed, true)
                SetEntityInvincible(HeliPed, true)
                SetBlockingOfNonTemporaryEvents(HeliPed, true)
            end

            TaskStartScenarioInPlace(HeliPed, Config.HeliPedScenario, 0, true)
                exports['qb-target']:AddBoxZone("pdheli" .. k, vector3(v.vehped.x, v.vehped.y, v.vehped.z-1), 1.0, 1.0, { 
                    name = "pdheli" .. k,
                    debugPoly = Config.Debug,
                    heading = v.vehped.w,
                    minZ = v.vehped.z - 1.0,
                    maxZ = v.vehped.z + 1.0,
                }, {
                    options = {
                        {
                            icon = 'fa-solid fa-helicopter',
                            label = Lang:t("targeting.garage_out_lable"),
                            type = "client",
                            event = "police:client:CopterMenu",
                            jobType = "leo",                      
                            spawn = k
            
                        },
                        {
                            icon = 'fa-solid fa-car',
                            label = Lang:t("targeting.garage_in_lable"),
                            type = "client",
                            event  = "police:client:returnveh",
                            jobType = "leo",
                   
                        }
                    },
                    distance = 2.0
                })
            
        end

        --Garage
        for k, v in pairs(Config.Locations["vehicle"]) do
            if Config.EnablePeds then
                QBCore.Functions.LoadModel(Config.GaragePed)
                while not HasModelLoaded(Config.GaragePed) do
                    Wait(100)
                end
                GaragePed = CreatePed(0, Config.GaragePed, v.vehped.x, v.vehped.y, v.vehped.z-1.0, v.vehped.w, false, true)
                table.insert(pedstable, GaragePed)
                TaskStartScenarioInPlace(GaragePed, true)
                FreezeEntityPosition(GaragePed, true)
                SetEntityInvincible(GaragePed, true)
                SetBlockingOfNonTemporaryEvents(GaragePed, true)
                TaskStartScenarioInPlace(GaragePed, Config.GaragePedScenario, 0, true) 
            end

            exports['qb-target']:AddBoxZone("PoliceGarage"..k, vector3(v.vehped.x, v.vehped.y, v.vehped.z-1), 1, 1, {
                name = "PoliceGarage"..k,
                heading = v.vehped.w,
                debugPoly = Config.Debug,
                minZ = v.vehped.z - 1,
                maxZ = v.vehped.z + 1,
            }, {
                options = {
                    {
                        icon = 'fa-solid fa-warehouse',
                        label = Lang:t("targeting.garage_out_lable"),
                        type = "client",
                        event = "police:client:VehicleMenuHeader",
                        jobType = "leo",
                        spawn = k
                    },
                    {
                        icon = 'fa-solid fa-car',
                        label = Lang:t("targeting.garage_in_lable"),
                        type = "client",
                        event  = "police:client:returnveh",
                        jobType = "leo",
                    }
                },
                distance = 1.5
            })
        end
        
        for k, v in pairs(Config.Locations["evidence"]) do
            if Config.EnablePeds then
                QBCore.Functions.LoadModel(Config.EvidencePed)
                while not HasModelLoaded(Config.EvidencePed) do
                    Wait(100)
                end
                EvidencePed = CreatePed(0, Config.EvidencePed, v.x, v.y, v.z-1.0, v.w, false, true)
                table.insert(pedstable, EvidencePed)
                TaskStartScenarioInPlace(EvidencePed, true)
                FreezeEntityPosition(EvidencePed, true)
                SetEntityInvincible(EvidencePed, true)
                SetBlockingOfNonTemporaryEvents(EvidencePed, true)
                TaskStartScenarioInPlace(EvidencePed, Config.EvidencePedScenario, 0, true) 
            end

            exports['qb-target']:AddBoxZone("PoliceEvidence"..k, vector3(v.x, v.y, v.z-1), 1, 1, {
                name = "PoliceEvidence"..k,
                heading = v.w,
                debugPoly = Config.Debug,
                minZ = v.z - 1,
                maxZ = v.z + 1,
            }, {
                options = {
                    {
                        type = "client",
                        event = "police:client:EvidenceStashDrawer",
                        icon = "fas fa-swords",
                        label = Lang:t("targeting.evidence_lable"),
                        jobType = "leo",
                    },
                },
                distance = 3.0
            })
        end

    end)

else

    -- Toggle Duty
    local dutyZones = {}
    for _, v in pairs(Config.Locations["duty"]) do
        dutyZones[#dutyZones+1] = BoxZone:Create(
            vector3(vector3(v.x, v.y, v.z)), 1.75, 1, {
            name="box_zone",
            debugPoly = Config.Debug,
            minZ = v.z - 1,
            maxZ = v.z + 1,
        })
    end

    local dutyCombo = ComboZone:Create(dutyZones, {name = "dutyCombo", debugPoly = false})
    dutyCombo:onPlayerInOut(function(isPointInside)
        if isPointInside then
            dutylisten = true
            if not PlayerJob.onduty then
                exports['qb-core']:DrawText(Lang:t('info.on_duty'),'left')
                dutylistener()
            else
                exports['qb-core']:DrawText(Lang:t('info.off_duty'),'left')
                dutylistener()
            end
        else
            dutylisten = false
            exports['qb-core']:HideText()
        end
    end)

    -- Personal Stash
    local stashZones = {}
    for _, v in pairs(Config.Locations["stash"]) do
        stashZones[#stashZones+1] = BoxZone:Create(
            vector3(vector3(v.x, v.y, v.z)), 1.5, 1.5, {
            name="box_zone",
            debugPoly = Config.Debug,
            minZ = v.z - 1,
            maxZ = v.z + 1,
        })
    end

    local stashCombo = ComboZone:Create(stashZones, {name = "stashCombo", debugPoly = false})
    stashCombo:onPlayerInOut(function(isPointInside, _, _)
        if isPointInside then
            inStash = true
            if PlayerJob.type == 'leo' and PlayerJob.onduty then
                exports['qb-core']:DrawText(Lang:t('info.stash_enter'), 'left')
                stash()
            end
        else
            inStash = false
            exports['qb-core']:HideText()
        end
    end)

    if Config.EnableTrahs then
        -- Police Trash
        local trashZones = {}
        for _, v in pairs(Config.Locations["trash"]) do
            trashZones[#trashZones+1] = BoxZone:Create(
                vector3(vector3(v.x, v.y, v.z)), 1, 1.75, {
                name="box_zone",
                debugPoly = Config.Debug,
                minZ = v.z - 1,
                maxZ = v.z + 1,
            })
        end

        local trashCombo = ComboZone:Create(trashZones, {name = "trashCombo", debugPoly = false})
        trashCombo:onPlayerInOut(function(isPointInside)
            if isPointInside then
                inTrash = true
                if PlayerJob.type == 'leo' and PlayerJob.onduty then
                    exports['qb-core']:DrawText(Lang:t('info.trash_enter'),'left')
                    trash()
                end
            else
                inTrash = false
                exports['qb-core']:HideText()
            end
        end)
    end
    -- Fingerprints
    local fingerprintZones = {}
    for _, v in pairs(Config.Locations["fingerprint"]) do
        fingerprintZones[#fingerprintZones+1] = BoxZone:Create(
            vector3(vector3(v.x, v.y, v.z)), 2, 1, {
            name="box_zone",
            debugPoly = Config.Debug,
            minZ = v.z - 1,
            maxZ = v.z + 1,
        })
    end

    local fingerprintCombo = ComboZone:Create(fingerprintZones, {name = "fingerprintCombo", debugPoly = false})
    fingerprintCombo:onPlayerInOut(function(isPointInside)
        if isPointInside then
            inFingerprint = true
            if PlayerJob.type == 'leo' and PlayerJob.onduty then
                exports['qb-core']:DrawText(Lang:t('info.scan_fingerprint'),'left')
                fingerprint()
            end
        else
            inFingerprint = false
            exports['qb-core']:HideText()
        end
    end)

    -- Armoury
    local armouryZones = {}
    for _, v in pairs(Config.Locations["armory"]) do
        armouryZones[#armouryZones+1] = BoxZone:Create(
            vector3(vector3(v.x, v.y, v.z)), 5, 1, {
            name="box_zone",
            debugPoly = Config.Debug,
            minZ = v.z - 1,
            maxZ = v.z + 1,
        })
    end

    local armouryCombo = ComboZone:Create(armouryZones, {name = "armouryCombo", debugPoly = false})
    armouryCombo:onPlayerInOut(function(isPointInside)
        if isPointInside then
            inArmoury = true
            if PlayerJob.type == 'leo' and PlayerJob.onduty then
                exports['qb-core']:DrawText(Lang:t('info.enter_armory'),'left')
                armoury()
            end
        else
            inArmoury = false
            exports['qb-core']:HideText()
        end
    end)

end

CreateThread(function()
    -- Evidence Storage
    local evidenceZones = {}
    for _, v in pairs(Config.Locations["evidence"]) do
        evidenceZones[#evidenceZones+1] = BoxZone:Create(
            vector3(vector3(v.x, v.y, v.z)), 2, 1, {
            name="box_zone",
            debugPoly = Config.Debug,
            minZ = v.z - 1,
            maxZ = v.z + 1,
        })
    end

    local evidenceCombo = ComboZone:Create(evidenceZones, {name = "evidenceCombo", debugPoly = false})
    evidenceCombo:onPlayerInOut(function(isPointInside)
        if isPointInside then
            if PlayerJob.type == "leo" and PlayerJob.onduty then
                local currentEvidence = 0
                local pos = GetEntityCoords(PlayerPedId())

                for k, v in pairs(Config.Locations["evidence"]) do
                    if #(pos - v) < 2 then
                        currentEvidence = k
                    end
                end
                exports['qb-menu']:showHeader({
                    {
                        header = Lang:t('info.evidence_stash', {value = currentEvidence}),
                        params = {
                            event = 'police:client:EvidenceStashDrawer',
                            args = {
                                currentEvidence = currentEvidence
                            }
                        }
                    }
                })
            end
        else
            exports['qb-menu']:closeMenu()
        end
    end)

    -- Helicopter
    local helicopterZones = {}
    for _, v in pairs(Config.Locations["helicopter"]) do
        helicopterZones[#helicopterZones+1] = BoxZone:Create(
            vector3(vector3(v.vehped.x, v.vehped.y, v.vehped.z)), 10, 10, {
            name="box_zone",
            debugPoly = Config.Debug,
            minZ = v.vehped.z - 1,
            maxZ = v.vehped.z + 1,
        })
    end

    local helicopterCombo = ComboZone:Create(helicopterZones, {name = "helicopterCombo", debugPoly = false})
    helicopterCombo:onPlayerInOut(function(isPointInside)
        if isPointInside then
            inHelicopter = true
            if PlayerJob.type == 'leo' and PlayerJob.onduty then
                if IsPedInAnyVehicle(PlayerPedId(), false) then
                    exports['qb-core']:HideText()
                    exports['qb-core']:DrawText(Lang:t('info.store_heli'), 'left')
                    heli()
                else
                    exports['qb-core']:DrawText(Lang:t('info.take_heli'), 'left')
                    heli()
                end
            end
        else
            inHelicopter = false
            exports['qb-core']:HideText()
        end
    end)

    -- Police Impound
    local impoundZones = {}
    for _, v in pairs(Config.Locations["impound"]) do
        impoundZones[#impoundZones+1] = BoxZone:Create(
            vector3(v.vehped.x, v.vehped.y, v.vehped.z), 1, 1, {
            name="box_zone",
            debugPoly = Config.Debug,
            minZ = v.vehped.z - 1,
            maxZ = v.vehped.z + 1,
            heading = v.vehped.w,
        })
    end

    local impoundCombo = ComboZone:Create(impoundZones, {name = "impoundCombo", debugPoly = false})
    impoundCombo:onPlayerInOut(function(isPointInside, point)
        if isPointInside then
            inImpound = true
            if PlayerJob.type == 'leo' and PlayerJob.onduty then
                if IsPedInAnyVehicle(PlayerPedId(), false) then
                    exports['qb-core']:DrawText(Lang:t('info.impound_veh'), 'left')
                    impound()
                else
                    local currentSelection = 0

                    for k, v in pairs(Config.Locations["impound"]) do
                        if #(point - vector3(v.x, v.y, v.z)) < 4 then
                            currentSelection = k
                        end
                    end
                    exports['qb-menu']:showHeader({
                        {
                            header = Lang:t('menu.pol_impound'),
                            params = {
                                event = 'police:client:ImpoundMenuHeader',
                                args = {
                                    currentSelection = currentSelection,
                                    location = data.spawn
                                }
                            }
                        }
                    })
                end
            end
        else
            inImpound = false
            exports['qb-menu']:closeMenu()
            exports['qb-core']:HideText()
        end
    end)

    -- Police Garage
    local garageZones = {}
    for _, v in pairs(Config.Locations["vehicle"]) do
        garageZones[#garageZones+1] = BoxZone:Create(
            vector3(v.vehped.x, v.vehped.y, v.vehped.z), 3, 3, {
            name="box_zone",
            debugPoly = Config.Debug,
            minZ = v.vehped.z - 1,
            maxZ = v.vehped.z + 1,
        })
    end

    local garageCombo = ComboZone:Create(garageZones, {name = "garageCombo", debugPoly = false})
    garageCombo:onPlayerInOut(function(isPointInside, point)
        if isPointInside then
            inGarage = true
            if PlayerJob.type == 'leo' and PlayerJob.onduty then
                if IsPedInAnyVehicle(PlayerPedId(), false) then
                    exports['qb-core']:DrawText(Lang:t('info.store_veh'), 'left')
		    garage()
                else
                    local currentSelection = 0

                    for k, v in pairs(Config.Locations["vehicle"]) do
                        if #(point - vector3(v.x, v.y, v.z)) < 4 then
                            currentSelection = k
                        end
                    end
                    exports['qb-menu']:showHeader({
                        {
                            header = Lang:t('menu.pol_garage'),
                            params = {
                                event = 'police:client:VehicleMenuHeader',
                                args = {
                                    currentSelection = currentSelection,
                                }
                            }
                        }
                    })
                end
            end
        else
            inGarage = false
            exports['qb-menu']:closeMenu()
            exports['qb-core']:HideText()
        end
    end)
end)
