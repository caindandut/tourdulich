# Script tu dong deploy WAR len XAMPP Tomcat
param(
    [string]$TomcatPath = "D:\Xampp\tomcat",
    [string]$ProjectPath = $PSScriptRoot,
    [string]$WarName = "tour-booking.war"
)

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  TOUR BOOKING - AUTO DEPLOY TO XAMPP" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Buoc 1: Build WAR file
Write-Host "[1/4] Building WAR file..." -ForegroundColor Yellow
Set-Location $ProjectPath
& mvn clean package -DskipTests

if ($LASTEXITCODE -ne 0) {
    Write-Host "Build FAILED!" -ForegroundColor Red
    exit 1
}

$warPath = Join-Path $ProjectPath "target\$WarName"
if (-not (Test-Path $warPath)) {
    Write-Host "WAR file not found: $warPath" -ForegroundColor Red
    exit 1
}

Write-Host "Build successful: $warPath" -ForegroundColor Green
Write-Host ""

# Buoc 2: Stop Tomcat
Write-Host "[2/4] Stopping Tomcat..." -ForegroundColor Yellow
$tomcatService = Get-Service -Name "Tomcat*" -ErrorAction SilentlyContinue
if ($tomcatService) {
    Stop-Service -Name $tomcatService.Name -Force -ErrorAction SilentlyContinue
    Write-Host "Tomcat service stopped" -ForegroundColor Green
}
else {
    $javaProcesses = Get-Process -Name "java" -ErrorAction SilentlyContinue
    $tomcatProcess = $javaProcesses | Where-Object { $_.Path -like "*tomcat*" }
    if ($tomcatProcess) {
        Write-Host "Stopping Tomcat process..." -ForegroundColor Yellow
        Stop-Process -Id $tomcatProcess.Id -Force -ErrorAction SilentlyContinue
        Start-Sleep -Seconds 2
        Write-Host "Tomcat process stopped" -ForegroundColor Green
    }
    else {
        Write-Host "Tomcat is not running" -ForegroundColor Green
    }
}
Write-Host ""

# Buoc 3: Deploy WAR
Write-Host "[3/4] Deploying WAR to XAMPP Tomcat..." -ForegroundColor Yellow
$webappsPath = Join-Path $TomcatPath "webapps"
$deployPath = Join-Path $webappsPath $WarName
$explodedPath = Join-Path $webappsPath "tour-booking"

if (Test-Path $deployPath) {
    Remove-Item $deployPath -Force -ErrorAction SilentlyContinue
    Write-Host "  Removed old WAR" -ForegroundColor Gray
}

if (Test-Path $explodedPath) {
    Remove-Item $explodedPath -Recurse -Force -ErrorAction SilentlyContinue
    Write-Host "  Removed old exploded directory" -ForegroundColor Gray
}

$workPath = Join-Path $TomcatPath "work\Catalina\localhost\tour-booking"
$tempPath = Join-Path $TomcatPath "temp"

if (Test-Path $workPath) {
    Remove-Item $workPath -Recurse -Force -ErrorAction SilentlyContinue
    Write-Host "  Cleared work cache" -ForegroundColor Gray
}

if (Test-Path $tempPath) {
    Get-ChildItem $tempPath -Recurse | Remove-Item -Force -Recurse -ErrorAction SilentlyContinue
    Write-Host "  Cleared temp cache" -ForegroundColor Gray
}

Copy-Item $warPath $deployPath -Force
Write-Host "WAR deployed: $deployPath" -ForegroundColor Green
Write-Host ""

# Buoc 4: Start Tomcat
Write-Host "[4/4] Starting Tomcat..." -ForegroundColor Yellow
if ($tomcatService) {
    Start-Service -Name $tomcatService.Name -ErrorAction SilentlyContinue
    Write-Host "Tomcat service started" -ForegroundColor Green
}
else {
    Write-Host "Tomcat service not found. Please start manually from XAMPP Control Panel" -ForegroundColor Yellow
}
Write-Host ""

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  DEPLOYMENT COMPLETE!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Application URL: http://localhost:8080/tour-booking" -ForegroundColor Green
Write-Host ""
Write-Host "Note: Wait 10-15 seconds for Tomcat to fully start" -ForegroundColor Yellow
Write-Host ""
