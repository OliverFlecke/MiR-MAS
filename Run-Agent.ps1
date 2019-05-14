param(
    # The file to launch the simulator with
    [Parameter(Mandatory=$true)]
    [String]
    $Map
)

start powershell "dotnet ./MAS.Agents/bin/Debug/netcoreapp2.2/MAS.Agents.dll ./MAS.Shared/maps/$Map 0"
