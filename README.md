
# qrwifi - Generate Wi-Fi QR Codes

## Description

`qrwifi` is a command-line utility that generates QR codes for easy Wi-Fi network access. It simplifies the process of sharing Wi-Fi credentials by creating a QR code that can be scanned by a mobile device or other QR code reader. The script retrieves the SSID and password (from the macOS keychain, if applicable) and encodes them into a QR code.

## Installation

1.  **Install `qrencode`:**  This script requires the `qrencode` command-line tool to generate the QR code images.  Install it using your system's package manager:

    *   **Debian/Ubuntu:** `sudo apt-get install qrencode`
    *   **macOS (using Homebrew):** `brew install qrencode`
    *   **Other systems:** Use your system's package manager.

2.  **Save the script:** Save the `qrwifi.sh` script to a suitable location (e.g., your home directory or `/usr/local/bin`).

3.  **Make the script executable:**  `chmod +x qrwifi.sh`

## Usage

```bash
./qrwifi.sh [OPTIONS]
