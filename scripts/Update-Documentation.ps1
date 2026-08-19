[CmdletBinding()]
param(
    [ValidateSet('All', 'BioLib', 'BioImager', 'BioGTK', 'IKVM11')]
    [string[]]$Project = @('All')
)

$ErrorActionPreference = 'Stop'

$siteRoot = Split-Path -Parent $PSScriptRoot
$documentationRoot = Join-Path $siteRoot 'Documentation'
$repositoryRoot = 'C:\Users\Erikr\Documents\GitHub'
$doxygen = (Get-Command doxygen -ErrorAction Stop).Source
$legacyThemeDoxyfile = Join-Path $repositoryRoot 'BioLibDoxyfile'

$projects = @{
    BioLib = @{
        Root = Join-Path $repositoryRoot 'BioLib'
        Readme = Join-Path $repositoryRoot 'BioLib\README.md'
        Doxyfiles = @($legacyThemeDoxyfile)
        WorkingDirectory = $repositoryRoot
    }
    BioImager = @{
        Root = Join-Path $repositoryRoot 'BioImager'
        Readme = Join-Path $repositoryRoot 'BioImager\README.md'
        Doxyfiles = @(Join-Path $repositoryRoot 'BioImagerDoxyfile')
        WorkingDirectory = $repositoryRoot
    }
    BioGTK = @{
        Root = Join-Path $repositoryRoot 'BioGTK\BioGTK'
        Readme = Join-Path $repositoryRoot 'BioGTK\BioGTK\README.md'
        Doxyfiles = @(Join-Path $repositoryRoot 'BioGTKDoxyfile')
        WorkingDirectory = $repositoryRoot
    }
    IKVM11 = @{
        Root = Join-Path $repositoryRoot 'ikvm'
        Readme = Join-Path $repositoryRoot 'ikvm\README.md'
        Doxyfiles = @($legacyThemeDoxyfile, (Join-Path $repositoryRoot 'ikvm\Doxyfile'))
        WorkingDirectory = Join-Path $repositoryRoot 'ikvm'
    }
}

function Invoke-Doxygen {
    param(
        [string]$Configuration,
        [string]$WorkingDirectory
    )

    Push-Location $WorkingDirectory
    try {
        & $doxygen $Configuration
        if ($LASTEXITCODE -ne 0) {
            throw "Doxygen failed for $WorkingDirectory with exit code $LASTEXITCODE."
        }
    }
    finally {
        Pop-Location
    }
}

function New-Doxyfile {
    param(
        [string[]]$IncludedDoxyfiles,
        [string]$OutputDirectory,
        [string]$MainPage
    )

    @(
        $IncludedDoxyfiles | ForEach-Object {
            "@INCLUDE = `"$($_.Replace('\', '/'))`""
        }
        "OUTPUT_DIRECTORY = `"$($OutputDirectory.Replace('\', '/'))`""
        "INPUT += `"$($MainPage.Replace('\', '/'))`""
        "USE_MDFILE_AS_MAINPAGE = `"$($MainPage.Replace('\', '/'))`""
        'HTML_HEADER = D:/repos/RepoErik/doxygen-awesome/doxygen-custom/header.html'
        'HTML_COLORSTYLE = TOGGLE'
        'GENERATE_TREEVIEW = YES'
        'DISABLE_INDEX = NO'
        'FULL_SIDEBAR = NO'
        'HTML_EXTRA_STYLESHEET = D:/repos/RepoErik/doxygen-awesome/doxygen-awesome.css D:/repos/RepoErik/doxygen-awesome/doxygen-awesome-sidebar-only.css D:/repos/RepoErik/doxygen-awesome/doxygen-awesome-sidebar-only-darkmode-toggle.css'
        'HTML_EXTRA_FILES = D:/repos/RepoErik/doxygen-awesome/doxygen-awesome-darkmode-toggle.js D:/repos/RepoErik/doxygen-awesome/doxygen-awesome-fragment-copy-button.js D:/repos/RepoErik/doxygen-awesome/doxygen-awesome-interactive-toc.js D:/repos/RepoErik/doxygen-awesome/doxygen-awesome-paragraph-link.js D:/repos/RepoErik/doxygen-awesome/doxygen-awesome-tabs.js D:/repos/RepoErik/doxygen-awesome/doxygen-custom/toggle-alternative-theme.js'
    ) -join [Environment]::NewLine
}

$requestedProjects = if ($Project -contains 'All') { @('BioLib', 'BioImager', 'BioGTK', 'IKVM11') } else { $Project }

foreach ($projectName in $requestedProjects) {
    $definition = $projects[$projectName]
    if (-not (Test-Path -LiteralPath $definition.Root)) {
        throw "Project root not found: $($definition.Root)"
    }
    foreach ($includedDoxyfile in $definition.Doxyfiles) {
        if (-not (Test-Path -LiteralPath $includedDoxyfile)) {
            throw "Doxygen configuration not found: $includedDoxyfile"
        }
    }
    if (-not (Test-Path -LiteralPath $definition.Readme)) {
        throw "README not found: $($definition.Readme)"
    }

    $targetDirectory = Join-Path $documentationRoot $projectName
    $stagingDirectory = Join-Path $env:TEMP ("BiologyTools-Doxygen-$projectName-$([guid]::NewGuid())")

    try {
        New-Item -ItemType Directory -Path $stagingDirectory -Force | Out-Null
        $doxyfile = Join-Path $stagingDirectory 'Doxyfile'
        Set-Content -LiteralPath $doxyfile -Value (New-Doxyfile -IncludedDoxyfiles $definition.Doxyfiles -OutputDirectory $stagingDirectory -MainPage $definition.Readme) -Encoding utf8
        Invoke-Doxygen -Configuration $doxyfile -WorkingDirectory $definition.WorkingDirectory

        $generatedHtml = Join-Path $stagingDirectory 'html'
        if (-not (Test-Path -LiteralPath (Join-Path $generatedHtml 'index.html'))) {
            throw "Doxygen did not create an index page for $projectName."
        }

        New-Item -ItemType Directory -Path $targetDirectory -Force | Out-Null
        & robocopy $generatedHtml $targetDirectory /MIR /COPY:DAT /DCOPY:DAT /R:1 /W:1 /NFL /NDL /NJH /NJS /NP
        if ($LASTEXITCODE -gt 7) {
            throw "Failed to publish $projectName documentation (robocopy exit code $LASTEXITCODE)."
        }

        Write-Host "Published $projectName documentation to $targetDirectory"
    }
    finally {
        if (Test-Path -LiteralPath $stagingDirectory) {
            Remove-Item -LiteralPath $stagingDirectory -Recurse -Force
        }
    }
}
