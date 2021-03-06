require "/scripts/ivrpgMonsterNpcHook.lua"
require "/npcs/ivrpguniquenpc.lua"

local ivrpgOldInit = init
local ivrpgOldUpdate = update
local ivrpgOldDamage = damage

function init()
  ivrpgOldInit()
  rpg_loadConfigs()
  rpg_loadVariables(npc.npcType(), npc.level())
  self.rpg_Actions = config.getParameter("ivrpgActions", false)
  if self.rpg_Actions then rpg_initUniqueNPC() end
  rpg_setHandlers()
end

function rpg_secondInit()
  ivrpgOldInit()
  rpg_loadConfigs()
  rpg_loadVariables(npc.npcType(), npc.level())
  self.rpg_Actions = config.getParameter("ivrpgActions", false)
  if self.rpg_Actions then rpg_initUniqueNPC() end
  rpg_setHandlers()
end

function update(dt)
  ivrpgOldUpdate(dt)
  rpg_updateEffects(dt)
  if self.rpg_Actions then rpg_updateUniqueNPC(dt) end
end

function damage(args)
  ivrpgOldDamage(args)
  rpg_updateDamageTaken(args)
  if self.rpg_Actions then rpg_damage(args.damage, args.sourceDamage, args.sourceKind, args.sourceId) end
end
