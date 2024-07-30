namespace ConfirmWindow {
    bool Render() {
        if (!UI::IsOverlayShown()) return false;

        UI::PushStyleColor(UI::Col::WindowBg,vec4(.1,.1,.1,1));
        UI::PushStyleVar(UI::StyleVar::WindowPadding, vec2(10, 10));
        UI::PushStyleVar(UI::StyleVar::WindowRounding, 10.0);
        UI::PushStyleVar(UI::StyleVar::FramePadding, vec2(10, 6));
        UI::PushStyleVar(UI::StyleVar::WindowTitleAlign, vec2(.5, .5));
        UI::SetNextWindowSize(450, 300);
        if(UI::Begin("Are You Sure?")) {
            if (UI::ColoredButton(Icons::Check, 1)) {
                return true;
            }
        }
        UI::End();
        UI::PopStyleVar(4);
        UI::PopStyleColor(1);
        return false;
    }
}