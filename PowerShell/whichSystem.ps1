#!/c/Windows/System32/WindowsPowerShell/v1.0/powershell.exe -File
$_args = $args
$src = $MyInvocation.MyCommand.Name


function helpPanel(){
    Write-Host "`n[+] Modo de uso: $src 127.0.0.1`n" -ForegroundColor DarkGreen

    exit 
}

if ($_args.Length -eq 0) {
    helpPanel
}
function send_icmp([String]$adress){

    $Ping = New-Object System.Net.NetworkInformation.Ping

    try { 

        $resp = $Ping.Send($adress)
        
        return $resp

    } catch [System.Net.NetworkInformation.PingException] {

        write-Host "`n[-] Error ocurrido: $_`n" -ForegroundColor Red
        exit 1

    } 
}

function GetOperatingSystem([int]$ttl){
    if ( $ttl -ge 1 -and $ttl -le 64 ) {

        return "Linux"
        <# Action to perform if the condition is true #>
    } elseif ( $ttl -ge 65 -and $ttl -le 128 ) {

        return "Windows"
        <# Action when this condition is true #>
    } else {

        return "Unknown"

    }
}

function main(){

    $addr = $_args[0]
    $response = send_icmp $addr

    $os = GetOperatingSystem -ttl $response.Options.Ttl

    Write-Host "`n[+] $addr (ttl => $($response.Options.Ttl)): $($os)`n" -ForegroundColor DarkMagenta
}

main