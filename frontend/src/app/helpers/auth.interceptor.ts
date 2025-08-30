import {
  HttpEvent,
  HttpHandler,
  HttpInterceptor,
  HttpRequest,
  HttpHeaders,
} from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';

import { AuthService } from '../services/authentication.service';

@Injectable()
export class AuthInterceptor implements HttpInterceptor {
  constructor(private authenticationService: AuthService) {}

  intercept(
    request: HttpRequest<any>,
    next: HttpHandler
  ): Observable<HttpEvent<any>> {
    const reqModified = request.clone({ headers: this.setAuthHeader() });

    // add authorization header with jwt token if available
    if (request.url.includes('auth')) {
      return next.handle(request);
    }

    return next.handle(reqModified);
  }

  private setAuthHeader() {
    let headers = new HttpHeaders();
    const authToken = this.authenticationService.getToken();

    if (authToken) {
      headers = headers.append('authorization', 'Bearer ' + authToken);
    }

    return headers;
  }
}
