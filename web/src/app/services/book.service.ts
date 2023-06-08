import {Injectable} from '@angular/core';
import {Observable} from "rxjs";
import {environment} from "../../enviroments/enviroment";
import {HttpClient, HttpHeaders} from "@angular/common/http";
import {BookPage, BookResponse} from "../interfaces/book-response";
import {UpdateBook} from "../interfaces/update-book";

@Injectable({
  providedIn: 'root'
})
export class BookService {

  constructor(private http: HttpClient) {
  }

  getAllBooks(page: number): Observable<BookPage> {
    return this.http.get<BookPage>(`${environment.apiBaseUrl}/book?page=${page}`, {
      headers: new HttpHeaders()
        .set('Authorization', 'Bearer ')
    });
  }

  getImage(imageName: String): Observable<ArrayBuffer> {
    console.log(`${environment.apiBaseUrl}/book/download/${imageName}`);
    return this.http.get<ArrayBuffer>(`${environment.apiBaseUrl}/book/download/${imageName}`, {
      headers: new HttpHeaders()
        .set('Authorization', 'Bearer ')
        .set('Accept', 'image/jpeg'),
    });
  }

  getImage2(imageName: String): any {
    fetch(`${environment.apiBaseUrl}/book/download/${imageName}`, {
      headers: {
        Authorization: 'Bearer '
      }
    });
  }

  deleteBook(id: String) {
    return this.http.delete(`${environment.apiBaseUrl}/book/${id}`, {
      observe: 'response',
      headers: new HttpHeaders()
        .set('Authorization', 'Bearer ')
    });
  }

  editBook(id: String, book: UpdateBook): Observable<BookResponse> {
    return this.http.put<BookResponse>(`${environment.apiBaseUrl}/book/edit/${id}`, book, {
      headers: new HttpHeaders()
        .set('Authorization', 'Bearer ')
    });
  }
}
