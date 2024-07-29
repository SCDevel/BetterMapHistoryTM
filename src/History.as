class History {
    private string history_file_location = IO::FromStorageFolder("history.json");
    private array<Map> maps;

    History() {
        if (!IO::FileExists(history_file_location)) {
            Json::Value temp = Json::Array();
            Json::ToFile(history_file_location, temp);
        }
    }

    Map@ GetMap(const uint map_id) {
        for(uint i = 0; i < maps.Length; i++) {
            if(maps[i].MX_ID == map_id) return maps[i];
        }
        return null;
    }

    array<Map> GetMaps() const {
        return this.maps;
    }

    void AddMap(const Map map) {
        maps.InsertAt(0, map);
    }

    void UpdateMap(const Map map) {
        //map.UpdateLastPlayed();
        uint i = maps.Find(map);
        maps.RemoveAt(i);
        maps.InsertAt(0, map);
    }

    void SortByLastPlayed() {
        for (uint i = 0; i < maps.Length - 1; i++) {
            for (uint j = 0; j < maps.Length - i - 1; j++) {
                if (maps[j].last_played > maps[j + 1].last_played) {
                    // Swap the elements.
                    Map temp = maps[j];
                    maps[j] = maps[j + 1];
                    maps[j + 1] = temp;
                }
            }
        }
    }

    // Load History From File
    void LoadHistory() {
        Json::Value history = Json::FromFile(history_file_location);
        if(history.GetType() != Json::Type::Array) throw("Error - LoadHistory: Json File not in Type of Array!");
        
        for(uint i = 0; i < history.Length; i++) {

            try {
                Map map = Map();
                map.MX_ID = history[i].Get("MX_ID");
                map.name = history[i].Get("Name");
                map.last_played = history[i].Get("Last_Played");
                //try {
                //    if(history[i].Get("records").GetType() != Json::Type::Array) throw("Error - LoadHistory: Map Records for '" + map.MX_ID + "' not in Type of Array!");
                //    for(uint j = 0; j < history[i].Get("records").Length; j++) {
                //        MapRecord mapRecord = MapRecord();
                //        mapRecord.datetime = history[i].Get("records")[j].Get("datetime");
                //        mapRecord.time = history[i].Get("records")[j].Get("time");
                //        map.records.InsertLast(mapRecord);
                //    }
                //} catch {
                //    warn("Map History: Was unable to load map records for map: " + Text::StripFormatCodes(map.name) + " (" + tostring(map.MX_ID) + ").");
                //}
                maps.InsertLast(map);
            } catch {
                error("Map History: A track was unable to be loaded.");
            }
        }
        SortByLastPlayed();
    }

    // Save History to file
    void SaveHistory() {
        Json::Value history = Json::Array();

        for(uint i = 0; i < maps.Length; i++) {
            try {
                Json::Value map = Json::Object();
                map["MX_ID"] = maps[i].MX_ID;
                map["Name"] = maps[i].name;
                map["Last_Played"] = maps[i].last_played;
                map["records"] = Json::Array();
                //for(uint j = 0; j < maps[i].records.Length; j++) {
                //    map["records"][j]["datetime"] = maps[i].records[j].datetime;
                //    map["records"][j]["time"] = maps[i].records[j].time;
                //}
                history.Add(map);
            } catch {
                error("Map History: Was unable to convert map to JSON data (unable to save map): " + Text::StripFormatCodes(maps[i].name) + " (" + tostring(maps[i].MX_ID) + ").");
            }

        }

        Json::ToFile(history_file_location, history);
    }
}

