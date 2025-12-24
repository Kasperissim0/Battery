# What
Monitors + Saves The Lowest Battery Percentage
# Why
My Old Mac (M1 2020 Mac Air) died after reaching ~half battery, I wanted to find the exact percentage.
(In order to launch an alert w. shortcuts, set low power mode (before), ...)
# How
// TODO Add description

# Relevant Commands
## (En/Dis)able The Daemon
###
    launchctl unload ~/Library/LaunchAgents/com.user.batterymonitor.plist
###
    launchctl load ~/Library/LaunchAgents/com.user.batterymonitor.plist
## Check Working Script(s)
###
    launchctl list | grep --color=auto batterymonitor              
###
    launchctl list | grep --color=auto com.user
## Get Ouput
###
    cat Documents/1_Projects/Battery\ Health/min
