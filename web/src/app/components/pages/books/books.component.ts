import {Component} from '@angular/core';
import {AuthService} from "../../../services/auth.service";
import {Router} from "@angular/router";
import {Subscription} from "rxjs";
import {BookPage, BookResponse} from "../../../interfaces/book-response";
import {BookService} from "../../../services/book.service";
import {EventBusService} from "../../../services/event-bus.service";
import {MatDialog} from "@angular/material/dialog";
import {DeleteDialogComponent} from "../../dialogs/delete-dialog/delete-dialog.component";
import {EditDialogComponent} from "../../dialogs/edit-dialog/edit-dialog.component";

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

  constructor(private authService: AuthService, private bookService: BookService, private router: Router, private eventBusService: EventBusService, public dialog: MatDialog) {
    this.images.length = 10;
    this.getAllBooks(0);
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

  editBook(book: BookResponse) {
    const dialogRef = this.dialog.open(EditDialogComponent, {
        width: '50%',
        data: {
          /*title: book.title,
          vip: book.vip,
          author: book.author,
          description: book.description,
          id: book.id,*/
          book: book,
        }
      }
    );

    dialogRef.afterClosed().subscribe(result => {
      console.log(`Dialog result: ${result}`);
    });
  }

  deleteBook(book: BookResponse) {
    const dialogRef = this.dialog.open(DeleteDialogComponent, {
        width: '25%',
        data: {
          bookName: book.title,
          bookId: book.id,
        }
      }
    );

    dialogRef.afterClosed().subscribe(result => {
      console.log(`Dialog result: ${result}`);
    });
  }

  counter() {
    return new Array(this.bookPage.totalPages);
  }

  changePage(page: number): void {
    this.getAllBooks(page);
  }

  getAllBooks(page: number) {
    this.bookService.getAllBooks(page).subscribe((response: BookPage) => {
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
}
