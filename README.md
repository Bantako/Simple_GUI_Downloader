# Simple GUI Downloader

A simple graphical download manager built with Bash, yad and aria2c.

## Features

- User-friendly GUI for entering download information
- Customizable download location (Downloads, Desktop, Documents, or custom location)
- Configurable automatic retry functionality
- Multi-connection downloads for faster speeds
- Visual progress indicator and completion notification
- Test mode for easy debugging

## Requirements

- Bash
- yad (Yet Another Dialog)
- aria2c (command-line download utility)
- xdg-user-dir (for finding standard user directories)

## Installation

1. Make sure you have the required dependencies:

```bash
# For Debian/Ubuntu-based systems
sudo apt install yad aria2 xdg-utils

# For Fedora/RHEL-based systems
sudo dnf install yad aria2 xdg-utils

# For Arch-based systems
sudo pacman -S yad aria2 xdg-utils
```

2. Clone this repository:

```bash
git clone https://github.com/yourusername/Simple_GUI_Downloader.git
cd Simple_GUI_Downloader
```

3. Make the script executable:

```bash
chmod +x downloader.sh
```

## Usage

Run the script without arguments to use the normal GUI mode:

```bash
./downloader.sh
```

For testing with a predefined download:

```bash
./downloader.sh --test
```

## How It Works

1. The script presents a form where you can input:
   - Download URL
   - Filename (optional - generates timestamp-based name if empty)
   - Download location (Downloads, Desktop, Documents, or custom)
   - Automatic retry option

2. The download is performed using aria2c with multi-connection capabilities
   - Uses 16 connections by default for faster downloads
   - Optional auto-retry with 5 attempts and 10 second wait between retries

3. Upon completion, a notification displays the download status

## License

See the [LICENSE](LICENSE) file for details.
