GADGET.PrintName = "Chakra"
GADGET.Description =
[[Removes all debuff buildups and debuffs.\nRecover 10 health.]]
GADGET.Icon = "items/gadgets/chakra.png"
GADGET.Duration = 0
GADGET.Cooldown = 5
GADGET.Active = false
GADGET.Params = {
}
GADGET.Hooks = {}

GADGET.Hooks.Horde_UseActiveGadget = function (ply)
    if CLIENT then return end
    if ply:Horde_GetGadget() ~= "gadget_chakra" then return end

    for debuff, buildup in pairs(ply.Horde_Debuff_Buildup) do
        ply:Horde_RemoveDebuff(debuff)
    end

    sound.Play("items/medshot4.wav", ply:GetPos())
    local healinfo = HealInfo:New({amount=10, healer=ply})
    HORDE:OnPlayerHeal(ply, healinfo)
end