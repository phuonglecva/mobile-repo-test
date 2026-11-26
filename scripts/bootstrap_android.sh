#!/usr/bin/env bash
set -euo pipefail

if ! command -v flutter >/dev/null 2>&1; then
  echo "Flutter SDK was not found. Install Flutter and add it to PATH first."
  exit 1
fi

if [ ! -d android ]; then
  flutter create --platforms=android --org com.miloenglish --project-name milo_english .
else
  echo "Android platform folder already exists; skipping generation."
fi

manifest="android/app/src/main/AndroidManifest.xml"
if [ -f "$manifest" ] && ! grep -q "android.intent.action.TTS_SERVICE" "$manifest"; then
  python3 - "$manifest" <<'PY'
from pathlib import Path
import sys

path = Path(sys.argv[1])
text = path.read_text(encoding="utf-8")
queries = '''    <queries>
        <intent>
            <action android:name="android.intent.action.TTS_SERVICE" />
        </intent>
    </queries>
'''
text = text.replace("    <application", queries + "    <application", 1)
path.write_text(text, encoding="utf-8")
PY
fi

echo "Android runner is ready. Next run: flutter pub get"
