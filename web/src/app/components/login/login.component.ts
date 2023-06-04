import {Component} from '@angular/core';
import {AuthService} from "../../services/auth.service";
import {Router} from "@angular/router";

@Component({
  selector: 'app-login',
  templateUrl: './login.component.html',
  styleUrls: ['./login.component.css']
})
export class LoginComponent {
  username: string = '';
  password: string = '';

  constructor(private authService: AuthService, private router: Router) {
  }

  login(): void {
    this.authService.login(this.username, this.password).subscribe(response => {
      console.log(response);
      this.authService.user = response;
      this.router.navigate(['/', 'books'], {state: {user: response}})//.then(() => window.location.reload());
    });
    // Implement your login logic here
    console.log('Username:', this.username);
    console.log('Password:', this.password);
  }
}
