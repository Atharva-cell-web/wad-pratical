// Registration Form Logic

if(document.getElementById("registerForm")) {

    document.getElementById("registerForm")
    .addEventListener("submit", function(e){

        e.preventDefault();

        // Get values
        let name = document.getElementById("name").value;
        let email = document.getElementById("email").value;
        let mobile = document.getElementById("mobile").value;

        // Create object
        let user = {
            name: name,
            email: email,
            mobile: mobile
        };

        // Get existing users
        let users = JSON.parse(localStorage.getItem("users")) || [];

        // Add new user
        users.push(user);

        // Store in local storage
        localStorage.setItem("users", JSON.stringify(users));

        // AJAX POST Request
        let xhr = new XMLHttpRequest();

        xhr.open("POST",
        "https://jsonplaceholder.typicode.com/posts",
        true);

        xhr.setRequestHeader(
            "Content-Type",
            "application/json"
        );

        xhr.onload = function() {

            alert("Registration Successful");

            // Redirect to next page
            window.location.href = "display.html";
        };

        xhr.send(JSON.stringify(user));

    });
}


// Display Data Logic

if(document.getElementById("userData")) {

    let users =
    JSON.parse(localStorage.getItem("users")) || [];

    let tableData = "";

    users.forEach(function(user){

        tableData += `
            <tr>
                <td>${user.name}</td>
                <td>${user.email}</td>
                <td>${user.mobile}</td>
            </tr>
        `;

    });

    document.getElementById("userData").innerHTML =
    tableData;
}