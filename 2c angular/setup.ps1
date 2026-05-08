Write-Host "Cleaning up old project if it exists..."
if (Test-Path "user-auth-app") {
    Remove-Item "user-auth-app" -Recurse -Force
}

Write-Host "Creating new Angular project: user-auth-app (skipping prompts)..."
# Use --defaults to bypass ALL prompts including SSR and AI features
ng new user-auth-app --defaults --skip-git
cd user-auth-app

Write-Host "Installing missing dependencies for legacy NgModule support..."
# Angular 19+ no longer installs platform-browser-dynamic by default!
npm install @angular/platform-browser-dynamic

Write-Host "Cleaning up default generated app files to prevent conflicts..."
if (Test-Path "src/app") {
    Remove-Item -Path "src/app/*" -Recurse -Force
}
if (Test-Path "src/main.ts") {
    Remove-Item -Path "src/main.ts" -Force
}

Write-Host "Creating component directories..."
New-Item -ItemType Directory -Force -Path "src/app/register" | Out-Null
New-Item -ItemType Directory -Force -Path "src/app/login" | Out-Null
New-Item -ItemType Directory -Force -Path "src/app/profile" | Out-Null

Write-Host "Creating src/main.ts (NgModule bootstrap)..."
$mainTsContent = @"
import { platformBrowserDynamic } from '@angular/platform-browser-dynamic';
import { AppModule } from './app/app.module';

platformBrowserDynamic().bootstrapModule(AppModule)
  .catch((err: any) => console.error(err));
"@
Set-Content -Path "src/main.ts" -Value $mainTsContent -Encoding UTF8

Write-Host "Creating app.module.ts..."
$appModuleContent = @"
import { NgModule } from '@angular/core';
import { BrowserModule } from '@angular/platform-browser';
import { FormsModule } from '@angular/forms';
import { RouterModule, Routes } from '@angular/router';

import { AppComponent } from './app.component';
import { RegisterComponent } from './register/register.component';
import { LoginComponent } from './login/login.component';
import { ProfileComponent } from './profile/profile.component';

const routes: Routes = [
  { path: '', component: RegisterComponent },
  { path: 'login', component: LoginComponent },
  { path: 'profile', component: ProfileComponent }
];

@NgModule({
  declarations: [
    AppComponent,
    RegisterComponent,
    LoginComponent,
    ProfileComponent
  ],
  imports: [
    BrowserModule,
    FormsModule,
    RouterModule.forRoot(routes)
  ],
  providers: [],
  bootstrap: [AppComponent]
})
export class AppModule { }
"@
Set-Content -Path "src/app/app.module.ts" -Value $appModuleContent -Encoding UTF8

Write-Host "Creating app.component.ts..."
$appComponentTsContent = @"
import { Component } from '@angular/core';

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  standalone: false
})
export class AppComponent {

}
"@
Set-Content -Path "src/app/app.component.ts" -Value $appComponentTsContent -Encoding UTF8

Write-Host "Creating app.component.html..."
$appComponentHtmlContent = @"
<h1>User Authentication App</h1>

<a routerLink="/">Register</a> |
<a routerLink="/login">Login</a> |
<a routerLink="/profile">Profile</a>

<hr>

<router-outlet></router-outlet>
"@
Set-Content -Path "src/app/app.component.html" -Value $appComponentHtmlContent -Encoding UTF8

Write-Host "Creating register.component.ts..."
$registerComponentTsContent = @"
import { Component } from '@angular/core';
import { Router } from '@angular/router';

@Component({
  selector: 'app-register',
  templateUrl: './register.component.html',
  standalone: false
})
export class RegisterComponent {

  user = {
    name: '',
    email: '',
    password: ''
  };

  constructor(private router: Router) {}

  registerUser() {

    localStorage.setItem('user', JSON.stringify(this.user));

    alert("Registration Successful");

    this.router.navigate(['/login']);
  }
}
"@
Set-Content -Path "src/app/register/register.component.ts" -Value $registerComponentTsContent -Encoding UTF8

Write-Host "Creating register.component.html..."
$registerComponentHtmlContent = @"
<h2>Register</h2>

<form>

  Name:
  <br>
  <input type="text" [(ngModel)]="user.name" name="name">

  <br><br>

  Email:
  <br>
  <input type="email" [(ngModel)]="user.email" name="email">

  <br><br>

  Password:
  <br>
  <input type="password" [(ngModel)]="user.password" name="password">

  <br><br>

  <button (click)="registerUser()">
    Register
  </button>

</form>
"@
Set-Content -Path "src/app/register/register.component.html" -Value $registerComponentHtmlContent -Encoding UTF8

Write-Host "Creating login.component.ts..."
$loginComponentTsContent = @"
import { Component } from '@angular/core';
import { Router } from '@angular/router';

@Component({
  selector: 'app-login',
  templateUrl: './login.component.html',
  standalone: false
})
export class LoginComponent {

  email = '';
  password = '';

  constructor(private router: Router) {}

  loginUser() {

    let data:any = localStorage.getItem('user');

    if(data) {

      let user = JSON.parse(data);

      if(this.email == user.email &&
         this.password == user.password) {

        alert("Login Successful");

        this.router.navigate(['/profile']);

      } else {

        alert("Invalid Credentials");
      }

    } else {

      alert("No User Registered");
    }
  }
}
"@
Set-Content -Path "src/app/login/login.component.ts" -Value $loginComponentTsContent -Encoding UTF8

Write-Host "Creating login.component.html..."
$loginComponentHtmlContent = @"
<h2>Login</h2>

<form>

  Email:
  <br>
  <input type="email" [(ngModel)]="email" name="email">

  <br><br>

  Password:
  <br>
  <input type="password" [(ngModel)]="password" name="password">

  <br><br>

  <button (click)="loginUser()">
    Login
  </button>

</form>
"@
Set-Content -Path "src/app/login/login.component.html" -Value $loginComponentHtmlContent -Encoding UTF8

Write-Host "Creating profile.component.ts..."
$profileComponentTsContent = @"
import { Component, OnInit } from '@angular/core';

@Component({
  selector: 'app-profile',
  templateUrl: './profile.component.html',
  standalone: false
})
export class ProfileComponent implements OnInit {

  user:any = {};

  ngOnInit() {

    let data:any = localStorage.getItem('user');

    if(data) {
      this.user = JSON.parse(data);
    }
  }
}
"@
Set-Content -Path "src/app/profile/profile.component.ts" -Value $profileComponentTsContent -Encoding UTF8

Write-Host "Creating profile.component.html..."
$profileComponentHtmlContent = @"
<h2>User Profile</h2>

<p>Name: {{user.name}}</p>

<p>Email: {{user.email}}</p>

<p>Password: {{user.password}}</p>
"@
Set-Content -Path "src/app/profile/profile.component.html" -Value $profileComponentHtmlContent -Encoding UTF8

Write-Host "Creating styles.css..."
$stylesCssContent = @"
body {
  font-family: Arial, Helvetica, sans-serif;
  background-color: #f0f8ff; /* AliceBlue */
  margin: 30px;
}

app-root {
  color: transparent; /* This magically hides the | pipes! */
  display: block;
  text-align: center;
}

h1 {
  color: darkblue;
  text-align: center;
}

/* Beautiful Navbar Links */
a {
  display: inline-block;
  margin: 0 10px;
  text-decoration: none;
  font-size: 16px;
  font-weight: bold;
  color: white;
  background-color: #3498db;
  padding: 12px 24px;
  border-radius: 30px;
  box-shadow: 0 4px 10px rgba(0,0,0,0.1);
  transition: all 0.3s ease;
}

a:hover {
  background-color: #2980b9;
  transform: translateY(-3px);
  box-shadow: 0 6px 15px rgba(0,0,0,0.2);
}

hr {
  border: none;
  border-top: 2px solid #ccc;
  margin: 30px 0;
}

app-register, app-login, app-profile {
  color: #333; /* Restore normal text color for the forms */
  display: flex;
  flex-direction: column;
  align-items: center;
}

h2 {
  color: #333;
}

form {
  background-color: white;
  padding: 20px;
  border: 2px solid #333;
  width: 300px;
  border-radius: 5px;
  text-align: left;
}

input {
  width: 250px;
  padding: 8px;
  margin-top: 5px;
}

button {
  padding: 10px 15px;
  background-color: darkblue;
  color: white;
  font-size: 16px;
  border: none;
  border-radius: 3px;
  cursor: pointer;
  margin-top: 10px;
}

button:hover {
  background-color: blue;
}

p {
  font-size: 18px;
  color: #222;
}
"@
Set-Content -Path "src/styles.css" -Value $stylesCssContent -Encoding UTF8

Write-Host "All files created successfully!"
Write-Host "Starting the Angular application..."
ng serve -o
