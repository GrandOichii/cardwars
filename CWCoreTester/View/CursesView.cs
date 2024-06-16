using System.Drawing;
using CWCore.Cards;
using CWCore.Match;
using CWCore.Match.States;
using Mindmagma.Curses;

public class CursesView : IMatchView
{
    private readonly Dictionary<string, short> LANDSCAPE_COLOR_MAP = new() {
        {"Useless Swamp", 236}, 
        {"Cornfield", CursesColor.YELLOW}, 
        {"Blue Plains", CursesColor.BLUE}, 
        {"SandyLands", 220}, 
        {"NiceLands", 15}, 
        {"IcyLands", 69}, // nice 
        {"Rainbow", 201}, 
    };

    private readonly Dictionary<string, short> LANDSCAPE_COLOR_PAIR_MAP;

    public Task End()
    {
        NCurses.Echo();
        NCurses.SetCursor(1);
        NCurses.EndWin();
        return Task.CompletedTask;
    }

    public Task Start()
    {
        return Task.CompletedTask;
    }

    public Task Update(GameMatch match)
    {
        NCurses.Clear();
        Logs.Add("---");

        if (match.LastState.Players.Length > 0) {
            DrawPlayer(0, 0, match.LastState.Players[0], false);
            DrawPlayer(0, 0, match.LastState.Players[1], true);
        }

        DrawLogs();

        return Task.CompletedTask;
    }

    private IntPtr Screen { get; }
    private readonly short BG_COLOR = 250;

    public CursesView() {
        
        Screen = NCurses.InitScreen();

        // NCurses.NoDelay(Screen, true);
        NCurses.NoEcho();
        NCurses.SetCursor(0);
        NCurses.StartColor();
        NCurses.InitPair(1, CursesColor.BLACK, BG_COLOR);
        NCurses.Background(NCurses.ColorPair(1));

        LANDSCAPE_COLOR_PAIR_MAP = new();
        short pairI = 1;
        foreach (var pair in LANDSCAPE_COLOR_MAP) {
            pairI++;
            NCurses.InitPair(pairI, pair.Value, BG_COLOR);
            LANDSCAPE_COLOR_PAIR_MAP.Add(pair.Key, pairI);
        }
    }

    private static readonly int CARD_WIDTH = 30;
    private static readonly int CARD_HEIGHT = 16;

    private static readonly int LANDSCAPE_WIDTH = 36;
    private static readonly int LANDSCAPE_HEIGHT = 24;

    private static readonly int LOGS_LIMIT = 40;

    public List<string> Logs { get; set; } = new();

    public void DrawLogs() {
        var start = 0;
        if (Logs.Count > LOGS_LIMIT) 
            start = Logs.Count - LOGS_LIMIT;

        var pos = 0;
        for (int i = start; i < Logs.Count; i++) {
            NCurses.MoveAddString(1 + pos, 4 * LANDSCAPE_WIDTH + 10, Logs[i]);
            ++pos;
        }
    }

    public void DrawPlayer(int y, int x, PlayerState player, bool isOpponent) {
        // NCurses.Flash();
        var mod = isOpponent ? LANDSCAPE_HEIGHT + 1 : 0;
        for (int i = 0; i < player.Landscapes.Count; i++) {
            DrawLandscape(mod + y, x + i * (LANDSCAPE_WIDTH+1), player.Landscapes[i]);
        }
    }

    public void DrawLandscape(int y, int x, LandscapeState landscape) {
        var pairI = LANDSCAPE_COLOR_PAIR_MAP[landscape.GetName];
        var pair = NCurses.ColorPair(pairI);
        NCurses.AttributeOn(pair);
        NCurses.MoveAddChar(y, x, CursesLineAcs.ULCORNER);
        NCurses.MoveAddChar(y, x + LANDSCAPE_WIDTH, CursesLineAcs.URCORNER);
        NCurses.MoveAddChar(y + LANDSCAPE_HEIGHT, x, CursesLineAcs.LLCORNER);
        NCurses.MoveAddChar(y + LANDSCAPE_HEIGHT, x + LANDSCAPE_WIDTH, CursesLineAcs.LRCORNER);
        for (int i = 0; i < LANDSCAPE_WIDTH - 1; i++) {
            NCurses.MoveAddChar(y, x + i + 1, CursesLineAcs.HLINE);
            NCurses.MoveAddChar(y + 2, x + i + 1, CursesLineAcs.HLINE);
            NCurses.MoveAddChar(y + LANDSCAPE_HEIGHT, x + i + 1, CursesLineAcs.HLINE);
        }
        for (int i = 0; i < LANDSCAPE_HEIGHT - 1; i++) {
            NCurses.MoveAddChar(y + i + 1, x, CursesLineAcs.VLINE);
            NCurses.MoveAddChar(y + i + 1, x + LANDSCAPE_WIDTH, CursesLineAcs.VLINE);
        }
        // TODO add more borders
        // draw text
        NCurses.MoveAddString(y+1, x+2, landscape.GetName());

        NCurses.AttributeOff(pair);

        if (landscape.Creature is not null) {
            DrawCard(y + 3, x + 3, landscape.Creature);
        }
    }

    public void DrawCard(int y, int x, CreatureState card) {
        DrawCard(y, x, card.Original.Card);

        NCurses.MoveAddString(y+15, x+2, "  ");
        NCurses.MoveAddString(y+15, x+2, card.Attack.ToString());
        NCurses.MoveAddString(y+15, x+CARD_WIDTH-3, "  ");
        NCurses.MoveAddString(y+15, x+CARD_WIDTH-3, (card.Defense - card.GetDamage()).ToString());
    }

    public void DrawCard(int y, int x, InPlayCardState card) {
        DrawCard(y, x, card.Original.Card);
        // if (!card.Original.Card.IsCreature) return;
        // NCurses.MoveAddString(y+15, x+2, card.Attack.ToString());
        // NCurses.MoveAddString(y+15, x+CARD_WIDTH-3, card.Template.Defense.ToString());
    }

    public void DrawCard(int y, int x, CardState card) {
        DrawCard(y, x, card.Original);
        NCurses.MoveAddString(y+1, x+2, card.Cost.ToString());
    }

    public void DrawCard(int y, int x, MatchCard card) {
        // draw borders
        var pairI = LANDSCAPE_COLOR_PAIR_MAP[card.Template.Landscape];
        var pair = NCurses.ColorPair(pairI);
        NCurses.AttributeOn(pair);
        NCurses.MoveAddChar(y, x, CursesLineAcs.ULCORNER);
        NCurses.MoveAddChar(y, x + CARD_WIDTH, CursesLineAcs.URCORNER);
        NCurses.MoveAddChar(y + CARD_HEIGHT, x, CursesLineAcs.LLCORNER);
        NCurses.MoveAddChar(y + CARD_HEIGHT, x + CARD_WIDTH, CursesLineAcs.LRCORNER);
        for (int i = 0; i < CARD_WIDTH - 1; i++) {
            NCurses.MoveAddChar(y, x + i + 1, CursesLineAcs.HLINE);
            NCurses.MoveAddChar(y + 2, x + i + 1, CursesLineAcs.HLINE);
            NCurses.MoveAddChar(y + 4, x + i + 1, CursesLineAcs.HLINE);
            NCurses.MoveAddChar(y + CARD_HEIGHT - 2, x + i + 1, CursesLineAcs.HLINE);
            NCurses.MoveAddChar(y + CARD_HEIGHT, x + i + 1, CursesLineAcs.HLINE);
        }
        for (int i = 0; i < CARD_HEIGHT - 1; i++) {
            NCurses.MoveAddChar(y + i + 1, x, CursesLineAcs.VLINE);
            NCurses.MoveAddChar(y + i + 1, x + CARD_WIDTH, CursesLineAcs.VLINE);
        }
        NCurses.MoveAddChar(y + 1, x + 4, CursesLineAcs.VLINE);
        // TODO add more borders


        NCurses.AttributeOff(pair);


        // draw text
        NCurses.MoveAddString(y+1, x+2, card.Template.Cost.ToString());
        NCurses.MoveAddString(y+1, x+5, card.Template.Name + $"[{card.ID}]");
        NCurses.MoveAddString(y+3, x+1, card.Template.Landscape + " " + card.Template.Type);
        
        var lines = WordWrap(card.Template.Text, 26);
        for (int i = 0; i < lines.Count; i++)
            NCurses.MoveAddString(y+5+i, x+1, lines[i]);

        if (!card.IsCreature) return;
        NCurses.MoveAddString(y+15, x+2, card.Template.Attack.ToString());
        NCurses.MoveAddString(y+15, x+CARD_WIDTH-3, card.Template.Defense.ToString());
    }

    public static List<string> WordWrap( string text, int maxLineLength )
    {
        var result = new List<string>();

        int currentIndex;
        var lastWrap = 0;
        var whitespace = new[] { ' ', '\r', '\n', '\t' };
        do
        {
            currentIndex = lastWrap + maxLineLength > text.Length ? text.Length : (text.LastIndexOfAny( new[] { ' ', ',', '.', '?', '!', ':', ';', '-', '\n', '\r', '\t' }, Math.Min( text.Length - 1, lastWrap + maxLineLength)  ) + 1);
            if( currentIndex <= lastWrap )
                currentIndex = Math.Min( lastWrap + maxLineLength, text.Length );
            result.Add( text.Substring( lastWrap, currentIndex - lastWrap ).Trim( whitespace ) );
            lastWrap = currentIndex;
        } while( currentIndex < text.Length );

        return result;
    }

}
