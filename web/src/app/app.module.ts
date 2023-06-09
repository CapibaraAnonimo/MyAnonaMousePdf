import {NgModule} from '@angular/core';
import {BrowserModule} from '@angular/platform-browser';

import {AppRoutingModule} from './app-routing.module';
import {AppComponent} from './app.component';
import {BrowserAnimationsModule} from '@angular/platform-browser/animations';
import {MaterialImportsModule} from "./modules/material-imports.module";
import {HTTP_INTERCEPTORS, HttpClientModule} from "@angular/common/http";
import {FormsModule, ReactiveFormsModule} from "@angular/forms";
import {LoginComponent} from './components/pages/login/login.component';
import {BooksComponent} from './components/pages/books/books.component';
import {CorsInterceptor, HttpRequestInterceptor, TokenInterceptor} from "./services/auth.interceptor";
import {AuthService} from "./services/auth.service";
import { DeleteDialogComponent } from './components/dialogs/delete-dialog/delete-dialog.component';
import { EditDialogComponent } from './components/dialogs/edit-dialog/edit-dialog.component';
import { UsersComponent } from './components/pages/users/users.component';
import { MainTollbarComponent } from './components/toolbars/main-tollbar/main-tollbar.component';
import {NgOptimizedImage} from "@angular/common";
import { RegisterComponent } from './components/pages/register/register.component';
import { RegisterErrorComponent } from './components/snackbar/register-error/register-error.component';

@NgModule({
  declarations: [
    AppComponent,
    LoginComponent,
    BooksComponent,
    DeleteDialogComponent,
    EditDialogComponent,
    UsersComponent,
    MainTollbarComponent,
    RegisterComponent,
    RegisterErrorComponent
  ],
  imports: [
    BrowserModule,
    AppRoutingModule,
    BrowserAnimationsModule,
    HttpClientModule,
    MaterialImportsModule,
    FormsModule,
    AppRoutingModule,
    ReactiveFormsModule,
    NgOptimizedImage
  ],
  providers: [
    AuthService,
    {provide: HTTP_INTERCEPTORS, useClass: CorsInterceptor, multi: true},
    {provide: HTTP_INTERCEPTORS, useClass: TokenInterceptor, multi: true,},
    {provide: HTTP_INTERCEPTORS, useClass: HttpRequestInterceptor, multi: true},],
  bootstrap: [AppComponent]
})
export class AppModule {
}
