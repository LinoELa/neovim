param(
  [switch]$PostMerge
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$repoRoot = Split-Path -Parent $PSScriptRoot
Set-Location $repoRoot
$repoName = Split-Path -Leaf $repoRoot
$configHome = Split-Path -Parent $repoRoot

function Write-Step {
  param([string]$Message)
  Write-Host "`n==> $Message" -ForegroundColor Cyan
}

function Refresh-Path {
  $machinePath = [System.Environment]::GetEnvironmentVariable("Path", "Machine")
  $userPath = [System.Environment]::GetEnvironmentVariable("Path", "User")
  $env:Path = "$machinePath;$userPath"
}

function Install-WithWinget {
  param(
    [Parameter(Mandatory = $true)][string]$PackageId,
    [Parameter(Mandatory = $true)][string]$DisplayName
  )

  if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
    throw "winget no esta disponible. Instala $DisplayName manualmente."
  }

  Write-Step "Instalando $DisplayName con winget"
  & winget install $PackageId -e --accept-package-agreements --accept-source-agreements
  if ($LASTEXITCODE -ne 0) {
    throw "Fallo instalando $DisplayName con winget."
  }

  Refresh-Path
}

function Ensure-Command {
  param(
    [Parameter(Mandatory = $true)][string]$CommandName,
    [Parameter(Mandatory = $true)][string]$PackageId,
    [Parameter(Mandatory = $true)][string]$DisplayName
  )

  if (Get-Command $CommandName -ErrorAction SilentlyContinue) {
    Write-Host "$DisplayName ya esta instalado."
    return
  }

  Install-WithWinget -PackageId $PackageId -DisplayName $DisplayName

  if (-not (Get-Command $CommandName -ErrorAction SilentlyContinue)) {
    throw "$DisplayName se instalo, pero '$CommandName' sigue sin estar en PATH. Cierra y abre la terminal, y vuelve a ejecutar el script."
  }
}

function Test-NerdFontInstalled {
  $fontKeys = @(
    "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts",
    "HKCU:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts"
  )

  foreach ($key in $fontKeys) {
    if (-not (Test-Path $key)) {
      continue
    }

    $propertyNames = (Get-ItemProperty $key).PSObject.Properties.Name
    if ($propertyNames -match "JetBrainsMono NFM") {
      return $true
    }
  }

  return $false
}

function Ensure-NerdFont {
  if (Test-NerdFontInstalled) {
    Write-Host "JetBrainsMono NFM ya esta instalada."
    return
  }

  Install-WithWinget -PackageId "DEVCOM.JetBrainsMonoNerdFont" -DisplayName "JetBrainsMono Nerd Font"

  if (-not (Test-NerdFontInstalled)) {
    Write-Warning "La fuente se instalo, pero aun no aparece en el registro. Reinicia la sesion si los iconos no se ven bien."
  }
}

function Assert-RepoShape {
  $requiredPaths = @(
    "init.lua",
    "lua\config\lazy.lua",
    "lua\plugins\lsp.lua",
    "lua\plugins\nvim-treesitter.lua"
  )

  foreach ($path in $requiredPaths) {
    if (-not (Test-Path $path)) {
      throw "Falta '$path'. Ejecuta este script desde la raiz del repo."
    }
  }
}

function Configure-GitHooks {
  Write-Step "Configurando hooks locales de Git"
  & git config core.hooksPath .githooks
  if ($LASTEXITCODE -ne 0) {
    throw "No pude configurar core.hooksPath en Git."
  }
}

function Invoke-NvimStep {
  param([string[]]$Arguments)

  $previousXdg = $env:XDG_CONFIG_HOME
  $previousAppName = $env:NVIM_APPNAME
  $env:XDG_CONFIG_HOME = $configHome
  $env:NVIM_APPNAME = $repoName
  & nvim @Arguments
  $env:XDG_CONFIG_HOME = $previousXdg
  $env:NVIM_APPNAME = $previousAppName
  if ($LASTEXITCODE -ne 0) {
    throw "Fallo ejecutando: nvim $($Arguments -join ' ')"
  }
}

Write-Step "Validando repositorio"
Assert-RepoShape

Write-Step "Comprobando dependencias base"
Ensure-Command -CommandName "git" -PackageId "Git.Git" -DisplayName "Git"
Configure-GitHooks
Ensure-Command -CommandName "nvim" -PackageId "Neovim.Neovim" -DisplayName "Neovim"
Ensure-Command -CommandName "fd" -PackageId "sharkdp.fd" -DisplayName "fd"
Ensure-Command -CommandName "rg" -PackageId "BurntSushi.ripgrep.MSVC" -DisplayName "ripgrep"
Ensure-NerdFont

Write-Step "Sincronizando plugins y herramientas de Neovim"
Invoke-NvimStep -Arguments @("--headless", "+Lazy! sync", "+MasonInstallAll", "+TSUpdateSync", "+qa")

if ($PostMerge) {
  Write-Host "`nHook post-merge ejecutado correctamente."
  exit 0
}

Write-Step "Versiones detectadas"
& git --version
& nvim --version | Select-Object -First 1
& fd --version
& rg --version | Select-Object -First 1

Write-Host "`nListo. Si algun servidor LSP o parser no quedo instalado, abre Neovim y ejecuta manualmente:"
Write-Host "  :MasonInstallAll"
Write-Host "  :TSUpdate"
