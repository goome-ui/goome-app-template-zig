<h1 align="center">🛠 Contributing to goome-app-template-zig 🛠</h1>

<p align="center">
This is a starting point, so less is better here. Fixes that make it build or run somewhere it doesnt yet are the most useful thing.<br>
Bugs in goome itself go to <a href="https://github.com/goome-ui/zig-goome">zig-goome</a>, new example apps to <a href="https://github.com/goome-ui/examples">goome-ui/examples</a>.
</p>

<details>
<summary align="center"><b>📋 The short version 📋</b></summary>

<p align="center">
• One thing per PR<br>
• Open your PR against the <b>dev</b> branch, not main<br>
• Keep it tiny, a template with a pile of features isnt a template anymore<br>
• If you change the app, change the same thing in every file in <code>variants/</code> that has it<br>
• Dont touch the protected files, a bot closes the PR if you do<br>
• CI has to pass<br>
• AI is fine, but say you used it and know what every line does
</p>
</details>

<details>
<summary align="center"><b>🚫 What gets closed automatically 🚫</b></summary>

<p align="center">
A bot checks every PR and closes it with a comment if it hits any of these. Fix it and open a new one.<br> <br>
• PRs that arent against <b>dev</b><br>
• Anything in <code>.github/</code><br>
• <code>build.zig.zon</code>, it decides which goome zig downloads<br>
• <code>LICENSE</code><br> <br>
Renaming or moving any of those counts too. Need one changed? <a href="https://github.com/goome-ui/goome-app-template-zig/issues">Open an issue</a>.
</p>
</details>

<details>
<summary align="center"><b>🧪 Testing 🧪</b></summary>

<p align="center">
Build it and run it like the README says, then run it on the test backend too:
</p>

```sh
GOOME_BACKEND=test GOOME_TEST_SHOTS=shots/ GOOME_TEST_SCRIPT="screen 1280x720 1; 3 click 60,28; end 6" zig build run
```

<p align="center">
In the PR write what you ran and on which OS. CI does linux, windows and mac and has to be green before I merge.
</p>
</details>

<details>
<summary align="center"><b>💬 Discussions and first issues 💬</b></summary>
<p align="center">
Questions and stuff you made with goome go in <a href="https://github.com/goome-ui/c-goome/discussions">Discussions</a>.<br>
If you want something to work on, the <a href="https://github.com/goome-ui/goome-app-template-zig/labels/good%20first%20issue">good first issue</a> ones are small. Comment on one before you start.
</p>
</details>

<details>
<summary align="center"><b>🛡️ Security 🛡️</b></summary>

<p align="center">
Found a security hole? Dont open a public issue or PR for it, read <a href="https://github.com/goome-ui/.github/blob/main/SECURITY.md">SECURITY.md</a> and tell me privately first.
</p>
</details>

<p align="center">
By sending a PR you agree your code goes out under the same <a href="LICENSE">GPL-3.0 license</a> as the rest of the template.
</p>
