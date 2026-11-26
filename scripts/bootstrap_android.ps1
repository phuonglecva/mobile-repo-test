$ErrorActionPreference = "Stop"

if (-not (Get-Command flutter -ErrorAction SilentlyContinue)) {
  Write-Error "Flutter SDK was not found. Install Flutter and add it to PATH first."
  exit 1
}

if (-not (Test-Path "android")) {
  flutter create --platforms=android --org com.miloenglish --project-name milo_english .
  if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
} else {
  Write-Host "Android platform folder already exists; skipping generation."
}

$manifest = "android/app/src/main/AndroidManifest.xml"
if ((Test-Path $manifest) -and -not (Select-String -Path $manifest -Pattern "android.intent.action.TTS_SERVICE" -Quiet)) {
  $content = [System.IO.File]::ReadAllText($manifest)
  $queries = @"
    <queries>
        <intent>
            <action android:name="android.intent.action.TTS_SERVICE" />
        </intent>
    </queries>
"@
  $replacement = $queries + [Environment]::NewLine + "    <application"
  $content = $content.Replace("    <application", $replacement)
  [System.IO.File]::WriteAllText($manifest, $content)
}

Write-Host "Android runner is ready. Next run: flutter pub get"
