local plymeta = FindMetaTable("Player")

-- Player damage.
hook.Add("ScaleNPCDamage", "Horde_ApplyDamage", function (npc, hitgroup, dmginfo)
    local ply = dmginfo:GetAttacker()
    if not npc:IsValid() or not ply:IsPlayer() then return end

    local increase = 0
    local more = 1

    -- Now find buffs that will affect damage.
    local bonus = {increase=increase, more=more}
    hook.Run("Horde_ApplyAdditionalDamage", ply, npc, bonus, hitgroup, dmginfo:GetDamageType())
    dmginfo:ScaleDamage(bonus.more * (1 + bonus.increase))
    --print(more * (1 + increase), dmginfo:GetDamage())
end)

hook.Add("Horde_ResetStatus", "Horde_ResetDamage", function(ply)
end)

-- Evasion
function plymeta:Horde_SetEvasion(evasion)
    self.Horde_Evasion = evasion
end

function plymeta:Horde_GetEvasion()
    return self.Horde_Evasion or 0
end

-- Player damage taken
hook.Add("EntityTakeDamage", "Horde_ApplyDamageTaken", function (target, dmg)
    if not target:IsValid() or not target:IsPlayer() then return end
    local ply = target

    -- Prevent damage from skill explosions (e.g. Chain Reaction, Volatile Dead)
    if dmg:GetInflictor():IsNPC() and dmg:GetAttacker():IsPlayer() then return true end

    -- Apply evasion
    if ply:Horde_GetEvasion() > 0 then
        local evade = math.random()
        if evade <= ply:Horde_GetEvasion() then return true end
    end

    -- Apply resistance
    local resistance = {resistance=0}
    hook.Run("Horde_ApplyAdditionalDamageTaken", ply, dmg, resistance)

    dmg:ScaleDamage(1 - resistance.resistance)
end)

hook.Add("Horde_ResetStatus", "Horde_ResetDamageTaken", function(ply)
    ply:Horde_SetEvasion(0)
    ply.Horde_DamageResistance = {}
end)

-- Enemy damage.
hook.Add("EntityTakeDamage", "Horde_MutationDamage", function (target, dmg)
    if target:IsValid() and target:IsNPC() and dmg:GetInflictor():IsNPC() and dmg:GetAttacker():IsNPC() then
        if target:GetNWEntity("HordeOwner"):IsPlayer() or dmg:GetInflictor():GetNWEntity("HordeOwner"):IsPlayer() then return end
        return true
    end
end)

-- Hulk hitbox fix
hook.Add("ScaleNPCDamage", "Horde_HulkDamage", function (npc, hitgroup, dmg)
    if npc:IsValid() and npc:GetClass() == "npc_vj_zss_zhulk" then
        if hitgroup == HITGROUP_GENERIC then
            dmg:ScaleDamage(1.5)
        end
    end
end)

-- Hulk hitbox fix
hook.Add("ScaleNPCDamage", "Horde_MutatedHulkDamage", function (npc, hitgroup, dmg)
    if npc:IsValid() and npc:GetClass() == "npc_vj_mutated_hulk" then
        if hitgroup == HITGROUP_GENERIC then
            dmg:ScaleDamage(1.5)
        end
    end
end)

-- Gonome headshot multiplier reduction
hook.Add("ScaleNPCDamage", "Horde_GonomeDamage", function (npc, hitgroup, dmg)
    if npc:IsValid() and npc:GetClass() == "npc_vj_alpha_gonome" then
        if hitgroup == HITGROUP_HEAD then
            dmg:ScaleDamage(0.5)
        end
    end
end)