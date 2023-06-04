import {NgModule} from '@angular/core';
import {RouterModule, Routes} from '@angular/router';
import {LoginComponent} from "./components/login/login.component";
import {BooksComponent} from "./components/books/books.component";
import {authenticationGuard} from "./authentication.guard";

const routes: Routes = [
  {path: '', component: LoginComponent},
  {path: 'books', component: BooksComponent, canActivate: [authenticationGuard]},
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule {
}
