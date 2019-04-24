param(
    # The file to launch the simulator with
    [Parameter(Mandatory=$true)]
    [String]
    $Map,
    [switch]
    $Unity,
    [switch]
    $Containers,
    [string]
    $Schedule,
    [switch]
    $NoAgents
)

function Count-Robots([string] $Map)
{
    $FileContent = Get-Content $Map
    $Matches = Select-String -InputObject $FileContent -Pattern "r" -AllMatches
    return $Matches.Matches.Count
}

Write-Host "Cleaning up old containers"
./Clean.ps1 -Unity=$Unity
Write-Host ""

if ($Unity) {
    MiR-Simulator/build/MiR-Simulator map ./MAS.Shared/maps/$Map
}

./Run-RabbitMQ.ps1

Write-Host "Starting mission controller and creator"
docker run -d --name mission_control --net="host" mission_control
docker run -d --name mission_creator --net="host" mission_creator "./maps/$Map" $Schedule

if ($NoAgents)
{
    Write-Host "Skipping agent creation"
}
else
{
    $Robots = Count-Robots("./MAS.Shared/maps/$Map")
    for ($i = 0; $i -lt $Robots; $i++) {
        Write-Host "Creating robot $i"
        if ($Containers)
        {
            docker run -d --name="agent$i" --net="host" agent $Map $i
        }
        else
        {
            start powershell "dotnet ./MAS.Agents/bin/Debug/netcoreapp2.2/MAS.Agents.dll ./MAS.Shared/maps/$Map $i"
        }
    }
}

