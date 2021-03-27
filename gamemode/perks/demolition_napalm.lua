PERK.PrintName = "Napalm"
PERK.Description = "25% increased Fire damage.\n75% reduced Fire damage taken."
PERK.Icon = "materials/perks/napalm.png"

PERK.Hooks = {}
PERK.Hooks.Horde_OnPlayerDamage = function (ply, npc, bonus, hitgroup, dmgtype)
    if not ply:Horde_GetPerk("demolition_napalm")  then return end
    if dmgtype == DMG_FIRE or dmgtype == DMG_BURN then
        bonus.increase = bonus.increase + 0.25
    end
end

PERK.Hooks.Horde_OnPlayerDamageTaken = function (ply, dmg, bonus)
    if not ply:Horde_GetPerk("demolition_napalm")  then return end
    if dmg:GetDamageType() == DMG_FIRE or dmg:GetDamageType() == DMG_BURN then
        bonus.resistance = bonus.resistance + 0.75
    end
end