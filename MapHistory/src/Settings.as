namespace Settings {
    [Setting name="Show menu" category="General"]
    bool Setting_ShowMenu = false;

    [Setting name="Use colored map name" category="General"]
    bool Setting_ColoredMapName = true;

    [Setting name="Max Map's to save" category="General" ]
    uint Setting_MaxMaps = 25;

    [Setting name="Preferred timestamp format" category="General"]
    string Setting_TimestampFormat = "%Y-%m-%dT%H:%M:%S (%z)";
}