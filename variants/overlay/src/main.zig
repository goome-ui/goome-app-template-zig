const std = @import("std");
const goome = @import("goome");

const app_name = "My Goome App";

pub fn main() !void {
    const g = goome.Goome.open(.{ .title = app_name }) catch |e| {
        std.debug.print("couldnt open an overlay: {s}\n", .{goome.strerror(goome.errorCode(e))});
        std.process.exit(1);
    };
    defer g.deinit();
    g.hotkey("alt+h", 1) catch {};
    const u = try g.ui();
    defer u.deinit();
    var win: goome.Window = .{ .x = 60, .y = 60, .w = 280 };
    var clicks: u32 = 0;
    var hidden = false;
    while (win.isOpen()) {
        while (try g.poll(16)) |ev| {
            if (ev.kind == .quit) win.setOpen(false);
            if (ev.kind == .hotkey) hidden = !hidden;
            _ = u.feed(ev);
        }
        if (!win.isOpen()) break;
        _ = u.begin(0) orelse continue;
        if (!hidden) {
            if (u.window(app_name, &win, goome.win.move | goome.win.close)) {
                u.label("im on top of everything");
                if (u.button("Click me")) clicks += 1;
                u.labelFmt("clicked {d} times", .{clicks});
                u.label("alt+h hides me");
            }
            u.windowEnd();
        }
        u.end();
    }
}
