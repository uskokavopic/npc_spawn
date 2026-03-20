# 🧍 ped_spawn

> **Lightweight static ped spawner for FiveM — fully compatible with OneSync Infinity and 300+ player servers.**

Spawns custom static NPCs at defined world coordinates. Peds are local-only entities — invisible to other players and the server, with zero impact on the global entity cap.

---

## ✨ Features

- ✅ **Local entity spawning** — peds are never networked, zero server entity cap cost
- ✅ **Distance-based spawn / despawn** — peds only exist when a player is nearby
- ✅ **Looping animation support** — any GTA V animDict / animName combination
- ✅ **Full static lock** — invincible, frozen, no ragdoll, no combat, no flee
- ✅ **Memory safe** — model and anim dict released from streaming RAM after spawn
- ✅ **Zero server CPU** — fully client-side, no server script required
- ✅ **Easy config** — add peds in `config.lua`, no code changes needed

---

## 📋 Requirements

| Requirement | Version |
|---|---|
| FiveM OneSync | `infinity` |
| FXServer | latest recommended |

> 💡 No external dependencies. Does not require ox_lib or any framework.

---

## 📦 Installation

1. Drop the `ped_spawn` folder into your `resources` directory
2. Add `ensure ped_spawn` to your `server.cfg`
3. Add your peds to `config.lua`
4. Restart the server

---

## ⚙️ Configuration

All peds are defined in `config.lua`. No code changes needed — just add entries to `Config.Peds`.

```lua
Config.Debug = false  -- set true to see spawn/delete logs in console

Config.Peds = {
    {
        model    = "s_m_y_xmech_02",                          -- GTA V ped model name
        coords   = vector4(722.8, -1082.5, 22.2, 90.0),      -- x, y, z, heading
        animDict = "amb@world_human_vehicle_mechanic@male@base",
        animName = "base",
        distance = 30.0,                                       -- spawn radius in metres
    },
}
```

### Config fields

| Field | Type | Required | Description |
|---|---|---|---|
| `model` | string | ✅ | GTA V ped model name (e.g. `"s_m_y_cop_01"`) |
| `coords` | vector4 | ✅ | World position — `x, y, z` + `w` for heading in degrees |
| `animDict` | string | ❌ | Animation dictionary name |
| `animName` | string | ❌ | Animation clip name |
| `distance` | number | ❌ | Spawn/despawn radius in metres (default: `35.0`) |

> 💡 `animDict` and `animName` are both optional. If omitted, the ped spawns in its default idle pose.

---

## ⚡ OneSync Infinity compatibility

This script is designed specifically to work safely on OneSync Infinity servers with 300+ players.

### 🔑 Local entities — the key design decision

```lua
CreatePed(4, model, x, y, z, heading, false, false)
--                                            ^^^^^ isNetwork = false
```

The last two arguments to `CreatePed` are both `false`:

- **`isNetwork = false`** — the ped is a **local entity**. It exists only on this client. The server does not know it exists. No other player can see it. Under OneSync Infinity, passing `true` here would sync the ped server-wide to every player on the server, eating into the global entity cap (~4096). With 300 players each spawning 8 peds that would be 2400 networked entities — just from decorative peds.
- **`bScriptHostPed = false`** — the ped is not a script host ped, keeping it fully local.

### 📊 Entity cap impact

| Scenario | Networked (❌ wrong) | Local (✅ correct) |
|---|---|---|
| 1 player, 8 peds | 8 server entities | 0 server entities |
| 300 players, 8 peds each | up to 2400 server entities | 0 server entities |

### 🗑️ Safe deletion

Because peds are local entities, `DeleteEntity()` is always safe to call directly — no `NetworkRequestControlOfEntity()` required. Local entities are always owned by the client that created them.

### 💾 Memory management

Two streaming RAM releases happen after each spawn:

```lua
SetModelAsNoLongerNeeded(model)      -- releases model asset slot
-- ... after TaskPlayAnim:
RemoveAnimDict(pedData.animDict)     -- releases anim dict slot
```

The ped and its animation continue running after these calls. Only the asset data in the streaming pool is freed. Without this, every unique model and anim dict would remain loaded in RAM permanently — on a server with many ped spawners this compounds into significant memory pressure per client.

---

## 🔁 Spawn / despawn logic

```
Every 1500ms (no peds nearby) / 1000ms (ped in range)
        │
        ▼
For each ped in Config.Peds:
  ├─ Player within distance?
  │     ├─ Ped already exists?  →  do nothing
  │     └─ Ped missing?         →  spawn ped + play anim
  └─ Player out of range?
        └─ Ped exists?          →  DeleteEntity, free slot
```

> 💡 The loop interval is relaxed (1500 ms) for frozen static peds — frequent checks add no value. It tightens to 1000 ms only when a player is near at least one ped.

---

## 🛡️ Ped properties

Every spawned ped gets the following flags applied automatically:

| Native | Effect |
|---|---|
| `SetEntityAsMissionEntity(ped, true, false)` | Prevents GC deletion, stays local |
| `SetBlockingOfNonTemporaryEvents(ped, true)` | Ignores world events (gunshots, explosions) |
| `SetEntityInvincible(ped, true)` | Cannot be killed |
| `FreezeEntityPosition(ped, true)` | Cannot be moved |
| `SetPedCanRagdollFromPlayerImpact(ped, false)` | No ragdoll on player collision |
| `SetEntityCanBeDamaged(ped, false)` | Cannot receive damage |
| `SetPedFleeAttributes(ped, 0, false)` | Will not flee from anything |
| `SetPedCombatAttributes(ped, 17, false)` | No combat behaviour |
| `SetPedDiesWhenInjured(ped, false)` | Does not die when injured |

---

## 🐛 Debug mode

Set `Config.Debug = true` in `config.lua` to enable console logging:

```
[ped_spawn] Spawned [1] model=s_m_y_xmech_02 dist=18.4
[ped_spawn] Deleted [1] model=s_m_y_xmech_02
```

---

## 📄 License

MIT — free to use, modify, and redistribute. Credit appreciated but not required.
