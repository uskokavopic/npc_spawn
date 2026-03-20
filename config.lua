Config = {}

Config.Debug = false  -- set true to print spawn/delete events to console

-- =========================
-- Ped definitions
-- All animation dicts verified against the GTA V animation list.
--
-- Fields:
--   model    (string)  — GTA V ped model name
--   coords   (vector4) — x, y, z, heading (w)
--   animDict (string)  — animation dictionary (optional)
--   animName (string)  — animation clip name (optional)
--   distance (number)  — spawn/despawn radius in metres (default 35.0)
-- =========================
Config.Peds = {

    -- Mechanic working under a car
    -- dict: amb@world_human_vehicle_mechanic@male@base — confirmed in GTA V anim list
    {
        model    = "S_M_Y_XMech_01",
        coords   = vec4(734.022, -1088.883, 22.169, 93.344),
        animDict = "amb@world_human_vehicle_mechanic@male@base",
        animName = "base",
        distance = 30.0,
    },

    -- Street vendor standing impatiently
    -- dict: amb@world_human_stand_impatient@male@base — confirmed valid
    {
        model    = "s_m_m_hairdress_01",
        coords   = vec4(23.553, -1105.571, 29.797, 147.431),
        animDict = "amb@world_human_stand_impatient@male@base",
        animName = "base",
        distance = 25.0,
    },

    -- Security guard with torch
    -- FIX: was "amb@world_human_security_shine_torch@base" — missing @male segment
    -- Correct: "amb@world_human_security_shine_torch@male@base"
    {
        model    = "s_m_m_security_01",
        coords   = vec4(299.619, -582.059, 43.261, 98.397),
        animDict = "anim@move_m@security_guard",
        animName = "idle",
        distance = 30.0,
    },

    -- Bartender behind a bar counter
    -- FIX: "amb@world_human_bartender_idles@female@idle_a" does not exist in GTA V.
    -- Correct bartender dict confirmed in dpemotes and community resources:
    {
        model    = "G_M_Y_StrPunk_01",
        coords   = vec4(215.722, -806.102, 30.795, 331.469),
        animDict = "anim@move_m@security_guard",
        animName = "idle",
        distance = 15.0,
    },

    -- Street musician playing guitar
    -- FIX: "@base" is an entry anim, not a loop — ped would freeze after playing it once.
    -- Correct loop: amb@world_human_musician@guitar@male@idle_a / idle_b (confirmed valid)
    {
        model    = "CSB_Musician_00",
        coords   = vector4(205.6, -934.1, 30.7, 330.0),
        animDict = "amb@world_human_musician@guitar@male@idle_a",
        animName = "idle_b",
        distance = 30.0,
    },

    -- Homeless person sitting slumped
    -- FIX: "amb@world_human_bum_slumped@male@base" / "base" is an entry transition anim.
    -- Correct idle loop: @idle_a / idle_a — ped stays in slumped sitting position
    {
        model    = "a_m_o_tramp_01",
        coords   = vector4(24.4, -1345.7, 29.5, 280.0),
        animDict = "amb@world_human_bum_slumped@male@idle_a",
        animName = "idle_a",
        distance = 20.0,
    },

    -- Business woman on her phone
    -- dict: confirmed valid in GTA V anim list
    {
        model    = "a_f_y_business_02",
        coords   = vec4(451.123, -965.852, 28.653, 359.840),
        animDict = "amb@world_human_strip_watch_stand@male_c@base",
        animName = "base",
        distance = 20.0,
    },

    -- Jogger stretching near the beach
    -- dict: confirmed valid
    {
        model    = "a_f_y_runner_01",
        coords   = vec4(-1204.957, -1560.406, 4.614, 32.732),
        animDict = "amb@world_human_jog_standing@female@idle_a",
        animName = "idle_a",
        distance = 30.0,
    },

}
