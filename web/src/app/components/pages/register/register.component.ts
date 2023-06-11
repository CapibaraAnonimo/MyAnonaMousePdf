import {Component} from '@angular/core';
import {AuthService} from "../../../services/auth.service";
import {Router} from "@angular/router";
import {CreateUser} from "../../../interfaces/create-user";
import {HttpErrorResponse, HttpResponse} from "@angular/common/http";
import {MatSnackBar} from "@angular/material/snack-bar";
import {RegisterErrorComponent} from "../../snackbar/register-error/register-error.component";

@Component({
  selector: 'app-register',
  templateUrl: './register.component.html',
  styleUrls: ['./register.component.css']
})
export class RegisterComponent {
  username: String = '';
  password: String = '';
  verifyPassword: String = '';
  email: String = '';
  fullName: String = '';
  userControl: String = '';

  errorMessage: String = '';

  constructor(private authService: AuthService, private router: Router, private snackBar: MatSnackBar) {
  }

  register() {
    let user: CreateUser = {
      username: this.username,
      password: this.password,
      verifyPassword: this.verifyPassword,
      email: this.email,
      fullName: this.fullName
    }

    if (this.userControl === 'user') {
      this.authService.register(user).subscribe((response: HttpResponse<any>) => {
          this.snackBar.dismiss();
          this.router.navigate(['/users']);
          //this.analiceRegister(response);
        },
        (response: HttpErrorResponse) => {
          let mensajes = [];
          for (let e of response.error.subErrores) {
            mensajes.push(e.mensaje)
          }
          this.errorMessage = mensajes.toString();

          this.openSnackBar(mensajes);
        });
    } else if (this.userControl === 'admin') {
      this.authService.registerAdmin(user).subscribe((response: HttpResponse<any>) => {
          this.snackBar.dismiss();
          this.router.navigate(['/users']);
          //this.analiceRegister(response);
        },
        (response: HttpErrorResponse) => {
          let mensajes = [];
          for (let e of response.error.subErrores) {
            mensajes.push(e.mensaje)
          }
          this.errorMessage = mensajes.toString();

          this.openSnackBar(mensajes);
        });
    }
  }

  analiceRegister(response: HttpResponse<any> | HttpErrorResponse) {
    if (response.status != 201) {
      if (this.errorMessage === 'Errores varios en la validación') {

      }
    } else
      this.snackBar.dismiss();
    this.router.navigate(['/users']);
  }

  openSnackBar(mensajes: string[]) {
    this.snackBar.openFromComponent(RegisterErrorComponent, {
      //duration: 500 * 1000,
      data: {mensajes},
    });
  }
}
