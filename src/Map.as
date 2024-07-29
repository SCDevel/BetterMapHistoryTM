class Map {
    uint MX_ID; // ManiaExchange Map ID
    string name; // ManiaExchange GbxMapName
    int64 last_played; // The Last time a map was loaded. Using Time::Stamp

    // Map Record's are all commented out due to being incomplete.

    //array<MapRecord> records;
    //void AddRecord(const uint datetime, const float time) {
    //    records.InsertAt(0, MapRecord(datetime, time));
    //}

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

//class MapRecord {
//    int64 datetime;
//    float time;
//
//    MapRecord() {}
//
//    MapRecord(const int64 _datetime, const float _time) {
//        datetime = _datetime;
//        time = _time;
//    }
//}