###Name - PS_Export-DeviceEventlogsToUNC
###User - WandJ0 | Justin Wandeler
###Date - 03/01/2023

##Exports whole System & Application Eventlog to UNC share

##Change these hostnames to the corresponding devices you want to monitor. To add more add ",'DeviceXY'".
$devices = @('DeviceXY, DeviceYX')

##This forech loop handles the exporting of the Eventlogs onto the UNC share. 
foreach ($device in $devices){
    Write-Host $device
    ##This Invoke-Command handles the exporting of the Eventlogs
    Invoke-Command -ComputerName $device -ScriptBlock{
        Write-Host "Getting System Eventlogs from & exporting them."
        wevtutil export-log System C:\temp\$(hostname)_$((Get-Date).ToString('HH_mm_dd_MM_yyyy_hh'))_System_Event_Log.evtx
        Write-Host "Getting Application Eventlogs from & exporting them."
        wevtutil export-log Application C:\temp\\$(hostname)_$((Get-Date).ToString('HH_mm_dd_MM_yyyy_hh'))_Application_Event_Log.evtx
    }

    ##This part of the script moves the newly exported Eventlogs to the UNC Share
    ##Be sure to add your specific UNC share
    Write-Host "Moving exported System Eventlog to UNC share"
    Move-Item "\\$($device)\c$\temp\$($device)_$((Get-Date).ToString('HH_mm_dd_MM_yyyy_hh'))_System_Event_Log.evtx" -Destination "\\vfs006\pkgshare$\GMLU_Citrix\EventLogs_VDI\"
    Write-Host "Moving exported System Eventlog to UNC share"
    Move-Item "\\$($device)\c$\temp\$($device)_$((Get-Date).ToString('HH_mm_dd_MM_yyyy_hh'))_Application_Event_Log.evtx" -Destination "\\vfs006\pkgshare$\GMLU_Citrix\EventLogs_VDI\"
}