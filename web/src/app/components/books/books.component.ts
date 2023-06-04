import { Component } from '@angular/core';

@Component({
  selector: 'app-books',
  templateUrl: './books.component.html',
  styleUrls: ['./books.component.css']
})
export class BooksComponent {
  books = [
    {
      title: 'Book 1',
      author: 'Author 1',
      imageUrl: 'path/to/book1.jpg'
    },
    {
      title: 'Book 2',
      author: 'Author 2',
      imageUrl: 'path/to/book2.jpg'
    },
    {
      title: 'Book 3',
      author: 'Author 3',
      imageUrl: 'path/to/book3.jpg'
    },
    // Add more books as needed
  ];
}
