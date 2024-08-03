namespace Settings {
    [Setting name="Show menu" category="General"]
    bool ShowMenu = false;

    [Setting name="Use colored map name" category="General"]
    bool ColoredMapName = true;

    [Setting name="Max Map's to save" category="General" ]
    uint MaxMaps = 30;

    [Setting name="Preferred timestamp format" category="General"]
    string TimestampFormat = "%Y-%m-%dT%H:%M:%S (%z)";
}