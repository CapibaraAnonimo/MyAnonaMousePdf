import {CanActivateFn} from '@angular/router';
import {AuthService} from "./services/auth.service";
import {inject} from "@angular/core";

export const authenticationGuard: CanActivateFn = (route, state) => {
  const authService: AuthService = inject(AuthService);
  console.log(authService.user);
  return authService.isAuthenticated();
};
