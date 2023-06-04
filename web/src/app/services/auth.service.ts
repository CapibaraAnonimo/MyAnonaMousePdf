import {Injectable} from '@angular/core';
import {HttpClient} from "@angular/common/http";
import {Observable, tap} from "rxjs";
import {environment} from "../../enviroments/enviroment";
import {UserResponse} from "../interfaces/user-response";

@Injectable({
  providedIn: 'root'
})
export class AuthService {
  user?: UserResponse = undefined;

  constructor(private http: HttpClient) {
    this.user = JSON.parse(sessionStorage.getItem('user') || 'null');
  }

  login(username: string, password: string): Observable<UserResponse> {
    return this.http.post<UserResponse>(`${environment.apiBaseUrl}/auth/login/admin`, {
      username,
      password,
    }).pipe(tap(user => {
      this.user = user;
      sessionStorage.setItem('user', JSON.stringify(user));
    }));
  }

  logout() {
    this.user = undefined;
    sessionStorage.removeItem('user');
  }

  isAuthenticated() {
    return this.user !== null;
  }
}
