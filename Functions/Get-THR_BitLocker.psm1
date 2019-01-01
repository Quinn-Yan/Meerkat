function Get-THR_BitLocker {
    <#
    .SYNOPSIS 
        Gets BitLocker details on a given system.

    .DESCRIPTION 
        Gets BitLocker details on a given system.

    .PARAMETER Computer  
        Computer can be a single hostname, FQDN, or IP address.  

    .EXAMPLE 
        Get-THR_BitLocker
        Get-THR_BitLocker SomeHostName.domain.com
        Get-Content C:\hosts.csv | Get-THR_BitLocker
        Get-ADComputer -filter * | Select -ExpandProperty Name | Get-THR_BitLocker

    .NOTES 
        Updated: 2018-12-31

        Contributing Authors:
            Jeremy Arnold
            Anthony Phipps
            
        LEGAL: Copyright (C) 2018
        This program is free software: you can redistribute it and/or modify
        it under the terms of the GNU General Public License as published by
        the Free Software Foundation, either version 3 of the License, or
        (at your option) any later version.
    
        This program is distributed in the hope that it will be useful,
        but WITHOUT ANY WARRANTY; without even the implied warranty of
        MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
        GNU General Public License for more details.

        You should have received a copy of the GNU General Public License
        along with this program.  If not, see <http://www.gnu.org/licenses/>.

    .LINK
       https://github.com/TonyPhipps/THRecon
    #>

    [CmdletBinding()]
    param(
    )

	begin{

        $DateScanned = Get-Date -Format u
        Write-Information -InformationAction Continue -MessageData ("Started {0} at {1}" -f $MyInvocation.MyCommand.Name, $DateScanned)

        $stopwatch = New-Object System.Diagnostics.Stopwatch
        $stopwatch.Start()
    }

    process{

        $ResultsArray = Get-BitLockerVolume

        foreach ($Result in $ResultsArray) {
            $Result | Add-Member -MemberType NoteProperty -Name "Host" -Value $env:COMPUTERNAME
            $Result | Add-Member -MemberType NoteProperty -Name "DateScanned" -Value $DateScanned
        }

        return $ResultsArray | Select-Object Host, DateScanned, MountPoint, EncryptionMethod, AutoUnlockEnabled, 
        MetadataVersion, VolumeStatus, ProtectionStatus, LockStatus, EncryptionPercentage, WipePercentage, VolumeType, CapacityGB, KeyProtector

    }

    end{
        
        $elapsed = $stopwatch.Elapsed

        Write-Verbose ("Started at {0}" -f $DateScanned)
        Write-Verbose ("Total time elapsed: {0}" -f $elapsed)
        Write-Verbose ("Ended at {0}" -f (Get-Date -Format u))
    }
}