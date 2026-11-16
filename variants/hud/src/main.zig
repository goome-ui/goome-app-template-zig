const std = @import("std");
const goome = @import("goome");
const ctime = @cImport(@cInclude("time.h"));

const app_name = "My Goome App";

pub fn main() !void {
    const g = goome.Goome.open(.{ .title = app_name }) catch |e| {
        std.debug.print("couldnt open an overlay: {s}\n", .{goome.strerror(goome.errorCode(e))});
        std.process.exit(1);
    };
    defer g.deinit();
    g.hotkey("alt+h", 1) catch {};
    const start = goome.nowMs();
    var last = start;
    var fps: f64 = 0;
    var hidden = false;
    var running = true;
    var pace: goome.Pacer = .{};
    while (running) {
        var wait = pace.wait(30);
        while (try g.poll(wait)) |ev| {
            if (ev.kind == .quit) running = false;
            if (ev.kind == .hotkey) hidden = !hidden;
            wait = pace.wait(30);
        }
        if (!running) break;
        const now = goome.nowMs();
        if (now > last) fps = fps * 0.9 + 100.0 / @as(f64, @floatFromInt(now - last));
        last = now;
        const cv = g.begin(0) orelse continue;
        if (!hidden) {
            var t = ctime.time(null);
            var clock: [16:0]u8 = undefined;
            const n = ctime.strftime(&clock, clock.len, "%H:%M:%S", ctime.localtime(&t));
            var up: [32]u8 = undefined;
            var rate: [32]u8 = undefined;
            cv.roundRect(20, 20, 160, 92, 10, 0xB0141820);
            _ = cv.text(34, 30, clock[0..n :0], true, 0xFFFFFFFF);
            _ = cv.text(34, 62, try std.fmt.bufPrintZ(&up, "up {d}s", .{@divTrunc(now - start, 1000)}), false, 0xFFC0C8D0);
            _ = cv.text(34, 84, try std.fmt.bufPrintZ(&rate, "{d:.0} fps", .{fps}), false, 0xFF6FDC5F);
        }
        try g.end(cv, &.{});
    }
}
