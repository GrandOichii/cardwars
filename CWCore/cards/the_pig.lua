-- Status: not tested

function _Create()
    local result = CardWars:Creature()

    local targets = function (playerI, laneI)
        return CW.LandscapeFilter():OnLane(laneI):OfLandscapeType(CardWars.Landscapes.Cornfield):CanBeFlippedDown(playerI)
    end

    CW.ActivatedAbility.Add(
        result,
        'FLOOP >>> Flip target Cornfield Landscape in this Lane face down.',
        CW.ActivatedAbility.Cost.And(
            CW.ActivatedAbility.Cost.Floop(),
            CW.ActivatedAbility.Cost.Check(function (me, playerI, laneI)
                return #targets(playerI, laneI):Do() > 0
            end)
        ),
        function (me, playerI, laneI)
            local landscape = CW.Target.Landscape(
                targets(playerI, laneI):Do(),
                playerI
            )
            assert(landscape ~= nil, 'activated ability check of card '..me.Original.Card.Template.Name..' returned true, but no flippable landscapes found')
            CW.Landscape.FlipDown(landscape.Original.OwnerI, landscape.Original.Idx)
        end
    )

    return result
end