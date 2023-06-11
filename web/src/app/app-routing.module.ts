import {NgModule} from '@angular/core';
import {RouterModule, Routes} from '@angular/router';
import {LoginComponent} from "./components/pages/login/login.component";
import {BooksComponent} from "./components/pages/books/books.component";
import {authenticationGuard} from "./authentication.guard";
import {UsersComponent} from "./components/pages/users/users.component";
import {RegisterComponent} from "./components/pages/register/register.component";

const routes: Routes = [
  {path: '', component: LoginComponent},
  {path: 'books', component: BooksComponent, canActivate: [authenticationGuard]},
  {path: 'users', component: UsersComponent, canActivate: [authenticationGuard]},
  {path: 'register', component: RegisterComponent, canActivate: [authenticationGuard]},
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule {
}
