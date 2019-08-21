Sample init scripts and service configuration for diazd
==========================================================

Sample scripts and configuration files for systemd, Upstart and OpenRC
can be found in the contrib/init folder.

    contrib/init/diazd.service:    systemd service unit configuration
    contrib/init/diazd.openrc:     OpenRC compatible SysV style init script
    contrib/init/diazd.openrcconf: OpenRC conf.d file
    contrib/init/diazd.conf:       Upstart service configuration file
    contrib/init/diazd.init:       CentOS compatible SysV style init script

Service User
---------------------------------

All three Linux startup configurations assume the existence of a "diaz" user
and group.  They must be created before attempting to use these scripts.
The macOS configuration assumes diazd will be set up for the current user.

Configuration
---------------------------------

At a bare minimum, diazd requires that the rpcpassword setting be set
when running as a daemon.  If the configuration file does not exist or this
setting is not set, diazd will shutdown promptly after startup.

This password does not have to be remembered or typed as it is mostly used
as a fixed token that diazd and client programs read from the configuration
file, however it is recommended that a strong and secure password be used
as this password is security critical to securing the wallet should the
wallet be enabled.

If diazd is run with the "-server" flag (set by default), and no rpcpassword is set,
it will use a special cookie file for authentication. The cookie is generated with random
content when the daemon starts, and deleted when it exits. Read access to this file
controls who can access it through RPC.

By default the cookie is stored in the data directory, but it's location can be overridden
with the option '-rpccookiefile'.

This allows for running diazd without having to do any manual configuration.

`conf`, `pid`, and `wallet` accept relative paths which are interpreted as
relative to the data directory. `wallet` *only* supports relative paths.

For an example configuration file that describes the configuration settings,
see `share/examples/diaz.conf`.

Paths
---------------------------------

### Linux

All three configurations assume several paths that might need to be adjusted.

Binary:              `/usr/bin/diazd`  
Configuration file:  `/etc/diaz/diaz.conf`  
Data directory:      `/var/lib/diazd`  
PID file:            `/var/run/diazd/diazd.pid` (OpenRC and Upstart) or `/var/lib/diazd/diazd.pid` (systemd)  
Lock file:           `/var/lock/subsys/diazd` (CentOS)  

The configuration file, PID directory (if applicable) and data directory
should all be owned by the diaz user and group.  It is advised for security
reasons to make the configuration file and data directory only readable by the
diaz user and group.  Access to diaz-cli and other diazd rpc clients
can then be controlled by group membership.

### macOS

Binary:              `/usr/local/bin/diazd`  
Configuration file:  `~/Library/Application Support/Diaz/diaz.conf`  
Data directory:      `~/Library/Application Support/Diaz`  
Lock file:           `~/Library/Application Support/Diaz/.lock`  

Installing Service Configuration
-----------------------------------

### systemd

Installing this .service file consists of just copying it to
/usr/lib/systemd/system directory, followed by the command
`systemctl daemon-reload` in order to update running systemd configuration.

To test, run `systemctl start diazd` and to enable for system startup run
`systemctl enable diazd`

NOTE: When installing for systemd in Debian/Ubuntu the .service file needs to be copied to the /lib/systemd/system directory instead.

### OpenRC

Rename diazd.openrc to diazd and drop it in /etc/init.d.  Double
check ownership and permissions and make it executable.  Test it with
`/etc/init.d/diazd start` and configure it to run on startup with
`rc-update add diazd`

### Upstart (for Debian/Ubuntu based distributions)

Upstart is the default init system for Debian/Ubuntu versions older than 15.04. If you are using version 15.04 or newer and haven't manually configured upstart you should follow the systemd instructions instead.

Drop diazd.conf in /etc/init.  Test by running `service diazd start`
it will automatically start on reboot.

NOTE: This script is incompatible with CentOS 5 and Amazon Linux 2014 as they
use old versions of Upstart and do not supply the start-stop-daemon utility.

### CentOS

Copy diazd.init to /etc/init.d/diazd. Test by running `service diazd start`.

Using this script, you can adjust the path and flags to the diazd program by
setting the DIAZD and FLAGS environment variables in the file
/etc/sysconfig/diazd. You can also use the DAEMONOPTS environment variable here.

### macOS

Copy org.diaz.diazd.plist into ~/Library/LaunchAgents. Load the launch agent by
running `launchctl load ~/Library/LaunchAgents/org.diaz.diazd.plist`.

This Launch Agent will cause diazd to start whenever the user logs in.

NOTE: This approach is intended for those wanting to run diazd as the current user.
You will need to modify org.diaz.diazd.plist if you intend to use it as a
Launch Daemon with a dedicated diaz user.

Auto-respawn
-----------------------------------

Auto respawning is currently only configured for Upstart and systemd.
Reasonable defaults have been chosen but YMMV.
