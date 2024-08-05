class History {
    private array<Map> maps;
    UI::SortDirection sortDirection = UI::SortDirection::Ascending;

    History(const string file = IO::FromStorageFolder("history.json")) {
        if (!IO::FileExists(file)) {
            Json::Value temp = Json::Array();
            Json::ToFile(file, temp);
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

    void RemoveMap(const Map map) {
        try {
            uint i = maps.Find(map);
            maps.RemoveAt(i);
        } catch {
            print("Map not found, unable to remove from history!");
        }
    }

    void UpdateMap(const Map map, const uint pos = 0) {
        RemoveMap(map);
        maps.InsertAt(pos, map);
    }

    void AddMap(const Map map) {
        RemoveMap(map);
        switch (sortDirection) {
            case UI::SortDirection::Ascending:
                maps.InsertAt(0, map);
                break;
            case UI::SortDirection::Descending:
                maps.InsertLast(map);
                break;
            case UI::SortDirection::None:
                maps.InsertAt(0, map);
                history.SortByLastPlayed();
                break;
        }
    }

    void SortByLastPlayed(UI::SortDirection sortDirection = UI::SortDirection::Ascending) {
        for (uint i = 0; i < maps.Length - 1; i++) {
            for (uint j = 0; j < maps.Length - i - 1; j++) {
                bool swap = false;
                switch (sortDirection) {
                    case UI::SortDirection::Ascending:
                        if (maps[j].last_played < maps[j + 1].last_played) swap = true;
                        break;
                    case UI::SortDirection::Descending:
                        if (maps[j].last_played > maps[j + 1].last_played) swap = true;
                        break;
                    case UI::SortDirection::None:
                        break;
                }
                if (swap) {
                    Map temp = maps[j];
                    maps[j] = maps[j + 1];
                    maps[j + 1] = temp;
                }
            }
        }
    }

    void BackupHistory(const string file = IO::FromStorageFolder("history.json"), const string backup_file = IO::FromStorageFolder("history.json.backup")) {
        Json::Value history = Json::FromFile(file);
        Json::ToFile(backup_file, history);
    }

    void SaveHistory() {
        BackupHistory();
        _SaveHistory();
    }

    // Load History From File
    void LoadHistory(const string file = IO::FromStorageFolder("history.json")) {
        Json::Value history = Json::FromFile(file);
        if(history.GetType() != Json::Type::Array) throw("TMX Map History - LoadHistory: Json File not in Type of Array!");
        
        for(uint i = 0; i < history.Length; i++) {

            try {
                Map map = Map();
                map.MX_ID = history[i].Get("MX_ID");
                map.name = history[i].Get("Name");
                map.last_played = history[i].Get("Last_Played");
                maps.InsertLast(map);
            } catch {
                error("TMX Map History: A track was unable to be loaded.");
            }
        }
    }

    // Save History to file
    void _SaveHistory(const string file = IO::FromStorageFolder("history.json")) {
        Json::Value history = Json::Array();

        for(uint i = 0; i < maps.Length; i++) {
            if (i >= Settings::MaxMaps) continue;
            try {
                Json::Value map = Json::Object();
                map["MX_ID"] = maps[i].MX_ID;
                map["Name"] = maps[i].name;
                map["Last_Played"] = maps[i].last_played;
                history.Add(map);
            } catch {
                error("TMX Map History: Was unable to convert map to JSON data (unable to save map): " + Text::StripFormatCodes(maps[i].name) + " (" + tostring(maps[i].MX_ID) + ").");
            }

        }

        Json::ToFile(file, history);
    }
}

