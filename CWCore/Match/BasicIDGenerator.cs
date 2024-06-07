namespace CWCore.Match;

public class BasicIDGenerator : IIDGenerator
{
    int _v = 0;
    
    public string Next()
    {
        _v++;
        return _v.ToString();
    }
}