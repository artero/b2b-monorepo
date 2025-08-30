import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';

import { tap, map } from 'rxjs/operators';

import { Cliente, CurrentUser } from '@models/user.model';
import { AuthService } from './authentication.service';
import { LocalStorageService } from './localstorage.service';

@Injectable({ providedIn: 'root' })
export class UserService {
  constructor(
    private http: HttpClient,
    private authService: AuthService,
    private localStorageService: LocalStorageService
  ) {}

  getUser() {
    return this.http.get('cliente').pipe(
      map((response: Cliente) => buildUser(response, this.authService.email)),
      tap((response: Cliente) =>
        this.localStorageService.setItem('user', response)
      )
    );
  }

  getCurrentUser(): CurrentUser {
    const value = localStorage.getItem('user');

    return value && JSON.parse(value);
  }
}

function buildUser(response: Cliente, email: string): CurrentUser {
  return {
    user: email,
    ...response
  };
}
