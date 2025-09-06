// tslint:disable: no-any
import {
  HttpRequest,
  HttpHandler,
  HttpEvent,
  HttpInterceptor
} from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Observable, throwError } from 'rxjs';
import { catchError } from 'rxjs/operators';

import { AuthService } from '../services/authentication.service';

@Injectable()
export class ErrorInterceptor implements HttpInterceptor {
  constructor(private authenticationService: AuthService) {}

  intercept(
    request: HttpRequest<any>,
    next: HttpHandler
  ): Observable<HttpEvent<any>> {
    return next.handle(request).pipe(
      catchError((err: any) => {
        // tslint:disable-next-line: no-magic-numbers
        if (err.status === 401 || err.status === 0) {
          // auto logout if 401 response returned from api
          this.authenticationService.logout();
        }
        const error = err.error.message || err.status.text;

        return throwError(error);
      })
    );
  }
}
