# Created by CloudRadial
# Visit us at https://cloudradial.com
 
# This intune script downloads the file, executes it silently and deletes the installer.
# for additional help on dataagent parameters visit: https://support.cloudradial.com/hc/en-us/articles/360021689932-Installing-the-Data-Agent

$BlobSASUrl = "https://cloudradialexample.blob.core.windows.net/installer/DataAgent-contoso-Current.exe?sp=r&st=2019-06-21T15:27:15Z&se=2119-06-21T23:27:15Z&spr=https&sv=2018-03-28&sig=CJeiX55vp7VfwxPHSOx0kUreOZH%2B1AefwldFdK5Benk%3D&sr=b"
$DataAgent = $(if($BlobSASUrl -match "([^/]*)\?") {$matches[1]})

Invoke-WebRequest $BlobSASUrl -OutFile $env:temp\$DataAgent
Start-Process -FilePath "$($env:temp)\$DataAgent" -Args "/companyid=1 /verysilent" -Verb RunAs -Wait
Remove-Item "$($env:temp)\$DataAgent"
