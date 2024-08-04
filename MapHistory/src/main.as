History history;
Map@ currentMap;
auto app; 

int mapUid = -1;

void Main() {
  app = cast<CTrackMania>(GetApp());
  history.LoadHistory();
  history.SortByLastPlayed();
}

void Update(float dt) {
  auto mapInfo = ManiaExchange::GetCurrentMapInfo();
  int mapId = mapInfo["TrackID"];
  string gbxMapName = mapInfo["GbxMapName"];

  if (mapId != mapUid && mapId >= 0 && app.Editor is null) { // checks if in map
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
      history.UpdateMap(currentMap);
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