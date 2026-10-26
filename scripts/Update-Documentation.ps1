[CmdletBinding()]
param(
    [ValidateSet('All', 'BioLib', 'BioImager', 'BioGTK', 'IKVM11', 'ZarrNET')]
    [string[]]$Project = @('All')
)

$ErrorActionPreference = 'Stop'

$siteRoot = Split-Path -Parent $PSScriptRoot
$documentationRoot = Join-Path $siteRoot 'Documentation'
$repositoryRoot = 'C:\Users\Erikr\Documents\GitHub'
$doxygenCommand = Get-Command doxygen -ErrorAction SilentlyContinue
$doxygen = if ($doxygenCommand) { $doxygenCommand.Source } else { Join-Path $env:ProgramFiles 'doxygen\bin\doxygen.exe' }
if (-not (Test-Path -LiteralPath $doxygen)) {
    throw 'Doxygen was not found on PATH or in Program Files.'
}
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
    ZarrNET = @{
        Root = Join-Path $repositoryRoot 'ZarrNET'
        Readme = Join-Path $repositoryRoot 'ZarrNET\README.md'
        Doxyfiles = @(Join-Path $repositoryRoot 'ZarrNETDoxyfile')
        WorkingDirectory = $repositoryRoot
        ProjectFile = Join-Path $repositoryRoot 'ZarrNET\Zarr.NET.csproj'
        HtmlReplacements = @{
            'https://BiologyTools.github.io/Documentation/ZarrNET/html/index.html' = 'https://biologytools.github.io/Documentation/ZarrNET/'
        }
        Overrides = @(
            'EXCLUDE_PATTERNS += */bin/* */obj/* */.git/* */.vs/* */.tmp/* */.agents/* */.codex/* */ZarrNET.Tests/*'
            'HTML_EXTRA_FILES += D:/repos/RepoErik/doxygen-awesome/logo.drawio.svg'
        )
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

$requestedProjects = if ($Project -contains 'All') { @('BioLib', 'BioImager', 'BioGTK', 'IKVM11', 'ZarrNET') } else { $Project }

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
    if ($definition.OutputSubdirectory) {
        $targetDirectory = Join-Path $targetDirectory $definition.OutputSubdirectory
    }
    $stagingDirectory = Join-Path $env:TEMP ("BiologyTools-Doxygen-$projectName-$([guid]::NewGuid())")

    try {
        New-Item -ItemType Directory -Path $stagingDirectory -Force | Out-Null
        $doxyfile = Join-Path $stagingDirectory 'Doxyfile'
        $configuration = New-Doxyfile -IncludedDoxyfiles $definition.Doxyfiles -OutputDirectory $stagingDirectory -MainPage $definition.Readme
        if ($definition.ProjectFile) {
            [xml]$projectXml = Get-Content -LiteralPath $definition.ProjectFile -Raw
            $version = @($projectXml.Project.PropertyGroup.Version | Where-Object { $_ })[0]
            if (-not $version) {
                throw "Project version not found: $($definition.ProjectFile)"
            }
            $configuration += "`nPROJECT_NUMBER = $version"
        }
        $configuration += "`n" + ($definition.Overrides -join "`n")
        Set-Content -LiteralPath $doxyfile -Value $configuration -Encoding utf8
        Invoke-Doxygen -Configuration $doxyfile -WorkingDirectory $definition.WorkingDirectory

        $generatedHtml = Join-Path $stagingDirectory 'html'
        if (-not (Test-Path -LiteralPath (Join-Path $generatedHtml 'index.html'))) {
            throw "Doxygen did not create an index page for $projectName."
        }

        # Keep links from upstream READMEs aligned with the site's published paths.
        if ($definition.HtmlReplacements) {
            foreach ($htmlFile in Get-ChildItem -LiteralPath $generatedHtml -Filter '*.html' -Recurse -File) {
                $html = [IO.File]::ReadAllText($htmlFile.FullName)
                $updatedHtml = $html
                foreach ($replacement in $definition.HtmlReplacements.GetEnumerator()) {
                    $updatedHtml = $updatedHtml.Replace($replacement.Key, $replacement.Value)
                }
                if ($updatedHtml -ne $html) {
                    [IO.File]::WriteAllText($htmlFile.FullName, $updatedHtml)
                }
            }
        }

        New-Item -ItemType Directory -Path $targetDirectory -Force | Out-Null
        $resolvedTarget = [IO.Path]::GetFullPath($targetDirectory)
        $resolvedDocumentationRoot = [IO.Path]::GetFullPath($documentationRoot) + [IO.Path]::DirectorySeparatorChar
        if (-not $resolvedTarget.StartsWith($resolvedDocumentationRoot, [StringComparison]::OrdinalIgnoreCase)) {
            throw "Documentation target is outside the documentation root: $resolvedTarget"
        }
        & robocopy $generatedHtml $targetDirectory /MIR /COPY:DAT /DCOPY:DAT /R:1 /W:1 /NFL /NDL /NJH /NJS /NP
        if ($LASTEXITCODE -gt 7) {
            throw "Failed to publish $projectName documentation (robocopy exit code $LASTEXITCODE)."
        }
        # Robocopy uses nonzero success codes; expose success to calling shells.
        $global:LASTEXITCODE = 0

        Write-Host "Published $projectName documentation to $targetDirectory"
    }
    finally {
        if (Test-Path -LiteralPath $stagingDirectory) {
            $resolvedStaging = [IO.Path]::GetFullPath($stagingDirectory)
            $temporaryRoot = [IO.Path]::GetFullPath($env:TEMP).TrimEnd('\', '/') + [IO.Path]::DirectorySeparatorChar
            if (-not $resolvedStaging.StartsWith($temporaryRoot, [StringComparison]::OrdinalIgnoreCase)) {
                throw "Staging directory is outside the temporary root: $resolvedStaging"
            }
            Remove-Item -LiteralPath $stagingDirectory -Recurse -Force
        }
    }
}
