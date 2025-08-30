// tslint:disable: no-any
import {
  HttpRequest,
  HttpHandler,
  HttpEvent,
  HttpInterceptor
} from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';

import { environment } from '../../environments/environment';

@Injectable()
export class ApiUrlInterceptor implements HttpInterceptor {
  intercept(
    request: HttpRequest<any>,
    next: HttpHandler
  ): Observable<HttpEvent<any>> {
    const baseUrl = request.url.includes('https://') ? '' : environment.apiUrl;
    const apiRequest = request.clone({ url: `${baseUrl}${request.url}` });

    return next.handle(apiRequest);
  }
}
