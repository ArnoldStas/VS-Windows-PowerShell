<#
    .SYNOPSIS
    Performs file and folder management tasks like creating, deleting, renaming, copying, moving files or folders, and searching items.

    .DESCRIPTION
    The Manage-File function is designed to handle basic file and folder operations such as deleting, creating (file or folder), renaming, moving, copying files or folders, and searching items.
    You can specify a path and action to perform, with additional optional parameters like Force, Recurse, and ShowInfo for added functionality.
    To get started with the operations, you must specify both the path and one of the five available actions.
    -ShowInfo displays detailed information about the completed action, including specific changes made.

    .PARAMETER Path
    Specifies the path to the file or folder you want to manage.

    .PARAMETER Action
    Specifies the action to perform on the specified path. Possible values are: Delete, CreateFolder, CreateFile, Rename, Move, and Copy.

    .PARAMETER Name
    Specifies the name of the file or folder to create. Used with CreateFolder and CreateFile actions.

    .PARAMETER NewName
    Specifies the new name for renaming a file or folder. Used with the Rename action.

    .PARAMETER Destination
    Specifies the destination path to move or copy a file or folder. Used with Move and Copy actions.

    .PARAMETER Force
    Forces the action to occur by overriding any restrictions, such as overwriting existing files or folders.

    .PARAMETER Recurse
    Deletes or copies all items within a directory recursively. Only applies to the Delete and Copy actions.

    .PARAMETER Date
    Specify the date by which files/folders will be searched.

    .PARAMETER ShowInfo
    Displays detailed information about the specified file or folder after the operation is completed.
    If any of actions were used, a summary will display this instead. This is an optional switch and can be used with any action.

    .EXAMPLE
    Manage-File -Path "C:\ExampleFolder" -Action Delete
    Deletes the ExampleFolder and all its contents forcefully.

    .EXAMPLE
    Manage-File -Path "C:\ExampleFolder" -Action CreateFolder -Name "NewFolder"
    Creates a new folder named "NewFolder" inside the specified path "C:\ExampleFolder".

    .EXAMPLE
    Manage-File -Path "C:\ExampleFolder" -Action CreateFile -Name "ExampleFile.txt"
    Creates a new file named "ExampleFile.txt" inside the specified path "C:\ExampleFolder".

    .EXAMPLE
    Manage-File -Path "C:\ExampleFile.txt" -Action Rename -NewName "RenamedFile.txt"
    Renames "ExampleFile.txt" to "RenamedFile.txt".

    .EXAMPLE
    Manage-File -Path "C:\ExampleFolder\ExampleFile.txt" -Action Move -Destination "D:\Backup"
    Moves "ExampleFile.txt" from "C:\ExampleFolder" to "D:\Backup".

    .EXAMPLE
    Manage-File -Path "C:\ExampleFolder\ExampleFile.txt" -Action Copy -Destination "D:\CopyExample"
    Copies "ExampleFile.txt" from "C:\ExampleFolder" to "D:\CopyExample".

    .EXAMPLE
    Manage-File -Path "C:\ExampleFolder" -Action Delete -ShowInfo
    Deletes the ExampleFolder and all its contents forcefully and shows information about the whole action.

    .EXAMPLE
    Manage-File -Path "C:\ExampleFolder" -Action Search -Date yyyy-MM-dd -ShowInfo
    This command will search within the folder C:\ExampleFolder for files that match the specified date criteria, likely displaying information about each file found. The search may look for files created, modified, or accessed on the provided date format, yyyy-MM-dd.

    .NOTES
    Ensure that you have the necessary permissions to perform the specified actions.
    The function supports ShouldProcess, meaning that actions like Delete, Create, and Rename can be confirmed or bypassed if required.  
    If you specify the additional -ShowInfo switch in the actions, you will receive detailed information about the completed action (e.g., whether the operation succeeded and what changes were made)
#>
function Manage-File
{
    [cmdletbinding(SupportsShouldProcess = $true)]
    param (
        [Parameter(Mandatory = $true, Position = 0, HelpMessage = 'Please enter the path to the file/folder:')]
        [ValidateNotNullOrEmpty()]
        [string]$Path,
        
        [Parameter(Mandatory = $true, HelpMessage = 'Please enter the action to proceed:')]
        [ValidateSet('Delete', 'CreateFolder', 'CreateFile', 'Rename', 'Move', 'Copy', 'Search')]
        [string]$Action,

        [Parameter(HelpMessage = 'Please enter the name of file/folder:')][string]$Name,

        [Parameter(HelpMessage = 'Please enter the new name of file/folder:')][string]$NewName,

        [Parameter(HelpMessage = 'Please enter the destination:')][string]$Destination,

        [Parameter(HelpMessage = 'Please enter the date:')][datetime]$Date = "$(Get-Date -Format yyyy-MM-dd)",

        [switch]$Force,
        [switch]$Recurse,

        [switch]$ShowInfo
    )

    BEGIN {

        Write-Host "`nSelected path:" $path -ForegroundColor Cyan
        if (Test-Path -Path $Path) {
            Write-Host "The Path exists. The action proceeds!" -ForegroundColor Green
        } else {
            Write-Host "The path doesn't exist. The action stops!" -ForegroundColor Red
        }
    }

    PROCESS {

        switch($Action) {
            'Delete' {
                Write-Verbose "Action '$Action' used for deleting files/folders"
                if (Test-Path -Path $Path) {
                    if ($PSCmdlet.ShouldProcess($Path, "Remove File/Folder")) {
                    $DeletedPath = $Path
                    Remove-Item -Path $Path -Recurse:$Recurse -Force:$Force -ErrorAction SilentlyContinue -Confirm
                    Write-Host "`nSuccesfully deleted a file/folder: $Path" -ForegroundColor Yellow
                    [bool]$Deletion = $true
                  }
                }
            }

            'CreateFolder' {
                Write-Verbose "Action '$Action' used for creating folders"
                if (Test-Path -Path $Path) {
                    $itemType = (Get-Item -Path $Path).PSIsContainer # Patikrina ar pateiktas failas nurodo faila ar aplanka. Jei aplankas - $true, jei failas - $false
                if (-not $itemType) {
                    Write-Host "`nCan't create a folder in file!" -ForegroundColor DarkRed
                } else {
                    if (Test-Path -path $Path\$Name) {
                        Write-Host "`nThe $Path\$Name already exists!" -ForegroundColor Red
                    } else {
                        if ($PSCmdlet.ShouldProcess($Path, "Create a Folder")) {
                        New-Item -ItemType Directory -Path $Path\$Name -Force:$Force
                        Write-Host "`nSuccesfully created a folder: $Path\$Name" -ForegroundColor Yellow
                        [bool]$CreationFolder = $true
                      }
                   }  
                }
              }
            }

            'CreateFile' {
                Write-Verbose "Action '$Action' used for creating files"
                if (Test-Path -Path $Path) {
                    $itemType = (Get-Item -Path $Path).PSIsContainer # Patikrina ar pateiktas failas nurodo faila ar aplanka. Jei aplankas - $true, jei failas - $false
                if (-not $itemType) {
                    Write-Host "`nCan't create a file in file!" -ForegroundColor DarkRed
                } else {
                    if (Test-Path -path $Path\$Name) {
                        Write-Host "`nThe $Path\$Name already exists!" -ForegroundColor Red
                    } else {
                        if ($PSCmdlet.ShouldProcess($Path, "Create a File")) {
                        New-Item -ItemType File -Path $Path\$Name -Force:$Force
                        Write-Host "`nSuccesfully created a file: $Path\$Name" -ForegroundColor Yellow
                        [bool]$CreationFile = $true
                      }
                   }  
                }
              }
            }

            'Rename' {
                 Write-Verbose "Action '$Action' used for renaming files/folders"
                 if (Test-Path -path $Path) {
                 $TestPath = Join-Path -Path (Split-Path -Path $Path) -ChildPath $NewName # split-path komanda atjungia paskutini failo ar aplanko pavadinima, o join-path -childpath $newname sujungia aplanko kelia su nauju pavadinimu
                 if (Test-Path -path $TestPath) {
                        Write-Host "`nCan't change file/folder name because it already exists!" -ForegroundColor Red
                        Write-Host "`nExisting path: $TestPath" -ForegroundColor Magenta
                 } else {
                    if ($TestPath -eq $Path) {
                        Write-Host "`nThe file/folder has already the exact name: $NewPath" -ForegroundColor Red
                        Write-Host "`nOld path: $Path" -ForegroundColor Blue
                        Write-Host "New path: $TestPath" -ForegroundColor Blue
                    } else {
                        Rename-Item -Path $Path -NewName $NewName -Force:$Force -ErrorAction SilentlyContinue
                        $NewPath = Join-Path -Path (Split-Path -Path $Path) -ChildPath $NewName
                        Write-Host "`nSuccesfully renamed a file/folder: $NewPath" -ForegroundColor Yellow
                        [bool]$Renamed = $true
                    }
                  }
                }
            }

            'Move' {
                Write-Verbose "Action '$Action' used for moving files/folders"
                if (Test-Path -Path $Path) {
                    $itemType = (Get-Item -Path $Destination).PSIsContainer # Patikrina ar pateiktas failas nurodo faila ar aplanka. Jei aplankas - $true, jei failas - $false
                    if (-not $itemType) {
                        Write-Host "`nDestination can't be set up to a file!" -ForegroundColor Red
                        Write-Host "`Destination: $Destination" -ForegroundColor Blue
                    } else {
                        $Type = (Get-Item -Path $Path).PSIsContainer
                        Move-Item -Path $Path -Destination $Destination -Force:$Force
                        Write-Host "`nSuccesfully moved a file/folder: $(Split-Path -Path $Path -Leaf)" -ForegroundColor Yellow
                        [bool]$Moved = $true
                    }
                }
            }

            'Copy' {
                Write-Verbose "Action '$Action' used for copying files/folders"
                if (Test-Path -Path $Path) {
                    $itemType = (Get-Item -Path $Destination).PSIsContainer # Patikrina ar pateiktas failas nurodo faila ar aplanka. Jei aplankas - $true, jei failas - $false
                    if (-not $itemType) {
                        Write-Host "`nDestination can't be set up to a file!" -ForegroundColor Red
                        Write-Host "`Destination: $Destination" -ForegroundColor Blue
                    } else {
                        $Type = (Get-Item -Path $Path).PSIsContainer
                        Copy-Item -Path $Path -Destination $Destination -Force:$Force
                        Write-Host "`nSuccesfully copied a file/folder: $(Split-Path -Path $Path -Leaf)" -ForegroundColor Yellow
                        [bool]$Copied = $true
                    }
                }
            }
            'Search' {
                Write-Verbose "Action '$Action' used for searching files/folders by specific date"
    
                if (Test-Path -Path $Path) {

                $items = @()

                $items += Get-ChildItem -Path $Path -Recurse:$Recurse | Where-Object {
                $_.LastWriteTime -ge $Date.Date -and $_.LastWriteTime -lt $Date.Date.AddDays(1)
            }

                Write-Host "`nItems that were created or modified on $Date" -ForegroundColor Cyan
                $items
                if ($items.Exists) {
                [bool]$Searched = $true
                } else {
                [bool]$Searched = $false
                }
        } else {
        Write-Host "The specified path does not exist." -ForegroundColor Red
       }
    }
  }
}

    END {
        if ($ShowInfo) {
            Write-Host "`n---------- Action Summary ----------" -BackgroundColor Red

        switch ($Action) {
            'Delete' {
                Write-Host "Action: Deletion" -ForegroundColor Yellow
                if ($Deletion) {
                    Write-Host "Status: Successfully deleted the item." -ForegroundColor Green
                    Write-Host "Path: $DeletedPath" -Foreground Blue
                } else {
                    Write-Host "Status: Deletion unsuccessful." -ForegroundColor Red
                    Write-Host "Path: -" -ForegroundColor Blue
                }
            }
            'CreateFolder' {
                Write-Host "Action: Folder Creation" -ForegroundColor Yellow
                if ($CreationFolder) {
                    Write-Host "Status: Folder created successfully." -ForegroundColor Green
                    Write-Host "Folder Name: $Name" -ForegroundColor Blue
                    Write-Host "Location: $Path" -ForegroundColor Blue
                    $item = Get-Item -Path $Path
                    Write-Host "Creation-date: $($item.CreationTime)" -ForegroundColor Blue
                } else {
                    Write-Host "Status: Folder creation unsuccessful." -ForegroundColor Red
                    Write-Host "Location: $Path" -ForegroundColor Blue
                }
            }
            'CreateFile' {
                Write-Host "Action: File Creation" -ForegroundColor Yellow
                if ($CreationFile) {
                    Write-Host "Status: File created successfully." -ForegroundColor Green
                    Write-Host "File Name: $Name" -ForegroundColor Blue
                    Write-Host "Location: $Path" -ForegroundColor Blue
                    $item = Get-Item -Path $Path
                    Write-Host "Creation-date: $($item.CreationTime)" -ForegroundColor Blue
                } else {
                    Write-Host "Status: File creation unsuccessful." -ForegroundColor Red
                    Write-Host "Location: $Path" -ForegroundColor Blue
                }
            }
            'Rename' {
                Write-Host "Action: Rename" -ForegroundColor Yellow
                if ($Renamed) {
                    Write-Host "Status: Renamed item successfully." -ForegroundColor Green
                    Write-Host "New Name: $NewName" -ForegroundColor Blue
                    Write-Host "Original Path: $Path" -ForegroundColor Blue
                } else {
                    Write-Host "Status: Renamed item unsuccessful." -ForegroundColor Red
                    Write-Host "Original Path: $Path" -ForegroundColor Blue
                }
            }
            'Move' {
                Write-Host "Action: Move" -ForegroundColor Yellow
                if ($Moved) {
                    Write-Host "Status: Moved item successfully." -ForegroundColor Green
                    Write-Host "Name: $(Split-Path -Path $Path -Leaf)" -ForegroundColor Blue
                    if ($Type) {
                        Write-Host "Type: Folder" -ForegroundColor Blue
                    } else {
                        Write-Host "Type: File" -ForegroundColor Blue
                    }
                    Write-Host "To: $Destination" -ForegroundColor Blue
                } else {
                    Write-Host "Status: Moved item unsuccessful." -ForegroundColor Red
                    Write-Host "Destination: $Destination" -ForegroundColor Blue
                }
            }
            'Copy' {
                Write-Host "Action: Copy" -ForegroundColor Yellow
                if ($Copied) {
                    Write-Host "Status: Copied item successfully." -ForegroundColor Green
                    Write-Host "Name: $(Split-Path -Path $Path -Leaf)" -ForegroundColor Blue
                    if ($Type) {
                        Write-Host "Type: Folder" -ForegroundColor Blue
                    } else {
                        Write-Host "Type: File" -ForegroundColor Blue
                    }
                    Write-Host "To: $Destination" -ForegroundColor Blue
                } else {
                    Write-Host "Status: Copied item unsuccessful." -ForegroundColor Red
                    Write-Host "Destination: $Destination" -ForegroundColor Blue
                }
            }
            'Search' {
                Write-Host "Action: Search" -ForegroundColor Yellow
                if ($Searched) {
                    Write-Host "Status: Searched items successfully." -ForegroundColor Green
                } else {
                    Write-Host "Status: Searched item unsuccessful." -ForegroundColor Red
                }
            }
        }

        Write-Host "Note: The action '$Action' was processed as requested." -ForegroundColor White -BackgroundColor DarkGray
    }
  }
}