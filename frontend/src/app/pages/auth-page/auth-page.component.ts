import { Component, OnInit } from '@angular/core';

import { enterLeaveFade } from '@animations/enterLeaveFade.animation';
import { navBarAnimation } from '@animations/navBar.animation';
import { AuthService } from '@services/authentication.service';
import { TranslateService } from '@ngx-translate/core';
import { CookieService } from 'ngx-cookie-service';

@Component({
  selector: 'nvs-auth-page',
  templateUrl: 'auth-page.component.html',
  animations: [navBarAnimation, enterLeaveFade()]
})
export class AuthPageComponent implements OnInit {
  opened: boolean;
  constructor(
    private authenticationService: AuthService,
    private translateService: TranslateService,
    private cookieService: CookieService
  ) {}

  ngOnInit() {}

  logout() {
    this.authenticationService.logout();
  }

  getCurrentLang() {
    return this.translateService.currentLang;
  }

  changeLang(language: string) {
    this.cookieService.set('languages', language, { expires: 365 });
    window.location.reload();
  }
}
