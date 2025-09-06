import { Component, OnInit } from '@angular/core';
import { UntypedFormBuilder, UntypedFormGroup, Validators } from '@angular/forms';
import { Router, ActivatedRoute } from '@angular/router';

import { AuthService } from '@services/authentication.service';
import { UserService } from '@services/user.service';
import { TranslateService } from '@ngx-translate/core';

@Component({
  selector: 'nvs-login-page',
  templateUrl: 'login-page.component.html',
  host: {
    class: 'nvs-page nvs-login-page',
  },
})
export class LoginPageComponent implements OnInit {
  loginForm: UntypedFormGroup;
  returnUrl: string;
  isLoading = false;
  error = '';

  constructor(
    private formBuilder: UntypedFormBuilder,
    private route: ActivatedRoute,
    private router: Router,
    private authService: AuthService,
    private userService: UserService,
    private translateService: TranslateService
  ) {}

  ngOnInit() {
    this.loginForm = this.formBuilder.group({
      username: ['', Validators.required],
      password: ['', Validators.required],
    });

    // get return url from route parameters or default to '/'
    this.returnUrl = this.route.snapshot.queryParams.returnUrl || '/';
  }

  get isElectron() {
    const userAgent = navigator.userAgent.toLowerCase();

    return userAgent.indexOf(' electron/') > -1;
  }

  onSubmit() {
    if (this.loginForm.invalid) {
      return;
    }

    this.isLoading = true;

    this.authService
      .login(
        this.loginForm.controls.username.value,
        this.loginForm.controls.password.value
      )
      .subscribe(
        (result: boolean) => this.saveCurrentUser(result),
        () => {
          this.error = this.translateService.instant('Login.ErrorAuth');
          this.isLoading = false;
        }
      );
  }

  private saveCurrentUser(result: boolean) {
    if (result) {
      // Los datos del usuario ya están guardados por DeviseTokenAuth
      // No necesitamos hacer otra llamada al servidor
      this.isLoading = false;
      this.router.navigate(['/']);
    } else {
      this.isLoading = false;
    }
  }
}
