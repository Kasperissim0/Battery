# Repo Content Explanation
## What
Monitors & saves the lowest battery percentage
## Why
My old mac (M1 2020 Mac Air) died after reaching ~half battery, I wanted to find the exact percentage.
In order to launch an alert w. shortcuts, set low power mode (before), etc...
## How
Creates a daemon that checks the battery % every 45 seconds, and logs/saves it locally + pushes changes to github.

# Relevant Commands
## Daemon Control
### Enable Daemon
######
    launchctl unload ~/Library/LaunchAgents/com.user.batterymonitor.plist
### Disable Daemon
######
    launchctl load ~/Library/LaunchAgents/com.user.batterymonitor.plist
## Check Working Script(s)
### Check If This Particular Daemon Is Active
######
    launchctl list | grep -i pid && launchctl list | grep --color batterymonitor
### List All Active User Created Daemons
######
    launchctl list | sort -k3 | egrep -i --color "com.user|$"
## Get Ouput
######
    cat Documents/1_Projects/Battery\ Health/min*

# The Contents Of com.user.batterymonitor.plist @ 2025-12-29
```
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.user.batterymonitor</string>
    <key>ProgramArguments</key>
    <array>
        <string>/bin/bash</string>
        <string>/Users/kasperissim0/Code/Battery Health/Extra/Script & Spec/battery_monitor.sh</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
    <key>KeepAlive</key>
    <true/>
    <key>StandardOutPath</key>
    <string>/Users/kasperissim0/Code/Battery Health/Extra/battery_monitor_out.log</string>
    <key>StandardErrorPath</key>
    <string>/Users/kasperissim0/Code/Battery Health/Extra/battery_monitor_err.log</string>
</dict>
</plist>

```
