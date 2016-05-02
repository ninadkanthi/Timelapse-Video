#this script creates an Azure File Share. During the program, this script was executed twice to create the /Share and /backup folders 
$SubscriptionName="XXXXXXXXXX "
$LoadSettings = Import-AzurePublishSettingsFile ".\NinadK.publishsettings"
Set-AzureSubscription -SubscriptionName $SubscriptionName -ErrorAction Stop
Select-AzureSubscription -SubscriptionName $SubscriptionName -ErrorAction Stop
$StorageAccountName= "nkXXXXX"
$AzureSampleShare="linuxXXX"
$ShareDirectoryName="Share"  # "backup"
$StorageContext = New-AzureStorageContext -StorageAccountName $StorageAccountName -StorageAccountKey
(Get-AzureStoragekey -StorageAccountName $StorageAccountName).Primary -Protocol Https
$rv=New-AzureStorageShare -Name $AzureSampleShare -Context $StorageContext
$newDirectory = New-AzureStorageDirectory -Share $rv -Path $ShareDirectoryName
Get-AzureStorageFile -Share $rv -Path $ShareDirectoryName

#Response
#   Directory: https://xxxx.file.core.windows.net/xxxxxxxx
#Type                Length Name
#----                ------ ----
#                         1 xxxxxx
