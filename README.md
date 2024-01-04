# jc-drugs
 Discord for support: https://discord.gg/D28KxFJV
 Video: https://www.youtube.com/watch?v=zseVvzRYNrs&ab_channel=Jackyfied
 
Features;
================= WEED =================
- Add as many different weed seeds as you wish, including how long they take to grow!
- Place and grow weed anywhere, no more restricted just to be inside!

================= COKE =================
- Add several locations where you want the coke plants to grow
- Change the amount of items/rewards you get for different tasks
- Easily modifiable locations for processing!
- Easy adding more, less or different ingredients for coke processing!

================= Meth =================
- Add Several locations where to find Lithium Rocks and Extract them!
- Easy adding more, less or different ingredients for meth processing!
- Easily modifiable locations for processing, cooking and meth cracking!
- Gather Cement from cement bags
- Gather other items from other locations and objects!

Dependencies;
k-ui - https://github.com/KamuiKody/k-ui
qb-core - https://github.com/qbcore-framework/qb-core

================= Config File =================
```Config = Config or {}

Config.Weedbag = 'empty_weed_bag' -- The item used to put drugs in

---------------------------------------------------------[[WEED CONFIGURATION]]-----------------------------------------------------------------
Config.Leafblower = 'leaf_blower' -- Leaf Blower Item
Config.Fertilizer = 'weed_nutrition' -- Item for feeding the plants
Config.Water = 'water_bottle' -- Item for watering the plants

Config.MaxBaggies = 5 -- This should ALWAYS be set to the highest amount of weed you can collect from highest quality from any plant!

Config.Seeds = {
    {
        name = 'Skunk', -- Just the name of the weed plant
        item = 'weed_skunk_seed', -- The seed used to plant with
        reward = 'weed_skunk', -- The item you will get for harvesting the plant
        time = 300, -- How long it takes to move to stage 1
        stageInterval = 60, -- How much longere it takes for each stage so start is 5 minutes and it will add an extra 1 minute in next stage!
        lowQualityReward = 1, -- How much the plant will give if quality is 15% or below
        midQualityReward = math.random(1, 3), -- How much the plant will give if quality is 50% or above
        highQualityReward = math.random(3, 5) -- How much the plant will give if quality is 85% or above
    },
    {
        name = 'OG Kush',
        item = 'weed_og-kush_seed',
        reward = 'weed_og-kush',
        time = 300,
        stageInterval = 120,
        lowQualityReward = 1,
        midQualityReward = math.random(1, 3),
        highQualityReward = math.random(3, 5)
    },
    {
        name = 'White Widow',
        item = 'weed_white-widow_seed',
        reward = 'weed_white-widow',
        time = 360,
        stageInterval = 120,
        lowQualityReward = 1,
        midQualityReward = math.random(1, 3),
        highQualityReward = math.random(3, 5)
    },
    {
        name = 'Purple Haze',
        item = 'weed_purple-haze_seed',
        reward = 'weed_purple-haze',
        time = 480,
        stageInterval = 200,
        lowQualityReward = 1,
        midQualityReward = math.random(1, 3),
        highQualityReward = math.random(3, 5)
    },
    {
        name = 'AK47',
        item = 'weed_ak47_seed',
        reward = 'weed_ak47',
        time = 500,
        stageInterval = 150,
        lowQualityReward = 1,
        midQualityReward = math.random(1, 2),
        highQualityReward = math.random(2, 4)
    },
    {
        name = 'Amnesia',
        item = 'weed_amnesia_seed',
        reward = 'weed_amnesia',
        time = 600,
        stageInterval = 120,
        lowQualityReward = 1,
        midQualityReward = math.random(1, 2),
        highQualityReward = math.random(2, 3)
    },
}
------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------[[COKE CONFIGURATION]]-----------------------------------------------------------------
Config.CokePlant = 'prop_bush_dead_02' -- The model of the coke plants
Config.LeafItem = 'coca_leaf' -- The item you get from the plants
Config.LeafAmount = math.random(2, 4) -- How leafs you get from each plant

Config.GasolineAmount = math.random(1, 4) -- How much illegal gasoline can be extracted
Config.GasolineExtractItem = 'empty_jerry_can' -- Item required to extract gasoline
Config.GasolineMinExtactAmount = 4 -- Needs to be the maximum of what Config.GasolineAmount is set to.
Config.GasolineItem = 'gasoline' -- The item for Illegal Gasoline

Config.CementExtractAmount = math.random(2, 5) -- How much cement can be extracted from cement bag
Config.CementItem = "cement" -- The item used for cement

Config.CokePlantLoc = { -- The locations of the cokeplants to spawn at
    vector3(-2164.42, 5177.58, 14.93),
    vector3(-2178.75, 5177.67, 15.7),
    vector3(-2190.01, 5177.04, 15.3),
    vector3(-2188.29, 5191.62, 18.12),
    vector3(-2158.44, 5171.27, 13.76),
    vector3(-2161.61, 5161.26, 12.93),
    vector3(-2193.84, 5148.27, 11.03),
    vector3(-2199.09, 5141.53, 12.05),
    vector3(-2205.03, 5140.11, 12.12)
}

Config.CokeProcessing = vector3(1090.4, -3194.82, -38.99) -- Coke Processing location
Config.CokePacking = vector3(1100.86, -3198.78, -38.99) -- Where player will pack coke bricks
Config.CokeAmount = 50 -- How much coke baggies you get from processing, and also how many baggies required to have to process.
Config.CokeItem = 'cokebaggy'

Config.SmallPackageAmount = 100 -- How many grams of coke for a small coke brick
Config.BigPackageAmount = 500 -- How many grams of coke for a big coke brick
Config.SmallBrick = 'coke_small_brick' -- The item used for Small Coke Brick
Config.BigBrick = 'coke_brick' -- The item used for Coke Brick

Config.CokeProcessIngredients = { -- Ingredients used for coke processing
    {
        name = 'Coca Leafs',
        item = 'coca_leaf',
        amount = 3
    },
    {
        name = 'Illegal Gasoline',
        item = 'gasoline',
        amount = 1
    },
    {
        name = 'Cement',
        item = 'cement',
        amount = 3
    },
    {
        name = 'Benzocaine',
        item = 'benzocaine',
        amount = 2
    }
}

Config.BenzocaineItems = { -- What you can get from the boxes you also get benzocaine, if you only want people to find acetone, just only add Benzocaine!
    'benzocaine',
    'copper',
    'aluminum',
    'iron',
}
------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------[[METH CONFIGURATION]]-----------------------------------------------------------------
    Config.ExtractItem = 'empty_jerry_can' -- The item used to extract both Methylamine and Hydrochloric Acid
    
    Config.AcidAmount = math.random(1, 4) -- How much Hydrochloric acid can be extracted. Can be set to 1 number too.
    Config.MinExtractItems = 4 -- Has to be what the highest amount of Config.AcidAmount it set to

    Config.MethylamineAmount = math.random(1, 4) -- How much Methylamine can be extracted from 1 barrel
    Config.MinExtraItems2 = 4 -- Same as the 1st one just for Config.MethylamineAmount instead

    Config.AcidItem = 'hydrochloric_acid' -- The item used for Hydrochloric Acid
    Config.MethylamineItem = 'methylamine' -- The item used for Methylamine
    Config.AcetoneItem = 'acetone' -- The item used for Acetone
    Config.LithiumItem = 'lithium' -- The item used for Lithium
    Config.ProcessedMethItem = 'meth_processed' -- The item used for Processed Item
    Config.MethTrayItem = 'methtray' -- The item used for Meth Tray
    Config.MethItem = 'meth' -- The item used for the meth itself

    Config.LithiumMaxExtract = 3 -- How much lithium you can get from each stone
    Config.LithiumChance = 100 -- How big a percentage to get lithium from the rocks!

    Config.ProcessedCokeAmount = math.random(3, 8) -- How much processed meth to get
    Config.MethAmount = math.random(5, 25) -- How much meth you get from cracking one tray

    Config.MethCookingTime = 30 -- How long cooking is in seconds..

    Config.Ingredients = { -- These are the ingredients for the processed meth!
        {
            item = Config.AcidItem,
            amount = 3,
        },
        {
            item = Config.MethylamineItem,
            amount = 2
        },
        {
            item = Config.AcetoneItem,
            amount = 4
        },
        {
            item = Config.LithiumItem,
            amount = 6
        },
    }

    Config.Trowel = 'trowel' -- Item used for gathering Lithium!
    Config.LithiumItems = { -- Items which can be archieved from picking up lithium rocks(So it's not always only lithium if you want it to only be lithium remove everything but lithium)
        'lithium',
        'copper',
        'aluminum',
        'iron',
    }

    Config.AcetoneItems = { -- What you can get from the boxes you also get acetone, if you only want people to find acetone, just only add Acetone!
        'acetone',
        'copper',
        'aluminum',
        'iron',
    }

    Config.LithiumLoc = { -- Locations for the lithium Rocks
        vector3(2831.16, -629.3, 1.96),
        vector3(2832.03, -636.05, 1.87),
        vector3(2825.8, -641.07, 1.92),
        vector3(2820.53, -639.92, 2.19),
        vector3(2818.22, -632.33, 2.5),
        vector3(2816.49, -624.55, 2.67),
        vector3(2815.17, -615.55, 2.73),
        vector3(2821.74, -610.34, 1.93),
        vector3(2808.3, -619.48, 3.33),
        vector3(2802.08, -634.58, 3.64),
        vector3(2813.22, -646.08, 2.44),
        vector3(2821.25, -648.15, 1.93),
        vector3(2831.18, -649.39, 1.72)
    }

    Config.MethProcession = vector3(1004.6, -3194.93, -38.99) -- Where you process the coke!
    Config.MethCooking = vector3(1003.84, -3202.54, -38.99) -- Where you coook the meth!
    Config.MethPicking = vector3(1012.02, -3194.96, -38.99) -- Where you crack the meth!

------------------------------------------------------------------------------------------------------------------------------------------------```
