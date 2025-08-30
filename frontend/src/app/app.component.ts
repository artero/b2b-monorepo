import { Component } from '@angular/core';
import { Router, NavigationEnd } from '@angular/router';
import { TranslateService } from '@ngx-translate/core';
import { CookieService } from 'ngx-cookie-service';

declare let gtag: Function;

import { routesAnimations } from '@animations/routes.animation';

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  animations: [routesAnimations]
})
export class AppComponent {
  constructor(
    public router: Router,
    public translateService: TranslateService,
    private cookieService: CookieService
  ) {
    this.router.events.subscribe(event => {
      if (event instanceof NavigationEnd) {
        gtag('config', 'UA-35798891-18', {
          page_path: event.urlAfterRedirects
        });
      }
    });

    this.setLanguage();
  }

  getBrowserLang() {
    return this.translateService.getBrowserLang() === 'es' ? 'es' : 'en';
  }

  setLanguage() {
    const lang = this.cookieService.get('languages')
      ? this.cookieService.get('languages')
      : this.getBrowserLang();

    this.translateService.addLangs(['en', 'es']);
    this.translateService.setDefaultLang('es');
    this.translateService.use(lang);
  }

  translateSite(language: string) {
    this.translateService.use(language);
  }

  public pdfOrderTable() {}
}
