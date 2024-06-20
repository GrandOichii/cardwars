namespace CWClient.v1;

public interface ILandscapeScene {
    public void SetPlayerIdx(int idx);
    public void SetLaneIdx(int idx);
    public void ConnectCardHover(Action<string> a);
}
