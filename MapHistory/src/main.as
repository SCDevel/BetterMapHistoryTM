History history;
Map@ currentMap;

int mapUid = -1;

void Main() {
  history.LoadHistory();
  history.SortByLastPlayed();
}

void Update(float dt) {
  auto app = cast<CTrackMania>(GetApp());
    auto mapInfo = ManiaExchange::GetCurrentMapInfo();
    int mapId = mapInfo["TrackID"];
    string gbxMapName = mapInfo["GbxMapName"];
  
    if (mapId != mapUid && mapId >= 0 && app.Editor is null) { 
      mapUid = mapId;
      @currentMap = history.GetMap(mapUid);
      if (currentMap is null) {
        Map map = Map();
        map.MX_ID = mapUid;
        map.name = gbxMapName;
        map.UpdateLastPlayed();
        history.AddMap(map);
      } else {
        history.UpdateMap(currentMap);
      }
      history.SaveHistory();
    }
}

void Render() {
  HistoryWindow::Render();
}

void RenderMenu() {
  if(UI::MenuItem("\\$FB0" + Icons::Calendar + "\\$z TMX Map History", "", Settings::Setting_ShowMenu)) {
    Settings::Setting_ShowMenu = !Settings::Setting_ShowMenu;
  }
}