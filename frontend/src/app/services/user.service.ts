import { Injectable } from '@angular/core';

import { AuthService } from './authentication.service';
import { LocalStorageService } from './localstorage.service';

@Injectable({ providedIn: 'root' })
export class UserService {
  constructor(
    private authService: AuthService,
    private localStorageService: LocalStorageService
  ) {}

  getUser() {
    // Los datos del usuario ya están en localStorage tras el login
    // No necesitamos hacer una llamada al servidor
    const userData = this.getCurrentUser();
    return new Promise(resolve => resolve(userData));
  }

  getCurrentUser(): any {
    const value = localStorage.getItem('user');
    return value ? JSON.parse(value) : null;
  }
}
