import { Component } from '@angular/core';
import { AuthService } from '@services/authentication.service';

@Component({
  selector: 'nvs-done-page',
  templateUrl: './done-page.component.html',
  host: {
    class: 'nvs-page nvs-auth-page'
  }
})
export class DonePageComponent {
  constructor(private authenticationService: AuthService) {}

  logout() {
    this.authenticationService.logout();
  }
}
