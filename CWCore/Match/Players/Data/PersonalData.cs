namespace CWCore.Match.Players.Data;

public readonly struct PersonalData {
    public List<CardData> Hand { get; }
    public PersonalData(GameMatch match, int playerI) {
        if (playerI >= match.LastState.Players.Length) {
            Hand = new();
            return;
        }
        var player = match.GetPlayerState(playerI);

        Hand = player.Hand.Select(card => new CardData(card)).ToList();
    }
}