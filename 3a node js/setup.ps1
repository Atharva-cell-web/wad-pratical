Write-Host "Cleaning up old project if it exists..."
if (Test-Path "static-website") {
    Remove-Item "static-website" -Recurse -Force
}

Write-Host "Creating static-website folder..."
New-Item -ItemType Directory -Force -Path "static-website" | Out-Null
Set-Location "static-website"

Write-Host "Creating public directory..."
New-Item -ItemType Directory -Force -Path "public" | Out-Null

Write-Host "Creating app.js..."
$appJsContent = @'
const express = require("express");
const path = require("path");

const app = express();
const PORT = 3000;

// Serve static files from "public" folder
app.use(express.static(path.join(__dirname, "public")));

// Start server
app.listen(PORT, () => {
    console.log(`Server running at http://localhost:${PORT}`);
});
'@
Set-Content -Path "app.js" -Value $appJsContent -Encoding UTF8

Write-Host "Creating package.json..."
$packageJsonContent = @'
{
  "name": "static-website",
  "version": "1.0.0",
  "main": "app.js",
  "scripts": {
    "start": "node app.js"
  },
  "dependencies": {
    "express": "^4.18.2"
  }
}
'@
Set-Content -Path "package.json" -Value $packageJsonContent -Encoding UTF8

Write-Host "Creating public/index.html..."
$indexHtmlContent = @'
<!DOCTYPE html>
<html>
<head>
    <title>My Static Website</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>

    <h1>Welcome to My Website</h1>
    <p>This is a static website using Node.js and Express.</p>

</body>
</html>
'@
Set-Content -Path "public/index.html" -Value $indexHtmlContent -Encoding UTF8

Write-Host "Creating public/style.css..."
$styleCssContent = @'
body {
    font-family: Arial;
    background-color: lightblue;
    text-align: center;
    margin-top: 100px;
}

h1 {
    color: darkblue;
}
'@
Set-Content -Path "public/style.css" -Value $styleCssContent -Encoding UTF8

Write-Host "Installing NPM dependencies (Express)..."
npm install

Write-Host "All files created and dependencies installed successfully!"
Write-Host "Starting the Node.js server. Opening browser at http://localhost:3000..."

# Automatically open the browser
Start-Process "http://localhost:3000"

# Start the server
npm start
