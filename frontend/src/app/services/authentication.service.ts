import { HttpClient, HttpResponse } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Router } from '@angular/router';
import { CookieService } from 'ngx-cookie-service';

import { Observable } from 'rxjs';
import { tap, map } from 'rxjs/operators';

import { Token } from '@models/user.model';
import { environment } from 'src/environments/environment';

const TOKEN_NAME = 'nvs_token';
const ACCESS_TOKEN_NAME = 'access_token';
const CLIENT_TOKEN_NAME = 'client_token';
const UID_TOKEN_NAME = 'uid_token';

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

  login(email: string, password: string): Observable<boolean> {
    this.email = email;

    return this.http
      .post('auth/sign_in', {
        email,
        password,
      }, { observe: 'response' })
      .pipe(
        tap((response: HttpResponse<any>) => this.setTokenFromDeviseTokenAuth(response)),
        map((response: HttpResponse<any>) => !!response.body?.data)
      );
  }

  logout(): void {
    // Clear DeviseTokenAuth tokens
    this.cookieService.delete(ACCESS_TOKEN_NAME, '/');
    this.cookieService.delete(CLIENT_TOKEN_NAME, '/');
    this.cookieService.delete(UID_TOKEN_NAME, '/');
    // Clear legacy token
    this.cookieService.set(TOKEN_NAME, '', -1, '/', environment.domain);
    this.cookieService.deleteAll();
    localStorage.removeItem('session');
    localStorage.removeItem('user');
    localStorage.clear();
    this.router.navigate(['/login']);
  }

  newPassword(token: string, password: string): Observable<boolean> {
    return this.http
      .post('auth/password', { 
        password,
        password_confirmation: password,
        reset_password_token: token 
      })
      .pipe(map((response: any) => !!response.data));
  }

  isLoggedIn(): boolean {
    return this.hasDeviseTokenAuthTokens() && !!localStorage.getItem('user');
  }

  getToken(): string {
    return this.cookieService.get(TOKEN_NAME);
  }

  getAccessToken(): string {
    return this.cookieService.get(ACCESS_TOKEN_NAME);
  }

  getClientToken(): string {
    return this.cookieService.get(CLIENT_TOKEN_NAME);
  }

  getUidToken(): string {
    return this.cookieService.get(UID_TOKEN_NAME);
  }

  hasDeviseTokenAuthTokens(): boolean {
    return !!(this.getAccessToken() && this.getClientToken() && this.getUidToken());
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

  private setTokenFromDeviseTokenAuth(response: HttpResponse<any>): void {
    // DeviseTokenAuth returns tokens in headers
    const accessToken = response.headers.get('access-token');
    const clientToken = response.headers.get('client');
    const uidToken = response.headers.get('uid');
    
    if (accessToken && clientToken && uidToken && response.body?.data) {
      // Store DeviseTokenAuth tokens
      this.cookieService.set(ACCESS_TOKEN_NAME, accessToken, 365, '/', environment.domain);
      this.cookieService.set(CLIENT_TOKEN_NAME, clientToken, 365, '/', environment.domain);
      this.cookieService.set(UID_TOKEN_NAME, uidToken, 365, '/', environment.domain);
      
      // Store user data
      localStorage.setItem('user', JSON.stringify(response.body.data));
      
      // Keep legacy token for backwards compatibility if needed
      this.cookieService.set(TOKEN_NAME, accessToken, 365, '/', environment.domain);
    }
  }
}
