import {Component, Inject} from '@angular/core';
import {MAT_SNACK_BAR_DATA, MatSnackBarRef} from "@angular/material/snack-bar";

@Component({
  selector: 'app-register-error',
  templateUrl: './register-error.component.html',
  styleUrls: ['./register-error.component.css']
})
export class RegisterErrorComponent {
  message: string[];

  constructor(
    public snackBarRef: MatSnackBarRef<RegisterErrorComponent>,
    @Inject(MAT_SNACK_BAR_DATA) public data: any
  ) {
    this.message = data.mensajes;

  }
}
