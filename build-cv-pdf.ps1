# Пересобирает Dubinets-Nikolai-CV.pdf из resume-print.html через headless-браузер.
# Запуск:  powershell -ExecutionPolicy Bypass -File build-cv-pdf.ps1
# После правок resume-print.html — прогони этот скрипт и закоммить обновлённый PDF.

$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $MyInvocation.MyCommand.Path
$html = Join-Path $root 'resume-print.html'
$pdf  = Join-Path $root 'Dubinets-Nikolai-CV.pdf'

if (-not (Test-Path $html)) { throw "Не найден $html" }

# Ищем Chrome или Edge
$candidates = @(
  "$env:ProgramFiles\Google\Chrome\Application\chrome.exe",
  "${env:ProgramFiles(x86)}\Google\Chrome\Application\chrome.exe",
  "$env:ProgramFiles\Microsoft\Edge\Application\msedge.exe",
  "${env:ProgramFiles(x86)}\Microsoft\Edge\Application\msedge.exe"
)
$browser = $candidates | Where-Object { Test-Path $_ } | Select-Object -First 1
if (-not $browser) { throw "Не найден Chrome или Edge для headless-печати" }

$fileUrl = 'file:///' + ($html -replace '\\','/')
Write-Host "Браузер: $browser"
Write-Host "Печать:  $html -> $pdf"

& $browser --headless=new --disable-gpu --no-pdf-header-footer --print-to-pdf="$pdf" $fileUrl | Out-Null

if (Test-Path $pdf) {
  $kb = [math]::Round((Get-Item $pdf).Length / 1KB)
  Write-Host "Готово: $pdf ($kb KB)"
} else {
  throw "PDF не создан"
}
