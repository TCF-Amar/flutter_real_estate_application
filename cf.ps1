# ===============================
# Usage: ./cf.ps1 auth
# Run from Flutter project root
# ===============================

param (
    [Parameter(Mandatory = $true)]
    [string]$feature
)

$base = "lib/features/$feature"

$folders = @(
    "models",
    "views/screens",
    "views/widgets",
    "controllers",
    "bindings"
)

$files = @(
    "models/${feature}_model.dart",
    "controllers/${feature}_controller.dart",
    "bindings/${feature}_binding.dart"
   
)


foreach ($folder in $folders) {
    New-Item -ItemType Directory -Path "$base/$folder" -Force | Out-Null
}

foreach ($file in $files) {
    New-Item -ItemType File -Path "$base/$file" -Force | Out-Null
}

Write-Host "Clean architecture feature '$feature' with binding created successfully!"
