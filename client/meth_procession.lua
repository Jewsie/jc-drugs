local QBCore = exports['qb-core']:GetCoreObject()

local extractedAcid = {}
local extractedMethylamine = {}
local searchedBox = {}
local pickedLithium = {}
local hasSearched = false

RegisterNetEvent('jc-drugs:client:extractAcid')
AddEventHandler('jc-drugs:client:extractAcid', function(data)
    local acidKey = tostring(data.entity)
    local playerPed = PlayerPedId()
    local amount = Config.AcidAmount

    if not extractedAcid[acidKey] then
        extractedAcid[acidKey] = { hasSearched = false }
    end

    if QBCore.Functions.HasItem(Config.ExtractItem, Config.MinExtractItems) then
        if extractedAcid[acidKey].hasSearched then
            QBCore.Functions.Notify('You have already extracted Acid from this!')
        else
            TaskStartScenarioInPlace(PlayerPedId(), "PROP_HUMAN_PARKING_METER", 10000, false)
            QBCore.Functions.Progressbar('extracting_acid', 'Extracting Hydrochloric Acid...', 10000, false, true, {
                disableMovement = true,
                disableCarMovement = true,
                disableMouse = false,
                disableCombat = true
                }, {}, {}, {}, function()
                    local chance = math.random(1, 100)

                    if chance <= 30 then
                        QBCore.Functions.Notify('You spilled too much acid!', 'error', 3000)
                        extractedAcid[acidKey].hasSearched = true
                    elseif chance > 30 then
                        TriggerServerEvent('jc-drugs:server:giveacid', amount)
                        ClearPedTasksImmediately(PlayerPedId())
                        extractedAcid[acidKey].hasSearched = true

                        Wait(1800 * 1000)
                        extractedAcid[acidKey].hasSearched = false
                    end
                end, function()
                    QBCore.Functions.Notify('You cancelled extracting Hydrochloric Acid!')
                    ClearPedTasksImmediately(PlayerPedId())
            end)
        end
    else
        QBCore.Functions.Notify('You need atleast ' .. Config.MinExtractItems .. ' jerry cans!')
    end
end)

RegisterNetEvent('jc-drugs:client:extractMethylamine')
AddEventHandler('jc-drugs:client:extractMethylamine', function(data)
    local acidKey = tostring(data.entity)
    local playerPed = PlayerPedId()
    local amount = Config.MethylamineAmount

    if not extractedMethylamine[acidKey] then
        extractedMethylamine[acidKey] = { hasSearched = false }
    end

    if QBCore.Functions.HasItem(Config.ExtractItem, Config.MinExtractItems) then
        if extractedMethylamine[acidKey].hasSearched then
            QBCore.Functions.Notify('You have already extracted Acid from this!')
        else
            TaskStartScenarioInPlace(PlayerPedId(), "PROP_HUMAN_PARKING_METER", 10000, false)
            QBCore.Functions.Progressbar('extracting_methylamine', 'Extracting Methylamine...', 10000, false, true, {
                disableMovement = true,
                disableCarMovement = true,
                disableMouse = false,
                disableCombat = true
                }, {}, {}, {}, function()
                    local chance = math.random(1, 100)

                    if chance <= 30 then
                        QBCore.Functions.Notify('You spilled too much methylamine!', 'error', 3000)
                        extractedMethylamine[acidKey].hasSearched = true
                    elseif chance > 30 then
                        TriggerServerEvent('jc-drugs:server:givemethylamine', amount)
                        ClearPedTasksImmediately(PlayerPedId())
                        extractedMethylamine[acidKey].hasSearched = true

                        Wait(1800 * 1000)
                        extractedMethylamine[acidKey].hasSearched = false
                    end
                end, function()
                    QBCore.Functions.Notify('You cancelled extracting Methylamine!')
                    ClearPedTasksImmediately(PlayerPedId())
            end)
        end
    else
        QBCore.Functions.Notify('You need atleast ' .. Config.MinExtraItems2 .. ' jerry cans!')
    end
end)

RegisterNetEvent('jc-drugs:client:searchcardboard')
AddEventHandler('jc-drugs:client:searchcardboard', function(data)
    local boxKey = tostring(data.entity)
    local playerPed = PlayerPedId()
    local amount = Config.MethylamineAmount

    if not searchedBox[boxKey] then
        searchedBox[boxKey] = { hasSearched = false }
    end

    if searchedBox[boxKey].hasSearched then
        QBCore.Functions.Notify('You have already searched this box!')
    else
        TaskStartScenarioInPlace(PlayerPedId(), "PROP_HUMAN_PARKING_METER", 10000, false)

        QBCore.Functions.Progressbar('cooking_meth', 'Searching Cardboard box...', 10000, false, true, {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true
            }, {}, {}, {}, function()
                TriggerServerEvent('jc-drugs:server:givecardboarditem')
                ClearPedTasks(PlayerPedId())
                searchedBox[boxKey].hasSearched = true

                Wait(1800 * 1000)
                searchedBox[boxKey].hasSearched = false
            end, function()
                QBCore.Functions.Notify('You\'ve cancelled the cooking session!', 'error', 3000)
        end)
    end
end)

Citizen.CreateThread(function()
    local extracthHydrochloride = 'prop_ind_mech_01c'
    local extractMethylamine = 'prop_barrel_02b'

    exports['qb-target']:AddTargetModel(extracthHydrochloride, {
        options = {
            {
                label = 'Extract Acid',
                icon = 'fas fa-acid',
                targeticon = 'fas fa-eye',
                type = 'client',
                event = 'jc-drugs:client:extractAcid'
            }
        }
    })

    exports['qb-target']:AddTargetModel(extractMethylamine, {
        options = {
            {
                label = 'Extract Methylamine',
                icon = 'fas fa-acid',
                targeticon = 'fas fa-eye',
                type = 'client',
                event = 'jc-drugs:client:extractMethylamine'
            }
        }
    })

    local model = 'prop_rock_1_g'

    RequestModel(model)
    while not HasModelLoaded(model) do
        RequestModel(model)
        Wait(1)
    end

    for _, loc in pairs(Config.LithiumLoc) do
        local lithiumRock = CreateObject(model, loc.x, loc.y, loc.z - 1.0, true, false, false)
        PlaceObjectOnGroundProperly(lithiumRock)
        FreezeEntityPosition(lithiumRock, true)

        exports['qb-target']:AddTargetEntity(lithiumRock, {
            options = {
                {
                    label = 'Pickup Lithium',
                    icon = 'fas fa-rock',
                    targeticon = 'fas fa-eye',
                    action = function()
                        local chance = math.random(1, 100)
                        if QBCore.Functions.HasItem(Config.Trowel) then
                            TaskStartScenarioInPlace(PlayerPedId(), "world_human_gardener_plant", 5000, false)
                            QBCore.Functions.Progressbar('picking_lithium', 'Picking up Rock...', 10000, false, true, {
                                disableMovement = true,
                                disableCarMovement = true,
                                disableMouse = false,
                                disableCombat = true
                                }, {}, {}, {}, function()
                                    if chance <= Config.LithiumChance then
                                        local newPos = GetEntityCoords(lithiumRock)
                                        TriggerServerEvent('jc-drugs:server:givelithium', math.random(1, Config.LithiumMaxExtract))
                                        ClearPedTasksImmediately(PlayerPedId())

                                        SetEntityVisible(lithiumRock, false)

                                        Wait(60 * 1000)
                                        SetEntityVisible(lithiumRock, true)
                                    else
                                        QBCore.Functions.Notify('You didn\'t find any lithium!', 'error', 3000)
                                        SetEntityVisible(lithiumRock, false)

                                        Wait(60 * 1000)
                                        SetEntityVisible(lithiumRock, true)
                                    end
                                end, function()
                                    QBCore.Functions.Notify('You cancelled picking up the rock!')
                                    ClearPedTasksImmediately(PlayerPedId())
                            end)
                        else
                            QBCore.Functions.Notify('You need a trowel to pickup this rock!')
                        end
                    end
                }
            }
        })
    end
end)

Citizen.CreateThread(function()
    exports['qb-target']:AddCircleZone('meth_procession', Config.MethProcession, 1.5, {
        name = 'meth_procession',
        debugPoly = false
    }, {
        options = {
            {
                label = 'Process Meth',
                targeticon = 'fas fa-eye',
                action = function()
                    TaskStartScenarioInPlace(PlayerPedId(), "PROP_HUMAN_PARKING_METER", 15000, false)
                    exports['ps-ui']:Circle(function(success)
                        if success then
                            TriggerServerEvent('jc-drugs:server:methprocession', 'processed')
                            ClearPedTasksImmediately(PlayerPedId())
                        else
                            QBCore.Functions.Notify('You failed at cooking the meth!', 'error', 3000)
                            TriggerServerEvent('jc-drugs:server:methprocession', 'failedprocession')
                            ClearPedTasksImmediately(PlayerPedId())
                        end
                    end, math.random(3, 5), 20)
                end
            }
        },
        distance = 2.5
    })
    
    exports['qb-target']:AddCircleZone('cook_meth', Config.MethCooking, 1.5, {
        name = 'cook_meth',
        debugPoly = false
    }, {
        options = {
            {
                label = 'Cook Meth',
                targeticon = 'fas fa-eye',
                action = function()
                    TaskStartScenarioInPlace(PlayerPedId(), "PROP_HUMAN_PARKING_METER", 15000, false)
                    exports['ps-ui']:Circle(function(success)
                        if success then
                            ClearPedTasksImmediately(PlayerPedId())

                            if QBCore.Functions.HasItem(Config.ProcessedMethItem) then
                                QBCore.Functions.Progressbar('cooking_meth', 'Cooking Meth...', Config.MethCookingTime * 1000, false, true, {
                                    disableMovement = true,
                                    disableCarMovement = true,
                                    disableMouse = false,
                                    disableCombat = true
                                    }, {}, {}, {}, function()
                                        TriggerServerEvent('jc-drugs:server:methprocession', 'cook')
                                        ClearPedTasks(PlayerPedId())
                                    end, function()
                                        QBCore.Functions.Notify('You\'ve cancelled the cooking session!', 'error', 3000)
                                        ClearPedTasks(PlayerPedId())
                                end)
                            else
                                QBCore.Functions.Notify('You need processed meth to cook!', 'error', 3000)
                            end
                        else
                            QBCore.Functions.Notify('You failed at cracking the meth!', 'error', 3000)
                            TriggerServerEvent('jc-drugs:server:methprocession', 'failedcooking')
                            ClearPedTasksImmediately(PlayerPedId())
                        end
                    end, math.random(3, 5), 20)
                end
            }
        },
        distance = 2.5
    })

    exports['qb-target']:AddCircleZone('crack_meth', Config.MethPicking, 1.5, {
        name = 'crack_meth',
        debugPoly = false
    }, {
        options = {
            {
                label = 'Crack Meth',
                targeticon = 'fas fa-eye',
                action = function()
                    if QBCore.Functions.HasItem(Config.MethTrayItem) then
                        TaskStartScenarioInPlace(PlayerPedId(), "WORLD_HUMAN_HAMMERING", 15000, false)
                        exports['ps-ui']:Circle(function(success)
                            if success then
                                TriggerServerEvent('jc-drugs:server:methprocession', 'cracking')
                                ClearPedTasksImmediately(PlayerPedId())
                            else
                                QBCore.Functions.Notify('You failed at mixing the ingredients!', 'error', 3000)
                                TriggerServerEvent('jc-drugs:server:methprocession', 'failedcracking')
                                ClearPedTasksImmediately(PlayerPedId())
                            end
                        end, math.random(4, 8), 20)
                    else
                        QBCore.Functions.Notify('You need a methtray to crack meth!', 'error', 3000)
                    end
                end
            }
        },
        distance = 2.5
    })

    local cardboard_box = "prop_boxpile_07d"

    exports['qb-target']:AddTargetModel(cardboard_box, {
        options = {
            {
                label = 'Search Boxes',
                icon = 'fas fa-box',
                targeticon = 'fas fa-eye',
                type = 'client',
                event = 'jc-drugs:client:searchcardboard'
            }
        }
    })
end)
