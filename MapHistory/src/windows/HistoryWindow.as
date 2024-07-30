namespace HistoryWindow {
    void Render() {
        bool isOpened = Settings::Setting_ShowMenu;
        if (!isOpened or !UI::IsOverlayShown()) return;

        UI::PushStyleColor(UI::Col::WindowBg,vec4(.1,.1,.1,1));
        UI::PushStyleVar(UI::StyleVar::WindowPadding, vec2(10, 10));
        UI::PushStyleVar(UI::StyleVar::WindowRounding, 10.0);
        UI::PushStyleVar(UI::StyleVar::FramePadding, vec2(10, 6));
        UI::PushStyleVar(UI::StyleVar::WindowTitleAlign, vec2(.5, .5));
        UI::SetNextWindowSize(450, 300);
        if(UI::Begin("TMX Map History", Settings::Setting_ShowMenu)) {
            array<Map> maps = history.GetMaps();
            if(UI::BeginTable("history_table", 3)) {
                UI::TableSetupColumn("Name", UI::TableColumnFlags::WidthStretch);
                UI::TableSetupColumn("Last Played", UI::TableColumnFlags::WidthStretch);
                UI::TableSetupColumn("Actions", UI::TableColumnFlags::WidthFixed);
                UI::TableHeadersRow();

                UI::ListClipper clipper(maps.Length);
                while(clipper.Step()) {
                    for(int i = clipper.DisplayStart; i < clipper.DisplayEnd; i++)
                    {
                        UI::PushID("ResMap"+i);
                        UI::TableNextRow();
                        UI::TableSetColumnIndex(0); // Map Name and MX_ID tooltip
                        if (Settings::Setting_ColoredMapName) UI::Text(Text::OpenplanetFormatCodes(maps[i].name));
                        else UI::Text(Text::StripFormatCodes(maps[i].name));
                        if (UI::IsItemHovered()) {
                            UI::BeginTooltip();
                            UI::Text("MX_ID = " + tostring(maps[i].MX_ID));
                            UI::EndTooltip();
                        }
                        UI::TableSetColumnIndex(1); // last_played datetime
                        UI::Text(Time::FormatString(Settings::Setting_TimestampFormat, maps[i].last_played));
                        UI::TableSetColumnIndex(2); // Button that opens to the TMX window
                        if (UI::ColoredButton(Icons::InfoCircle, 0.5f)) {
                            ManiaExchange::ShowMapInfo(maps[i].MX_ID);
                        }
                        UI::SameLine();
                        if (UI::ColoredButton(Icons::Trash, 1.0f)) {
                            history.RemoveMap(maps[i]);
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