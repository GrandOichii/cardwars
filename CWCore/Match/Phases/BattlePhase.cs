using CWCore.Exceptions;
using CWCore.Match.Players;
using CWCore.Match.States;

namespace CWCore.Match.Phases;

public class BattlePhase : IPhase
{
    public async Task Exec(GameMatch match, int playerI)
    {
        var player = match.GetPlayer(playerI);
        match.LogInfo($"Player {player.LogFriendlyName} proceeds to battle");
        
        while (true) {
            await match.ReloadState();
            if (!match.Active) return;
        
            if (!match.Config.CanAttackOnFirstTurn && match.TurnCount == 1) {
                break;
            }

            var state = match.GetPlayerState(playerI);
            var opponentState = match.GetPlayerState(1 - playerI);

            var options = AvailableAttacks(state);
            if (options.Count == 0) break;

            var laneI = await player.PickAttackLane(options);
            if (laneI < 0 || laneI >= match.Config.LaneCount) {
                match.ActionError($"Player {player.LogFriendlyName} picked lane idx {laneI} for attack");
                continue;
            }

            var lane = state.Landscapes[laneI];
            if (lane.Creature is null) {
                match.ActionError($"Player {player.LogFriendlyName} tried to attack in lane {laneI}, where they don't have any creatures");
                continue;
            }

            var attackerState = lane.Creature;
            if (!attackerState.CanAttack) {
                match.ActionError($"Player {player.LogFriendlyName} tried to attack in lane {laneI}, but the creature in that lane can't attack ({attackerState.Original.Card.LogFriendlyName})");
                continue;
            }

            var attacker = attackerState.GetOriginal();
            await match.ExhaustToAttack(attacker);
            
            // damage
            var defenderState = opponentState.Landscapes[laneI].Creature;
            if (defenderState is null) {
                var attack = attackerState.Attack;
                await match.DealDamageToPlayer(1 - playerI, attack);
                // TODO add update
                continue;
            }

            // TODO bad?
            var defender = (Creature)defenderState.Original;

            // TODO deal damage to each other
            match.LogInfo($"{attacker.Card.LogFriendlyName} attacks {defender.Card.LogFriendlyName} in lane {laneI}");
            await match.DealDamageToCreature(defender, attackerState.Attack);
            await match.DealDamageToCreature(attacker, defenderState.Attack);
        }
    }

    private static List<int> AvailableAttacks(PlayerState playerState) {
        var result = new List<int>();

        for (int i = 0; i < playerState.Landscapes.Count; i++) {
            var lane = playerState.Landscapes[i];

            if (lane.Creature is null) continue;
            if (!lane.Creature.CanAttack) continue;

            result.Add(i);
        }

        return result;
    }

    public static bool CanAttack(PlayerState playerState) {
        foreach (var lane in playerState.Landscapes) {
            if (lane.Creature is null) continue;

            if (lane.Creature.CanAttack) return true;
        }

        return false;
    }
}
