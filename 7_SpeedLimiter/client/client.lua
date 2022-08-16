ESX = nil
local ListIndex = 1;
local ListLabel = "~r~désactivé"
local LastDisabled = false

Citizen.CreateThread(function()
    indexOfLimiter = 1
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj)
            ESX = obj
        end)
        Citizen.Wait(100)
    end
end)

local ListOfSpeed = {5, 10, 15, 20, 25, 30, 35, 40, 45, 50, 55, 60, 65, 70, 75, 80, 85, 90, 95, 100, 105, 110, 115, 120,
                     125, 130, 135, 140, 145, 150, 155, 160, 165, 170, 175, 180, 185, 190, 195, 200}

------------------------------------------------------------------------------
----------------------[ Création des menus / sous menus ]---------------------
------------------------------------------------------------------------------

RMenu.Add('home', 'main', RageUI.CreateMenu( Config.serverName , 'Limitateur'))

Citizen.CreateThread(function()
    while true do

        RageUI.IsVisible(RMenu:Get('home', 'main'), true, true, true, function()

            RageUI.Separator(" ______________________________")
            RageUI.Separator("Limitateur actuellement " .. ListLabel)
            RageUI.Separator(" ______________________________")

            RageUI.List('Vitesse', ListOfSpeed, ListIndex, nil, {
                RightLabel = "km/h"
            }, true, function(Hovered, Active, Selected, Index)
                local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), false)
                if (Selected) then
                    SetVehicleMaxSpeed(GetVehiclePedIsIn(PlayerPedId(), false), Index * 5.0 / 3.60) -- 0.44385 seems to be the golden value for going from GTA's speed units to MPH
                    ListLabel = "~g~activé"
                    LastDisabled = false
                end

                ListIndex = Index;

            end)

            RageUI.Button("~r~Désactiver", nil, {}, true, function(Hovered, Active, Selected)
                if (Selected) then
                    SetVehicleMaxSpeed(GetVehiclePedIsIn(PlayerPedId(), false), 1000000 * 0.44385)
                    ListLabel = "~r~désactivé"

                end
            end)
        end)

        Citizen.Wait(1)
    end
end)

----------------------------------------[ Ouverture du Menu ]--------------------------------------------

Citizen.CreateThread(function()
    while true do
        if IsPedInAnyVehicle(PlayerPedId()) then
            if IsControlPressed(1, 168) then

                RageUI.Visible(RMenu:Get('home', 'main'), not RageUI.Visible(RMenu:Get('home', 'main')))

            end

        else
            if (LastDisabled) then
            else
                SetVehicleMaxSpeed(GetVehiclePedIsIn(PlayerPedId(), true), 10000000 * 0.44)
                ListLabel = "~r~désactivé"
                LastDisabled = true
            end

        end

        Citizen.Wait(100)

    end
end)

print('Started')
