-- This is the entry-point to your game mode and should be used primarily to precache models/particles/sounds/etc

require('internal/util')
require('gamemode')

function Precache( context )
  DebugPrint("[BAREBONES] Performing pre-load precache")
  PrecacheUnitByNameSync("npc_dota_hero_ancient_apparition", context)
  PrecacheUnitByNameSync("npc_dota_hero_phoenix", context)
  PrecacheUnitByNameSync("npc_dota_hero_shadow_demon", context)
  PrecacheUnitByNameSync("npc_dota_hero_lich", context)
  PrecacheUnitByNameSync("npc_dota_hero_invoker", context)
  PrecacheUnitByNameSync("npc_dota_hero_sand_king", context)
  PrecacheUnitByNameSync("npc_dota_hero_axe", context)
  PrecacheUnitByNameSync("npc_dota_hero_shadow_shaman", context)
  PrecacheResource("model", "models/props_gameplay/sheep01.vmdl", context)
  PrecacheResource("particle_folder", "particles/units/heroes/hero_slark", context)
  PrecacheResource("particle", "particles/econ/items/shadow_demon/sd_ti7_shadow_poison/sd_ti7_golden_shadow_poison_release_crush_carrier.vpcf", context)
  PrecacheResource("model", "models/props_gameplay/temple_portal001.vmdl", context)
end

-- Create the game mode when we activate
function Activate()
  GameRules.GameMode = GameMode()
  GameRules.GameMode:_InitGameMode()
end