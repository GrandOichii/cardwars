# Card Wars
Backend and client client for sumulating matches of the collectable card game Card Wars

## Projects

### CWCore
Core match system. Includes match simulation, player controllers, cards and decks.

### CWCoreTester
Project for testing matches in the console.

### CWClient
Match client written in the Godot 4 game engine.

### CWImageRedirector
Simple web service for searching card images for Card Wars.

## Card scripting
All cards use Lua as their scripting language. All of the cards and their scripts can be found in the _cards_ directory.

### Card script example (Corn Lord)
```lua
function _Create()
    local result = CardWars:Creature()

    -- Corn Lord has +1 ATK for each other Cornfield Creature you control.
    CW.State.ModATKDEF(result, function (me)
        local controllerI = me.Original.ControllerI
        local ipid = me.Original.IPID

        local creatures = CW.CreatureFilter()
            :LandscapeType(CardWars.Landscapes.Cornfield)
            :ControlledBy(controllerI)
            :Except(ipid)
            :Do()

        me.Attack = me.Attack + #creatures
    end)

    return result
end
```

## Screenshots
<!-- TODO add better screenshots -->
![match1](https://github.com/GrandOichii/cardwars/blob/master/screenshots/match1.png)