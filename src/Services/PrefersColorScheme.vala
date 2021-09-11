/*
 * Copyright 2018–2021 elementary, Inc. (https://elementary.io)  (https://github.com/elementary/switchboard-plug-pantheon-shell/blob/master/src/Views/Appearance.vala)
 * Copyright 2021 Allie Law <allie@cloverleaf.app>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

public class PrefersColorScheme : GLib.Object {

    private AccountsService? pantheon_act = null;

    public bool prefers_dark { get; set; }
    private string? user_path = null;

    public void set_dark () {
        pantheon_act.prefers_color_scheme = Granite.Settings.ColorScheme.DARK;
        prefers_dark = true;
    }

    public void set_light () {
        pantheon_act.prefers_color_scheme = Granite.Settings.ColorScheme.NO_PREFERENCE;
        prefers_dark = false;
    }

    construct {

        try {
            FDO.Accounts? accounts_service = GLib.Bus.get_proxy_sync (
                GLib.BusType.SYSTEM,
                "org.freedesktop.Accounts",
                "/org/freedesktop/Accounts"
            );

            user_path = accounts_service.find_user_by_name (GLib.Environment.get_user_name ());
        } catch (Error e) {
            critical (e.message);
        }

        if (user_path != null) {
            try {
                pantheon_act = GLib.Bus.get_proxy_sync (
                    GLib.BusType.SYSTEM,
                    "org.freedesktop.Accounts",
                    user_path,
                    GLib.DBusProxyFlags.GET_INVALIDATED_PROPERTIES
                );
            } catch (Error e) {
                warning ("Unable to get AccountsService proxy, color scheme preference may be incorrect");
            }
        }

        prefers_dark = pantheon_act.prefers_color_scheme == Granite.Settings.ColorScheme.DARK;

        ((GLib.DBusProxy) pantheon_act).g_properties_changed.connect ((changed, invalid) => {
            var color_scheme = changed.lookup_value ("PrefersColorScheme", new VariantType ("i"));
            if (color_scheme != null) {
                //  debug("Detected system changed to: %s", color_scheme.get_int32 () == Granite.Settings.ColorScheme.DARK ? "Dark" : "Light");
                switch ((Granite.Settings.ColorScheme) color_scheme.get_int32 ()) {
                    case Granite.Settings.ColorScheme.DARK:
                        prefers_dark = true;
                        break;
                    default:
                        prefers_dark = false;
                        break;
                }
            }
        });

        this.notify["prefers-dark"].connect (() => {
            //  debug("Detected prefers-dark change to %s", prefers_dark.to_string ());
            if (prefers_dark) {
                set_dark ();
            } else {
                set_light ();
            }
        });
    }
}
