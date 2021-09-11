/*
 * Copyright 2021 Allie Law <allie@cloverleaf.app>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

public class DarkStyle.Widgets.PopoverWidget : Gtk.Grid {

  public unowned DarkStyle.Indicator indicator { get; construct set; }
  public unowned PrefersColorScheme color_scheme { get; construct set; }

  public PopoverWidget (DarkStyle.Indicator indicator, PrefersColorScheme color_scheme) {
    Object (indicator: indicator, color_scheme: color_scheme);
  }

  construct {

    orientation = Gtk.Orientation.VERTICAL;

    var toggle_switch = new Granite.SwitchModelButton (_("Use Dark style"));

    toggle_switch.bind_property ("active", color_scheme, "prefers-dark", BindingFlags.BIDIRECTIONAL);

    var seperator = new Gtk.Separator (Gtk.Orientation.HORIZONTAL);

    var settings_button = new Gtk.ModelButton ();
    settings_button.text = _("Dark Style Settings…");
    settings_button.clicked.connect (show_settings);

    add (toggle_switch);
    add (seperator);
    add (settings_button);

  }


  private void show_settings () {
    try {
        AppInfo.launch_default_for_uri ("settings://desktop/appearance", null);
    } catch (Error e) {
        warning ("Failed to open appearance settings: %s", e.message);
    }

    indicator.close ();
  }
}
