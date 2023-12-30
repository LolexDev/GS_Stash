--────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
--─██████████████─████████████████───██████████████─██████──██████─██████████████────██████████████─██████████████─████████████████───██████████─██████████████─██████████████─██████████████─
--─██░░░░░░░░░░██─██░░░░░░░░░░░░██───██░░░░░░░░░░██─██░░██──██░░██─██░░░░░░░░░░██────██░░░░░░░░░░██─██░░░░░░░░░░██─██░░░░░░░░░░░░██───██░░░░░░██─██░░░░░░░░░░██─██░░░░░░░░░░██─██░░░░░░░░░░██─
--─██░░██████████─██░░████████░░██───██░░██████░░██─██░░██──██░░██─██░░██████████────██░░██████████─██░░██████████─██░░████████░░██───████░░████─██░░██████░░██─██████░░██████─██░░██████████─
--─██░░██─────────██░░██────██░░██───██░░██──██░░██─██░░██──██░░██─██░░██────────────██░░██─────────██░░██─────────██░░██────██░░██─────██░░██───██░░██──██░░██─────██░░██─────██░░██─────────
--─██░░██─────────██░░████████░░██───██░░██──██░░██─██░░██──██░░██─██░░██████████────██░░██████████─██░░██─────────██░░████████░░██─────██░░██───██░░██████░░██─────██░░██─────██░░██████████─
--─██░░██──██████─██░░░░░░░░░░░░██───██░░██──██░░██─██░░██──██░░██─██░░░░░░░░░░██────██░░░░░░░░░░██─██░░██─────────██░░░░░░░░░░░░██─────██░░██───██░░░░░░░░░░██─────██░░██─────██░░░░░░░░░░██─
--─██░░██──██░░██─██░░██████░░████───██░░██──██░░██─██░░██──██░░██─██░░██████████────██████████░░██─██░░██─────────██░░██████░░████─────██░░██───██░░██████████─────██░░██─────██████████░░██─
--─██░░██──██░░██─██░░██──██░░██─────██░░██──██░░██─██░░░░██░░░░██─██░░██────────────────────██░░██─██░░██─────────██░░██──██░░██───────██░░██───██░░██─────────────██░░██─────────────██░░██─
--─██░░██████░░██─██░░██──██░░██████─██░░██████░░██─████░░░░░░████─██░░██████████────██████████░░██─██░░██████████─██░░██──██░░██████─████░░████─██░░██─────────────██░░██─────██████████░░██─
--─██░░░░░░░░░░██─██░░██──██░░░░░░██─██░░░░░░░░░░██───████░░████───██░░░░░░░░░░██────██░░░░░░░░░░██─██░░░░░░░░░░██─██░░██──██░░░░░░██─██░░░░░░██─██░░██─────────────██░░██─────██░░░░░░░░░░██─
--─██████████████─██████──██████████─██████████████─────██████─────██████████████────██████████████─██████████████─██████──██████████─██████████─██████─────────────██████─────██████████████─
--────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
local sefovi = {}
local sefisada = {}
local stavljaUpravo = false 

Citizen.CreateThread(function ()
    for k,v in pairs(Config.Sef) do
        exports.qtarget:AddTargetModel(v.SafeProp, {
            options = {
                {
                    action = function ()
                        exports.ox_inventory:openInventory('stash', { id = 'sef', owner = 'char1:license' })
                    end,
                    icon = 'fas fa-vault',
                    label = _U('opensafe'),
                },
                {
                    action = function ()
                        skloniSef()
                    end,
                    icon = 'fas fa-trash',
                    label = _U('removesafe')
                },
                -- { Coming in next version!
                --     action = function ()
                --         local input = lib.inputDialog(_U('setpasst'), {'Šifra:'})
                --         if not input then
                --             return obavesti(_U('notentered'), '', 'warning', 'top', 1000)
                --         end
                --         TriggerServerEvent('GS_Stash:promenaLozinke', input[1])
                --     end,
                --     icon = 'fas fa-hashtag',
                --     label = _U('setpass')
                -- }
            },
            distance = 2
        })
    end
end)

RegisterNetEvent('GS_Stash:postaviSef')
AddEventHandler('GS_Stash:postaviSef', function ()
    for k,v in pairs(Config.Sef) do
        local korde = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 1.0, 0.0)
        local heading = GetEntityHeading(PlayerPedId())
        local id = math.random(1,1000)
        local prop = v.SafeProp
        insert(sefovi, {korde, id}) 

        RequestModel(GetHashKey(prop))
        while not HasModelLoaded(prop) do
            Wait(500)
        end
  
        local Sef = CreateObject(prop, korde, false, true)
        insert(sefisada, Sef)
        SetEntityHeading(Sef, heading)
        FreezeEntityPosition(Sef, true)
        SetEntityInvincible(Sef, true)
        PlaceObjectOnGroundProperly(Sef)
        SetModelAsNoLongerNeeded(prop)
    end
end)

RegisterNetEvent("GS_Stash:postavi")
AddEventHandler("GS_Stash:postavi", function()
    for k,v in pairs(Config.Sef) do
        local hash = GetHashKey(v.SafeProp)
        local pedKorde = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 1.0, 0.0)
        local blizu = IsObjectNearPoint(hash, vector3(pedKorde.x , pedKorde.y, pedKorde.z), 1.5)
        if not stavljaUpravo then 
            if not blizu then 
                stavljaUpravo = true 
                FreezeEntityPosition(PlayerPedId(), true)
                lib.progressCircle({
                    duration = v.PlacingTime * 1000,
                    label = _U('placing'),
                    position = 'bottom',
                    useWhileDead = false,
                    disable = {
                        car = true,
                        move = true,
                        combat = true,
                        mouse = false,
                    },
                    anim = {
                        dict = v.Placingdict,
                        clip = v.Placingclip
                    },
                })
                FreezeEntityPosition(PlayerPedId(), false)
                TriggerEvent('GS_Stash:postaviSef')
                obavesti(_U('placed'),'','success','top',1000)
                stavljaUpravo = false 
                TriggerServerEvent("GS_Stash:postavioS", v.SafeItem)
                insert(sefovi, { kordinate = pedKorde})
            end
        end
    end
end)

skloniSef = function()
    for k,v in pairs(Config.Sef) do
        local korde = GetEntityCoords(PlayerPedId())
        lib.progressCircle({
            duration = v.PickingTime * 1000,
            label = _U('picking'),
            position = 'bottom',
            useWhileDead = false,
            disable = {
                car = true,
                move = true,
                combat = true,
                mouse = false,
            },
            anim = {
                dict = v.Pickingdict,
                clip = v.Pickingclip
            },
        })
        ESX.Game.DeleteObject(GetClosestObjectOfType(korde.x, korde.y, korde.z, 1.0, v.SafeProp, false, false, false))
        Wait(400)
        TriggerServerEvent("GS_Stash:sklonioSef", v.SafeItem)
    end
end

RegisterCommand('sklonisve', function () -- Skloni sve sefove komanda(Radi samo dok nije skripta restartana sklanja sve sefove a kad se restartuje radit ce samo na onima koji su posle restarta stavljeni SKLONITI SVE SEFOVE JE POTREBAN RR SERVERA!) // Remove all safes command (The script when it restarts you can't remove safes only when u restart whole server)
    for i = 1, #sefisada do
        DeleteObject(sefisada[i])
    end
end)