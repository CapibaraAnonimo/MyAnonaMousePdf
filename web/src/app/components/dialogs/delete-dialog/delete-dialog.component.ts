import {Component, Inject} from '@angular/core';
import {MAT_DIALOG_DATA} from "@angular/material/dialog";
import {BookService} from "../../../services/book.service";

@Component({
  selector: 'app-delete-dialog',
  templateUrl: './delete-dialog.component.html',
  styleUrls: ['./delete-dialog.component.css']
})
export class DeleteDialogComponent {
  constructor(@Inject(MAT_DIALOG_DATA) public data: any, private bookService: BookService) {
  }

  delete() {
    this.bookService.deleteBook(this.data.bookId).subscribe(response => {
      console.log(response.status);
      location.reload();
    });
  }
}
