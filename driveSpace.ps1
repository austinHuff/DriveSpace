import-module activedirectory
$ErrorActionPreference = 'SilentlyContinue'
$ADComputers = Get-ADComputer -Filter "OperatingSystem -notlike '*Server*'" | select Name # gets all comp names from AD

Invoke-Command -computerName (

                    #'ocio-2t2rqd2', 'ocio-test01', 'ocio-test03', 'ocio-test04', 'ocio-test05' # test computers
                    $ADComputers | Select-Object -expand Name
 
                ) -command {
                    
                    #SAVED PROGRESS LINE-----Get-WmiObject win32_logicaldisk -filter "DeviceID='c:'" | select @{n='Percentage of Memory Remaining'; e={($_.freespace / $_.size)*100}} | where {{($_.freespace / $_.size)*100} -gt $criticalThreshold}
                    
                    Get-WmiObject win32_logicaldisk -filter "DeviceID='c:'" | where {($_.freespace / $_.size)*100 -lt 5} | select @{n='Percentage of Memory Remaining'; e={($_.freespace / $_.size)*100}}, ExtentionAttribute2
                    #Get-WmiObject win32_logicaldisk -filter "DeviceID='c:'" | select @{n='Percentage of Memory Remaining'; e={($_.freespace / $_.size)*100}} | where {{($_.freespace / $_.size)*100} -gt $criticalThreshold}

                }  -ThrottleLimit 250 | export-csv C:\users\huffa\test1.csv
