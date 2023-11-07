#.commit File wird erstellt um eine loop zuverhindern
if(Test-Path ".commit")
{
    Remove-Item ".commit" -Force
    git add . #Alle geänderten Files in git hinzufügen
    git commit --amend -C HEAD --no-verify #Letzter Commit bearbeiten ohne Hooks
}