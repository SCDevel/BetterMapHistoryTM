namespace HistoryWindow {
    void Render() {
        bool isOpened = Settings::ShowMenu;
        if (!isOpened or !UI::IsOverlayShown()) return;

        UI::PushStyleColor(UI::Col::WindowBg,vec4(.1,.1,.1,1));
        UI::PushStyleVar(UI::StyleVar::WindowPadding, vec2(10, 5));
        UI::PushStyleVar(UI::StyleVar::WindowRounding, 10.0);
        UI::PushStyleVar(UI::StyleVar::FramePadding, vec2(10, 6));
        UI::PushStyleVar(UI::StyleVar::WindowTitleAlign, vec2(.5, .5));
        UI::SetNextWindowSize(500, 300);
        int windowFlags = Settings::IsDevMode ? UI::WindowFlags::MenuBar + UI::WindowFlags::NoCollapse : UI::WindowFlags::NoCollapse;
        if(UI::Begin("TMX Map History", Settings::ShowMenu, windowFlags)) {
            if (Settings::IsDevMode && UI::BeginMenuBar()) {
                if (UI::Button(Icons::Refresh)) {
                    history.SortByLastPlayed();
                }
                UI::EndMenuBar();
            }
            array<Map> maps = history.GetMaps();
            if(UI::BeginTable("history_table", 4, UI::TableFlags::Sortable)) {
                UI::TableSetupColumn("Name", UI::TableColumnFlags::WidthStretch + UI::TableColumnFlags::NoSort);
                UI::TableSetupColumn("Last Played", UI::TableColumnFlags::WidthStretch + UI::TableColumnFlags::PreferSortAscending);
                UI::TableSetupColumn("   " + Icons::Map, UI::TableColumnFlags::WidthFixed + UI::TableColumnFlags::NoSort);
                UI::TableSetupColumn(Icons::Wrench, UI::TableColumnFlags::WidthFixed + UI::TableColumnFlags::NoSort);
                UI::TableHeadersRow();

                UI::TableSortSpecs@ sortSpecs = UI::TableGetSortSpecs();
                if (sortSpecs.Dirty) {
                    history.SortByLastPlayed(sortSpecs.Specs[0].SortDirection);
                    sortSpecs.Dirty = false;
                }

                UI::ListClipper clipper(maps.Length);
                while(clipper.Step()) {
                    for(int i = clipper.DisplayStart; i < clipper.DisplayEnd; i++)
                    {
                        UI::PushID("TMXMHMapHistory_"+i);
                        UI::TableNextRow();
                        if (i > 0) { // adds a sperator line between days
                        if ((maps[i - 1].last_played - maps[i].last_played) / 86400 > 0) {
                            for(int j = 0; j < 4; j++) {
                                UI::TableSetColumnIndex(j);
                                UI::Separator();
                            }
                            UI::TableNextRow();
                        }
                        }
                        UI::TableSetColumnIndex(0); // Map Name and MX_ID tooltip
                        if (Settings::ColoredMapName) UI::Text(Text::OpenplanetFormatCodes(maps[i].name));
                        else UI::Text(Text::StripFormatCodes(maps[i].name));
                        if (UI::IsItemHovered()) {
                            UI::BeginTooltip();
                            UI::Text("MX_ID = " + tostring(maps[i].MX_ID));
                            UI::EndTooltip();
                        }
                        UI::TableSetColumnIndex(1); // last_played datetime
                        UI::Text(Time::FormatString(Settings::TimestampFormat, maps[i].last_played));
                        if (UI::IsItemHovered()) {
                            UI::BeginTooltip();
                            UI::Text("SECONDS = " + tostring(maps[i].last_played));
                            UI::EndTooltip();
                        }
                        UI::TableSetColumnIndex(2); // Button that opens to the TMX window
                        if (UI::ColoredButton(Icons::InfoCircle, 0.5f)) {
                            ManiaExchange::ShowMapInfo(maps[i].MX_ID);
                        }
                        UI::TableSetColumnIndex(3); // Button that delete's the map
                        if (UI::BeginMenu("")) {
                            if (Settings::IsDevMode) {
                                if (UI::MenuItem(Icons::ArrowUp) && i > 0) {
                                    history.UpdateMap(maps[i], 0);
                                }
                                if (UI::MenuItem(Icons::LongArrowUp) && i > 0) {
                                    history.UpdateMap(maps[i], i - 1);
                                }
                                if (UI::MenuItem(Icons::LongArrowDown) && i < maps.Length) {
                                    history.UpdateMap(maps[i], i + 1);
                                }
                                if (UI::MenuItem(Icons::ArrowDown) && i < maps.Length) {
                                    history.UpdateMap(maps[i], maps.Length - 1);
                                }
                            }
                            UI::Separator();
                            if (UI::MenuItem("\\$F00\\$oD E L E T E")) {
                                history.RemoveMap(maps[i]);
                                history.SaveHistory();
                            }
                            UI::Separator();
                            UI::EndMenu();
                        }
                        UI::PopID();
                    }
                }

                UI::EndTable();
            }
        }
        UI::End();
        UI::PopStyleVar(4);
        UI::PopStyleColor(1);
    }
}