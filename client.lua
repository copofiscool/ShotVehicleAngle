local restrictedAngle = 180.0
local checkInterval = 250 -- Check every 500ms

local function isFiringAllowed(vehicleHeading, playerAimDirection)
    local angleDifference = math.abs(vehicleHeading - playerAimDirection) % 360
    return not (angleDifference > restrictedAngle / 2 and angleDifference < 360 - restrictedAngle / 2)
end

Citizen.CreateThread(function()
    local player = PlayerId()

    while true do
        Citizen.Wait(checkInterval)
        local ped = GetPlayerPed(player)
        local vehicle = GetVehiclePedIsIn(ped, false)

        if vehicle ~= 0 then
            local _, weaponGroupHash = GetCurrentPedWeapon(ped, true)
            if weaponGroupHash ~= -1609580060 and weaponGroupHash ~= -728555052 then -- Not fists or melee
                local vehicleHeading = GetEntityHeading(vehicle)
                local playerAimDirection = GetGameplayCamRot(0).z
                local canFire = isFiringAllowed(vehicleHeading, playerAimDirection)

                DisablePlayerFiring(player, not canFire)
            end
        end
    end
end)
