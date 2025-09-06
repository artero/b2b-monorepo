import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Router } from '@angular/router';
import { CookieService } from 'ngx-cookie-service';

import { Observable } from 'rxjs';
import { tap, map } from 'rxjs/operators';

import { Token } from '@models/user.model';
import { environment } from 'src/environments/environment';

const TOKEN_NAME = 'nvs_token';

@Injectable({
  providedIn: 'root',
})
export class AuthService {
  email: string;

  constructor(
    private cookieService: CookieService,
    private http: HttpClient,
    private router: Router
  ) {}

  login(User: string, Password: string): Observable<boolean> {
    this.email = User;

    return this.http
      .post('login', {
        User,
        Password,
      })
      .pipe(
        tap((response: Token) => this.setToken(response)),
        map((response: Token) => !!response)
      );
  }

  logout(): void {
    this.cookieService.set(TOKEN_NAME, '', -1, '/', environment.domain);
    this.cookieService.deleteAll();
    localStorage.removeItem('session');
    localStorage.clear();
    this.router.navigate(['/login']);
  }

  newPassword(token: string, NewPassword: string): Observable<boolean> {
    return this.http
      .post('resetpassword', { token, NewPassword })
      .pipe(map((response: boolean) => !!response));
  }

  isLoggedIn(): boolean {
    return !!this.getToken() && !!localStorage.getItem('user'); // need email user
  }

  getToken(): string {
    return this.cookieService.get(TOKEN_NAME);
  }

  private setToken(response: Token): void {
    this.cookieService.set(
      TOKEN_NAME,
      response.Token,
      365,
      '/',
      environment.domain
    );
  }
}
