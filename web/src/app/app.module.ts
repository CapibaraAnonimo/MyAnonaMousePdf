import {NgModule} from '@angular/core';
import {BrowserModule} from '@angular/platform-browser';

import {AppRoutingModule} from './app-routing.module';
import {AppComponent} from './app.component';
import {BrowserAnimationsModule} from '@angular/platform-browser/animations';
import {MaterialImportsModule} from "./modules/material-imports.module";
import {HTTP_INTERCEPTORS, HttpClientModule} from "@angular/common/http";
import {FormsModule, ReactiveFormsModule} from "@angular/forms";
import {LoginComponent} from './components/login/login.component';
import {BooksComponent} from './components/books/books.component';
import {CorsInterceptor, HttpRequestInterceptor, TokenInterceptor} from "./services/auth.interceptor";

@NgModule({
  declarations: [
    AppComponent,
    LoginComponent,
    BooksComponent
  ],
  imports: [
    BrowserModule,
    AppRoutingModule,
    BrowserAnimationsModule,
    HttpClientModule,
    MaterialImportsModule,
    FormsModule,
    AppRoutingModule,
    ReactiveFormsModule
  ],
  providers: [
    { provide: HTTP_INTERCEPTORS, useClass: CorsInterceptor, multi: true },
    {provide: HTTP_INTERCEPTORS, useClass: TokenInterceptor, multi: true,},
    {provide: HTTP_INTERCEPTORS, useClass: HttpRequestInterceptor, multi: true},],
  bootstrap: [AppComponent]
})
export class AppModule {
}
