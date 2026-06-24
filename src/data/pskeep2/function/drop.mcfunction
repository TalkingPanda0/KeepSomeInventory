
function ~/item:
    $summon item ~ ~ ~ {Age:-6000s,Item:$(item)}

function ~/xploop:
  summon experience_orb ~ ~ ~ {Age:-6000s,Value:32767}
  scoreboard players remove .xpiter pskeep2 1
  execute if score .xpiter pskeep2 matches 1.. run function pskeep2:drop/xploop

function ~/xp:
    execute if score .xpiter pskeep2 matches 1.. run function pskeep2:drop/xploop
    $summon experience_orb ~ ~ ~ {Age:-6000s,Value:$(xp)}
