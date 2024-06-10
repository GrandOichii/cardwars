using CWCore.Match.Players;
using CWCore.Match.States;

namespace CWCore.Match.Phases;

public class TurnEndPhase : IPhase {
    public async Task Exec(GameMatch match, int playerI) {
        // TODO other stuff

        match.UEOTEffects.Clear();
        foreach (var player in match.Players) {
            player.CardsPlayedThisTurn.Clear();

            foreach (var landscape in player.Landscapes) {
                var cards = new List<InPlayCard?>() { landscape.Creature, landscape.Building };
                foreach (var card in cards) {
                    if (card is null) continue;
                    foreach (var a in card.ActivatedEffects)
                        a.ActivatedThisTurn = 0;
                }
            }
        }
    }
}