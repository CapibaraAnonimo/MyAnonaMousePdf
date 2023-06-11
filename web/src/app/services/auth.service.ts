import {Injectable, OnDestroy} from '@angular/core';
import {HttpClient} from "@angular/common/http";
import {Observable, tap} from "rxjs";
import {environment} from "../../enviroments/enviroment";
import {JwtUserResponse} from "../interfaces/jwt-user-response";
import {Tokens} from "../interfaces/tokens";
import {Router} from "@angular/router";
import {CreateUser} from "../interfaces/create-user";

@Injectable({
  providedIn: 'root'
})
export class AuthService implements OnDestroy {
  user?: JwtUserResponse = undefined;

  constructor(private http: HttpClient, private router: Router) {
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

  register(newUser: CreateUser): Observable<any> {
    return this.http.post(`${environment.apiBaseUrl}/auth/register`, newUser,
      {observe: 'response'});
  }

  registerAdmin(newUser: CreateUser): Observable<any> {
    return this.http.post(`${environment.apiBaseUrl}/auth/register/admin`, newUser,
      {observe: 'response'});
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
    this.router.navigate(['/']);
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
