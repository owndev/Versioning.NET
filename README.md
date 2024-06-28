# Introducing
This project is for automatic versioning of .NET projects including WinUI, .NET MAUI, Blazor, Console, WPF and Xamarin Forms. All GitHooks scripts run PowerShell scripts that contain the necessary functions.

# Get Started
- Paste all files into the GitHook's folder (`\.git\hooks`).
- If you want versions to be visible in `README.md`, add the chapter ***Buildversion*** (In Markdown -> `# Buildversion`).

## For WinUI and Xamarin Forms:
- Add a `find.me` file to the project folder (this folder should contain a `.csproj` file).
  - For **Xamarin Forms**, add another `find.me.android` in the project folder of the Android project.

## And Now for Each Commit:
- The version number is included in the commit message.
- A `releasenotes.txt` is written (only if ***Buildversion*** is in `README.md`; otherwise, only the current commit is written). This file is written as a markdown table.
- If ***Buildversion*** is in `README.md`, then the commit is written as a markdown table under ***Buildversion***.

## Supported Projects
- **WinUI**
  - Add a `find.me` file to the project folder.
- **.NET MAUI**
- **Blazor**
  - Created for Blazer Web App with Server and Client
- **Console**
- **WPF**
- **Xamarin Forms**
  - Add a `find.me` file to the project folder.
  - Add a `find.me.android` file in the Android project folder.
