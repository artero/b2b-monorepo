// tslint:disable: no-unused
import { Injectable } from '@angular/core';
import { ActivatedRouteSnapshot, RouterStateSnapshot } from '@angular/router';
import { Observable } from 'rxjs';

import { LocalStorageService } from '@services/localstorage.service';
import { AuthService } from '../services/authentication.service';

@Injectable({ providedIn: 'root' })
export class AuthGuard  {
  constructor(
    public authService: AuthService,
    private localStorageService: LocalStorageService
  ) {}

  canActivate(
    next: ActivatedRouteSnapshot,
    state: RouterStateSnapshot
  ): Observable<boolean> | Promise<boolean> | boolean {
    this.localStorageService.saved();
    if (!this.authService.isLoggedIn()) {
      this.authService.logout();
    }

    return true;
  }
}
