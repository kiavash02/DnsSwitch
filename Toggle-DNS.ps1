$PreferredDNS = "78.157.42.100"   # Change to your desired DNS
$AlternativeDNS = "78.157.42.101"  # Change to your desired alternative DNS

# Get the active network adapter
$NetworkAdapter = Get-NetAdapter | Where-Object { $_.Status -eq "Up" } | Select-Object -ExpandProperty Name

# Check if a network adapter is found
if ($null -ne $NetworkAdapter) {
    # Get the current DNS settings
    $CurrentDNS = (Get-DnsClientServerAddress -InterfaceAlias $NetworkAdapter -AddressFamily IPv4).ServerAddresses
    $DNSSource = (Get-DnsClient -InterfaceAlias $NetworkAdapter).UseDhcp

    # For Debugging
    $DNSString = $CurrentDNS -join ","

    # Show current DNS settings
    Write-Host "Current DNS Settings: $DNSString"
    Write-Host "DNS Source (Use DHCP): $DNSSource"

    # If DNS matches the manually set custom DNS, reset it to automatic
    if ($CurrentDNS -contains $PreferredDNS) {
        Set-DnsClientServerAddress -InterfaceAlias $NetworkAdapter -ResetServerAddresses
        Write-Host "✅ DNS has been reset to automatic (Obtain DNS server automatically)."
    } else {
        # If DNS is automatic or different, apply custom DNS
        Set-DnsClientServerAddress -InterfaceAlias $NetworkAdapter -ServerAddresses ($PreferredDNS, $AlternativeDNS)
        Write-Host "✅ DNS has been set to:"
        Write-Host "   Preferred DNS: $PreferredDNS"
        Write-Host "   Alternative DNS: $AlternativeDNS"
    }
} else {
    Write-Host "No active network adapter found. Please check your internet connection."
}