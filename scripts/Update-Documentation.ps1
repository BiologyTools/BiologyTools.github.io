[CmdletBinding()]
param(
    [ValidateSet('All', 'BioLib', 'BioImager', 'BioGTK', 'IKVM11')]
    [string[]]$Project = @('All')
)

$ErrorActionPreference = 'Stop'

$siteRoot = Split-Path -Parent $PSScriptRoot
$documentationRoot = Join-Path $siteRoot 'Documentation'
$doxygen = (Get-Command doxygen -ErrorAction Stop).Source

$projects = @{
    BioLib = @{
        Root = 'C:\Users\Erikr\Documents\GitHub\BioLib'
        Input = @('README.md', 'Source')
        Brief = 'BioLib microscopy image processing library for .NET'
    }
    BioImager = @{
        Root = 'C:\Users\Erikr\Documents\GitHub\BioImager'
        Input = @('README.md', 'Source')
        Brief = 'BioImager microscopy image analysis application'
    }
    BioGTK = @{
        Root = 'C:\Users\Erikr\Documents\GitHub\BioGTK\BioGTK'
        Input = @('README.md', 'Source')
        Brief = 'BioGTK microscopy image analysis application'
    }
    IKVM11 = @{
        Root = 'C:\Users\Erikr\Documents\GitHub\ikvm'
        Input = @('Doxyfile')
        Brief = 'Java SE 11 Virtual Machine for .NET'
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
        [hashtable]$Definition,
        [string]$ProjectName,
        [string]$OutputDirectory
    )

    $quotedInputs = $Definition.Input | ForEach-Object {
        '"{0}"' -f (Join-Path $Definition.Root $_).Replace('\', '/')
    }

    @(
        'DOXYFILE_ENCODING = UTF-8'
        "PROJECT_NAME = $ProjectName"
        "PROJECT_BRIEF = `"$($Definition.Brief)`""
        "OUTPUT_DIRECTORY = `"$($OutputDirectory.Replace('\', '/'))`""
        'OUTPUT_LANGUAGE = English'
        "INPUT = $($quotedInputs -join ' ')"
        'FILE_PATTERNS = *.cs *.md'
        'RECURSIVE = YES'
        'EXCLUDE_PATTERNS = */bin/* */obj/* */.vs/* */packages/* */.tmp/*'
        'EXTRACT_ALL = YES'
        'EXTRACT_PRIVATE = NO'
        'SOURCE_BROWSER = YES'
        'INLINE_SOURCES = YES'
        'GENERATE_HTML = YES'
        'HTML_OUTPUT = html'
        'GENERATE_LATEX = NO'
        'GENERATE_XML = NO'
        'HAVE_DOT = NO'
        'USE_MDFILE_AS_MAINPAGE = README.md'
    ) -join [Environment]::NewLine
}

$requestedProjects = if ($Project -contains 'All') { @('BioLib', 'BioImager', 'BioGTK', 'IKVM11') } else { $Project }

foreach ($projectName in $requestedProjects) {
    $definition = $projects[$projectName]
    if (-not (Test-Path -LiteralPath $definition.Root)) {
        throw "Project root not found: $($definition.Root)"
    }

    $targetDirectory = Join-Path $documentationRoot $projectName
    $stagingDirectory = Join-Path $env:TEMP ("BiologyTools-Doxygen-$projectName-$([guid]::NewGuid())")

    try {
        if ($projectName -eq 'IKVM11') {
            Invoke-Doxygen -Configuration 'Doxyfile' -WorkingDirectory $definition.Root
            $generatedHtml = Join-Path $definition.Root 'doc\doxygen\html'
        }
        else {
            $doxyfile = Join-Path $stagingDirectory 'Doxyfile'
            New-Item -ItemType Directory -Path $stagingDirectory -Force | Out-Null
            Set-Content -LiteralPath $doxyfile -Value (New-Doxyfile -Definition $definition -ProjectName $projectName -OutputDirectory $stagingDirectory) -Encoding utf8
            Invoke-Doxygen -Configuration $doxyfile -WorkingDirectory $definition.Root
            $generatedHtml = Join-Path $stagingDirectory 'html'
        }

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
