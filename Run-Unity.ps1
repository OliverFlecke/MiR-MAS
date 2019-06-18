param(
    # The file to launch the simulator with
    [Parameter(Mandatory=$true)]
    [String]
    $Map,
    [switch]
    $CanUseSameSpace,
    [Switch]
    $Batchmode
)

./MiR-simulator/Stop-Unity.ps1

$Args = if ($CanUseSameSpace) {"-CanUseSameSpace"} else {""}

if ($Batchmode)
{
    ./MiR-Simulator/build/MiR-Simulator map ./MAS.Shared/maps/$Map -batchmode $Args
}
else
{
    ./MiR-Simulator/build/MiR-Simulator map ./MAS.Shared/maps/$Map $Args
}
