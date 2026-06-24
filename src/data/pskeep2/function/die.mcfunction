advancement ~/ {
    "criteria": {
        "requirement": {
            "trigger": "minecraft:entity_hurt_player",
            "conditions": {
                "player": [
                    {
                        "condition": "minecraft:entity_properties",
                        "entity": "this",
                        "predicate": {
                            "nbt": "{Health:0f}"
                        }
                    }
                ]
            }
        }
    },
    "rewards": {
        "function": "pskeep2:die"
    }
}
advancement revoke @s only ~/

# clear all items with a vanishing enchantment to remove permanently
clear @s *[enchantments~[{enchantments:vanishing_curse}]]
# store items before and after clearing
data modify storage pskeep2:main items.all set from entity @s Inventory
execute if data entity @s equipment.offhand run function pskeep2:drop/offhand
data modify storage pskeep2:main offhand.item set from entity @s equipment.offhand
clear @s #pskeep2:drop
data modify storage pskeep2:main items.left set from entity @s Inventory
data modify storage pskeep2:main offhand.left set from entity @s equipment.offhand

# if no items are left after clearing but were before -- drop all
unless data storage pskeep2:main items.left[0] if data storage pskeep2:main items.all[0] function ~/drop_all_recursive:
    data modify storage pskeep2:main drop.item set from storage pskeep2:main items.all[-1]
    function pskeep2:drop/item with storage pskeep2:main drop
    data remove storage pskeep2:main items.all[-1]
    if data storage pskeep2:main items.all[0] function ~/

# go through all items and drop the cleared ones
if data storage pskeep2:main items.all[0] function ~/drop_recursive:
    data modify storage pskeep2:main drop.item set from storage pskeep2:main items.left[-1]
    store result score #is_different pskeep2 data modify storage pskeep2:main drop.item set from storage pskeep2:main items.all[-1]
    if score #is_different pskeep2 matches 1 function pskeep2:drop/item with storage pskeep2:main drop
    data remove storage pskeep2:main items.all[-1]
    if score #is_different pskeep2 matches 0 data remove storage pskeep2:main items.left[-1]
    # if no items are left -- drop all to prevent unforseen behavior
    unless data storage pskeep2:main items.left[0] if data storage pskeep2:main items.all[0] return run function ~/../drop_all_recursive
    if data storage pskeep2:main items.all[0] function ~/

execute unless data storage pskeep2:main offhand.left if data storage pskeep2:main offhand.item run function pskeep2:drop/item with storage pskeep2:main offhand

execute function ~/drop_xp:
    #> https://minecraft.wiki/w/Experience#Leveling_up
    # set up variables
    execute store result score .level pskeep2 store result score .xp pskeep2 store result score #level_squared pskeep2 run xp query @s levels
    execute store result score .points pskeep2 run xp query @s points
    scoreboard players operation #level_squared pskeep2 *= #level_squared pskeep2
    execute if score .level pskeep2 matches 17..31 run scoreboard players operation #level_squared pskeep2 *= #5 pskeep2
    execute if score .level pskeep2 matches 32.. run scoreboard players operation #level_squared pskeep2 *= #9 pskeep2
    execute if score .level pskeep2 matches 1..16 run scoreboard players operation .xp pskeep2 *= #6 pskeep2
    execute if score .level pskeep2 matches 17..31 run scoreboard players operation .xp pskeep2 *= #-81 pskeep2
    execute if score .level pskeep2 matches 32.. run scoreboard players operation .xp pskeep2 *= #-325 pskeep2
    execute if score .level pskeep2 matches 17.. run scoreboard players operation #level_squared pskeep2 /= #2 pskeep2
    execute if score .level pskeep2 matches 17.. run scoreboard players operation .xp pskeep2 /= #2 pskeep2
    execute if score .level pskeep2 matches 17..31 run scoreboard players add .xp pskeep2 360
    execute if score .level pskeep2 matches 32.. run scoreboard players add .xp pskeep2 2220
    scoreboard players operation .xp pskeep2 += #level_squared pskeep2
    scoreboard players operation .xp pskeep2 += .points pskeep2
    execute store result score .xpiter pskeep2 run scoreboard players get .xp pskeep2
    scoreboard players operation .xpiter pskeep2 /= #xpmax pskeep2
    execute store result storage pskeep2:main drop.xp int 1 run scoreboard players operation .xp pskeep2 %= #xpmax pskeep2
    execute if score .xp pskeep2 matches 1.. run function pskeep2:drop/xp with storage pskeep2:main drop
    xp set @s 0 levels
    xp set @s 0 points

data remove storage pskeep2:main offhand
