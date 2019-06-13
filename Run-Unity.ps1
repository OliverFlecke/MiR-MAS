param(
    # The file to launch the simulator with
    [Parameter(Mandatory=$true)]
    [String]
    $Map,
    [Switch]
    $Batchmode
)

./MiR-simulator/Stop-Unity.ps1

if ($Batchmode)
{
    ./MiR-Simulator/build/MiR-Simulator map ./MAS.Shared/maps/$Map -batchmode
}
else
{
    ./MiR-Simulator/build/MiR-Simulator map ./MAS.Shared/maps/$Map
}
