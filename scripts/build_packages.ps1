$ErrorActionPreference = 'Stop'

Add-Type -AssemblyName System.IO.Compression
Add-Type -AssemblyName System.IO.Compression.FileSystem

$repoRoot = (Resolve-Path -LiteralPath (Join-Path $PSScriptRoot '..')).Path
$distDir = Join-Path $repoRoot 'dist'
$skillPath = Join-Path $repoRoot 'SKILL.md'
$licensePath = Join-Path $repoRoot 'LICENSE'
$upstreamLicensePath = Join-Path $repoRoot 'upstream\humanizer\LICENSE'

New-Item -ItemType Directory -Force -Path $distDir | Out-Null

function Write-PackageZip {
    param(
        [Parameter(Mandatory = $true)][string]$Destination,
        [Parameter(Mandatory = $true)][object[]]$Entries
    )

    foreach ($entry in $Entries) {
        if (-not (Test-Path -LiteralPath $entry.Source -PathType Leaf)) {
            throw "Required package file is missing: $($entry.Source)"
        }
    }

    $temporary = "$Destination.tmp"
    if (Test-Path -LiteralPath $temporary) {
        Remove-Item -LiteralPath $temporary -Force
    }

    $archive = [System.IO.Compression.ZipFile]::Open(
        $temporary,
        [System.IO.Compression.ZipArchiveMode]::Create
    )
    try {
        foreach ($entry in $Entries) {
            [System.IO.Compression.ZipFileExtensions]::CreateEntryFromFile(
                $archive,
                $entry.Source,
                $entry.Name,
                [System.IO.Compression.CompressionLevel]::Optimal
            ) | Out-Null
        }
    }
    finally {
        $archive.Dispose()
    }

    Move-Item -LiteralPath $temporary -Destination $Destination -Force
}

$pluginEntries = @(
    @{ Source = (Join-Path $repoRoot 'plugin.json'); Name = 'humanizer-plugin/plugin.json' }
    @{ Source = (Join-Path $repoRoot 'README.md'); Name = 'humanizer-plugin/README.md' }
    @{ Source = $licensePath; Name = 'humanizer-plugin/LICENSE' }
    @{ Source = $skillPath; Name = 'humanizer-plugin/skills/humanizer/SKILL.md' }
    @{ Source = $upstreamLicensePath; Name = 'humanizer-plugin/skills/humanizer/LICENSE' }
)

$skillEntries = @(
    @{ Source = $skillPath; Name = 'humanizer/SKILL.md' }
    @{ Source = $upstreamLicensePath; Name = 'humanizer/LICENSE' }
)

$pluginZip = Join-Path $distDir 'Humanizer-plugin.zip'
$skillZip = Join-Path $distDir 'Humanizer-skill.zip'
Write-PackageZip -Destination $pluginZip -Entries $pluginEntries
Write-PackageZip -Destination $skillZip -Entries $skillEntries

Write-Output "Built $pluginZip"
Write-Output "Built $skillZip"
