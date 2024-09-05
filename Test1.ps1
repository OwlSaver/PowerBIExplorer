<#
Install these libraries first if you want to use below cmdlets
$PSVersionTable
Install-PackageProvider -Name NuGet -Force
Install-Module -Name MicrosoftPowerBIMgmt -Force
#>

#Log in to Power BI Service 2 options Login or connect
Login-PowerBI  -Environment Public 
#Connect-PowerBIServiceAccount -Credential (Get-Credential)

#First, Collect all (or one) of the workspaces in a parameter called PBIWorkspace
$PBIWorkspace = Get-PowerBIWorkspace    # Collect all workspaces you have access to
#$PBIWorkspace = Get-PowerBIWorkspace -Name 'workspace name'    #Use the -Name parameter to limit to one workspace

#Now collect todays date
$TodaysDate = Get-Date -Format "yyyyMMdd" 

#Almost finished: Build the outputpath. This Outputpath creates a news map, based on todays date
$OutPutPath = "C:\report\" + $TodaysDate 

#Now loop through the workspaces, hence the ForEach
ForEach($Workspace in $PBIWorkspace)
{
    #For all workspaces there is a new Folder destination: Outputpath + Workspacename
    $Folder = $OutPutPath + "\" + $Workspace.name 
    #If the folder doens't exists, it will be created.
    If(!(Test-Path $Folder))
    {
        New-Item -ItemType Directory -Force -Path $Folder
    }
    #At this point, there is a folder structure with a folder for all your workspaces 
    
    #Collect all (or one) of the reports from one or all workspaces 
    $PBIReports = Get-PowerBIReport -WorkspaceId $Workspace.Id   # Collect all reports from the workspace we selected.
    
       # (optional enable to use) Only Selecting particular reports for selective download
       #$SelectedReportList = $PBIReports.name | select-string -pattern ('some pattern') # '_UAT$', ending with _UAT reports only.

       #creating array variable to append all names and details together
       $Reports_list = @() 

       #foreach loop to append all details in a csv file
       ForEach($Report in $PBIReports.name)
     {
       $Reports_list += Get-PowerBIReport -WorkspaceId $Workspace.Id -Name $Report
     }
       $OutputFile = $OutPutPath + "\"+$Workspace.name +"\" + "Report_list.csv"
       $Reports_list | Export-csv $OutputFile
    
    #Collect all (or one) of the databases from one or all workspaces 
    $PBIDatabases = Get-PowerBIDataset -WorkspaceId $Workspace.Id   # Collect all reports from the workspace we selected.
    
       # (optional enable to use) Only Selecting particular reports for selective download
       #$SelectedReportList = $PBIDatabases.name | select-string -pattern ('some pattern') # '_UAT$', ending with _UAT reports only.

       #creating array variable to append all names and details together
       $Databases_list = @() 

       #foreach loop to append all details in a csv file
       ForEach($Database in $PBIDatabases.name)
     {
       $Databases_list += Get-PowerBIDataset -WorkspaceId $Workspace.Id -Name $Database
     }
       $DBOutputFile = $OutPutPath + "\"+$Workspace.name +"\" + "Database_list.csv"
       $Databases_list | Export-csv $DBOutputFile

}