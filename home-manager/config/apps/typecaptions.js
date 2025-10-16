const { spawn, spawnSync } = require('child_process');

const dbusMonitor = spawn('dbus-monitor', [
    "type='signal',interface='net.sapples.LiveCaptions.External'"
]);

let recentMessages = new Set();

dbusMonitor.stdout.on('data', (data) => {
    const lines = data.toString().split('\n');

    lines.forEach((line) => {
        // Only process lines containing the actual text
        const match = line.match(/string \"(.*)/);

        if (!match) {
            return;
        }

        let message = match[1];

        if (message.endsWith('"')) {
            message = message.slice(0, -1);
        }

        message = message
            .replace(/^:\d+\.\d+\s*/, '') // Remove timestamps
            .replace(/\n\s+/g, '\n') // Normalize newlines
            .trim(); // Remove leading/trailing whitespace

        message.split('\n').forEach((msg) => {
            msg = msg.trim();
            if (msg && !recentMessages.has(msg)) {
                // Keep track of some recent messages to avoid crazy repetition
                recentMessages.add(msg);
                if (recentMessages.size > 10) {
                    recentMessages.delete([...recentMessages][0]);
                }

                // Output the message
                const outputWithNewline = `${msg} `;
                console.log(outputWithNewline);
                // Change keyboard layout before/after using my weird script, remove if you don't need it
                spawnSync(`${process.env.HOME}/.setup/home-manager/config/hyprland/scripts/switch-layout-silent.sh`, [], { shell: true });
                spawnSync(`ydotool type -d=0 "${outputWithNewline}"`, [], { shell: true });
                spawnSync(`${process.env.HOME}/.setup/home-manager/config/hyprland/scripts/switch-layout-silent.sh`, [], { shell: true });
            }
        });
    });
});

dbusMonitor.stderr.on('data', (data) => {
    console.error(`Error: ${data}`);
});

dbusMonitor.on('close', (code) => {
    console.log(`dbus-monitor process exited with code ${code}`);
});
