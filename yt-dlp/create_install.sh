#!/bin/bash
dp0="$(realpath "$(dirname "$0")")"
dp0_tools="$dp0/../.tools" && source "$dp0_tools/env_tools.sh"
set -e
cd "$dp0"

latest_version=https://api.github.com/repos/yt-dlp/yt-dlp/releases/latest
echo Get latest version: "$latest_version" ...
download_url=$($curl --silent --location "$latest_version" | "$grep" --only-matching '(?<="browser_download_url":\s")[^,]+yt-dlp\.exe(?=")' | head -n1)
[[ -z "$download_url" ]] && {
  echo "Cannot get release version"
  exit 1
}

echo "Downloading: $download_url ..."
$curl --location "$download_url" --remote-name



ffmpeg_latest_version=https://api.github.com/repos/BtbN/FFmpeg-Builds/releases/latest
echo Get latest version: "$ffmpeg_latest_version" ...
ffmpeg_download_url=$($curl --silent --location "$ffmpeg_latest_version" | "$grep" --only-matching '(?<="browser_download_url":\s")[^,]+ffmpeg-master-latest-win64-gpl\.zip(?=")' | head -n1)
[[ -z "$ffmpeg_download_url" ]] && {
  echo "Cannot get release version"
  exit 1
}

ffmpeg_filename="$(basename -- "$ffmpeg_download_url")"

echo "Downloading: $ffmpeg_download_url ..."
$curl --location "$ffmpeg_download_url" --remote-name

echo Extracting ...
"$p7z" e "$ffmpeg_filename" "-o." "*.exe" -aoa -r
