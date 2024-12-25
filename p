print("Uruchamianie suko")

if game.PlaceId == game.PlaceId then
    local start = tick()
    repeat task.wait() until game:isLoaded()
    repeat task.wait() until game:GetService("Players")
    repeat task.wait() until game:GetService("Players").LocalPlayer
    repeat task.wait() until game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    repeat task.wait() until game:GetService("Players").LocalPlayer.PlayerGui.Main.Enabled
    repeat task.wait() until game:GetService("Workspace"):FindFirstChild('__MAP')
end

-- ANTIAFK
local GC = getconnections or get_signal_cons
if GC then
    for i,v in pairs(GC(game.Players.LocalPlayer.Idled)) do
        if v["Disable"] then
            v["Disable"](v)
        elseif v["Disconnect"] then
            v["Disconnect"](v)
        end
    end
else
    local vu = game:GetService("VirtualUser")
    game:GetService("Players").LocalPlayer.Idled:connect(function()
        vu:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
        wait(1)
        vu:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
    end)
end

-- Bypass
local Client = require(game.ReplicatedStorage.Library.Client)
local Library = require(game.ReplicatedStorage.Library)
local set_con = syn_context_set or setthreadcontext
local SaveModule = require(game:GetService("ReplicatedStorage").Library.Client.Save)
local ChatMsg = require(game:GetService("ReplicatedStorage").Library.Client.ChatMsg)

-- Thanks Message
set_con(2)
--Library.Message.New("Thanks for buying my script \nDeveloper: \n!yomamale2")
set_con(8)

-- Library
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Creating Window
local Window = Rayfield:CreateWindow({
   Name = "KSD Pet Simulator X",
   LoadingTitle = "KSD Team",
   LoadingSubtitle = "by !yomamale2",
   ConfigurationSaving = {Enabled = true, FolderName = "KSD", FileName = "PetSimulatorXNew"},
   Discord = {Enabled = true, Invite = "", RememberJoins = true}
   })

--Client.Network.Invoke('Name', Args)
--Client.Network.Fire('Name', Args)

debug.setupvalue(Client.Network.Invoke, 1, function() return true end)
debug.setupvalue(Client.Network.Fire, 1, function() return true end)


-- Locales

local EnchantsList_OLD = {
    'Magnet',
    'Royalty',
    'Glittering',
    'Tech Coins',
    'Rainbow Coins',
    'Fantasy Coins',
    'Coins',
    'Teamwork',
    'Diamonds',
    'Strength',
    'Chests',
    'Presents',
    'Agility',
    'Charm',
    'Gifts'
}

local MethodList = {'Normal', 'Chest', "Multi Target (Only Donator)", 'Multi Target', 'Lowest Value (Only Donator)', 'Lowest Value (Multi)', 'Highest Value', 'Highest Value (Multi)'}

local AreaListLoc = {
    -- Spawn
    'VIP'; 'Town'; 'Forest'; 'Beach'; 'Mine'; 'Winter'; 'Glacier'; 'Desert'; 'Volcano';

    -- Fantasy
    'Enchanted Forest'; 'Ancient Island'; 'Samurai Island'; 'Candy Island'; 'Haunted Island'; 'Hell Island'; 'Heaven Island'; 'Heavens Gate';

    -- Tech
    'Ice Tech'; 'Tech City'; 'Dark Tech'; 'Steampunk'; "Alien Lab"; "Alien Forest"; "Glitch"; "Hacker Portal";

    -- Axolotl Ocean
    "Axolotl Ocean"; "Axolotl Deep Ocean"; "Axolotl Cave";

    -- Pixel
    "Pixel Forest"; "Pixel Kyoto"; "Pixel Alps"; "Pixel Vault";

    -- Cat World
    "Cat Paradise"; "Cat Backyard"; "Cat Taiga"; "Cat Kingdom"; "Cat Throne Room";
    
    -- Doodle World
    "Doodle Meadow"; "Doodle Peaks"; "Doodle Farm"; "Doodle Oasis"; "Doodle Woodlands"; "Doodle Safari"; "Doodle Fairyland"; "Doodle Cave"; "Doodle Barn";
    
    -- Kawaii World
    "Kawaii Village"; "Kawaii Temple"; "Kawaii Tokyo"; "Kawaii Candyland"; "Kawaii Dojo";

    -- Dog World
    "Dog Park"; "Dog City"; "Dog Firehouse"; "Dog Mansion"; 
}

local GuiList = {
    'Collection'; 'FusePets'; 'Golden'; 'Rainbow'; 'DarkMatter'; 'Merchant'; 'EnchantPets';
    'Upgrades'; 'Bank'; 'Daycare'; 'Mailbox'; 'HugeMachine';
}

local CurrencyList = {}
for icur,vcur in pairs(game:GetService("Players").LocalPlayer.PlayerGui.Main.Right:GetChildren()) do
	if not string.match(vcur.Name, 2) and string.match(vcur.Name, "Coins") or vcur.Name == "Diamonds" then
		table.insert(CurrencyList, vcur.Name)
	end
end

local EggsList = {} 
for i,v in pairs(game:GetService("ReplicatedStorage")["__DIRECTORY"].Eggs:GetChildren()) do
    if v:IsA("Folder") then
        for i2,v2 in pairs(v:GetChildren()) do 
            table.insert(EggsList, v2.Name)
        end
        table.sort(EggsList)
    end
end  


local IDToName = {}
local PettoRarity = {}
local a = Library.Directory.Pets
for i, v in pairs(a) do
    PettoRarity[i] = v.rarity
    IDToName[i] = v.name
end


local IDToNamePets = {}
local NameToIDPets = {}
local PettoRarityPets = {}
local RarityTablePets = {}
local PetNamesTablePets = {}

for i,v in pairs(Library.Directory.Pets) do
    IDToNamePets[i] = v.name
    NameToIDPets[v.name] = i
    PettoRarityPets[i] = v.rarity
    if not table.find(RarityTablePets, v.rarity) then
        table.insert(RarityTablePets, v.rarity)
    end
    table.insert(PetNamesTablePets, v.name)
    table.sort(PetNamesTablePets)
end

-- Functions

function SecondsToClock(seconds) 
    local days = math.floor(seconds / 86400)
    seconds = seconds - days * 86400
    local hours = math.floor(seconds / 3600 )
    seconds = seconds - hours * 3600
    local minutes = math.floor(seconds / 60) 
    seconds = seconds - minutes * 60
    return string.format("%d d, %d h, %d m, %d s.",days,hours,minutes,seconds)
end

function OpenEgg(SelectedEgg, TriplePass, OctuplePass)
    local LocalPlayer = game:GetService("Players").LocalPlayer
    local HumanoidRootPart = LocalPlayer.Character:WaitForChild("HumanoidRootPart")
    local LocalPlayerPosition = HumanoidRootPart.Position
    local WorkspaceEggs = workspace:WaitForChild('__MAP'):WaitForChild('Eggs')
    local Egg
    local GetEgg

    for i,v in pairs(WorkspaceEggs:GetChildren()) do
        if string.find(v.Name, SelectedEgg) then
            Egg = v
        end
    end
    
    GetEgg = Egg['Eggs']["Egg Capsule"].Egg

    if (LocalPlayerPosition - GetEgg.Position).magnitude > 50 then
        HumanoidRootPart.CFrame = CFrame.new(GetEgg.Position)
    else
        Client.Network.Invoke('Buy Egg', SelectedEgg, TriplePass, OctuplePass)
    end
end

function GetCoins(Area)
    local Coins = {}
    for i,v in next, Client.Network.Invoke('Get Coins') do 
        if v.a == Area then 
            Coins[i] = v
        end 
    end 
    return Coins
end

function FarmCoin(Coin, Pet)
    Client.Network.Invoke('Join Coin', Coin, {Pet})
    Client.Network.Fire('Farm Coin', Coin, Pet)
end

function GetSortedCoins(Area, Type)
    local CoinTable = GetCoins(Area)
    local function getKeysSortedByValue(tbl, sortFunction)
        local keys = {}
        for key in pairs(tbl) do
            table.insert(keys, key)
        end
        table.sort(
            keys,
            function(a, b)
                return sortFunction(tbl[a].h, tbl[b].h)
            end
        )
        return keys
    end
    
    local sortedKeys
    if Type == 'Highest' then
        sortedKeys = getKeysSortedByValue(CoinTable, function(a, b) return a > b end)
    elseif Type == 'Lowest' then
        sortedKeys = getKeysSortedByValue(CoinTable, function(a, b) return a < b end)
    end

    local newCoinTable = {}
    for i, key in ipairs(sortedKeys) do
        newCoinTable[key] = CoinTable[key]
    end

    return newCoinTable
end

function HatchEgg(Pet)
    local state = ''
    if string.find(Pet, 'Golden') then 
        state = 'gold'
        Pet = string.gsub(Pet, 'Golden ', '')
    elseif string.find(Pet, 'Rainbow') then 
        state = 'rainbow'
        Pet = string.gsub(Pet, 'Rainbow ', '')
    elseif string.find(Pet, 'Dark Matter') then
        state = 'darkmatter'
        Pet = string.gsub(Pet, 'Dark Matter ', '')
    else 
        state = 'normal'
    end
    local pet = Pet
    for i,v in pairs(Library.Directory.Pets) do
        if string.split(tostring(v), ' - ')[2] == pet then
            pet = string.split(tostring(v), ' - ')[1]
        end
    end
    local tbl = {
        {
        nk = 'Preston',
        idt = '69',
        e = false,
        uid = '69',
        s = 999999999999,
        rarity = 'Exclusive',
        id = pet,
    }}
    local g_tbl = {
        {
        nk = 'Preston',
        idt = '69',
        e = false,
        g = true,
        uid = '69',
        s = 999999999999,
        rarity = 'Exclusive',
        id = pet,
    }} 
    local r_tbl = {
        {
        nk = 'Preston',
        idt = '69',
        e = false,
        r = true,
        uid = '69',
        rarity = 'Exclusive',
        s = 999999999999,
        id = pet,
    }}
    local dm_tbl = {
        {
        nk = 'Preston',
        idt = '69',
        e = false,
        dm = true,
        rarity = 'Exclusive',
        uid = '69',
        s = 999999999999,
        id = pet,
    }} 
    local egg
    for i_,script in pairs(game:GetService("ReplicatedStorage")["__DIRECTORY"].Eggs:GetDescendants()) do
        if script:IsA('ModuleScript') then
            if typeof(require(script).drops) == 'table' then
                for i,v in pairs(require(script).drops) do
                    if v[1] == pet then
                        egg = require(script).displayName
                    end
                end
            end
        end
    end
    if Pet == 'Huge Pegasus' then
        egg = 'Cracked Egg'
    elseif Pet == 'Huge Cat' then
        egg = 'Cracked Egg'
    elseif Pet == 'Huge Santa Paws' then
        egg = 'Cracked Egg'
    elseif Pet == 'Huge Forest Wyvern' then
        egg = 'Cracked Egg'
    elseif Pet == 'Huge Gargoyle Dragon' then
        egg = 'Cracked Egg'
    elseif Pet == 'Huge Lucky Cat' then
        egg = 'Cracked Egg'
    elseif Pet == 'Huge Cupcake' then
        egg = 'Cracked Egg'
    elseif Pet == 'Huge Dog' then
        egg = 'Cracked Egg'
    elseif Pet == 'Huge Dragon' then
        egg = 'Cracked Egg'
    elseif Pet == 'Huge Pony' then
        egg = 'Cracked Egg'
    elseif Pet == 'Huge Storm Agony' then
        egg = 'Cracked Egg'
    elseif Pet == 'Huge Super Corgi' then
        egg = 'Cracked Egg'
    elseif Pet == 'Huge Rainbow Unicorn' then
        egg = 'Cracked Egg'
    elseif Pet == 'Huge Easter Cat' then
        egg = 'Cracked Egg'
    elseif Pet == 'Huge Party Cat' then
        egg = 'Cracked Egg'
    elseif Pet == 'Huge Cyborg Capybara' then
        egg = 'Cracked Egg'
    elseif Pet == 'Huge Hell Rock' then
        egg = 'Cracked Egg'
    elseif Pet == 'Huge Enchanted Deer' then
        egg = 'Cracked Egg'
    elseif Pet == 'Huge Samurai Bull' then
        egg = 'Cracked Egg'
    elseif Pet == 'Huge Chest Mimic' then
        egg = 'Cracked Egg'
    elseif Pet == 'Huge Floppa' then
        egg = 'Cracked Egg'
    elseif Pet == 'Huge Sleipnir' then
        egg = 'Cracked Egg'
    elseif Pet == 'Huge Nightfall Pegasus' then
        egg = 'Cracked Egg'
    elseif Pet == 'Huge Nightfall Wolf' then
        egg = 'Cracked Egg'
    elseif Pet == 'Huge Crystal Dog' then
        egg = 'Cracked Egg'
    elseif Pet == 'Huge Mosaic Griffin' then
        egg = 'Cracked Egg'
    elseif Pet == 'Huge Mosaic Corgi' then
        egg = 'Cracked Egg'
    elseif Pet == 'Huge Tiedye Corgi' then
        egg = 'Cracked Egg'
    elseif Pet == 'Huge Tiedye Cat' then
        egg = 'Cracked Egg'
    end
    for i,v in pairs(getgc(true)) do
        if (typeof(v) == 'table' and rawget(v, 'OpenEgg')) then
            if state == 'normal' then
                v.OpenEgg(egg, tbl)
            else 
                if state == 'gold' then 
                    v.OpenEgg(egg, g_tbl)
                elseif state == 'rainbow' then 
                    v.OpenEgg(egg, r_tbl) 
                elseif state == 'darkmatter' then 
                    v.OpenEgg(egg, dm_tbl)
                end 
            end 
        end
    end
end


function GetPets()
    return Client.PetCmds.GetEquipped()
end 


function GetAllMyPets()
    local MyPets = {}
    for i,v in pairs(SaveModule.Get().Pets) do
        --if (not getgenv().AllowMythicals) or (getgenv().AllowMythicals and (PettoRarity[v.id] ~= 'Mythical' and PettoRarity[v.id] ~= 'Exclusive' and not string.find(IDToName[v.id]:lower(), "maskot"))) then
            local ThingyThingyTempTypeThing = (v.g and 'Gold') or (v.r and 'Rainbow') or (v.dm and 'Dark Matter') or 'Normal'
            local TempString = ThingyThingyTempTypeThing .. IDToName[v.id]
            if MyPets[TempString] then
                table.insert(MyPets[TempString], v.uid)
            else
                MyPets[TempString] = {}
                table.insert(MyPets[TempString], v.uid)
            end
        --end
    end
    return MyPets
end

-- Colectables
for i,v in pairs(workspace.__THINGS.Orbs:GetChildren()) do 
    Client.Network.Fire('Claim Orbs', {v.Name})
end 
game.Workspace["__THINGS"].Orbs.ChildAdded:Connect(function(vorb)
    Client.Network.Fire('Claim Orbs', {vorb.Name})
end)
for i,v in pairs(game.Workspace["__THINGS"].Lootbags:GetChildren()) do
    if v:IsA("MeshPart") then
          v.Position = game.Players.LocalPlayer.Character.HumanoidRootPart.Position
    end
end
game.Workspace["__THINGS"].Lootbags.ChildAdded:Connect(function(vloot)
    if vloot:IsA("MeshPart") then
        repeat wait(0.5)
            vloot.Position = game.Players.LocalPlayer.Character.HumanoidRootPart.Position
        until not game.Workspace["__THINGS"].Lootbags:FindFirstChild(vloot.Name)
    end
end)

-- Creators Page
local Authors = Window:CreateTab("Authors", 7956021367)
Authors:CreateParagraph({Title = "Developer", Content = "!yomamale2 - Poland"})
Authors:CreateButton({Name = "Discord Server", Callback = function()
    pcall(function()
        local http = game:GetService('HttpService') 
        local req = (syn and syn.request) or (http and http.request) or http_request
        if req then
            req({
                Url = 'http://127.0.0.1:6463/rpc?v=1',
                Method = 'POST',
                Headers = {
                   ['Content-Type'] = 'application/json',
                   Origin = ''
                },
                Body = http:JSONEncode({
                   cmd = 'INVITE_BROWSER',
                   nonce = http:GenerateGUID(false),
                   args = {code = '3FV3qCMkU2'}
                })
            })
        end
    end)
    setclipboard('')
end})


-- Farming Sections
local Farming = Window:CreateTab("Farming", 7956020621)
local Farming1 = Farming:CreateSection("Farming")



Farming:CreateDropdown({Name = "Select Area", Options = AreaListLoc, CurrentOption = {"Select"}, MultipleOptions = false, Flag = "AutoFarmAreaFlag", Callback = function(areafunc)
    for _,area in pairs(areafunc) do
        getgenv().SelectedArea = area
    end
end})


Farming:CreateDropdown({Name = "Select Method", Options = MethodList, CurrentOption = {"Select"}, MultipleOptions = false, Flag = "AutoFarmMethodFlag", Callback = function(methodfunc)
    for _,method in pairs(methodfunc) do
        getgenv().SelectedMethod = method
    end
end})

Farming:CreateToggle({Name = "AutoFarm", CurrentValue = false, Flag = "AutoFarmToggle", Callback = function(autofarmfunc)
    if autofarmfunc == true then
        getgenv().AutoFarm = true
    elseif autofarmfunc == false then
        getgenv().AutoFarm = false
    end
    
    local Pets = GetPets()
    local CurrentFarmingPets = {}
    
    while task.wait() and getgenv().AutoFarm do
        if getgenv().SelectedMethod == "Normal" then
            
            local Coins = GetCoins(getgenv().SelectedArea)
            for i,v in next, Coins do
                if workspace.__THINGS.Coins:FindFirstChild(i) and getgenv().AutoFarm then 
                    for _,Pet in next, Pets do 
                        spawn(function()
                            if getgenv().AutoFarm then
                                FarmCoin(i, Pet.uid)
                            end
                        end)
                    end 
                end 
                repeat task.wait() until not workspace.__THINGS.Coins:FindFirstChild(i) or not getgenv().AutoFarm
            end
        
        elseif getgenv().SelectedMethod == "Lowest Value (Multi)" then
            
            local Coins = GetSortedCoins(getgenv().SelectedArea, "Lowest")
            local numberOfPets = #Pets
            local currentPetIndex = 1
            
            for i, v in next, Coins do
                if workspace.__THINGS.Coins:FindFirstChild(i) and getgenv().AutoFarm then
                    local Pet = Pets[currentPetIndex]
                    spawn(function()
                        if getgenv().AutoFarm then
                            FarmCoin(i, Pet.uid)
                        end
                    end)
                    task.wait(0.5)
                    currentPetIndex = currentPetIndex % numberOfPets + 1
                end
            end
        
        elseif getgenv().SelectedMethod == "Lowest Value (Only Donator)" then
            --local hwidListDonator = loadstring(game:HttpGet('https://raw.githubusercontent.com/KrystekYTpv/AJOVFusfvboasjfbosfpoazsfnasfafa/main/hwidListDonator.lua', true))()
            --local HwidCheck = tostring(game:GetService("RbxAnalyticsService"):GetClientId())
            --if table.find(hwidListDonator,HwidCheck) then
                local Coins = GetSortedCoins(getgenv().SelectedArea, "Lowest")
                for i,v in next, Coins do
                    if workspace.__THINGS.Coins:FindFirstChild(i) and getgenv().AutoFarm then 
                        for _,Pet in next, Pets do 
                            spawn(function()
                                if getgenv().AutoFarm then
                                    FarmCoin(i, Pet.uid)
                                end
                            end)
                        end 
                    end 
                    repeat task.wait() until not workspace.__THINGS.Coins:FindFirstChild(i) or not getgenv().AutoFarm
                end
            --else
            --   game:Shutdown() 
            --end
          
        elseif getgenv().SelectedMethod == "Highest Value" then
            
            local Coins = GetSortedCoins(getgenv().SelectedArea, "Highest")
            for coinId, coinData in pairs(Coins) do
                if workspace.__THINGS.Coins:FindFirstChild(coinId) and getgenv().AutoFarm then 
                    for _, Pet in next, Pets do 
                        spawn(function()
                            if getgenv().AutoFarm then
                                FarmCoin(coinId, Pet.uid)
                            end
                        end)
                    end 
                end 
                repeat task.wait() until not workspace.__THINGS.Coins:FindFirstChild(coinId) or not getgenv().AutoFarm
            end

        elseif getgenv().SelectedMethod == "Highest Value (Multi)" then
            
            local Coins = GetSortedCoins(getgenv().SelectedArea, "Highest")
            local numberOfPets = #Pets
            local currentPetIndex = 1
            
            for i, v in next, Coins do
                if workspace.__THINGS.Coins:FindFirstChild(i) and getgenv().AutoFarm then
                    local Pet = Pets[currentPetIndex]
                    spawn(function()
                        if getgenv().AutoFarm then
                            FarmCoin(i, Pet.uid)
                        end
                    end)
                    task.wait(0.5)
                    currentPetIndex = currentPetIndex % numberOfPets + 1
                end
            end
            
        elseif getgenv().SelectedMethod == "Multi Target" then
            
            local Coins = GetCoins(getgenv().SelectedArea)
            local numberOfPets = #Pets
            local currentPetIndex = 1
            
            for i, v in next, Coins do
                if workspace.__THINGS.Coins:FindFirstChild(i) and getgenv().AutoFarm then
                    local Pet = Pets[currentPetIndex]
                    spawn(function()
                        if getgenv().AutoFarm then
                            FarmCoin(i, Pet.uid)
                        end
                    end)
                    task.wait(0.5)
                    currentPetIndex = currentPetIndex % numberOfPets + 1
                end
            end
        
        elseif getgenv().SelectedMethod == "Multi Target (Only Donator)" then
            --local hwidListDonator = loadstring(game:HttpGet('https://raw.githubusercontent.com/KrystekYTpv/AJOVFusfvboasjfbosfpoazsfnasfafa/main/hwidListDonator.lua', true))()
            --local HwidCheck = tostring(game:GetService("RbxAnalyticsService"):GetClientId())
            --if table.find(hwidListDonator,HwidCheck) then
                local Coins = GetCoins(getgenv().SelectedArea)
                local numberOfPets = #Pets
                local currentPetIndex = 1

                for i, v in next, Coins do
                    if workspace.__THINGS.Coins:FindFirstChild(i) and getgenv().AutoFarm then
                        local Pet = Pets[currentPetIndex]
                        spawn(function()
                            if getgenv().AutoFarm then
                                FarmCoin(i, Pet.uid)
                            end
                        end)
                        task.wait(0.25)
                        currentPetIndex = currentPetIndex % numberOfPets + 1
                    end
                end
            --else
            --   game:Shutdown() 
            --end
        end
    end
end})


-- Farming Addons
local Farming2 = Farming:CreateSection("Farming Addons")

Farming:CreateToggle({Name = "Auto Triple Damage", CurrentValue = false, Flag = "AutoTripleDamageFlag", Callback = function(autotripledamage)
    if autotripledamage == true then
        getgenv().TripleDamage = true
    elseif autotripledamage == false then
        getgenv().TripleDamage = false
    end
    
    while wait(2) and getgenv().TripleDamage do
        if not game:GetService("Players").LocalPlayer.PlayerGui.Main.Boosts:FindFirstChild("Triple Damage") then
            Client.Network.Fire('Activate Boost', "Triple Damage")
        end
    end
end})

Farming:CreateToggle({Name = "Auto Triple Coins", CurrentValue = false, Flag = "AutoTripleCoinsFlag", Callback = function(autotriplecoins)
    if autotriplecoins == true then
        getgenv().TripleCoins = true
    elseif autotriplecoins == false then
        getgenv().TripleCoins = false
    end
    
    while wait(2) and getgenv().TripleCoins do
        if not game:GetService("Players").LocalPlayer.PlayerGui.Main.Boosts:FindFirstChild("Triple Coins") then
            Client.Network.Fire('Activate Boost', "Triple Coins")
        end
    end
end})


-- Eggs Sections
local Eggs = Window:CreateTab("Eggs", 7956020976)
local Eggs1 = Eggs:CreateSection("Open Eggs")

Eggs:CreateDropdown({Name = "Select Egg", Options = EggsList, CurrentOption = {"Select"}, MultipleOptions = false, Flag = "SelectedEggAutoFlag", Callback = function(selectegg)
    for _,egg in pairs(selectegg) do
        getgenv().SelectedEggOpen = egg
    end
end})

Eggs:CreateButton({Name = "Check Opened Eggs", Callback = function()
    local CheckOpenEgg = getgenv().SelectedEggOpen
    local CountEggs = SaveModule.Get().EggsOpened[CheckOpenEgg] or 0
    set_con(2)
    --Library.Message.New(tostring(CheckOpenEgg).."\n" .."Count: "..CountEggs)
    set_con(8)
end})

Eggs:CreateToggle({Name = "Triple Egg GamePass", CurrentValue = false, Flag = "TripleGamePassFlag", Callback = function(triplegamep)
    if triplegamep == true then
        getgenv().TripleGamePass = true
    elseif triplegamep == false then
        getgenv().TripleGamePass = false
    end
end})

Eggs:CreateToggle({Name = "Octuple Egg GamePass", CurrentValue = false, Flag = "OctupleGamePassFlag", Callback = function(octuplegamep)
    if octuplegamep == true then
        getgenv().OctupleGamePass = true
    elseif octuplegamep == false then
        getgenv().OctupleGamePass = false
    end
end})


Eggs:CreateToggle({Name = "Auto Open Egg", CurrentValue = false, Flag = "AutoOpenEggFlag", Callback = function(openeggfunc)
    if openeggfunc == true then
        getgenv().AutoOpenEgg = true
    elseif openeggfunc == false then
        getgenv().AutoOpenEgg = false
    end
    
    while task.wait(0.1) and getgenv().AutoOpenEgg do
        OpenEgg(getgenv().SelectedEggOpen, getgenv().TripleGamePass, getgenv().OctupleGamePass)
    end
end})

local Eggs2 = Eggs:CreateSection("Open Boosts")

Eggs:CreateToggle({Name = "Auto Ultra Lucky Boost", CurrentValue = false, Flag = "AutoUltraLuckyFlag", Callback = function(ultraluckyb)
    if ultraluckyb == true then
        getgenv().UltraLuckyBoost = true
    elseif ultraluckyb == false then
        getgenv().UltraLuckyBoost = false
    end
    
    while wait(2) and getgenv().UltraLuckyBoost do
        if not game:GetService("Players").LocalPlayer.PlayerGui.Main.Boosts:FindFirstChild("Ultra Lucky") then
            Client.Network.Fire('Activate Boost', "Ultra Lucky")
        end
    end
end})

Eggs:CreateToggle({Name = "Auto Super Lucky Boost", CurrentValue = false, Flag = "AutoSuperLuckyFlag", Callback = function(superluckyb)
    if superluckyb == true then
        getgenv().SuperLuckyBoost = true
    elseif superluckyb == false then
        getgenv().SuperLuckyBoost = false
    end
    
    while wait(2) and getgenv().SuperLuckyBoost do
        if not game:GetService("Players").LocalPlayer.PlayerGui.Main.Boosts:FindFirstChild("Super Lucky") then
            Client.Network.Fire('Activate Boost', "Super Lucky")
        end
    end
end})



local Eggs3 = Eggs:CreateSection("Open Eggs Addons")

local pathToScript = game.Players.LocalPlayer.PlayerScripts.Scripts.Game['Open Eggs']
local oldFunc = getsenv(pathToScript).OpenEgg
Eggs:CreateToggle({Name = "Remove Egg Animation", CurrentValue = false, Flag = "RemoveEggAnimFlag", Callback = function(delanimation)
    if delanimation == true then 
        getsenv(pathToScript).OpenEgg = function() return end 
    else
        getsenv(pathToScript).OpenEgg = oldFunc
    end
end})

Eggs:CreateToggle({Name = "Anti Lag Open (Experimental)", CurrentValue = false, Flag = "AntiLagOpenFlag", Callback = function(antiopenlag)
    if antiopenlag == true then
        getgenv().AntiLagOpen = true
        game:GetService("Players").LocalPlayer.PlayerGui.Inventory.Frame.Main.Pets.Visible = false
    elseif antiopenlag == false or destroygui then
        getgenv().AntiLagOpen = false
        game:GetService("Players").LocalPlayer.PlayerGui.Inventory.Frame.Main.Pets.Visible = true
    end
    
    while wait(10) and getgenv().AntiLagOpen do
        game:GetService("Players").LocalPlayer.PlayerGui.Inventory.Enabled = not game:GetService("Players").LocalPlayer.PlayerGui.Inventory.Enabled
        task.wait(0.5)
        game:GetService("Players").LocalPlayer.PlayerGui.Inventory.Enabled = not game:GetService("Players").LocalPlayer.PlayerGui.Inventory.Enabled
    end
end})

Eggs:CreateToggle({Name = "Auto Close Notification", CurrentValue = false, Flag = "AutoCloseNotifFlag", Callback = function(closenotif)
    if closenotif == true then
        getgenv().CloseNotification = true
    elseif closenotif == false then
        getgenv().CloseNotification = false
    end
    
    while wait(0.5) and getgenv().CloseNotification do
        firesignal(game:GetService("Players").LocalPlayer.PlayerGui.Message.Frame.No.Activated)
    end
end})


Eggs:CreateButton({Name = "Show Hidden Egg Chances", Callback = function()
    workspace.__MAP.Eggs.DescendantAdded:Connect(function(a)
       if a.Name == 'EggInfo' then
           for i,v in pairs(a.Frame.Pets:GetChildren()) do
               if v:IsA('Frame') and v.Thumbnail.Chance.Text == '??' then
                   local pet
                   for _,tbl in pairs(getgc(true)) do
                       if (typeof(tbl) == 'table' and rawget(tbl, 'thumbnail')) then
                           if tbl.thumbnail == v.Thumbnail.Image then
                               pet = string.split(tostring(tbl.model.Parent), ' - ')[1]
                           end
                       end
                   end
                   for _,egg in pairs(game:GetService("ReplicatedStorage")["__DIRECTORY"].Eggs:GetDescendants()) do
                       if egg:IsA('ModuleScript') and typeof(require(egg).drops) == 'table' then
                           for _,drop in pairs(require(egg).drops) do
                               if pet == '266' then v.Thumbnail.Chance.Text = '0.000002%' return end
                               if drop[1] == pet then
                                   v.Thumbnail.Chance.Text = drop[2] .. '%'
                               end
                           end
                       end
                   end
               end
           end
       end
    end)
    
    --table.foreach(SaveModule.Get())
    
    local oldworld = SaveModule.Get().World
    while wait(0.1) do
       if SaveModule.Get().World ~= oldworld then
           oldworld = SaveModule.Get().World
           workspace.__MAP.Eggs.DescendantAdded:Connect(function(a)
               if a.Name == 'EggInfo' then
                   for i,v in pairs(a.Frame.Pets:GetChildren()) do
                       if v:IsA('Frame') and v.Thumbnail.Chance.Text == '??' then
                           local pet
                           for _,tbl in pairs(getgc(true)) do
                               if (typeof(tbl) == 'table' and rawget(tbl, 'thumbnail')) then
                                   if tbl.thumbnail == v.Thumbnail.Image then
                                       pet = string.split(tostring(tbl.model.Parent), ' - ')[1]
                                   end
                               end
                           end
                           for _,egg in pairs(game:GetService("ReplicatedStorage")["__DIRECTORY"].Eggs:GetDescendants()) do
                               if egg:IsA('ModuleScript') and typeof(require(egg).drops) == 'table' then
                                   for _,drop in pairs(require(egg).drops) do
                                       if pet == '266' then v.Thumbnail.Chance.Text = '0.000002%' return end
                                       if drop[1] == pet then
                                           v.Thumbnail.Chance.Text = drop[2] .. '%'
                                       end
                                   end
                               end
                           end
                       end
                   end
               end
           end)
       end
    end 
end})


-- Players Section
local Misc = Window:CreateTab("Player", 5012544693)
local Misc1 = Misc:CreateSection("Movement")

Misc:CreateSlider({Name = "Select Speed", Range = {0, 1000}, Increment = 1, Suffix = "km/h", CurrentValue = 25, Flag = "SelectedSpeedFlag", Callback = function(playerspeed)
    getgenv().PlayerSpeed = playerspeed
end})

Misc:CreateToggle({Name = "Speed Toggle", CurrentValue = false, Flag = "SpeedToggleFlag", Callback = function(speedtoggle)
    if speedtoggle == true then
        getgenv().SpeedToggle = true
    elseif speedtoggle == false then
        getgenv().SpeedToggle = false
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 25
    end
    
    while wait() and getgenv().SpeedToggle do
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = getgenv().PlayerSpeed
    end
end})

Misc:CreateSlider({Name = "Select Jump Power", Range = {0, 1000}, Increment = 1, Suffix = "He", CurrentValue = 50, Flag = "SelectedJumpFlag", Callback = function(jumppower)
    getgenv().JumpPower = jumppower
end})

Misc:CreateToggle({Name = "Jump Power Toggle", CurrentValue = false, Flag = "JumpToggleFlag", Callback = function(jumppowertoggle)
    if jumppowertoggle == true then
        getgenv().JumpPowerToggle = true
    elseif jumppowertoggle == false then
        getgenv().JumpPowerToggle = false
        game.Players.LocalPlayer.Character.Humanoid.JumpPower = 50
    end
    
    while wait() and getgenv().JumpPowerToggle do
        game.Players.LocalPlayer.Character.Humanoid.JumpPower = getgenv().JumpPower
    end
end})


Misc:CreateToggle({Name = "Inventory Storage Info", CurrentValue = false, Flag = "InvStoInfoFlag", Callback = function(maxstorage)
    if maxstorage == true then
        getgenv().MaxStorage = true
    elseif maxstorage == false then
        getgenv().MaxStorage = false
    end
    
    local TextLabelThing = game:GetService("Players").LocalPlayer.PlayerGui.Inventory.Frame.PetAmount

    while task.wait(0.3) do
        if getgenv().MaxStorage then
            if not string.find(TextLabelThing.Text, "/") then
                TextLabelThing.Text = string.gsub(TextLabelThing.Text, " ", tostring("/"..SaveModule.Get().MaxSlots.." "))
            end
        elseif getgenv().MaxStorage == false then
            if not string.find(TextLabelThing.Text, "/") then
                TextLabelThing.Text = string.gsub(TextLabelThing.Text, tostring("/"..SaveModule.Get().MaxSlots.." "), " ")
            end
        end
    end
    UpdateTextLabelMaxAmount()
    TextLabelThing:GetPropertyChangedSignal("Text"):Connect(function() UpdateTextLabelMaxAmount() end)

end})

local Misc2 = Misc:CreateSection("Hide Functions")

Misc:CreateButton({Name = "Safe Place (Spawn World)", Callback = function()
     game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-185.74574279785156, 135.9728240966797, 112.64253997802734)
end})

Misc:CreateButton({Name = "Safe Place (Fantasy World)", Callback = function()
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(2828.88330078125, 144.52987670898438, 362.3201599121094)
end})

Misc:CreateButton({Name = "Safe Place (Tech World)", Callback = function()
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-1236.5024414063, 235.4162902832, 3440.3850097656)
end})

Misc:CreateButton({Name = "Safe Place (Void World)", Callback = function()
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(37.149620056152344, 43.9581298828125, 5270.95166015625)
end})

Misc:CreateButton({Name = "Safe Place (Axolotl World)", Callback = function()
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(4556.36474609375, 65.28596496582031, 3668.533447265625)
end})

Misc:CreateButton({Name = "Safe Place (Pixel World)", Callback = function()
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(3616.545654296875, 28.272851943969727, 2346.276123046875)
end})

local Misc3 = Misc:CreateSection("Bank Options")

Misc:CreateToggle({Name = "Hide Bank Users", CurrentValue = false, Flag = "HideBankUsersFlag", Callback = function(hidenames)
    if hidenames == true then
        getgenv().HideNameBank = true
    elseif hidenames == false then
        getgenv().HideNameBank = false
    end

    game:GetService"RunService".RenderStepped:Connect(function()
        if getgenv().HideNameBank == true then
            game:GetService("Players").LocalPlayer.PlayerGui.Bank.Frame.BankTitle.Owner.Text = "@UnknownUser"
            for i,v in pairs(game:GetService("Players").LocalPlayer.PlayerGui.Bank.Frame.Side.Holder:GetDescendants()) do
                if v.Name == "Owner" then
                    v.Text = "@UnknownUser"
                end
            end
        end
    end)
end})


local Misc4 = Misc:CreateSection("Merchant Options")

Misc:CreateToggle({Name = "Buy Merchant Tier 1", CurrentValue = false, Flag = "BuyMerchantT1Flag", Callback = function(buymerchant1func)
    if buymerchant1func == true then
        getgenv().MerchantBuy1 = true
    elseif buymerchant1func == false then
        getgenv().MerchantBuy1 = false
    end

    while task.wait() and getgenv().MerchantBuy1 do
        Client.Network.Invoke('Buy Merchant Item', 1)
    end
end})

Misc:CreateToggle({Name = "Buy Merchant Tier 2", CurrentValue = false, Flag = "BuyMerchantT2Flag", Callback = function(buymerchant2func)
    if buymerchant2func == true then
        getgenv().MerchantBuy2 = true
    elseif buymerchant2func == false then
        getgenv().MerchantBuy2 = false
    end

    while task.wait() and getgenv().MerchantBuy2 do
        Client.Network.Invoke('Buy Merchant Item', 2)
    end
end})

Misc:CreateToggle({Name = "Buy Merchant Tier 3", CurrentValue = false, Flag = "BuyMerchantT3Flag", Callback = function(buymerchant3func)
    if buymerchant3func == true then
        getgenv().MerchantBuy3 = true
    elseif buymerchant3func == false then
        getgenv().MerchantBuy3 = false
    end

    while task.wait() and getgenv().MerchantBuy3 do
        Client.Network.Invoke('Buy Merchant Item', 3)
    end
end})


local Misc5 = Misc:CreateSection("Useful Options")

Misc:CreateToggle({Name = "Auto Collect Rewards", CurrentValue = false, Flag = "CollectRewardFlag", Callback = function(autorewards)
    if autorewards == true then
        getgenv().AutoRewards = true
    elseif autorewards == false then
        getgenv().AutoRewards = false
    end

    while task.wait(1) and getgenv().AutoRewards do
        Client.Network.Invoke('Redeem VIP Rewards', {});
        Client.Network.Invoke('Redeem Rank Rewards', {});
    end
end})

Misc:CreateToggle({Name = "Auto Collect Present Rewards", CurrentValue = false, Flag = "CollectRewardFlag", Callback = function(autorewardspresent)
    if autorewardspresent == true then
        getgenv().AutoRewardsPresent = true
    elseif autorewardspresent == false then
        getgenv().AutoRewardsPresent = false
    end

    while task.wait(1) and getgenv().AutoRewardsPresent do
        for i=1,12 do
            Client.Network.Invoke('Redeem Free Gift', i)
        end	
    end
end})

Misc:CreateToggle({Name = "Stat Tracker", CurrentValue = false, Flag = "StatTrackerFlag", Callback = function(stattrackerfunc)
    local gamelibrary = require(game:GetService("ReplicatedStorage").Framework.Library)
    local Save = gamelibrary.Save.Get
    local Commas = gamelibrary.Functions.Commas
    local types = {}
    local menus = game:GetService("Players").LocalPlayer.PlayerGui.Main.Right
    if stattrackerfunc == true then
        getgenv().StartTracker = true
    elseif stattrackerfunc == false then
        getgenv().StartTracker = false
    end

    for i, v in pairs(menus:GetChildren()) do
        if v.ClassName == 'Frame' and v.Name ~= 'Rank' and not string.find(v.Name, "2") then
            table.insert(types, v.Name)
        end
    end

    function get(thistype)
        return Save()[thistype]
    end

    menus.Diamonds.LayoutOrder = game:GetService("Players").LocalPlayer.PlayerGui.Main.Right.Diamonds.LayoutOrder + 1
    menus['Tech Coins'].LayoutOrder = game:GetService("Players").LocalPlayer.PlayerGui.Main.Right["Tech Coins"].LayoutOrder + 1
    menus['Fantasy Coins'].LayoutOrder = game:GetService("Players").LocalPlayer.PlayerGui.Main.Right["Fantasy Coins"].LayoutOrder + 1
    menus['Easter Coins'].LayoutOrder = game:GetService("Players").LocalPlayer.PlayerGui.Main.Right["Easter Coins"].LayoutOrder + 1
    menus['Cartoon Coins'].LayoutOrder = game:GetService("Players").LocalPlayer.PlayerGui.Main.Right["Cartoon Coins"].LayoutOrder + 1
    menus['Clover Coins'].LayoutOrder = game:GetService("Players").LocalPlayer.PlayerGui.Main.Right["Rainbow Coins"].LayoutOrder + 1
    menus['Rainbow Coins'].LayoutOrder = game:GetService("Players").LocalPlayer.PlayerGui.Main.Right["Rainbow Coins"].LayoutOrder + 1
    menus.Coins.LayoutOrder = game:GetService("Players").LocalPlayer.PlayerGui.Main.Right.Coins.LayoutOrder + 1
    menus.UIListLayout.HorizontalAlignment = 2

    getgenv().MyTypes = {}
    for i,v in pairs(types) do
        if menus:FindFirstChild(v.."2") then
            menus:FindFirstChild(v.."2"):Destroy()
        end
    end

    for i,v in pairs(types) do
        if not menus:FindFirstChild(v.."2") then
            local tempmaker = menus:FindFirstChild(v):Clone()
            tempmaker.Name = tostring(tempmaker.Name .. "2")
            tempmaker.Parent = menus
            tempmaker.Size = UDim2.new(0, 175, 0, 30)
            tempmaker.LayoutOrder = tempmaker.LayoutOrder + 1
            getgenv().MyTypes[v] = tempmaker
        end
    end
    menus.Diamonds2.Add.Visible = false


    for i,v in pairs(types) do
        spawn(function()
            local megatable = {}
            local imaginaryi = 1
            local ptime = 0
            local last = tick()
            local now = last
            local TICK_TIME = 0.5
            while true and getgenv().StartTracker do
                if ptime >= TICK_TIME then
                    while ptime >= TICK_TIME do ptime = ptime - TICK_TIME end
                    local currentbal = get(v)
                    megatable[imaginaryi] = currentbal
                    local diffy = currentbal - (megatable[imaginaryi-120] or megatable[1])
                    imaginaryi = imaginaryi + 1
                    getgenv().MyTypes[v].Amount.Text = tostring(Commas(diffy).." in 60s")
                    getgenv().MyTypes[v]["Amount_odometerGUIFX"].Text = tostring(Commas(diffy).." in 60s")
                end
                task.wait(0.001)
                now = tick()
                ptime = ptime + (now - last)
                last = now
            end
        end)
    end

    if getgenv().StartTracker == false then
        for _,deltracker in pairs(game:GetService("Players").LocalPlayer.PlayerGui.Main.Right:GetChildren()) do
        	if string.match(deltracker.Name, "Coins2") or string.match(deltracker.Name, "Diamonds2") then
        		deltracker:Destroy()
        	end
        end
    end

end})



local Misc6 = Misc:CreateSection("Open GUIs")


Misc:CreateDropdown({Name = "Select GUI", Options = GuiList, CurrentOption = {"Select"}, MultipleOptions = false, Callback = function(guifunc)
    for _,gui in pairs(guifunc) do
        game:GetService("Players").LocalPlayer.PlayerGui[gui].Enabled = not game:GetService("Players").LocalPlayer.PlayerGui[gui].Enabled
    end
end})



local Pets = Window:CreateTab("Pets", 7955955376)
local Pets1 = Pets:CreateSection("Auto Gold/Rainbow/DarkMatter")

Pets:CreateDropdown({Name = "Select Count", Options = {'1','2','3','4','5','6'}, CurrentOption = {"Select"}, MultipleOptions = false, Flag = "SelectedCombineFlag", Callback = function(selectcombinefunc)
    for _,ench2 in pairs(selectcombinefunc) do
        getgenv().CombineCount = tonumber(selectcombinefunc)
    end
end})

Pets:CreateToggle({Name = "Auto Gold", CurrentValue = false, Flag = "ConvertGoldFlag", Callback = function(togglegoldfunc)
    if togglegoldfunc == true then
        getgenv().ToggleGold = true
    elseif togglegoldfunc == false then
        getgenv().ToggleGold = false
    end
end})

Pets:CreateToggle({Name = "Auto Rainbow", CurrentValue = false, Flag = "ConvertRainbowFlag", Callback = function(toggleraibowfunc)
    if toggleraibowfunc == true then
        getgenv().ToggleRainbow = true
    elseif toggleraibowfunc == false then
        getgenv().ToggleRainbow = false
    end
end})

Pets:CreateToggle({Name = "Auto Dark Matter", CurrentValue = false, Flag = "ConvertRainbowFlag", Callback = function(toggledarkmatterfunc)
    if toggledarkmatterfunc == true then
        getgenv().ToggleDarkMatter = true
    elseif toggledarkmatterfunc == false then
        getgenv().ToggleDarkMatter = false
    end
end})

Pets:CreateButton({Name = "Dark Matter Time Check", Callback = function()
    local PetListDarkMatter = {}
    for i,v in pairs(Library.Directory.Pets) do
        PetListDarkMatter[i] = v.name
    end

    local returnstring = ""
    for i,v in pairs(SaveModule.Get().DarkMatterQueue) do
        local timeleft = 'Done!'
        if math.floor(v.readyTime - os.time()) > 0 then
            timeleft = SecondsToClock(math.floor(v.readyTime - os.time()))
        end
        local stringthing = PetListDarkMatter[v.petId] .." will be ready in: ".. timeleft
        returnstring = returnstring .. stringthing .. "\n"
    end
    set_con(2)
    --Library.Message.New(returnstring)
    set_con(8)
end})

Pets:CreateToggle({Name = "Start Auto Combine", CurrentValue = false, Flag = "AutoGoldRainbowDarkMatterFlag", Callback = function(autocombinefunc)
    if autocombinefunc == true then
        getgenv().AutoCombine = true
    elseif autocombinefunc == false then
        getgenv().AutoCombine = false
    end

    while wait(0.8) and getgenv().AutoCombine do
        local AllMyPets = GetAllMyPets()
        if AllMyPets ~= nil then
            for i,v in pairs(AllMyPets) do
                if #v >= getgenv().CombineCount and getgenv().AutoCombine then
                    if string.find(i, "Normal") and getgenv().AutoCombine and getgenv().ToggleGold then
                        local Args = {}
                        for eeeee = 1, getgenv().CombineCount do
                            if v[#Args+1] ~= nil then
                                Args[#Args+1] = v[#Args+1]
                            end
                        end
                        Client.Network.Invoke('Use Golden Machine', Args)

                    elseif string.find(i, "Gold") and getgenv().AutoCombine and getgenv().ToggleRainbow then
                        local Args = {}
                        for eeeee = 1, getgenv().CombineCount do
                            if v[#Args+1] ~= nil then
                                Args[#Args+1] = v[#Args+1]
                            end
                        end
                        Client.Network.Invoke('Use Rainbow Machine', Args)

                    elseif string.find(i, "Rainbow") and getgenv().AutoCombine and getgenv().ToggleDarkMatter then
                        local Args = {}
                        for eeeee = 1, getgenv().CombineCount do
                            if v[#Args+1] ~= nil then
                                Args[#Args+1] = v[#Args+1]
                            end
                        end
                        Client.Network.Invoke('Convert To Dark Matter', Args)
                    end
                end
            end
        end
    end
end})

Pets:CreateToggle({Name = "Auto Claim Dark Matters", CurrentValue = false, Flag = "AutoClaimDarkMatterFlag", Callback = function(autoclaimdark)
    if autoclaimdark == true then
        getgenv().AutoClaimDarkMatter = true
    elseif autoclaimdark == false then
        getgenv().AutoClaimDarkMatter = false
    end

    while task.wait(1) and getgenv().AutoClaimDarkMatter do
        for i,v in pairs(Library.Save.Get().DarkMatterQueue) do
            if math.floor(v.readyTime - os.time()) < 0 then
                Client.Network.Invoke('Redeem Dark Matter Pet', {i})
            end
        end
    end
end})


local Troll = Window:CreateTab("Troll", 7955958468)
local Troll1 = Troll:CreateSection("Dupes")

Troll:CreateDropdown({Name = "Select Currency", Options = CurrencyList, CurrentOption = {"Select"}, Flag = "CurrencyFlag", MultipleOptions = false, Callback = function(currencyfunc)
    for _,cur in pairs(currencyfunc) do
        getgenv().SelectedCurrency = cur
    end
end})

Troll:CreateButton({Name = "Visual Dupe Currency", Callback = function()
    function comma_value(amount)
      local formatted = amount
      while true do  
        formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
        if (k == 0) then
          break
        end
      end
      return formatted
    end

    local FuckedCurrency = game.Players.LocalPlayer.PlayerGui.Main.Right[getgenv().SelectedCurrency].Amount
    local old = FuckedCurrency.Text
    local oldNumber = string.gsub(old, ",", "")
    local newNumber = oldNumber * 2
    local new = comma_value(newNumber)
    local newString = tostring(new)
    FuckedCurrency.Text = newString
end})


--local Troll3 = Troll:CreateSection("Fake Hatch")
--Troll:CreateInput({Name = "Pet Name", PlaceholderText = "Input Name", RemoveTextAfterFocusLost = false, Callback = function(fakehatchpet)
--    getgenv().FakePet = fakehatchpet
--end})
--
--Troll:CreateButton({Name = "Fake Hatch Egg", Callback = function()
--    HatchEgg(tostring(getgenv().FakePet))
--end})



















































-- Settings Sections
local Settings = Window:CreateTab("Settings", 7952149029)
local Settings1 = Settings:CreateSection("GUI")

Settings:CreateButton({Name = "Destroy GUI", Callback = function()
    Rayfield:Destroy()
end})

local Settings2 = Settings:CreateSection("Addons")
Settings:CreateButton({Name = "Rejoin Server", Callback = function()
    local ts = game:GetService("TeleportService")
    local p = game:GetService("Players").LocalPlayer
    ts:Teleport(game.PlaceId, p)
end})


-- Loading Config
Rayfield:Notify({Title = "Information", Content = "GUI Has Been Fully Loaded. \nDont fargot to join our Discord", Duration = 15, Image = 4483362458})
ChatMsg.New("GUI Has Been Fully Loaded.", Color3.new(0, 1, 1))
--

Rayfield:LoadConfiguration()




wait(0.5)local ba=Instance.new("ScreenGui")
local ca=Instance.new("TextLabel")local da=Instance.new("Frame")
local _b=Instance.new("TextLabel")local ab=Instance.new("TextLabel")ba.Parent=game.CoreGui
ba.ZIndexBehavior=Enum.ZIndexBehavior.Sibling;ca.Parent=ba;ca.Active=true
ca.BackgroundColor3=Color3.new(0.176471,0.176471,0.176471)ca.Draggable=true
ca.Position=UDim2.new(0.698610067,0,0.098096624,0)ca.Size=UDim2.new(0,370,0,52)
ca.Font=Enum.Font.SourceSansSemibold;ca.Text="Anti AFK Script"ca.TextColor3=Color3.new(0,1,1)
ca.TextSize=22;da.Parent=ca
da.BackgroundColor3=Color3.new(0.196078,0.196078,0.196078)da.Position=UDim2.new(0,0,1.0192306,0)
da.Size=UDim2.new(0,370,0,107)_b.Parent=da
_b.BackgroundColor3=Color3.new(0.176471,0.176471,0.176471)_b.Position=UDim2.new(0,0,0.800455689,0)
_b.Size=UDim2.new(0,370,0,21)_b.Font=Enum.Font.Arial;_b.Text="Made by yomamale2"
_b.TextColor3=Color3.new(0,1,1)_b.TextSize=20;ab.Parent=da
ab.BackgroundColor3=Color3.new(0.176471,0.176471,0.176471)ab.Position=UDim2.new(0,0,0.158377,0)
ab.Size=UDim2.new(0,370,0,44)ab.Font=Enum.Font.ArialBold;ab.Text="Status: Aktywny"
ab.TextColor3=Color3.new(0,1,1)ab.TextSize=20;local bb=game:service'VirtualUser'
game:service'Players'.LocalPlayer.Idled:connect(function()
bb:CaptureController()bb:ClickButton2(Vector2.new())
ab.Text="Roblox"wait(2)ab.Text="Status : Aktywny"end)
