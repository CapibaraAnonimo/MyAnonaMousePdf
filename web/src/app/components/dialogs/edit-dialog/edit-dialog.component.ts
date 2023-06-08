import {Component, Inject} from '@angular/core';
import {MAT_DIALOG_DATA} from "@angular/material/dialog";
import {BookService} from "../../../services/book.service";
import {CategoryResponse} from "../../../interfaces/category-response";
import {CategoryService} from "../../../services/category-service.service";
import {UpdateBook} from "../../../interfaces/update-book";

@Component({
  selector: 'app-edit-dialog',
  templateUrl: './edit-dialog.component.html',
  styleUrls: ['./edit-dialog.component.css']
})
export class EditDialogComponent {
  title: String = '';
  author: String = '';
  description: String = '';
  category?: CategoryResponse = undefined;
  categoryId: String = '';
  vip: boolean = false;

  categories: CategoryResponse[] = [];
  disable = true;

  constructor(@Inject(MAT_DIALOG_DATA) public data: any, private bookService: BookService, private categoryService: CategoryService) {
    this.title = data.book.title;
    this.author = data.book.author;
    this.description = data.book.description;
    this.categoryId = data.book.category;
    this.vip = data.book.vip;

    categoryService.getAllCategories().subscribe(response => {
      this.categories = response;
    });
  }

  edit() {
    let book: UpdateBook = {
      author: this.author,
      vip: this.vip,
      title: this.title,
      category: this.category!.id,
      description: this.description,
    }
    this.bookService.editBook(this.data.book.id, book).subscribe(response => {
      console.log(response.category);
      location.reload();
    });
  }

  autoGrowTextZone(e: any) {
    e.target.style.height = "0px";
    e.target.style.height = (e.target.scrollHeight + 25) + "px";
  }

  setCategory(category: CategoryResponse) {
    this.category = category;
  }
}
