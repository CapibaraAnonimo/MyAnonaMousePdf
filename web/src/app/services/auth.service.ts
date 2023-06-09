import {Injectable, OnDestroy} from '@angular/core';
import {HttpClient, HttpHeaders} from "@angular/common/http";
import {Observable, tap} from "rxjs";
import {environment} from "../../enviroments/enviroment";
import {JwtUserResponse} from "../interfaces/jwt-user-response";
import {Tokens} from "../interfaces/tokens";
import {UserResponse} from "../interfaces/user-response";

@Injectable({
  providedIn: 'root'
})
export class AuthService implements OnDestroy {
  user?: JwtUserResponse = undefined;

  constructor(private http: HttpClient) {
    this.user = JSON.parse(sessionStorage.getItem('user') || 'null');
  }

  login(username: string, password: string): Observable<JwtUserResponse> {
    return this.http.post<JwtUserResponse>(`${environment.apiBaseUrl}/auth/login/admin`, {
      username,
      password,
    }).pipe(tap(user => {
      this.user = user;
      sessionStorage.setItem('user', JSON.stringify(user));
    }));
  }

  refreshToken(): Observable<Tokens> {
    this.user != undefined ? console.log('Previous User: ' + this.user.refreshToken) : null;
    return this.http.post<JwtUserResponse>(`${environment.apiBaseUrl}/refreshtoken`, {refreshToken: this.user!.refreshToken})
      .pipe(tap(tokens => {
        console.log('Old User: ' + this.user);
        if (this.user != undefined) {
          this.user.token = tokens.token;
          this.user.refreshToken = tokens.refreshToken;
          console.log('New User: ' + this.user);
          sessionStorage.setItem('user', JSON.stringify(this.user));
        }
      }));
  }

  logout() {
    this.user = undefined;
    sessionStorage.removeItem('user');
  }

  isAuthenticated() {
    return this.user !== null;
  }

  getToken(): String {
    return this.user != undefined ? this.user.token : '';
  }

  ngOnDestroy() {
    this.user = undefined;
    sessionStorage.removeItem('user');
  }
}
