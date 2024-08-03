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
        if(UI::Begin("TMX Map History", Settings::ShowMenu)) {
            array<Map> maps = history.GetMaps();
            if(UI::BeginTable("history_table", 4)) {
                UI::TableSetupColumn("Name", UI::TableColumnFlags::WidthStretch);
                UI::TableSetupColumn("Last Played", UI::TableColumnFlags::WidthStretch);
                UI::TableSetupColumn("   " + Icons::Map, UI::TableColumnFlags::WidthFixed);
                UI::TableSetupColumn(Icons::Wrench, UI::TableColumnFlags::WidthFixed);
                UI::TableHeadersRow();

                UI::ListClipper clipper(maps.Length);
                while(clipper.Step()) {
                    for(int i = clipper.DisplayStart; i < clipper.DisplayEnd; i++)
                    {
                        UI::PushID("TMXMHMapHistory_"+i);
                        UI::TableNextRow();
                        if (i > 0) { // adds a sperator line between days
                        if (Math::Floor(maps[i - 1].last_played / 86400) != Math::Floor(maps[i].last_played / 86400)) {
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
                        UI::TableSetColumnIndex(2); // Button that opens to the TMX window
                        if (UI::ColoredButton(Icons::InfoCircle, 0.5f)) {
                            ManiaExchange::ShowMapInfo(maps[i].MX_ID);
                        }
                        UI::TableSetColumnIndex(3); // Button that delete's the map
                        if (UI::BeginMenu("")) {
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