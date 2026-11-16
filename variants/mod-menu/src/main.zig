const std = @import("std");
const goome = @import("goome");

const app_name = "My Goome App";

pub fn main() !void {
    const g = goome.Goome.open(.{ .title = app_name }) catch |e| {
        std.debug.print("couldnt open an overlay: {s}\n", .{goome.strerror(goome.errorCode(e))});
        std.process.exit(1);
    };
    defer g.deinit();
    g.hotkey("alt+m", 1) catch {};
    const u = try g.ui();
    defer u.deinit();
    var menu: goome.Window = .{ .x = 80, .y = 80, .w = 300, .open = 0 };
    var fly = false;
    var god = false;
    var speed: f64 = 1;
    var running = true;
    while (running) {
        while (try g.poll(16)) |ev| {
            if (ev.kind == .quit) running = false;
            if (ev.kind == .hotkey) menu.setOpen(!menu.isOpen());
            _ = u.feed(ev);
        }
        if (!running) break;
        const cv = u.begin(0) orelse continue;
        if (menu.isOpen()) {
            if (u.window(app_name, &menu, goome.win.move | goome.win.close)) {
                _ = u.toggle("Fly", &fly);
                _ = u.checkbox("God mode", &god);
                _ = u.slider("Speed", &speed, 1, 10, "%.1f");
                if (u.button("Respawn")) u.toast("respawned", 2000);
            }
            u.windowEnd();
        } else {
            cv.roundRect(20, 20, 170, 30, 8, 0xC0202838);
            _ = cv.text(32, 26, "alt+m opens the menu", false, 0xFFFFFFFF);
        }
        u.end();
    }
}
