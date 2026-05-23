# Simple test script for beginner projects.
# It checks if local href links in your HTML files point to real files.

$ErrorActionPreference = "Stop"

$root = Split-Path -Parent $MyInvocation.MyCommand.Path
$pages = @("index.html", "uses.html", "digital-garden.html", "maker-lab.html")
$missingLinks = @()

foreach ($page in $pages) {
  $fullPath = Join-Path $root $page
  $content = Get-Content -Path $fullPath -Raw
  $matches = [regex]::Matches($content, 'href="([^"]+)"')

  foreach ($match in $matches) {
    $href = $match.Groups[1].Value

    # Skip external links, anchor links, and email/phone links.
    if ($href.StartsWith("http") -or $href.StartsWith("#") -or $href.StartsWith("mailto:") -or $href.StartsWith("tel:")) {
      continue
    }

    $targetPath = Join-Path $root $href
    if (-not (Test-Path $targetPath)) {
      $missingLinks += "$page -> $href"
    }
  }
}

if ($missingLinks.Count -eq 0) {
  Write-Output "PASS: All local links resolve."
}
else {
  Write-Output "FAIL: Missing local links found:"
  $missingLinks | ForEach-Object { Write-Output $_ }
  exit 1
}

