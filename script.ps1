# Writes an error to build summary and to log in red text
Write-Host  "##vso[task.LogIssue type=error;]This is the error"
exit 1