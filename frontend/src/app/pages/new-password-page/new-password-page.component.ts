import { Component, OnInit } from '@angular/core';
import { UntypedFormBuilder, UntypedFormGroup, Validators } from '@angular/forms';
import { Router, ActivatedRoute } from '@angular/router';
import { AuthService } from '@services/authentication.service';
import { TranslateService } from '@ngx-translate/core';

@Component({
  selector: 'nvs-new-password-page',
  templateUrl: './new-password-page.component.html',
  host: {
    class: 'nvs-page nvs-login-page',
  },
})
export class NewPasswordPageComponent implements OnInit {
  changePasswordForm: UntypedFormGroup;
  isLoading = false;
  error = '';
  token = '';

  constructor(
    private formBuilder: UntypedFormBuilder,
    private authenticationService: AuthService,
    private router: Router,
    private route: ActivatedRoute,
    private translateService: TranslateService
  ) {
    this.route.queryParams.subscribe((params: any) => {
      this.token = params.token;
    });
  }

  ngOnInit() {
    this.changePasswordForm = this.formBuilder.group({
      newPassword: ['', Validators.required],
      repeatPassword: ['', Validators.required],
      checkCookies: [false, Validators.requiredTrue],
    });
  }

  onCheck() {
    this.checkForm(this.changePasswordForm);
  }

  onSubmit() {
    this.checkForm(this.changePasswordForm);

    if (this.changePasswordForm.invalid) {
      return;
    }

    this.isLoading = true;

    this.authenticationService
      .newPassword(this.token, this.changePasswordForm.get('newPassword').value)
      .subscribe(
        () => this.authenticationService.logout(),
        () => {
          this.error = this.translateService.instant('NewPassword.ErrorToken');
          this.isLoading = false;
        }
      );
  }

  private checkForm(group: UntypedFormGroup) {
    const newPassword = group.get('newPassword').value;
    const repeatPassword = group.get('repeatPassword').value;
    const checkCookies = group.get('checkCookies').value;

    if (newPassword !== repeatPassword) {
      this.error = this.translateService.instant('NewPassword.ErrorPasswords');
      group.get('repeatPassword').setErrors({ incorrect: true });
    } else if (!checkCookies) {
      this.error = this.translateService.instant('NewPassword.ErrorCookies');
      group.get('checkCookies').setErrors({ incorrect: true });
    } else {
      this.error = null;
    }
  }
}
