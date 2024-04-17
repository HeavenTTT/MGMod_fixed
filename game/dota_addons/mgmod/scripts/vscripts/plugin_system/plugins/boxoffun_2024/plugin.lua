BoxOfFun23Plugin = class({})
_G.BoxOfFun23Plugin = BoxOfFun23Plugin

function BoxOfFun23Plugin:Init()
    print("[BoxOfFun23Plugin] found")
end

function BoxOfFun23Plugin:ApplySettings()
    BoxOfFun23Plugin.settings = PluginSystem:GetAllSetting("xmas_2023")
    --Towers give mana but you have 0 mana regen elsewhere.
    --LinkLuaModifier( "xmas23_day5", "plugin_system/plugins/xmas_2023/modifiers/xmas23_day5", LUA_MODIFIER_MOTION_NONE )

    ListenToGameEvent("npc_spawned", function(event)
        if GameRules:State_Get() < DOTA_GAMERULES_STATE_HERO_SELECTION then return end
        BoxOfFun23Plugin:SpawnEvent(event)
    end,nil)

    ListenToGameEvent("dota_rune_activated_server", function(event)
        if GameRules:State_Get() < DOTA_GAMERULES_STATE_HERO_SELECTION then return end
        BoxOfFun23Plugin:RunePickupEvent(event)
    end,nil)

    
end

function BoxOfFun23Plugin:GameInProgressEvent()
end

function BoxOfFun23Plugin:SpawnEvent(event)
    local hUnit = EntIndexToHScript(event.entindex)
    if not hUnit:IsDOTANPC() then return end

    if hUnit:IsRealHero() then
    end
end
function BoxOfFun23Plugin:RunePickupEvent(event)
    local iPlayer = event.PlayerID
    local iRune = event.rune
    local iTeam = PlayerResource:GetCustomTeamAssignment(iPlayer)
    local hPlayer = PlayerResource:GetPlayer(iPlayer)
    local hHero = hPlayer:GetAssignedHero()
    local t = {
        {"modifier_rune_doubledamage",45},
        {"modifier_rune_haste",22},
        {"modifier_rune_illusion",45},
        {"modifier_rune_invis",45},
        {"modifier_rune_bounty",1}, --TODO: MAKE ONE
        {"modifier_rune_arcane",50},
        {"modifier_rune_water",1}, --TODO: MAKE ONE
        {"modifier_rune_xp",1}, --TODO: MAKE ONE
        {"modifier_rune_shield",75}
    }
    BoxOfFun23Plugin:AddNewModifierToTeam(iTeam,t[iRune][1],{duration = t[iRune][2]},true,hHero)
end

function BoxOfFun23Plugin:AddNewModifierToTeam(iTeam,sMod,tData,bHeroes,hSkip)
    if sMod == "" then return end
    bHeroes = bHeroes or false
    local iTeam = iTeam or -1
    local e = Entities:Next(nil)
    while e do
        if e.IsBaseNPC and e:IsBaseNPC() then
            if bHeroes == e:IsRealHero() or not bHeroes then
                if hSkip ~= e then
                    if iTeam == -1 or (e.GetTeam and e:GetTeam() == iTeam) then
                        local hModifier = e:AddNewModifier(e,nil,sMod,tData)
                    end
                end
            end
        end
        e = Entities:Next(e)
    end
end