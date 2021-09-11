/*
 * Copyright 2020–2021 elementary, Inc. (https://elementary.io)
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

[DBus (name = "io.elementary.pantheon.AccountsService")]
private interface AccountsService : Object {
    public abstract int prefers_color_scheme { get; set; }
}

[DBus (name = "org.freedesktop.Accounts")]
interface FDO.Accounts : Object {
    public abstract string find_user_by_name (string username) throws GLib.Error;
}
