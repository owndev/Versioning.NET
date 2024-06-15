#Pfad
$projectFilePath = (Get-ChildItem -Path . -Include *.csproj -Recurse | Select-Object -ExpandProperty FullName) #Projektpfad herausfinden

#Edit .csproj
if (Test-Path $projectFilePath) 
{
    # Load the .csproj file
    [xml]$xml = Get-Content $projectFilePath

    # Extract the old versions
    $oldAssemblyVersion = $xml.Project.PropertyGroup.AssemblyVersion
    $oldFileVersion = $xml.Project.PropertyGroup.FileVersion

    # Increment the versions
    $newAssemblyVersion = $oldAssemblyVersion.Substring(0, $oldAssemblyVersion.LastIndexOf('.')) + "." + ([int]$oldAssemblyVersion.Substring($oldAssemblyVersion.LastIndexOf('.') + 1) + 1)
    $newFileVersion = $oldFileVersion.Substring(0, $oldFileVersion.LastIndexOf('.')) + "." + ([int]$oldFileVersion.Substring($oldFileVersion.LastIndexOf('.') + 1) + 1)

    # Update the versions in the .csproj file
    $xml.Project.PropertyGroup.AssemblyVersion = $newAssemblyVersion
    $xml.Project.PropertyGroup.FileVersion = $newFileVersion

    # Save the .csproj file
    $xml.Save($projectFilePath)
}

#In Git erneut hinzufügen
git add $projectFilePath

#Temp .commit erstellen
Out-File ".commit" -Force