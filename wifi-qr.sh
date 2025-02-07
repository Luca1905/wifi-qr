#!/usr/bin/env sh

version="0.1.0"

keychain="/usr/bin/security"
if [ ! -f "$keychain" ]; then
  echo "ERROR: Can not find \`keychain\` CLI program at \"$keychain\"." >&2
  exit 1
fi

# Check for qrencode
qrencode_cli="qrencode"
if ! command -v "$qrencode_cli" >/dev/null 2>&1; then
  echo "ERROR: qrencode not found. Please install it (e.g., sudo apt-get install qrencode)." >&2
  exit 1
fi

if [ -t 1 ]; then
  verbose=1
else
  verbose=
fi

usage() {
  cat <<EOF
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

EOF
}

while true; do
  if [[ -z "$1" ]]; then
    break
  fi

  if [[ "$1" == "--" ]]; then
    shift
    break
  fi

  if [[ "$1" =~ ^- ]]; then
    case "$1" in
      -s | --ssid )
        ssid="$2"
        shift 2
        ;;
      -p | --password )
        pass="$2"
        shift 2
        ;;
      -o | --output )
        output_file="$2"
        shift 2
        ;;
      -q | --quiet )
        verbose=
        shift
        ;;
      -V | --version )
        echo "$version"
        exit
        ;;
      -h | --help )
        usage
        exit
        ;;
      * )
        echo "Error: Unknown option: $1" >&2
        usage
        exit 1
        ;;
    esac
  else
    echo "Error: Unexpected argument: $1" >&2
    usage
    exit 1
  fi
done

if [ -z "$ssid" ]; then
  ssid=$(
    system_profiler SPAirPortDataType |
      awk '/Current Network Information:/ { getline; print substr($0, 13, (length($0) - 13)); exit }'
  )
  if [ "$ssid" = "" ]; then
    echo "ERROR: Could not retrieve current SSID. Are you connected?" >&2
    exit 1
  fi
fi

if [ -z "$pass" ]; then
  if [ $verbose ]; then
    echo ""
    echo "\033[90m … getting password for \"$ssid\". \033[39m"
    echo "\033[90m … keychain prompt incoming. \033[39m"
  fi

  sleep 2

  pass="`security find-generic-password -wga \"$ssid\"`"

  if [[ "$pass" =~ "could" ]]; then
    echo "ERROR: Could not find SSID \"$ssid\"" >&2
    exit 1
  fi

  pass=$(echo "$pass" | sed -e 's/^.*"\(.*\)\".*$/\1/')

  if [ "" == "$pass" ]; then
    echo "ERROR: Failed getting password. Did you enter your Keychain credentials?" >&2
    exit 1
  fi
fi

# Generate the QR code
qr_data="WIFI:T:WPA;S:$ssid;P:$pass;;"

if [ -z "$output_file" ]; then
  # Display QR code in terminal
  if [ $verbose ]; then
    echo "\033[90m … generating QR code. \033[39m"
  fi
  "$qrencode_cli" -t UTF8 "$qr_data"
else
  # Generate QR code to file
  if [ $verbose ]; then
    echo "\033[90m … generating QR code to \"$output_file\". \033[39m"
  fi
  "$qrencode_cli" -o "$output_file" "$qr_data"
fi

if [ $verbose ]; then
  echo "\033[96m ✓ \"$pass\" \033[39m"
  echo ""
else
  echo "$pass"
fi
