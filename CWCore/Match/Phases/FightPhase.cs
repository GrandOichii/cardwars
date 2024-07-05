using CWCore.Exceptions;
using CWCore.Match.Players;
using CWCore.Match.States;

namespace CWCore.Match.Phases;

public class FightPhase : IPhase
{
    public async Task PostEmit(GameMatch match, int playerI)
    {
        var player = match.GetPlayer(playerI);
        match.LogInfo($"Player {player.LogFriendlyName} proceeds to fighting");
        
        // TODO didn't update state for some reason
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

            var attacker = attackerState;
            await match.ExhaustToAttack(attacker);
            await match.SoftReloadState();
            attackerState = match.GetPlayerState(playerI).Landscapes[laneI].Creature!;

            attackerState.OnAttack();
            
            // damage to opponent
            var defenderState = match.GetPlayerState(1 - playerI).Landscapes[laneI].Creature;
            if (defenderState is null) {
                await match.DealDamageToPlayerBy(1 - playerI, attackerState);
                // TODO add update
                continue;
            }

            // damage to creatures
            var defender = defenderState;

            match.LogInfo($"{attacker.Original.Card.LogFriendlyName} attacks {defender.Original.Card.LogFriendlyName} in lane {laneI}");
            if (attackerState.IgnoreBlocker)
                await match.DealDamageToPlayerBy(1 - playerI, attackerState);
            else
                await match.DealDamageToCreatureBy(defender, attackerState);
            await match.DealDamageToCreatureBy(attacker, defenderState);
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

    public string GetName() => "turn_fight";

    public Task PreEmit(GameMatch match, int playerI)
    {
        return Task.CompletedTask;
    }
}
