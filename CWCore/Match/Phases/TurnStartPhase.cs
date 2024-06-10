using CWCore.Match.Players;
using CWCore.Match.States;

namespace CWCore.Match.Phases;

public class TurnStartPhase : IPhase {
    public async Task Exec(GameMatch match, int playerI) {
        var player = match.GetPlayer(playerI);

        player.ActionPoints = match.Config.ActionPointsPerTurn;

        foreach (var lane in player.Landscapes) {
            var creature = lane.Creature;
            if (creature is not null) {
                creature.MovementCount = 0;
                creature.EnteredThisTurn = false;
            } 
            var building = lane.Building;
            if (building is not null) {
                building.EnteredThisTurn = false;
            }
        }
        
        await player.ResetActionPoints();
        await player.ReadyInPlayCards();

        await match.Emit("turn_start", new(){ {"playerI", playerI} });

        player.Draw(1);
    }
}