# check-script-wrapper

Wraps commands and GUI apps to require NordVPN before launching on macOS.

## Setup

```sh
git clone <repo-url> # depends on whether you prefer SSH or HTTPS
cd check-script-wrapper
./setup.sh
source ~/.zshrc
```

`setup.sh` adds the `wrappers/` directory to your `PATH` and installs `vpn_check` as a command.

## Command-line wrappers

Wraps a CLI command so it checks VPN before running.

### Wrap a command

```sh
./new_wrapper.sh <command>
# e.g. ./new_wrapper.sh ssh
```

Creates `wrappers/<command>`. Any invocation of `<command>` will now fail if VPN is off.

### Unwrap a command

```sh
./unset_wrapper.sh <command>
# e.g. ./unset_wrapper.sh ssh
```

Removes `wrappers/<command>`, restoring the original.

### Limitation

The command-line wrapper only checks VPN at launch time. If VPN disconnects while the process is running, the process is **not** killed.

## GUI app wrappers

Wraps a macOS `.app` bundle. The real app is moved to `~/hidden_from_spotlight/` and a lightweight wrapper app is placed in `~/Applications/`.

> **Warning:** Please ensure the app's update mechanism is not affected by the script moving the real app to a different location.

### Wrap an app

```sh
./new_app_wrapper.sh /Applications/SomeApp.app
```

- Moves the real app to `~/hidden_from_spotlight/SomeApp.app`
- Creates a wrapper at `~/Applications/SomeApp.app`
- The wrapper shows an alert and refuses to open if VPN is off

After running, follow the next steps the script prints.

### Unwrap an app

```sh
./unset_app_wrapper.sh <AppName>
# e.g. ./unset_app_wrapper.sh SomeApp
```

After unwrapping, remove the app from NordVPN's Kill Switch app list if it was added.

To see all currently wrapped apps:

```sh
ls ~/hidden_from_spotlight
```
