param(
  [string]$ProjectRoot = "$PSScriptRoot\.."
)

$ErrorActionPreference = 'SilentlyContinue'
$hbPath = Join-Path -Path (Resolve-Path $ProjectRoot) -ChildPath 'Documentation\Heartbeat.md'

if (!(Test-Path $hbPath)) {
  New-Item -ItemType File -Path $hbPath -Force | Out-Null
  Set-Content -Path $hbPath -Value "# Live Heartbeat`r`n`r`n## Latest`r`n- Status: initializing...`r`n- Timestamp: $(Get-Date -Format o)`r`n`r`n## Log`r`n- $(Get-Date -Format o) — Heartbeat started`r`n"
}

function Update-Heartbeat {
  param(
    [string]$status = 'working'
  )
  $ts = Get-Date -Format o
  $latestBlock = "## Latest`r`n- Status: $status`r`n- Timestamp: $ts`r`n`r`n"

  $content = Get-Content -Path $hbPath -Raw
  if ($content -match '## Latest[\s\S]*?\r?\n\r?\n') {
    $content = [regex]::Replace($content, '## Latest[\s\S]*?\r?\n\r?\n', $latestBlock)
  } else {
    $content = "# Live Heartbeat`r`n`r`n$latestBlock## Log`r`n"
  }
  Set-Content -Path $hbPath -Value $content -Encoding UTF8
  Add-Content -Path $hbPath -Value "- $ts — heartbeat ($status)"
}

while ($true) {
  Update-Heartbeat -status 'working'
  Start-Sleep -Seconds 300
}