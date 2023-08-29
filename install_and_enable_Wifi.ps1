# Check if the Wi-Fi feature is already installed
$wifiFeature = Get-WindowsFeature -Name Wireless-Networking

if ($wifiFeature.Installed -eq $false) {
    # Install the Wi-Fi feature
    Install-WindowsFeature -Name Wireless-Networking -IncludeManagementTools

    # Check if the installation was successful
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Wi-Fi feature installation failed."
        exit 1
    } else {
        Write-Host "Wi-Fi feature installed successfully."
    }
} else {
    Write-Host "Wi-Fi feature is already installed."
}

# Enable Wi-Fi adapter
$wifiAdapter = Get-NetAdapter | Where-Object { $_.InterfaceDescription -like "*Wireless*" }

if ($wifiAdapter) {
    if ($wifiAdapter.Status -eq "Up") {
        Write-Host "Wi-Fi adapter is already enabled."
    } else {
        Enable-NetAdapter -Name $wifiAdapter.Name
        Write-Host "Wi-Fi adapter enabled successfully."
    }

    # Configure Wi-Fi network parameters
    $ssid = "YourWiFiSSID"
    $password = "YourWiFiPassword"

    # Connect to the specified Wi-Fi network
    $wifiProfile = @{
        SSID = $ssid
        KeyMaterial = $password
    }

    Connect-WiFi -Name $ssid -Password $password

    if ($LASTEXITCODE -eq 0) {
        Write-Host "Connected to Wi-Fi network '$ssid' successfully."
    } else {
        Write-Host "Failed to connect to Wi-Fi network '$ssid'."
    }
} else {
    Write-Host "No Wi-Fi adapter found."
}
