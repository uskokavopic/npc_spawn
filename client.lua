-- =========================
-- Ped Spawn Script
-- Spawns static local peds near defined coordinates.
-- Fully compatible with OneSync Infinity (300+ players).
--
-- OneSync Infinity design decisions:
--   1. CreatePed(..., false, false) — last two args = isNetwork:false, bScriptHostPed:false
--      Keeps the ped as a LOCAL entity. Under OneSync Infinity, a networked ped
--      (isNetwork:true) gets synced server-wide to every player, eating the global
--      entity cap (~4096). Local peds are invisible to other clients and cost nothing
--      on the network.
--   2. SetEntityAsMissionEntity(ped, true, false) — second false = do not make networked.
--      Prevents GTA's garbage collector from deleting the ped between checks.
--   3. SetModelAsNoLongerNeeded after CreatePed — releases the model from streaming
--      RAM immediately. The ped stays alive but the asset slot is freed.
--   4. RemoveAnimDict after TaskPlayAnim — same principle for anim dicts.
--      The ped continues playing the looping animation (-1 flag) without holding
--      the dict in memory.
-- =========================

local spawnedPeds = {}

-- Debug helper — declared first so it is in scope everywhere below
local function logDebug(msg)
    if Config.Debug then
        print(("[ped_spawn] %s"):format(msg))
    end
end

-- =========================
-- Main spawn loop
-- =========================
CreateThread(function()
    while true do
        local playerPed    = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        local waitTime     = 1500  -- relaxed interval for static frozen peds

        for i, pedData in ipairs(Config.Peds) do
            local pedCoords = vector3(pedData.coords.x, pedData.coords.y, pedData.coords.z)
            local dist      = #(playerCoords - pedCoords)
            local drawDist  = pedData.distance or 35.0

            if dist < drawDist then
                waitTime = 1000  -- tighten interval when player is near any ped

                -- Spawn only if not already alive
                if not spawnedPeds[i] or not DoesEntityExist(spawnedPeds[i]) then

                    -- Load ped model
                    local model = GetHashKey(pedData.model)
                    RequestModel(model)
                    while not HasModelLoaded(model) do
                        Wait(0)
                    end

                    -- Create ped as local entity (isNetwork = false)
                    local ped = CreatePed(
                        4,
                        model,
                        pedCoords.x, pedCoords.y, pedCoords.z - 1.0,
                        pedData.coords.w,
                        false,   -- isNetwork: false = local only, not synced server-wide
                        false    -- bScriptHostPed
                    )

                    -- Prevent GC from cleaning up the ped; keep local (not networked)
                    SetEntityAsMissionEntity(ped, true, false)

                    -- Make ped fully static and indestructible
                    SetBlockingOfNonTemporaryEvents(ped, true)
                    SetEntityInvincible(ped, true)
                    FreezeEntityPosition(ped, true)
                    SetPedCanRagdollFromPlayerImpact(ped, false)
                    SetEntityCanBeDamaged(ped, false)
                    SetPedFleeAttributes(ped, 0, false)
                    SetPedCombatAttributes(ped, 17, false)  -- no combat behaviour
                    SetPedDiesWhenInjured(ped, false)

                    -- Release model from streaming RAM — ped stays alive without it
                    SetModelAsNoLongerNeeded(model)

                    -- Play looping animation if defined
                    if pedData.animDict and pedData.animName then
                        RequestAnimDict(pedData.animDict)
                        while not HasAnimDictLoaded(pedData.animDict) do
                            Wait(0)
                        end
                        TaskPlayAnim(
                            ped,
                            pedData.animDict,
                            pedData.animName,
                            8.0, 1.0, -1, 1, 0,
                            false, false, false
                        )
                        -- Release anim dict — ped keeps looping (-1), dict no longer needed
                        RemoveAnimDict(pedData.animDict)
                    end

                    spawnedPeds[i] = ped
                    logDebug(("Spawned [%d] model=%s dist=%.1f"):format(i, pedData.model, dist))
                end

            else
                -- Out of range — clean up
                if spawnedPeds[i] and DoesEntityExist(spawnedPeds[i]) then
                    DeleteEntity(spawnedPeds[i])
                    spawnedPeds[i] = nil
                    logDebug(("Deleted [%d] model=%s"):format(i, pedData.model))
                end
            end
        end

        Wait(waitTime)
    end
end)
