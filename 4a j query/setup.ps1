Write-Host "Cleaning up old project if it exists..."
if (Test-Path "jquery-mobile-app") {
    Remove-Item "jquery-mobile-app" -Recurse -Force
}

Write-Host "Creating jquery-mobile-app folder..."
New-Item -ItemType Directory -Force -Path "jquery-mobile-app" | Out-Null
Set-Location "jquery-mobile-app"

Write-Host "Creating index.html..."
$indexHtmlContent = @'
<!DOCTYPE html>
<html>
<head>
    <title>jQuery Mobile Website</title>

    <!-- jQuery Mobile CSS -->
    <link rel="stylesheet"
    href="https://code.jquery.com/mobile/1.4.5/jquery.mobile-1.4.5.min.css">

    <!-- Custom CSS -->
    <link rel="stylesheet" href="style.css">

    <!-- jQuery -->
    <script src="https://code.jquery.com/jquery-1.11.1.min.js"></script>

    <!-- jQuery Mobile -->
    <script src="https://code.jquery.com/mobile/1.4.5/jquery.mobile-1.4.5.min.js"></script>

    <!-- Custom JS -->
    <script src="script.js"></script>
</head>

<body>

    <!-- Home Page -->
    <div data-role="page" id="home">

        <div data-role="header">
            <h1>My Website</h1>
        </div>

        <div data-role="content">
            <h2>Welcome</h2>

            <p>This is simple jQuery Mobile website.</p>

            <a href="#about" data-role="button">About</a>
            <a href="#contact" data-role="button">Contact</a>
        </div>

        <div data-role="footer">
            <h4>SPPU WAD Practical</h4>
        </div>

    </div>

    <!-- About Page -->
    <div data-role="page" id="about">

        <div data-role="header">
            <h1>About</h1>
        </div>

        <div data-role="content">

            <p>Website created using jQuery Mobile.</p>

            <ul data-role="listview">
                <li>Simple UI</li>
                <li>Mobile Friendly</li>
                <li>Easy Design</li>
            </ul>

            <a href="#home" data-role="button">Back</a>
        </div>

        <div data-role="footer">
            <h4>About Page</h4>
        </div>

    </div>

    <!-- Contact Page -->
    <div data-role="page" id="contact">

        <div data-role="header">
            <h1>Contact</h1>
        </div>

        <div data-role="content">

            <form>

                <label>Name:</label>
                <input type="text">

                <label>Email:</label>
                <input type="email">

                <label>Message:</label>
                <textarea></textarea>

                <input type="submit" value="Submit">

            </form>

            <a href="#home" data-role="button">Back</a>

        </div>

        <div data-role="footer">
            <h4>Contact Page</h4>
        </div>

    </div>

</body>
</html>
'@
Set-Content -Path "index.html" -Value $indexHtmlContent -Encoding UTF8

Write-Host "Creating style.css..."
$styleCssContent = @'
body {
    font-family: Arial;
}

h2 {
    text-align: center;
}

p {
    text-align: center;
}
'@
Set-Content -Path "style.css" -Value $styleCssContent -Encoding UTF8

Write-Host "Creating script.js..."
$scriptJsContent = @'
$(document).ready(function () {

    alert("Website Loaded Successfully");

});
'@
Set-Content -Path "script.js" -Value $scriptJsContent -Encoding UTF8

Write-Host "All files created successfully!"
Write-Host "Opening index.html in the default browser..."

# Automatically open the index.html file in the browser
Invoke-Item "index.html"
