param(
  [string]$Repository = "yuzhe399/gpt-image-2-5-skills",
  [string]$Ref = "main",
  [string]$Source,
  [string]$Destination = $(if ($env:CODEX_SKILLS_DIR) { $env:CODEX_SKILLS_DIR } else { Join-Path $HOME ".agents/skills" })
)

$ErrorActionPreference = "Stop"
$skills = @(
  "gpt-image25-social-design",
  "gpt-image25-product-studio",
  "gpt-image25-precise-edit",
  "gpt-image25-sketch-render",
  "gpt-image25-knowledge-visual",
  "gpt-image25-brand-series"
)

$temp = Join-Path ([System.IO.Path]::GetTempPath()) ("gpt-image-2-5-skills-" + [guid]::NewGuid())
New-Item -ItemType Directory -Path $temp | Out-Null

try {
  if ($Source) {
    $repoRoot = (Resolve-Path $Source).Path
  } else {
    if ([string]::IsNullOrWhiteSpace($Repository)) {
      throw "Repository is not configured. Pass -Repository OWNER/REPO."
    }
    $archive = Join-Path $temp "repository.zip"
    Invoke-WebRequest "https://github.com/$Repository/archive/refs/heads/$Ref.zip" -OutFile $archive
    $expanded = Join-Path $temp "repository"
    Expand-Archive $archive -DestinationPath $expanded
    $repoRoot = (Get-ChildItem $expanded -Directory | Select-Object -First 1).FullName
  }

  $sourceSkills = Join-Path $repoRoot "plugins/gpt-image-2-5-skills/skills"
  foreach ($skill in $skills) {
    if (-not (Test-Path (Join-Path $sourceSkills "$skill/SKILL.md"))) {
      throw "Invalid package: missing $skill/SKILL.md"
    }
  }

  New-Item -ItemType Directory -Force -Path $Destination | Out-Null
  $stamp = (Get-Date).ToUniversalTime().ToString("yyyyMMddTHHmmssZ")
  $backupRoot = Join-Path $HOME ".agents/skill-backups/gpt-image-2-5-skills/$stamp"
  $backedUp = $false

  foreach ($skill in $skills) {
    $target = Join-Path $Destination $skill
    if (Test-Path $target) {
      New-Item -ItemType Directory -Force -Path $backupRoot | Out-Null
      Move-Item $target (Join-Path $backupRoot $skill)
      $backedUp = $true
    }
    Copy-Item (Join-Path $sourceSkills $skill) $target -Recurse
  }

  Write-Host "Installed 6 skills to $Destination"
  if ($backedUp) { Write-Host "Previous versions were moved to $backupRoot" }
  Write-Host 'Restart Codex, then invoke a skill with $gpt-image25-... or /skills.'
} finally {
  if (Test-Path $temp) { Remove-Item $temp -Recurse -Force }
}
