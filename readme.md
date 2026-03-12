# 🟢 Client-Side NPC Spawn for FiveM (2026)

This resource is a **client-side NPC spawn system** for FiveM with:

- ✅ Distance-based spawning per NPC  
- ✅ Individually configurable animations and heading  
- ✅ Full cleanup when the resource stops  
- ✅ Fully OneSync-friendly, minimal server load  
- ✅ FPS optimized  

This system was created to fix issues caused by **old spawn scripts** and maximize performance on modern servers.

---

## ⚠️ Why old spawn scripts often failed

Old scripts that:

- Spawned NPCs across the map  
- Spawned vehicles or peds repeatedly   

caused:

- Duplicate entities 🚗  
- Ghost entities 👻  
- Unexpected despawns ❌  
- Players not seeing spawned NPCs 👀  

**Reason:**  

- NPCs were not spawned correctly server-side  
- OneSync requires proper **entity ownership**  
- Entities must be synchronized **only for nearby players**  

**Consequences of non-OneSync-friendly spawns:**  

- Entity has no correct owner  
- Duplicate or missing NPCs  
- FPS drop with many entities  
- Players cannot see entities  

> Examples of problematic old scripts:  
> - NPCs spawning all over the map  
> - Auto spawners  
> - Scripts without distance-based or client-side spawning

---

## 🟢 How this resource works (current 2026 version)

- ✅ **Client-side spawn** – each player spawns NPCs locally  
- ✅ **Distance-based spawn** – NPCs appear only when players are nearby  
- ✅ **Individual distance per NPC** – each ped can have its own spawn radius  
- ✅ **Animations and heading** – each ped can have its own animation and rotation  
- ✅ **Cleanup** – NPCs are automatically deleted when players leave or the resource stops  
- ✅ **FPS-friendly and OneSync-safe** – no ghost NPCs, minimal load, server unaffected  

> ⚠️ Synchronized NPCs (like a global vendor) are no longer part of this version because client-side spawning is **more stable and OneSync-safe**.  

---

## 📄 Configuration (`config.lua`)

```lua
Config = {}
Config.Peds = {
    {
        model = "a_m_y_beach_03",
        coords = vector4(440.417, -983.604, 30.690, 200.0),
        animDict = "missmic_3_ext@leadin@mic_3_ext",
        animName = "_leadin_trevor",
        distance = 50.0 -- spawn distance for this ped
    },
    {
        model = "s_m_m_security_01",
        coords = vector4(-260.0, -970.0, 30.2, 110.0),
        animDict = "amb@world_human_guard_patrol@male@base",
        animName = "base",
        distance = 30.0
    },
    {
        model = "a_f_y_business_02",
        coords = vector4(450.0, -970.0, 30.6, 180.0),
        animDict = "amb@world_human_stand_mobile@female@standing@base",
        animName = "base",
        distance = 20.0
    }
}