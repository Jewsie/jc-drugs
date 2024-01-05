local QBCore = exports['qb-core']:GetCoreObject()

local extractedGasoline = {}
local extractedCement = {}
local searchBenzocaine = {}

local hasSearched = false

RegisterNetEvent('jc-drugs:client:extractGasoline')
AddEventHandler('jc-drugs:client:extractGasoline', function(data)
    local gasolineKey = tostring(data.entity)
    local playerPed = PlayerPedId()
    local amount = Config.GasolineAmount

    if not extractedGasoline[gasolineKey] then
        extractedGasoline[gasolineKey] = { hasSearched = false }
    end

    if QBCore.Functions.HasItem(Config.GasolineExtractItem, Config.GasolineMinExtactAmount) then
        if extractedGasoline[gasolineKey].hasSearched then
            QBCore.Functions.Notify('You have already extracted Gasoline from this!')
        else
            TaskStartScenarioInPlace(PlayerPedId(), "PROP_HUMAN_PARKING_METER", 10000, false)
            QBCore.Functions.Progressbar('extracting_gasoline', 'Extracting Gasoline...', 10000, false, true, {
                disableMovement = true,
                disableCarMovement = true,
                disableMouse = false,
                disableCombat = true
                }, {}, {}, {}, function()
                    local chance = math.random(1, 100)

                    if chance <= 30 then
                        QBCore.Functions.Notify('You spilled too much gasoline!', 'error', 3000)
                        extractedGasoline[gasolineKey].hasSearched = true
                    elseif chance > 30 then
                        TriggerServerEvent('jc-drugs:server:givegasoline', amount)
                        ClearPedTasksImmediately(PlayerPedId())
                        extractedGasoline[gasolineKey].hasSearched = true

                        Wait(1800 * 1000)
                        extractedGasoline[gasolineKey].hasSearched = false
                    end
                end, function()
                    QBCore.Functions.Notify('You cancelled extracting Gasoline!')
                    ClearPedTasksImmediately(PlayerPedId())
            end)
        end
    else
        QBCore.Functions.Notify('You need atleast ' .. Config.GasolineMinExtactAmount .. ' jerry cans!')
    end
end)

RegisterNetEvent('jc-drugs:client:searchBenzocaine')
AddEventHandler('jc-drugs:client:searchBenzocaine', function(data)
    local benzocaineKey = tostring(data.entity)
    local playerPed = PlayerPedId()

    if not searchBenzocaine[benzocaineKey] then
        searchBenzocaine[benzocaineKey] = { hasSearched = false }
    end

    if searchBenzocaine[benzocaineKey].hasSearched then
        QBCore.Functions.Notify('You have already searched this box!')
    else
        TaskStartScenarioInPlace(PlayerPedId(), "PROP_HUMAN_PARKING_METER", 15000, false)
        QBCore.Functions.Progressbar('searching_boxes', 'Searching airport boxes...', 15000, false, true, {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true
            }, {}, {}, {}, function()
                TriggerServerEvent('jc-drugs:server:givebenzo', amount)
                ClearPedTasksImmediately(PlayerPedId())
                searchBenzocaine[benzocaineKey].hasSearched = true

                Wait(1800 * 1000)
                searchBenzocaine[benzocaineKey].hasSearched = false
            end,
            function()
                QBCore.Functions.Notify('You cancelled searching the airport box!')
                ClearPedTasksImmediately(PlayerPedId())
        end)
    end
end)


RegisterNetEvent('jc-drugs:client:extractCement')
AddEventHandler('jc-drugs:client:extractCement', function(data)
    local cementKey = tostring(data.entity)
    local playerPed = PlayerPedId()
    local amount = Config.CementExtractAmount

    if not extractedCement[cementKey] then
        extractedCement[cementKey] = { hasSearched = false }
    end

    TaskStartScenarioInPlace(PlayerPedId(), "PROP_HUMAN_PARKING_METER", 10000, false)
    QBCore.Functions.Progressbar('extracting_cement', 'Extracting Cement...', 10000, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true
        }, {}, {}, {}, function()
            local chance = math.random(1, 100)

            if chance <= 30 then
                QBCore.Functions.Notify('You didn\'t find any cement!', 'error', 3000)
                extractedCement[cementKey].hasSearched = true
            elseif chance > 30 then
                TriggerServerEvent('jc-drugs:server:givecement', amount)
                ClearPedTasksImmediately(PlayerPedId())
                extractedCement[cementKey].hasSearched = true

                Wait(1800 * 1000)
                extractedCement[cementKey].hasSearched = false
            end
        end, function()
            QBCore.Functions.Notify('You cancelled extracting Cement!')
            ClearPedTasksImmediately(PlayerPedId())
    end)
end)


Citizen.CreateThread(function()
    local extractGasoline = 'prop_air_fueltrail2'

    for _, loc in pairs(Config.CokePlantLoc) do
        local model = Config.CokePlant

        RequestModel(model)
        while not HasModelLoaded(model) do
            RequestModel(model)
            Wait(1)
        end

        local coke = CreateObject(model, loc.x, loc.y, loc.z - 1.0, true, false, false)
        FreezeEntityPosition(coke, true)
        PlaceObjectOnGroundProperly(coke)

        exports['qb-target']:AddTargetEntity(coke, {
            options = {
                {
                    label = 'Harvest Coca Plant',
                    icon = 'fas fa-plant',
                    targeticon = 'fas fa-eye',
                    action = function()
                        if QBCore.Functions.HasItem('meth') then
                            TaskStartScenarioInPlace(PlayerPedId(), "world_human_gardener_plant", 10000, false)
                            QBCore.Functions.Progressbar('picking_coke', 'Picking Coke...', 10000, false, true, {
                                disableMovement = true,
                                disableCarMovement = true,
                                disableMouse = false,
                                disableCombat = true
                                }, {}, {}, {}, function()
                                    local cokePos = GetEntityCoords(coke)
                                    SetEntityVisible(coke, false)
                                    TriggerServerEvent('jc-drugs:server:giveCokeLeafs')
                                    ClearPedTasksImmediately(PlayerPedId())

                                    Wait(60 * 1000)
                                    SetEntityVisible(coke, true)
                                end, function()
                                    QBCore.Functions.Notify('You cancelled picking coke!')
                                    ClearPedTasksImmediately(PlayerPedId())
                            end)
                        else
                            QBCore.Functions.Notify('You need a trowel to harvest plants!', 'error', 3000)
                        end
                    end
                }
            }
        })
    end
    
    exports['qb-target']:AddCircleZone('coke_processing', Config.CokeProcessing, 1.5, {
        name = 'coke_processing',
        debugPoly = false,
    }, {
        options = {
            {
                label = 'Process Coke',
                icon = 'fas fa-plant',
                targeticon = 'fas fa-eye',
                action = function()
                    local hasIngredients = true
                    local hasIngredients2 = true
                    
                    for _, i in pairs(Config.CokeProcessIngredients) do
                        if not QBCore.Functions.HasItem(i.item, i.amount) then
                            hasIngredients = false
                            QBCore.Functions.Notify('You need ' .. i.name .. ' x' .. i.amount)
                            break
                        end
                    end

                    if not QBCore.Functions.HasItem(Config.Weedbag, Config.CokeAmount) then
                        hasIngredients2 = false
                        QBCore.Functions.Notify('You need ' .. Config.CokeAmount .. ' Baggies!')
                    end

                    if hasIngredients and hasIngredients2 then
                        exports['ps-ui']:Circle(function(success)
                            if success then
                                TaskStartScenarioInPlace(PlayerPedId(), "PROP_HUMAN_PARKING_METER", 10000, false)
                                QBCore.Functions.Progressbar('process_coke', 'Processing Coke...', 15000, false, true, {
                                    disableMovement = true,
                                    disableCarMovement = true,
                                    disableMouse = false,
                                    disableCombat = true
                                    }, {}, {}, {}, function()
                                        TriggerServerEvent('jc-drugs:server:givecoke', Config.CokeProcessIngredients)
                                        ClearPedTasksImmediately(PlayerPedId())
                                    end, function()
                                        QBCore.Functions.Notify('You have cancelled the coke processing!')
                                        ClearPedTasksImmediately(PlayerPedId())
                                end)
                            else
                                TriggerServerEvent('jc-drugs:server:removecokeitems')
                            end
                        end, math.random(4, 7), 20)
                    else
                        QBCore.Functions.Notify('You are missing ingredients!')
                    end
                end
            }
        }
    })

    exports['qb-target']:AddCircleZone('coke_packaging', Config.CokePacking, 1.5, {
        name = 'coke_packaging',
        debugPoly = false,
    }, {
        options = {
            {
                label = 'Package Coke',
                icon = 'fas fa-package',
                targeticon = 'fas fa-eye',
                action = function()
                    lib.registerContext({
                        id = 'coke_packaging',
                        title = 'Coke Packaging',
                        options = {
                            {
                                title = 'Coke Package',
                                description = 'Coke Baggies Required: ' .. Config.SmallPackageAmount,
                                onSelect = function()
                                    if QBCore.Functions.HasItem(Config.CokeItem, Config.SmallPackageAmount) then
                                        exports['ps-ui']:Circle(function(success)
                                            if success then
                                                TaskStartScenarioInPlace(PlayerPedId(), "PROP_HUMAN_PARKING_METER", 10000, false)
                                                QBCore.Functions.Progressbar('packaging_package', 'Packaging Coke Package...', 30000, false, true, {
                                                    disableMovement = true,
                                                    disableCarMovement = true,
                                                    disableMouse = false,
                                                    disableCombat = true
                                                    }, {}, {}, {}, function()
                                                        TriggerServerEvent('jc-drugs:server:givebrick', Config.CokeItem, Config.SmallBrick, Config.SmallPackageAmount)
                                                        ClearPedTasksImmediately(PlayerPedId())
                                                    end, function()
                                                        ClearPedTasksImmediately(PlayerPedId())
                                                        QBCore.Functions.Notify('You cancelled processing small coke brick!')
                                                end)
                                            else
                                                TriggerServerEvent('jc-drugs:server:removedrugs', Config.CokeItem, Config.SmallPackageAmount)
                                            end
                                        end, math.random(6, 8), 20)
                                    else
                                        QBCore.Functions.Notify('You need atleast ' .. Config.SmallPackageAmount .. ' Coke Baggies!')
                                    end
                                end
                            },
                            {
                                title = 'Coke Brick',
                                description = 'Coke Baggies Required: ' .. Config.BigPackageAmount,
                                onSelect = function()
                                    if QBCore.Functions.HasItem(Config.CokeItem, Config.BigPackageAmount) then
                                        TaskStartScenarioInPlace(PlayerPedId(), "PROP_HUMAN_PARKING_METER", 10000, false)
                                        exports['ps-ui']:Circle(function(success)
                                            if success then
                                                QBCore.Functions.Progressbar('packaging_brick', 'Packaging Coke Brick..', 45000, false, true, {
                                                    disableMovement = true,
                                                    disableCarMovement = true,
                                                    disableMouse = false,
                                                    disableCombat = true
                                                    }, {}, {}, {}, function()
                                                        TriggerServerEvent('jc-drugs:server:givebrick', Config.CokeItem, Config.BigBrick, Config.BigPackageAmount)
                                                        ClearPedTasksImmediately(PlayerPedId())
                                                    end, function()
                                                        ClearPedTasksImmediately(PlayerPedId())
                                                        QBCore.Functions.Notify('You cancelled processing small coke brick!')
                                                end)
                                            else
                                                TriggerServerEvent('jc-drugs:server:removedrugs', Config.CokeItem, Config.SmallPackageAmount)
                                            end
                                        end, math.random(7, 10), 20)
                                    else
                                        QBCore.Functions.Notify('You need atleast ' .. Config.BigPackageAmount .. ' Coke Baggies!')
                                    end
                                end
                            },
                        }
                    })
                    lib.showContext('coke_packaging')
                end
            }
        }
    })

    exports['qb-target']:AddTargetModel(extractGasoline, {
        options = {
            {
                label = 'Extract Gasoline',
                icon = 'fas fa-acid',
                targeticon = 'fas fa-eye',
                type = 'client',
                event = 'jc-drugs:client:extractGasoline'
            }
        }
    })

    local CementModel = "prop_cons_cements01"
    exports['qb-target']:AddTargetModel(CementModel, {
        options = {
            {
                label = 'Extract Cement',
                icon = 'fas fa-cement',
                targeticon = 'fas fa-eye',
                type = 'client',
                event = 'jc-drugs:client:extractCement'
            }
        }
    })

    local benzocaineModel = 'prop_air_cargo_01b'
    exports['qb-target']:AddTargetModel(benzocaineModel, {
        options = {
            {
                label = 'Search Box',
                icon = 'fas fa-cement',
                targeticon = 'fas fa-eye',
                type = 'client',
                event = 'jc-drugs:client:searchBenzocaine'
            }
        }
    })
end)
