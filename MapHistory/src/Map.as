class Map {
    // ManiaExchange Map ID
    uint MX_ID;
    // ManiaExchange GbxMapName
    string name; 
    // The Last time a map was loaded. Using Time::Stamp
    int64 last_played;

    void UpdateLastPlayed() {
        last_played = Time::Stamp;
    }

    bool opEquals(const Map& other) const {
        return (MX_ID == other.MX_ID);
    }

    bool less(const Map& other) const {
        return (last_played < other.last_played);
    }
}