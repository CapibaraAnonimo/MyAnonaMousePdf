import {Component} from '@angular/core';
import {AuthService} from "../../services/auth.service";
import {Router} from "@angular/router";
import {EventBusService} from "../../services/event-bus.service";
import {Subscription} from "rxjs";
import {BookService} from "../../services/book.service";
import {BookPage, BookResponse} from "../../interfaces/book-response";

@Component({
  selector: 'app-books',
  templateUrl: './books.component.html',
  styleUrls: ['./books.component.css']
})
export class BooksComponent {
  bookPage!: BookPage;
  books: BookResponse[] = [];
  images: String[] = [];
  eventBusSub?: Subscription;

  constructor(private authService: AuthService, private bookService: BookService, private router: Router, private eventBusService: EventBusService,) {
    this.images.length = 10;
    this.bookService.getAllBooks(0).subscribe(response => {
      console.log(response);
      this.bookPage = response;
      this.books = [];
      this.books.push.apply(this.books, response.content);

      for (let i = 0; i < this.books.length; i++) {
        this.fetchImage(this.books[i].image, i)
      }

      this.eventBusSub = this.eventBusService.on('logout', () => {
        this.authService.logout();
        this.router.navigate(['/']);
      });
    });
  }

  ngOnInit(): void {

  }

  // fetchImage(image: String, position: number) {
  //   this.bookService.getImage(image).subscribe(response => {
  //     console.log("Blob: " + response.type);
  //     this.images[position] = URL.createObjectURL(response);
  //     console.log(this.images[position]);
  //   })
  // }

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

  fetchImage2(image: String, position: number) {
    this.bookService.getImage2(image)
      .then((response: any) => response.blob())
      .then((blob: Blob) => {
        this.images[position] = URL.createObjectURL(blob);
        /*const img = document.querySelector('img');
        img!.addEventListener('load', () => URL.revokeObjectURL(imageUrl));
        document.querySelector('img')!.src = imageUrl;*/
      });
  }

  editBook(book: any) {
    // Implement the logic to handle editing the book
    console.log('Editing book:', book);
  }

  deleteBook(book: any) {
    // Implement the logic to handle deleting the book
    console.log('Deleting book:', book);
  }

  counter() {
    return new Array(this.bookPage.totalPages);
  }

  changePage(page: number): void {
    this.bookService.getAllBooks(page).subscribe(response => {
      console.log(response);
      this.bookPage = response;
      this.books = [];
      this.books.push.apply(this.books, response.content);

      for (let i = 0; i < this.books.length; i++) {
        this.fetchImage(this.books[i].image, i)
      }

      this.eventBusSub = this.eventBusService.on('logout', () => {
        this.authService.logout();
        this.router.navigate(['/']);
      });
    });
  }

  protected readonly Array = Array;
}
