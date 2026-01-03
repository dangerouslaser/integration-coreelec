# CoreELEC Integration for Unfolded Circle Remote Two/3

# THIS IS BETA SOFTWARE. EXPECT BUGS.

Control your CoreELEC device with **Wake-on-LAN** and **HDMI-CEC** support for TV and AVR control.

Based on [integration-kodi](https://github.com/albaintor/integration-kodi) by Albaintor, with CoreELEC-specific enhancements.

## Features

### CoreELEC-Specific Features
| Feature | Description |
|---------|-------------|
| **Wake-on-LAN** | Power on your CoreELEC device remotely via MAC address |
| **CEC TV Power** | Automatically turn TV on/off when powering device |
| **CEC AVR Volume** | Control your AV receiver's volume via HDMI-CEC |
| **CEC Commands** | Manual CEC control: `CEC_TV_ON`, `CEC_TV_OFF`, `CEC_TOGGLE` |

### Supported Attributes
- State (on, off, playing, paused, unknown)
- Title, Album, Artist, Artwork
- Media position / duration
- Volume (level, up/down, mute)
- Sources: video chapters (Kodi >= 22)
- Remote entity with predefined button mappings

### Supported Commands
- **Power**: Turn on (with WoL + CEC), Turn off (with CEC)
- **Navigation**: D-pad, Enter, Back, Home, Context menu
- **Playback**: Play/Pause, Stop, Next, Previous, Fast Forward, Rewind, Seek
- **Volume**: Up, Down, Mute (supports CEC passthrough to AVR)
- **Channels**: Up/Down
- **Other**: Numeric pad, Colored buttons, Subtitle/Audio switching, Source selection

## Installation

### Quick Install (Pre-built Binary)

1. Download `dist/intg-coreelec/` from the [releases](https://github.com/dangerouslaser/integration-coreelec/releases) or clone this repo
2. On your Remote's Web Configurator: **Integrations > Add new > Install custom**
3. Upload the `intg-coreelec` folder

### Requirements

- CoreELEC must be running with remote control enabled:
  - **Settings > Services > Control** - Enable HTTP control
  - Set username and password
  - Default ports: HTTP `8080`, WebSocket `9090`

## Configuration Options

During setup, you can configure:

| Option | Description | Default |
|--------|-------------|---------|
| **MAC Address** | For Wake-on-LAN (format: `AA:BB:CC:DD:EE:FF`) | Empty |
| **Enable CEC** | Master switch for CEC features | On |
| **CEC TV On** | Turn TV on when powering on device | On |
| **CEC TV Off** | Turn TV off (standby) when powering off device | On |
| **CEC AVR Volume** | Send volume commands to AVR via CEC | Off |

### CEC AVR Volume

When enabled, volume up/down commands are sent via HDMI-CEC to your AV receiver instead of controlling Kodi's internal volume. This is useful when:
- You have an AVR/receiver in your setup
- You want the Remote to control your receiver's volume directly

**Note:** CEC volume uses relative commands (up/down), not absolute values. The volume slider will still control Kodi's internal volume.

## Simple Commands

These commands are available in both Media Player and Remote entities:

| Command | Description |
|---------|-------------|
| `CEC_TV_ON` | Turn TV on via CEC (CECActivateSource) |
| `CEC_TV_OFF` | Turn TV off via CEC (CECStandby) |
| `CEC_TOGGLE` | Toggle TV power via CEC |
| `APP_SHUTDOWN` | Shutdown CoreELEC |
| `APP_REBOOT` | Reboot CoreELEC |
| `APP_SUSPEND` | Suspend CoreELEC |
| `APP_HIBERNATE` | Hibernate CoreELEC |
| `MODE_FULLSCREEN` | Toggle fullscreen |
| `MODE_ZOOM_IN/OUT` | Zoom controls |
| `MODE_SHOW_SUBTITLES` | Toggle subtitles |
| `ACTION_RED/GREEN/YELLOW/BLUE` | Colored buttons |

## Building from Source

### Prerequisites
- Docker with QEMU support for ARM64 emulation

### Setup QEMU (x86-64 hosts only)
```bash
docker run --rm --privileged multiarch/qemu-user-static --reset -p yes
```

### Build
```bash
./build.sh
```

The built integration will be in `dist/intg-coreelec/`.

## External Installation (Docker/Server)

For running on an external server instead of the Remote:

### Docker Compose
```bash
git clone https://github.com/dangerouslaser/integration-coreelec.git
cd integration-coreelec
docker-compose up -d
```

### Manual
```bash
pip3 install -r requirements.txt
python3 src/driver.py
```

**Note:** Use `--network host` for Docker to enable WoL magic packets.

### Configuration
- Default port: `9090` (override with `UC_INTEGRATION_HTTP_PORT`)
- Config stored in `./config` directory

## Troubleshooting

### Wake-on-LAN not working
- Ensure WoL is enabled in your device's BIOS/settings
- Verify MAC address format: `AA:BB:CC:DD:EE:FF`
- Check that the integration host can reach the device on the network

### CEC not working
- Verify CEC is enabled in CoreELEC: **Settings > CoreELEC > Hardware > CEC**
- Check your TV supports CEC (called different names by manufacturers: Anynet+, Bravia Sync, SimpLink, etc.)
- Try the `CEC_TOGGLE` command to test

### D-pad not working
- In Kodi settings, go to **Add-ons > My Add-ons > Peripheral Libraries > Joystick Support** and disable it
- Restart Kodi completely (not just minimize)

## Credits

- Original [integration-kodi](https://github.com/albaintor/integration-kodi) by [Albaintor](https://github.com/albaintor)
- [Unfolded Circle](https://www.unfoldedcircle.com/) for the Remote Two/3 and integration API
- [CoreELEC](https://coreelec.org/) team

## License

This project is licensed under the [**Mozilla Public License 2.0**](https://choosealicense.com/licenses/mpl-2.0/).
See the [LICENSE](LICENSE) file for details.
