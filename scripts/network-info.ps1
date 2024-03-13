Clear-Host

# Get client network information
$networkInfo = @{
    IPAddress = (Get-NetIPAddress -AddressFamily IPv4).IPAddress
    DefaultGateway = (Get-NetRoute -DestinationPrefix 0.0.0.0/0).NextHop
    MACAddress = (Get-NetAdapter -Physical | Where-Object { $_.Status -eq "Up" }).MacAddress
    DNSServers = (Get-DnsClientServerAddress -AddressFamily IPv4).ServerAddresses
    DnsSuffixSearchList = (Get-DnsClientGlobalSetting).SuffixSearchList
}

# Perform ARP scan to discover other clients on the network
$arpScan = arp -a

# Get network interface information
$interfaces = Get-NetAdapter | Select-Object Name, Status, LinkSpeed, InterfaceType

# Display client network information
Write-Host "Client Network Information"
Write-Host "---------------------------"
Write-Host "IP Address:                 $($networkInfo.IPAddress)"
Write-Host "Default Gateway:            $($networkInfo.DefaultGateway)"
Write-Host "MAC Address:                $($networkInfo.MACAddress)"
Write-Host "DNS Servers:                $($networkInfo.DNSServers -join ', ')"
Write-Host "DNS Suffix Search List:     $($networkInfo.DnsSuffixSearchList -join ', ')"
Write-Host ""

# Display other clients on the network
Write-Host "Other Clients on the Network"
Write-Host "---------------------------"
$arpScan | ForEach-Object {
    $ip = ($_ -split '\s+')[1]
    $mac = ($_ -split '\s+')[2]
    Write-Host "IP Address: $($ip), MAC Address: $($mac)"
}
Write-Host ""

# Display network interface information
Write-Host "Network Interface Information"
Write-Host "-------------------------------"
$interfaces | Format-Table
