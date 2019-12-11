#add-type @"
 #   using System.Net;
  #  using System.Security.Cryptography.X509Certificates;
   # public class TrustAllCertsPolicy : ICertificatePolicy {
    #    public bool CheckValidationResult(
    #        ServicePoint srvPoint, X509Certificate certificate,
     #       WebRequest request, int certificateProblem) {
      #      return true;
       # }
    #}
#"@
#[System.Net.ServicePointManager]::CertificatePolicy = New-Object TrustAllCertsPolicy

#[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Ssl3, [Net.SecurityProtocolType]::Tls, [Net.SecurityProtocolType]::Tls11, [Net.SecurityProtocolType]::Tls12
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
function Get-Data([string]$username, [string]$password, [string]$url) {
 
  # Step 1. Create a username:password pair
  $credPair = "$($username):$($password)"
 
  # Step 2. Encode the pair to Base64 string
  $encodedCredentials = [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes($credPair))
 
  # Step 3. Form the header and add the Authorization attribute to it
  $headers = @{ Authorization = "Basic $encodedCredentials" }
 
  # Step 4. Make the GET request
  $responseData = (Invoke-WebRequest -Uri $url -Method Get -Headers $headers -UseBasicParsing -SkipCertificateCheck -ContentType "application/json").Content | ConvertFrom-Json | ConvertTo-Json
 #$responseData = Invoke-RestMethod -Uri $url -Method Get -UseBasicParsing 
  return $responseData
}

$data = Get-Data -username attiq.ur.rehman@spglobal.com -password ABCSHHAAHHA -url https://ssc.spglobal.com/ssc/api/v1/projectVersions/11807/issues
#$dataToDict = $data | ConvertFrom-Json
$data | Out-File .\api_response.txt

#Conditional operator to stop/resume the build
cd C:
$pwd=pwd
echo "Current working directory is $pwd"
$oc=(get-content .\api_response.txt | select-string -pattern Critical).length

if($oc -le 20){
   write-host("Low Critical")
   Write-Host  "##vso[task.LogIssue type=error;]This is the error and we need to initmate the developer team for this"
exit 0
}else {
   write-host("High Critical")
   Write-Host  "##vso[task.LogIssue type=error;]This is the Nomal and we dont need to initmate the developer team for this"
exit 1
}



