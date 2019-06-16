param(
    # The file to launch the simulator with
    [Parameter(Mandatory=$true)]
    [String]
    $Map,
    [switch]
    $Containers,
    [switch]
    $Centralized,
    [switch]
    $CanUseSameSpace,
    [String]
    [ValidateSet('3.0', '2.2')]
    $DotnetVersion = '3.0'
)

function Count-Robots([string] $Map)
{
    $FileContent = Get-Content $Map
    $Matches = Select-String -InputObject $FileContent -Pattern "r" -AllMatches
    return $Matches.Matches.Count
}

$Args = if ($CanUseSameSpace) {"-CanUseSameSpace"} else {""}

if ($Centralized)
{
    start powershell "dotnet ./MAS.CentralizedAgents/bin/Debug/netcoreapp$DotnetVersion/MAS.CentralizedAgents.dll ./MAS.Shared/maps/$Map $Args"
}
else
{
    $Robots = Count-Robots("./MAS.Shared/maps/$Map")
    for ($i = 0; $i -lt $Robots; $i++) {
        Write-Host "Creating robot $i"
        if ($Containers)
        {
            docker run -d --name="agent$i" --net="host" agent $Map $i $Args
        }
        else
        {
            start powershell "dotnet ./MAS.Agents/bin/Debug/netcoreapp$DotnetVersion/MAS.Agents.dll ./MAS.Shared/maps/$Map $i $Args"
        }
    }
}