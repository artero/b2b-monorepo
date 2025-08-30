import {
  HttpClient,
  HttpClientModule,
  HTTP_INTERCEPTORS,
  HttpBackend,
} from '@angular/common/http';
import { NgModule, LOCALE_ID } from '@angular/core';
import { ReactiveFormsModule, FormsModule } from '@angular/forms';
import { BrowserModule } from '@angular/platform-browser';
import { BrowserAnimationsModule } from '@angular/platform-browser/animations';

import { TranslateLoader, TranslateModule } from '@ngx-translate/core';
import { TranslateHttpLoader } from '@ngx-translate/http-loader';

import { AppRoutingModule } from './app-routing.module';
import { AppComponent } from './app.component';

// helpers
import { ApiUrlInterceptor } from './helpers/api-url.interceptor';
import { AuthInterceptor } from './helpers/auth.interceptor';
import { ErrorInterceptor } from './helpers/error.interceptor';

// pages
import { AuthPageComponent } from './pages/auth-page/auth-page.component';
import { DonePageComponent } from './pages/done-page/done-page.component';
import { LoginPageComponent } from './pages/login-page/login-page.component';
import { NewPasswordPageComponent } from './pages/new-password-page/new-password-page.component';
import { ProductsPageComponent } from './pages/products-page/products-page.component';

const PAGES = [
  AuthPageComponent,
  DonePageComponent,
  LoginPageComponent,
  NewPasswordPageComponent,
  ProductsPageComponent,
];

// components
import { LoadingComponent } from './components/loading/loading.component';
import { OrderTableComponent } from './components/order-table/order-table.component';
import { ProductsTableComponent } from './components/products-table/products-table.component';

// directives
import { TooltipEllipsisDirective } from './directives/tooltip-ellipsis.directive';

// pipes
import { ClickStopPropagationDirective } from './pipes/click-stop-propagation.directive';
import { ClickStopPropagationParentDirective } from './pipes/click-stop-propagation-parent.directive';
import { LocaleNumberPipe } from './pipes/locale-number.pipe';

import { registerLocaleData, DecimalPipe } from '@angular/common';
// Locale
// tslint:disable-next-line: match-default-export-name
import es from '@angular/common/locales/es';
import { MyDateAdapter } from './helpers/my-date-adapter';

import { CookieService } from 'ngx-cookie-service';

registerLocaleData(es);

const PUBLIC_COMPONENTS = [
  LoadingComponent,
  OrderTableComponent,
  ProductsTableComponent,
];

const PUBLIC_PIPES = [
  ClickStopPropagationDirective,
  ClickStopPropagationParentDirective,
  LocaleNumberPipe,
];

const PUBLIC_DIRECTIVES = [TooltipEllipsisDirective];

const PUBLIC_ELEMENTS = [
  ...PUBLIC_COMPONENTS,
  ...PUBLIC_PIPES,
  ...PUBLIC_DIRECTIVES,
];

// material
import { MatButtonModule } from '@angular/material/button';
import { MatCardModule } from '@angular/material/card';
import { MatCheckboxModule } from '@angular/material/checkbox';
import { MatNativeDateModule, DateAdapter } from '@angular/material/core';
import { MatDatepickerModule } from '@angular/material/datepicker';
import { MatIconModule } from '@angular/material/icon';
import { MatInputModule } from '@angular/material/input';
import { MatProgressSpinnerModule } from '@angular/material/progress-spinner';
import { MatSidenavModule } from '@angular/material/sidenav';
import { MatSliderModule } from '@angular/material/slider';
import { MatStepperModule } from '@angular/material/stepper';
import { MatTableModule } from '@angular/material/table';
import { MatTooltipModule } from '@angular/material/tooltip';

const MATERIAL = [
  MatButtonModule,
  MatCardModule,
  MatCheckboxModule,
  MatDatepickerModule,
  MatIconModule,
  MatInputModule,
  MatNativeDateModule,
  MatProgressSpinnerModule,
  MatSidenavModule,
  MatSliderModule,
  MatStepperModule,
  MatTableModule,
  MatTooltipModule,
];

const MODULES_TO_EXPORT = [
  // Modules
  FormsModule,
  ReactiveFormsModule,
  BrowserModule,
  AppRoutingModule,
  BrowserAnimationsModule,
  HttpClientModule,
  // TranslateModule,

  // Material
  ...MATERIAL,

  // 3rd party libraries
];

@NgModule({
  declarations: [AppComponent, ...PAGES, ...PUBLIC_ELEMENTS],
  imports: [
    ...MODULES_TO_EXPORT,
    TranslateModule.forRoot({
      loader: {
        provide: TranslateLoader,
        useFactory: HttpLoaderFactory,
        deps: [HttpBackend],
      },
    }),
  ],
  exports: [...MODULES_TO_EXPORT, ...PUBLIC_ELEMENTS],
  providers: [
    CookieService,
    DecimalPipe,
    LocaleNumberPipe,
    { provide: DateAdapter, useClass: MyDateAdapter },
    { provide: HTTP_INTERCEPTORS, useClass: ApiUrlInterceptor, multi: true },
    { provide: HTTP_INTERCEPTORS, useClass: AuthInterceptor, multi: true },
    { provide: HTTP_INTERCEPTORS, useClass: ErrorInterceptor, multi: true },
    { provide: LOCALE_ID, useValue: 'es-ES' },
  ],
  bootstrap: [AppComponent],
})
export class AppModule {}

export function HttpLoaderFactory(handler: HttpBackend) {
  const http = new HttpClient(handler);

  return new TranslateHttpLoader(http, './assets/i18n/', '.json');
}
