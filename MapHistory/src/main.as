History history;
Json::Value mapInfo;
Map@ currentMap;
CTrackMania@ app; 
int mapUid = -1;

#if TMNEXT

void Main() {
  Settings::IsDevMode = Meta::IsDeveloperMode();
  CTrackMania@ app = cast<CTrackMania>(GetApp());
  history.LoadHistory();
}

void Update(float dt) {
  // try to get map info but return if error.
  try {
    mapInfo = ManiaExchange::GetCurrentMapInfo();
  } catch {
    return;
  }
  
  int mapId = mapInfo["TrackID"];
  string gbxMapName = mapInfo["GbxMapName"];

  if (mapId != mapUid && mapId >= 0) { // checks if in map
    mapUid = mapId;
    @currentMap = history.GetMap(mapUid);
    if (currentMap is null) {
      Map map = Map();
      map.MX_ID = mapUid;
      map.name = gbxMapName;
      map.UpdateLastPlayed();
      history.AddMap(map);
    } else {
      currentMap.UpdateLastPlayed();
      history.AddMap(currentMap);
    }
    history.SaveHistory();
  }
}

void Render() {
  HistoryWindow::Render();
}

void RenderMenu() {
  if(UI::MenuItem("\\$FB0" + Icons::Calendar + "\\$z TMX Map History", "", Settings::ShowMenu)) {
    Settings::ShowMenu = !Settings::ShowMenu;
  }
}

#else

void Main() {
  error("TMNEXT is the only supported game.");
}

#endif