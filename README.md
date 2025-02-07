# qrwifi - Generate Wi-Fi QR Codes (macOS Only)

## Description

`qrwifi` is a command-line utility designed *exclusively* for macOS that generates QR codes for easy Wi-Fi network access. It simplifies the process of sharing Wi-Fi credentials by creating a QR code that can be scanned by a mobile device or other QR code reader. The script retrieves the SSID and password (from the macOS keychain) and encodes them into a QR code.

## Installation

1.  **Install `qrencode`:** This script requires the `qrencode` command-line tool to generate the QR code images. Install it using your system's package manager:

    *   **macOS (using Homebrew):** `brew install qrencode`

2.  **Save the script:** Save the `qrwifi.sh` script to a suitable location (e.g., your home directory or `/usr/local/bin`).

3.  **Make the script executable:** `chmod +x qrwifi.sh`

## Usage

```bash
  Usage: qrwifi [OPTIONS]

  Generate a Wi-Fi QR code for easy network access.

  Options:
    -s, --ssid <SSID>       Specify the SSID. If not provided, attempts to
                            detect the current SSID.
    -p, --password <PASSWORD>  Specify the password for the network.
    -o, --output <FILE>     Specify the output file for the QR code image
                            (e.g., qr.png).  Defaults to stdout.
    -q, --quiet             Only output the password.
    -V, --version               Show the version and exit.
    -h, --help              Show this help message and exit.

  Examples:
    qrwifi -s MyWiFi -p MyPassword
    qrwifi -s MyWiFi -p MyPassword -o wifi.png

  Note:
    - If SSID is not provided, the utility will attempt to detect the current
      SSID. This may require appropriate permissions.
    - Requires the 'qrencode' command-line tool to be installed.
