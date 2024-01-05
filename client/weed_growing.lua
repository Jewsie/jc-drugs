local QBCore = exports['qb-core']:GetCoreObject()

local stage = 0
local health = 100
local thirst = 100
local quality = 100
local plants = {}

function Draw3DText(x, y, z, scl_factor, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local p = GetGameplayCamCoords()
    local distance = GetDistanceBetweenCoords(p.x, p.y, p.z, x, y, z, 1)
    local scale = (1 / distance) * 2
    local fov = (1 / GetGameplayCamFov()) * 100
    local scale = scale * fov * scl_factor
    if onScreen then
        SetTextScale(0.0, scale)
        SetTextFont(0)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 215)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry('STRING')
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x, _y)
    end
end

function Draw3DTextForPlant(plant, data, timePlant)
    local objectPos = GetEntityCoords(plant)
    local minutes = math.floor(remainingTime / 60)
    local seconds = remainingTime % 60
    local timeText = remainingTime > 60 and string.format("%d minutes %d seconds", minutes, seconds) or string.format("%d seconds", timePlant)

    if data.stage < 3 then
        Draw3DText(objectPos.x, objectPos.y, objectPos.z + 1.1, 1, tostring(data.name) .. ' - ' .. timeText .. '\n' .. 'Quality: ' .. data.quality .. '%\n' .. 'Health: ' .. data.health .. '%\n' .. 'Thirst: ' .. data.thirst .. '%')
    else
        Draw3DText(objectPos.x, objectPos.y, objectPos.z + 1.1, 1, 'Ready to be picked up')
    end
end

function Draw3DTextForDeadPlant(plant, data, timePlant)
    local objectPos = GetEntityCoords(plant)
    local minutes = math.floor(remainingTime / 60)
    local seconds = remainingTime % 60
    local timeText = remainingTime > 60 and string.format("%d minutes %d seconds", minutes, seconds) or string.format("%d seconds", timePlant)
    Draw3DText(objectPos.x, objectPos.y, objectPos.z + 1.1, 1, tostring(data.name) .. ' - ' .. timeText .. '\n' .. 'Quality: ' .. data.quality .. '%\n' .. 'Health: ' .. data.health .. '%\n' .. 'Thirst: ' .. data.thirst .. '%')
end

function Draw3DTextFinishedPlant(plant)
    local objectPos = GetEntityCoords(plant)
    Draw3DText(objectPos.x, objectPos.y, objectPos.z + 1.1, 1, 'Ready to be picked up')
end

function DecreaseHealthAndThirst(plant)
    Citizen.CreateThread(function()
        while plants[plant] do
            Wait(5000)

            local plantData = plants[plant]
            if plantData.health > 0 then
                plantData.health = plantData.health - 1
            end
            if plantData.thirst > 0 then
                plantData.thirst = plantData.thirst - 1
            end
        end
    end)

    Citizen.CreateThread(function()
        while plants[plant] do
            Wait(15000)

            local plantData = plants[plant]
            if plantData.quality > 0 then
                plantData.quality = plantData.quality - 1
            end
        end
    end)
end

RegisterNetEvent('jc-drugs:client:plantweed')
AddEventHandler('jc-drugs:client:plantweed', function(item, name, reward, time, stageInterval, lowQualityReward, midQualityReward, highQualityReward, coords)
    local model = 'bkr_prop_weed_med_01b'
    local coords = coords
    local stageUpgrade = stageInterval

    if not coords then
        coords = GetEntityCoords(PlayerPedId())
    end

    RequestModel(model)
    while not HasModelLoaded(model) do
        RequestModel(model)
        Wait(1)
    end

    local time2 = time
    local timeWeed = GetGameTimer() + (time2 * 1000)

    if stage == 0 then
        TaskStartScenarioInPlace(PlayerPedId(), "world_human_gardener_plant", 5000, false)
        TriggerServerEvent('jc-drugs:server:removeSeed', item)

        Wait(5000)
    end
    
    local weedPlant = CreateObject(model, coords.x, coords.y, coords.z, true, false, false)
    PlaceObjectOnGroundProperly(weedPlant)
    FreezeEntityPosition(weedPlant, true)
    ClearPedTasksImmediately(PlayerPedId())

    plants[weedPlant] = {
        name = name,
        reward = reward,
        time2 = time2,
        timeWeed = timeWeed,
        stageUpgrade = stageUpgrade,
        stage = stage,
        health = health,
        thirst = thirst,
        quality = quality
    }

    local plantData2 = plants[weedPlant]

    exports['qb-target']:AddTargetEntity(weedPlant, {
        options = {
            {
                label = 'Water Plant',
                icon = 'fas fa-water',
                targeticon = 'fas fa-eye',
                action = function()
                    if QBCore.Functions.HasItem(Config.Water) then
                        plantData2.thirst = plantData2.thirst + 25
                        TaskStartScenarioInPlace(PlayerPedId(), "world_human_gardener_plant", 5000, false)
                        TriggerServerEvent('jc-drugs:server:removeitem', Config.Water)
                        
                        Wait(5500)
                        ClearPedTasksImmediately(PlayerPedId())
                    else
                        QBCore.Functions.Notify('You do not have water!', 'error', 3000)
                    end
                end
            },
            {
                label = 'Feed Plant',
                icon = 'fas fa-burger',
                targeticon = 'fas fa-eye',
                action = function()
                    if QBCore.Functions.HasItem(Config.Fertilizer) then
                        plantData2.health = plantData2.health + 25
                        TaskStartScenarioInPlace(PlayerPedId(), "world_human_gardener_plant", 5000, false)
                        TriggerServerEvent('jc-drugs:server:removeitem', Config.Fertilizer)

                        Wait(5500)
                        ClearPedTasksImmediately(PlayerPedId())
                    else
                        QBCore.Functions.Notify('You do not have fertilizer!', 'error', 3000)
                    end
                end
            },
            {
                label = 'Trim Leafs',
                icon = 'fas fa-plant-cutter',
                targeticon = 'fas fa-eye',
                action = function()
                    if QBCore.Functions.HasItem(Config.Leafblower) then
                        plantData2.quality = plantData2.quality + 25
                        TaskStartScenarioInPlace(PlayerPedId(), "world_human_gardener_leaf_blower", 5000, false)

                        Wait(5500)
                        ClearPedTasksImmediately(PlayerPedId())
                    else
                        QBCore.Functions.Notify('You do not have a leaf blower!', 'error', 3000)
                    end
                end
            },
            {
                label = 'Harvest Plant',
                icon = 'fas fa-plant',
                targeticon = 'fas fa-eye',
                action = function()
                    if QBCore.Functions.HasItem(Config.Weedbag, Config.MaxBaggies) then
                        if plantData2.stage == 0 then
                            QBCore.Functions.Notify('It\'s too early to harvest this plant!', 'error', 3000)
                        elseif plantData2.stage == 1 then
                            TaskStartScenarioInPlace(PlayerPedId(), "world_human_gardener_plant", 5000, false)
                            Wait(5500)
                            TriggerServerEvent('jc-drugs:server:giveWeed', reward, lowQualityReward)
                            DeleteObject(weedPlant)
                            ClearPedTasksImmediately(PlayerPedId())
                        elseif plantData2.stage == 2 then
                            TaskStartScenarioInPlace(PlayerPedId(), "world_human_gardener_plant", 5000, false)
                            Wait(5500)
                            if plantData2.quality <= 15 then
                                TriggerServerEvent('jc-drugs:server:giveWeed', reward, lowQualityReward)
                                DeleteObject(weedPlant)
                            elseif plantData2.quality >= 50 then
                                TriggerServerEvent('jc-drugs:server:giveWeed', reward, midQualityReward)
                                DeleteObject(weedPlant)
                            end
                            ClearPedTasksImmediately(PlayerPedId())
                        elseif plantData2.stage == 3 then
                            TaskStartScenarioInPlace(PlayerPedId(), "world_human_gardener_plant", 5000, false)
                            Wait(5500)
                            if plantData2.quality <= 15 then
                                TriggerServerEvent('jc-drugs:server:giveWeed', reward, lowQualityReward)
                                DeleteObject(weedPlant)
                            elseif plantData2.quality >= 50 and plantData2.quality <= 84 then
                                TriggerServerEvent('jc-drugs:server:giveWeed', reward, midQualityReward)
                                DeleteObject(weedPlant)
                            elseif plantData2.quality >= 85 then
                                TriggerServerEvent('jc-drugs:server:giveWeed', reward, highQualityReward)
                                DeleteObject(weedPlant)
                            end
                            ClearPedTasksImmediately(PlayerPedId())
                        end
                    else
                        QBCore.Functions.Notify('You don\'t have any empty weedbags! Get ATLEAST 5!', 'error', 3000)
                    end
                end
            }
        }
    })
    DecreaseHealthAndThirst(weedPlant)  -- Start the timer for health and thirst

    while true do
        Wait(0)
        local pos, awayFromObject = GetEntityCoords(PlayerPedId()), true
        if plants[weedPlant] then
            local objectPos = GetEntityCoords(weedPlant)
            if #(pos - objectPos) <= 5.0 then
                awayFromObject = false
                local plantData = plants[weedPlant]

                if plantData.health > 0 and plantData.thirst > 0 then
                    remainingTime = math.floor((plantData.timeWeed - GetGameTimer()) / 1000)
                    Draw3DTextForPlant(weedPlant, plantData, remainingTime)

                    if remainingTime <= 0 then
                        if plantData.stage < 3 then
                            plantData.timeWeed = GetGameTimer() + (plantData.time2 + plantData.stageUpgrade * 1000)
                            plantData.stageUpgrade = plantData.stageUpgrade + stageUpgrade
                            plantData.stage = plantData.stage + 1
                            coords = GetEntityCoords(weedPlant)
                            thirst = plantData.thirst
                            health = plantData.health
                            quality = plantData.quality
                            stage = plantData.stage
                            DeleteObject(weedPlant)
                            TriggerEvent('jc-drugs:client:plantweed', nil, name, reward, time + stageUpgrade, stageUpgrade, lowQualityReward, midQualityReward, highQualityReward, coords)
                            print(tostring(plantData.stage))
                        elseif plantData.stage == 3 then
                            Draw3DTextFinishedPlant(weedPlant)
                        else
                            break
                        end
                    end
                else
                    Draw3DTextForDeadPlant(weedPlant, plantData, remainingTime)
                end
            end
        end
    end
end)
