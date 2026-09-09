param(
  [string[]]$Skill,
  [string]$Destination = $(if ($env:CODEX_SKILLS_DIR) { $env:CODEX_SKILLS_DIR } else { Join-Path $HOME ".agents/skills" })
)

$ErrorActionPreference = "Stop"
$allSkills = @(
  "gpt-image25-social-design",
  "gpt-image25-product-studio",
  "gpt-image25-precise-edit",
  "gpt-image25-sketch-render",
  "gpt-image25-knowledge-visual",
  "gpt-image25-brand-series"
)
$skills = if ($Skill -and $Skill.Count -gt 0) { @($Skill | Select-Object -Unique) } else { $allSkills }
foreach ($name in $skills) {
  if ($allSkills -notcontains $name) { throw "Unknown skill: $name" }
}

$stamp = (Get-Date).ToUniversalTime().ToString("yyyyMMddTHHmmssZ")
$backupRoot = Join-Path $HOME ".agents/skill-backups/gpt-image-2-5-skills/uninstalled-$stamp"
$moved = $false
$movedCount = 0

foreach ($skill in $skills) {
  $target = Join-Path $Destination $skill
  if (Test-Path $target) {
    New-Item -ItemType Directory -Force -Path $backupRoot | Out-Null
    Move-Item $target (Join-Path $backupRoot $skill)
    $moved = $true
    $movedCount++
  }
}

if ($moved) {
  Write-Host "Uninstalled $movedCount skill(s). Files were moved to $backupRoot"
} else {
  Write-Host "No installed GPT Image 2.5 skills were found in $Destination"
}
