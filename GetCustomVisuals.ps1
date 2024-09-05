Login-PowerBI  -Environment Public 

$reportId = "055b703a-acc9-4ba2-b5a6-54cc4b25a24f"
$workspaceId = "fa70f8f7-096a-4bb8-adcd-16f5cf7a7379"
$exportFolder = "c:\temp"

Export-PowerBIReport -WorkspaceId $workspaceId -id $reportId -OutFile $exportFolder"\"$reportId".zip"
Expand-Archive $exportFolder"\"$reportId".zip" -DestinationPath $exportFolder"\"$reportId 

$customVisuals = get-childitem $exportFolder"\"$reportId"\Report\CustomVisuals"
$customVisuals.PSChildName

#remove-item $exportFolder"\"$reportId".zip" -Force
#remove-item $exportFolder"\"$reportId -Force -Recurse