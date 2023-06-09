import {Injectable} from '@angular/core';
import {HttpClient, HttpHeaders} from "@angular/common/http";
import {UserResponse} from "../interfaces/user-response";
import {Observable} from "rxjs";
import {environment} from "../../enviroments/enviroment";

@Injectable({
  providedIn: 'root'
})
export class UserService {

  constructor(private http: HttpClient) {
  }

  getAllUsers(): Observable<UserResponse[]> {
    return this.http.get<UserResponse[]>(`${environment.apiBaseUrl}/user`, {
      headers: new HttpHeaders()
        .set('Authorization', 'Bearer ')
    });
  }

  enableUser(id: String): Observable<UserResponse> {
    return this.http.put<UserResponse>(`${environment.apiBaseUrl}/admin/enable/${id}`, {
      headers: new HttpHeaders()
        .set('Authorization', 'Bearer ')
    });
  }

  disableUser(id: String): Observable<UserResponse> {
    return this.http.put<UserResponse>(`${environment.apiBaseUrl}/admin/disable/${id}`, {
      headers: new HttpHeaders()
        .set('Authorization', 'Bearer ')
    });
  }
}
