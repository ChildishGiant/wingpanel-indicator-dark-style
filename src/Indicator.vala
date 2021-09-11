/*
 * Copyright 2021 Pong Loong Yeat (https://github.com/pongloongyeat/wingpanel-indicator-template)
 * Copyright 2021 Allie Law <allie@cloverleaf.app>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

public class DarkStyle.Indicator : Wingpanel.Indicator {

    private Gtk.Image indicator_icon;
    private Gtk.Grid popover_widget;
    private PrefersColorScheme color_scheme;

    private string dark_enabled_icon = "weather-clear-night-symbolic";
    private string dark_disabled_icon = "display-brightness-symbolic";

    public Indicator () {
        Object (
            code_name: "wingpanel-indicator-dark-style"
        );

        visible = true;
    }
    public override Gtk.Widget get_display_widget () {
        return indicator_icon;
    }

    public override Gtk.Widget? get_widget () {

        if (popover_widget == null) {
            popover_widget = new DarkStyle.Widgets.PopoverWidget (this, color_scheme);
        }

        return popover_widget;
    }

    public override void opened () {
        //  debug("Opened");
    }

    public override void closed () {
        //  debug("Closed");
    }

    private void update_tooltip (bool prefer_dark) {
        string primary_text = _("Light Mode is on");
        string secondary_text = _("Middle-click to switch to Dark Mode");

        if (prefer_dark) {
            primary_text = _("Dark Mode is on");
            secondary_text = _("Middle-click to switch to Light Mode");
        }

        indicator_icon.tooltip_markup = "%s\n%s".printf (
            primary_text,
            Granite.TOOLTIP_SECONDARY_TEXT_MARKUP.printf (secondary_text)
        );
    }

    construct {

        color_scheme = new PrefersColorScheme ();

        indicator_icon = new Gtk.Image.from_icon_name (dark_enabled_icon, Gtk.IconSize.LARGE_TOOLBAR);

        indicator_icon.button_press_event.connect ((e) => {
            if (e.button == Gdk.BUTTON_MIDDLE) {
                //  Toggle dark mode
                color_scheme.prefers_dark = !color_scheme.prefers_dark;
                return Gdk.EVENT_STOP;
            }

            return Gdk.EVENT_PROPAGATE;
        });

        //  debug (color_scheme.prefers_dark.to_string ());
        update_tooltip (color_scheme.prefers_dark);

        //  Listen for a change in dark style preference
        color_scheme.notify["prefers-dark"].connect (() => {
            indicator_icon.icon_name = color_scheme.prefers_dark ? dark_enabled_icon : dark_disabled_icon;
            update_tooltip (color_scheme.prefers_dark);
        });
    }

}

public Wingpanel.Indicator? get_indicator (Module module, Wingpanel.IndicatorManager.ServerType server_type) {
    debug ("Activating Dark Style Indicator");

    if (server_type != Wingpanel.IndicatorManager.ServerType.SESSION) {
        return null;
    }

    var indicator = new DarkStyle.Indicator ();
    return indicator;
}
