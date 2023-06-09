import {Component} from '@angular/core';
import {UserService} from "../../../services/user.service";
import {UserResponse} from "../../../interfaces/user-response";
import {AuthService} from "../../../services/auth.service";
import {BookService} from "../../../services/book.service";
import {Router} from "@angular/router";
import {EventBusService} from "../../../services/event-bus.service";
import {Subscription} from "rxjs";

@Component({
  selector: 'app-users',
  templateUrl: './users.component.html',
  styleUrls: ['./users.component.css']
})
export class UsersComponent {
  users: UserResponse[] = [];

  checked: boolean[] = [];

  images: String[] = [];
  eventBusSub?: Subscription;

  constructor(private userService: UserService, private authService: AuthService, private bookService: BookService, private router: Router, private eventBusService: EventBusService) {
    this.userService.getAllUsers().subscribe(response => {
      console.log(response);
      this.users = response;

      this.users.forEach((value, index) => {
        this.checked.push(true);
      });

      for (let i = 0; i < this.users.length; i++) {
        this.fetchImage(this.users[i].avatar, i)
      }

      this.eventBusSub = this.eventBusService.on('logout', () => {
        this.authService.logout();
        this.router.navigate(['/']);
      });
    });
  }

  fetchImage(image: String, position: number) {
    this.bookService.getImage(image)
      .subscribe((response: ArrayBuffer) => {
        console.log('Responseeeeeeeeeeee: ' + response);
        const blob = new Blob([response], {type: 'image/jpeg'});
        const reader = new FileReader();
        reader.onloadend = () => {
          this.images[position] = reader.result as string;
        };
        reader.readAsDataURL(blob);
      });
  }

  changeState(i: number) {
    if (this.checked[i]) {
      this.userService.enableUser(this.users[i].id).subscribe(response => {

      });
    } else {
      this.userService.disableUser(this.users[i].id).subscribe(response => {
        if (response.id === this.authService.user!.id) {
          this.router.navigate(['/']);
        }
      });
    }
  }
}
