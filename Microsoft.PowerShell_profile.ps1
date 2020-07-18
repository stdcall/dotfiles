New-Alias ec emacsclient.exe
function sage { docker run -p 8888:8888 sagemath/sagemath-jupyter }
Set-PSReadLineOption -EditMode Emacs

Import-Module 'C:\proj\pulled\posh-git\src\posh-git.psd1'

# Chocolatey profile
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}
