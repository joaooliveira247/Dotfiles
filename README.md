# ⚙️ Dotfiles

## 💻 System info

|      Component      |                                Spec                                 | Version  |
| :-----------------: | :-----------------------------------------------------------------: | :------: |
|         OS          |              [Garuda Linux](https://garudalinux.org/)               | 2.13.0-1 |
|       Kernel        | [Linux Zen](https://archlinux.org/packages/extra/x86_64/linux-zen/) |  7.1.8   |
|  Window management  |                   [Hyprland](https://hypr.land/)                    |  0.56.2  |
|        Shell        |                   [Fish](https://fishshell.com/)                    |  4.8.1   |
|      Terminal       |               [Foot](https://codeberg.org/dnkl/foot)                |  1.27.0  |
| Notification Center |   [SwayNC](https://github.com/ErikReider/SwayNotificationCenter)    |  0.12.6  |
|       Top bar       |             [Waybar](https://github.com/Alexays/Waybar)             |  0.15.0  |
|    App launcher     |              [Wofi](https://github.com/SimplyCEO/wofi)              |  1.5.3   |
|       Editor        |                       [Zed](https://zed.dev/)                       |  1.15.0  |

## 🪟 [Hyprland](./hypr)

I use [hyprconf2lua](https://github.com/Prateek-squadron/hyprconf2lua) to convert my `hyprland.conf` to `hyprland.lua`.

### [hyprland](./hypr/hyprland.lua)

- Set position of HDMI-A-1(left) and eDP-1(right).
- Add HDMI-A-1 as default workspace(1) 'cause is my main monitor.
- Set [Zed](#-zed-editor) editor to always open in workspace 3.
- Add config to HyperX alloy core / Lenovo keyboard
- Add config to generic keyboard using white label controller
- Set keybind `mainMod + o` to open brave browser
- Set window rules to [ksshaskpass](#-ssh-ask-pass)
- Set Picture in Picture and vlc as float window
- Fix Print bind invalid args in `slurp` and `swappy`
- Add layer rule to swaync control center and notication window 'cause hyprland blur bloken swaync window layer transparent.
- Add bind to exit from fullscreen_state `mainMod + ALT + F`
- Add bind to move float window `mouse:275`

### [hypridle](./hypr/hyprpridle.conf)

- Add reload of waybar when back from hyprlock 'cause it is killing waybar process.
- Change timeout 5 min to 10 min

### [hyprlock.conf](./hypr/hyprlock.conf)

#### Theme: https://github.com/mahaveergurjar/Hyprlock-Dots

⚠️ OBS: To change profile photo in hyprlock change `$HOME/.config/hyprlock/layouts/<layout>.conf`

```conf
# Profile-Photo
image {
  ...
  path = <path to profile photo>
  ...
}
```

## ➖ [Waybar](./waybar)

#### Theme: https://github.com/soaddevgit/WaybarTheme/tree/main

⚠️ OBS: I do some changes in theme to set it like i wanted.

- Add custom notification button to SwayNC
- Add button to custom/power default script in waybar
- Add batery button
- Add network trafic button, but use network default waybar script instead network-trafic custom script 'cause it's broken

#### [Waybar config](./waybar/config)

#### [Waybar css](./waybar/style.css)

## 🐟 Fish shell

### 🔨 Functions

All functions has `--help` flag to show documentation

- [diffTime](./fish/functions/diffTime.fish) - Simple calculator between two times
- [firefox](./fish/functions/firefox.fish) - Only open firefox as sudo
- [radio](./fish/functions/radio.fish) - mpv webradio([Hunter.fm](https://hunter.fm/)) control
- [sortFolder](./fish/functions/sortFolder.fish) - Sort items recursive into folder like photos/videos/docs
- [streamDownloader](./fish/functions/streamDownloader.fish) - Download Twitch/Kick VOD segments using ffmpeg
- [volume](./fish/functions/volume.fish) - Simple interface to set sys volume

## 🔛 Grub

### Theme: https://github.com/Flava-Clown/AstronautGrub

## 🔒 SDDM

### Theme: https://github.com/JaKooLit/simple-sddm-2

## 🙋 SSH Ask pass

https://github.com/kde/ksshaskpass

⚠️ Warning

Don't forget set env vars

I set in hyprland.lua

```lua
...
hl.env("SSH_ASKPASS", "/usr/bin/ksshaskpass")
hl.env("SSH_ASKPASS_REQUIRE", "prefer")
...
```

## 🔔 SwayNC

### [config.json](./swaync/config.json)

### [style.css](./swaync/style.css)

## 📝 Zed editor

## 📜 Custom Scripts

### [mpris notifier](./custom/mpris-notifier.sh)

send notification to sys when change music in spotify or mpv([Radio](#-functions)) fish functions, mpv stream don't send album cover art, so i get it from deezer api.

## 🖼️ Wallpaper

https://wall.alphacoders.com/big.php?i=896653