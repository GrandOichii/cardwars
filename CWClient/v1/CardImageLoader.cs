using System.IO;

namespace CWClient.v1;

// TODO complete this
public class CardImageLoader {
    private readonly string _path;
    public CardImageLoader(string path) {
        System.IO.Directory.CreateDirectory(path);;
        _path = path;
    }

    public Image? Get(string cardName) {
        var path = Path.Join(_path, cardName + ".jpg");
        if (!File.Exists(path)) return null;
        return Image.LoadFromFile(path);
    }
}