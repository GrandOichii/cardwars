using CWCore.Match.Players;
using CWCore.Match.States;
using CWCore.Exceptions;

namespace CWCore.Match.Phases;

public class TurnEndPhase : IPhase {
    public async Task Exec(GameMatch match, int playerI) {
        // TODO other stuff

        foreach (var trigger in match.AEOTEffects) {
            try {
                trigger.Call();
            } catch (Exception e) {
                throw new CWCoreException("error while executing \"at the end of turn\" effect", e);
            }
        }
        match.AEOTEffects.Clear();

        match.UEOTEffects.Clear();
        foreach (var player in match.Players) {
            player.CardsPlayedThisTurn.Clear();

            foreach (var landscape in player.Landscapes) {
                landscape.CreaturesEnteredThisTurn.Clear();
                
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