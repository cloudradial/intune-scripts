This Example uses Azure Blob storage, but the file can be any https link the client can reach.

## Requirements
* Windows 10 version 1607 or later
* Microsoft Intune subscription
* Azure AD Joined devices

## Setup
### Copy executable to the cloud
If you do not have a location to store the file, consider using an azure storage account
#### Create azure storage account
1. From storage accounts, click **+ Add**
Subscription: <choose a subscription>
Resource group: <choose a resource group>
Storage account name: cloudradialdataagent
Location: <choose a location near you>
Replication: Locally-redundant storage (LRS)
1. Click **Review + Create**
1. Click **Create**
1. Once deployment completes click **Go to resource**
#### Copy exeutable to storage account
1. From the storage account, select Blob Service - Blob
1. Click **+ Container**
Name: installer
1. Select the new container, then click **Upload**
1. From the Select file screen, **rename the Agent installer removing the version** because the install script always uses the same name.
e.x. "DataAgent-{company-name}-Current.exe"
1. Select file, then click **Open**
1. Click **Upload**
1. Close the Upload blob blade, then click the **context menu** button for the uploaded file and choose **Generate SAS**
1. Set Expiry date/time to 100 years into the future
1. Click **Generate blob SAS token and URL
1. Save the **Blob SAS URL** for use in the next section, and
1. Verify the download is successful using your favorite web browser.

### Configure Intune
1. [Download](https://raw.githubusercontent.com/cloudradial/intune-scripts/master/Example%201/Install-CloudRadialDataAgent.ps1) or Save the script below as "Install-CloudRadialDataAgent.ps1"
    ```
    $BlobSASUrl = "https://cloudradialexample.blob.core.windows.net/installer/DataAgent-contoso-Current.exe?sp=r&st=2019-06-21T15:27:15Z&se=2119-06-21T23:27:15Z&spr=https&sv=2018-03-28&sig=CJeiX55vp7VfwxPHSOx0kUreOZH%2B1AefwldFdK5Benk%3D&sr=b"
    $DataAgent = $(if($BlobSASUrl -match "([^/]*)\?") {$matches[1]})

    Invoke-WebRequest $BlobSASUrl -OutFile $env:temp\$DataAgent
    Start-Process -FilePath "$($env:temp)\$DataAgent" -Args "/companyid=1 /verysilent" -Verb RunAs -Wait
    Remove-Item "$($env:temp)\$DataAgent"
    ```
1. Modify the example script provided with the **BlobSASUrl** obtained from the previous section
1. From the Azure portal, Navigate to **Intune > Device configuration > PowerShell Scripts**
1. Click **+ Add**
Name: Install CloudRadial DataAgent
1. Click **Next**
1. Use the following Script settings
Script location: `<Select the Install-CloudRadialDataAgent.ps1 script from step 1>`
Run this script using the logged on credentials: No (default)
Enforce script signature check: No (default)
Run script in 64 bit PowerShell Host: Yes
1. Click **Next**
1. Click **+ Select groups to include** and choose the desired user or device group.
1. Click **Add**
Once configured it can take some time for the device configuration policy to reach the assigned machines. Check the troubleshooting section for more information.

## Troubleshooting
If the agent is not deploying, verify the "Microsoft Intune Management Extension" is installed on the client. This extension can be found in "App/Remove Programs" and will download a copy of the PowerShell script to the folder "C:\Program Files (x86)\Microsoft Intune Management Extension\Policies\Script".
