local QBCore = exports['qb-core']:GetCoreObject()

for _, s in pairs(Config.Seeds) do
    QBCore.Functions.CreateUseableItem(s.item, function(source, item)
        TriggerClientEvent('jc-drugs:client:plantweed', source, s.item, s.name, s.reward, s.time, s.stageInterval, s.lowQualityReward, s.midQualityReward, s.highQualityReward, nil)
    end)
end

RegisterServerEvent('jc-drugs:server:removeSeed')
AddEventHandler('jc-drugs:server:removeSeed', function(seed)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    Player.Functions.RemoveItem(seed, 1)
    TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items[seed], 'remove')
end)

RegisterServerEvent('jc-drugs:server:removeitem')
AddEventHandler('jc-drugs:server:removeitem', function(item)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    Player.Functions.RemoveItem(item, 1)
    TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items[item], 'remove')
end)

RegisterServerEvent('jc-drugs:server:giveWeed')
AddEventHandler('jc-drugs:server:giveWeed', function(reward, amount)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local baggy = Player.Functions.GetItemByName(Config.Weedbag)

    if baggy and baggy.amount >= amount then
        Player.Functions.AddItem(reward, amount)
        Player.Functions.RemoveItem(baggy, amount)
        TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items[reward], 'add')
        TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items[baggy], 'remove')
    else
        QBCore.Functions.Notify(src, 'You don\'t have enough bags!', 'error', 3000)
    end
end)

RegisterServerEvent('jc-drugs:server:giveCokeLeafs')
AddEventHandler('jc-drugs:server:giveCokeLeafs', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    Player.Functions.AddItem(Config.LeafItem, Config.LeafAmount)
    TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items[Config.LeafItem], 'add')
end)

RegisterServerEvent('jc-drugs:server:givecoke')
AddEventHandler('jc-drugs:server:givecoke', function(ingredients)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    for _, i in pairs(ingredients) do
        Player.Functions.RemoveItem(i.item, i.amount)
        TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items[i.item], 'remove')
    end

    Player.Functions.AddItem(Config.CokeItem, Config.CokeAmount)
    TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items[Config.CokeItem], 'add')

    Player.Functions.RemoveItem(Config.Weedbag, Config.CokeAmount)
    TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items[Config.Weedbag], 'remove')
end)

RegisterServerEvent('jc-drugs:server:removecokeitems')
AddEventHandler('jc-drugs:server:removecokeitems', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    
    for _, i in pairs(ingredients) do
        Player.Functions.RemoveItem(i.item, i.amount)
        TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items[i.item], 'remove')
    end
end)

RegisterServerEvent('jc-drugs:server:givebrick')
AddEventHandler('jc-drugs:server:givebrick', function(item, reward, amount)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    Player.Functions.RemoveItem(item, amount)
    Player.Functions.AddItem(reward, 1)
    TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items[reward], 'add')
    TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items[item], 'remove')
end)

RegisterServerEvent('jc-drugs:server:removedrugs')
AddEventHandler('jc-drugs:server:removedrugs', function(item, amount)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    Player.Functions.RemoveItem(item, amount)
    TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items[item], 'remove')
end)

RegisterServerEvent('jc-drugs:server:giveacid')
AddEventHandler('jc-drugs:server:giveacid', function(amount)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local jerrycan = Player.Functions.GetItemByName(Config.ExtractItem)

    if jerrycan and jerrycan.amount >= amount then
        Player.Functions.AddItem(Config.AcidItem, amount)
        Player.Functions.RemoveItem(Config.ExtractItem, amount)
        TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items[Config.AcidItem], 'add')
        TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items[Config.ExtractItem], 'remove')
    else
        QBCore.Functions.Notify('You need atleast ' .. amount .. ' Empty jerry cans!', 'error', 3000)
    end
end)

RegisterServerEvent('jc-drugs:server:givemethylamine')
AddEventHandler('jc-drugs:server:givemethylamine', function(amount)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local jerrycan = Player.Functions.GetItemByName(Config.ExtractItem)

    if jerrycan and jerrycan.amount >= amount then
        Player.Functions.AddItem(Config.MethylamineItem, amount)
        Player.Functions.RemoveItem(Config.ExtractItem, amount)
        TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items[Config.MethylamineItem], 'add')
        TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items[Config.ExtractItem], 'remove')
    else
        QBCore.Functions.Notify('You need atleast ' .. amount .. ' Empty jerry cans!', 'error', 3000)
    end
end)

RegisterServerEvent('jc-drugs:server:givegasoline')
AddEventHandler('jc-drugs:server:givegasoline', function(amount)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local jerrycan = Player.Functions.GetItemByName(Config.ExtractItem)

    if jerrycan and jerrycan.amount >= amount then
        Player.Functions.AddItem(Config.GasolineItem, amount)
        Player.Functions.RemoveItem(Config.GasolineExtractItem, amount)
        TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items[Config.GasolineItem], 'add')
        TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items[Config.GasolineExtractItem], 'remove')
    else
        QBCore.Functions.Notify('You need atleast ' .. amount .. ' Empty jerry cans!', 'error', 3000)
    end
end)

RegisterServerEvent('jc-drugs:server:givecement')
AddEventHandler('jc-drugs:server:givecement', function(amount)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    Player.Functions.AddItem(Config.CementItem, amount)
    TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items[Config.CementItem], 'add')
end)

RegisterServerEvent('jc-drugs:server:givelithium')
AddEventHandler('jc-drugs:server:givelithium', function(amount)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local chance = math.random(1, 100)

    local item1 = Config.LithiumItems[math.random(1, #Config.LithiumItems)]
    local item2 = Config.LithiumItems[math.random(1, #Config.LithiumItems)]
    
    if chance <= 50 then
        Player.Functions.AddItem(item1, math.random(1, 3))
        Player.Functions.AddItem(item2, math.random(1, 3))
        TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items[item1], 'add')
        TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items[item2], 'add')
    else
        Player.Functions.AddItem(item1, math.random(1, 2))
        TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items[item1], 'add')
    end
end)

RegisterServerEvent('jc-drugs:server:methprocession')
AddEventHandler('jc-drugs:server:methprocession', function(action)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    if action == "processed" then
        local hasIngredients = false

        for _, i in pairs(Config.Ingredients) do
            local hasItem = Player.Functions.GetItemByName(i.item)
    
            if not hasItem or hasItem.amount < i.amount then
                hasIngredients = false
                break
            else
                hasIngredients = true
                Player.Functions.RemoveItem(i.item, i.amount)
                TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items[i.item], 'remove')
            end
        end
    
        if hasIngredients then
            Player.Functions.AddItem(Config.ProcessedMethItem, Config.ProcessedCokeAmount)
            TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items[Config.ProcessedMethItem], 'add')
        else
            QBCore.Functions.Notify(src, 'You are missing some ingredients!')
        end
    elseif action == "cook" then
        local hasItem = Player.Functions.GetItemByName(Config.ProcessedMethItem)

        Player.Functions.RemoveItem(Config.ProcessedMethItem, 1)
        TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items[Config.ProcessedMethItem], 'remove')

        Player.Functions.AddItem(Config.MethTrayItem, 1)
        TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items[Config.MethTrayItem], 'add')
    elseif action == "cracking" then
        local hasItem = Player.Functions.GetItemByName(Config.ProcessedMethItem)

        Player.Functions.RemoveItem(Config.MethTrayItem, 1)
        TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items[Config.MethTrayItem], 'remove')

        Player.Functions.AddItem(Config.MethItem, Config.MethAmount)
        TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items[Config.MethItem], 'add')
    elseif acton == "failedprocession" then
        local hasIngredients = false

        for _, i in pairs(Config.Ingredients) do
            local hasItem = Player.Functions.GetItemByName(i.item)
    
            if not hasItem or hasItem.amount < i.amount then
                hasIngredients = false
                QBCore.Functions.Notify(src, 'You don\'t have enough ingredients!', 'error', 3000)
                break
            else
                hasIngredients = true
                Player.Functions.RemoveItem(i.item, i.amount)
                TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items[i.item], 'remove')
            end
        end
    elseif acton == "failedcooking" then
        local hasItem = Player.Functions.GetItemByName(Config.ProcessedMethItem)
    
        if not hasItem or hasItem.amount < 1 then
            hasIngredients = false
            QBCore.Functions.Notify(src, 'You don\'t have enough ingredients!', 'error', 3000)
        else
            hasIngredients = true
            Player.Functions.RemoveItem(Config.ProcessedMethItem, 1)
            TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items[Config.ProcessedMethItem], 'remove')
        end
    elseif acton == "failedcracking" then
        local hasItem = Player.Functions.GetItemByName(Config.MethTrayItem)
    
        if not hasItem or hasItem.amount < 1 then
            hasIngredients = false
            QBCore.Functions.Notify(src, 'You don\'t have enough ingredients!', 'error', 3000)
        else
            hasIngredients = true
            Player.Functions.RemoveItem(Config.MethTrayItem, 1)
            TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items[Config.MethTrayItem], 'remove')
        end
    end
end)

RegisterServerEvent('jc-drugs:server:givecardboarditem')
AddEventHandler('jc-drugs:server:givecardboarditem', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local chance = math.random(1, 100)

    local item1 = Config.AcetoneItems[math.random(1, #Config.AcetoneItems)]
    local item2 = Config.AcetoneItems[math.random(1, #Config.AcetoneItems)]
    
    if chance <= 50 then
        Player.Functions.AddItem(item1, math.random(1, 3))
        Player.Functions.AddItem(item2, math.random(1, 3))
        TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items[item1], 'add')
        TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items[item2], 'add')
    else
        Player.Functions.AddItem(item1, math.random(1, 2))
        TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items[item1], 'add')
    end
end)

RegisterServerEvent('jc-drugs:server:givebenzo')
AddEventHandler('jc-drugs:server:givebenzo', function(amount)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local chance = math.random(1, 100)

    local item1 = Config.BenzocaineItems[math.random(1, #Config.BenzocaineItems)]
    local item2 = Config.BenzocaineItems[math.random(1, #Config.BenzocaineItems)]
    
    if chance <= 50 then
        Player.Functions.AddItem(item1, math.random(1, 3))
        Player.Functions.AddItem(item2, math.random(1, 3))
        TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items[item1], 'add')
        TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items[item2], 'add')
    else
        Player.Functions.AddItem(item1, math.random(1, 2))
        TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items[item1], 'add')
    end
end)
