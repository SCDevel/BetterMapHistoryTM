namespace UI {
    bool ColoredButton(const string &in text, float h, float s=0.6f, float v=0.6f) {
        UI::PushStyleColor(UI::Col::Button, UI::HSV(h, s, v));
        UI::PushStyleColor(UI::Col::ButtonHovered, UI::HSV(h, s+0.1f, v+0.1f));
        UI::PushStyleColor(UI::Col::ButtonActive, UI::HSV(h, s+0.2f, v+0.2f));
        bool rtn = UI::Button(text);
        UI::PopStyleColor(3);
        return rtn;
    }
}