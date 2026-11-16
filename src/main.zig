const std = @import("std");
const goome = @import("goome");

const app_name = "My Goome App";

const State = struct {
    clicks: u32 = 0,
    volume: f64 = 0.5,
    overlay: bool = false,
    shown: bool = false,
    win: goome.Window = .{},
};

fn openMode(s: *State, overlay: bool) goome.Error!*goome.Goome {
    if (!overlay) return goome.Goome.openApp(app_name, 640, 420);
    const g = try goome.Goome.open(.{ .title = app_name });
    var mons: [1]goome.Monitor = undefined;
    const ms = g.monitors(&mons);
    const x: f64 = if (ms.len > 0) @floatFromInt(ms[0].area.x + ms[0].area.w - 340) else 40;
    s.win = .{ .x = x, .y = 60, .w = 300 };
    return g;
}

fn contents(u: *goome.Ui, s: *State) void {
    _ = u.toggle("Overlay mode", &s.overlay);
    u.separator();
    u.pushColor(goome.c.GOOME_S_TEXT, u.animColor("hello", if (s.shown) 0xFFF2F4F8 else 0x00F2F4F8, 600, .out));
    s.shown = true;
    u.heading("Hello from " ++ app_name);
    u.pop(1);
    if (u.button("Click me")) s.clicks += 1;
    u.labelFmt("clicked {d} times", .{s.clicks});
    _ = u.slider("Volume", &s.volume, 0, 1, "%.2f");
}

pub fn main() !void {
    var s: State = .{};
    var mode = false;
    var g = openMode(&s, false) catch |e| {
        std.debug.print("couldnt open a window: {s}\n", .{goome.strerror(goome.errorCode(e))});
        std.process.exit(1);
    };
    var u = try g.ui();
    var running = true;
    while (running) {
        while (try g.poll(16)) |ev| {
            if (ev.kind == .quit or ev.kind == .close) running = false;
            _ = u.feed(ev);
        }
        if (!running) break;
        if (s.overlay != mode) {
            u.deinit();
            g.deinit();
            g = openMode(&s, s.overlay) catch blk: {
                std.debug.print("no overlay here, staying in window mode\n", .{});
                s.overlay = false;
                break :blk try openMode(&s, false);
            };
            mode = s.overlay;
            u = try g.ui();
            std.fs.File.stdout().writeAll(if (mode) "overlay mode\n" else "window mode\n") catch {};
            continue;
        }
        _ = u.begin(0) orelse continue;
        if (mode) {
            if (u.window(app_name, &s.win, goome.win.move | goome.win.collapse)) contents(u, &s);
            u.windowEnd();
        } else {
            _ = u.app(app_name, 0);
            contents(u, &s);
            u.appEnd();
        }
        u.end();
    }
    u.deinit();
    g.deinit();
}
