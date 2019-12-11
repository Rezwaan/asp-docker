# Writes an error to build summary and to log in red text
#Write-Host  "##vso[task.LogIssue type=error;]This is the error and we need to initmate the developer team for this"
#exit 1
$vers = $PSVersionTable
Write-Host "Curren version is $vers "
