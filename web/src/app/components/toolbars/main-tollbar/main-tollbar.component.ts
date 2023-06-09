import {Component} from '@angular/core';
import {AuthService} from "../../../services/auth.service";

@Component({
  selector: 'app-main-tollbar',
  templateUrl: './main-tollbar.component.html',
  styleUrls: ['./main-tollbar.component.css']
})
export class MainTollbarComponent {
  constructor(private authService: AuthService) {
  }

  logout() {
    this.authService.logout()
  }
}
