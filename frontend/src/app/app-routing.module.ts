import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';

import { AuthPageComponent } from './pages/auth-page/auth-page.component';
import { DonePageComponent } from './pages/done-page/done-page.component';
import { LoginPageComponent } from './pages/login-page/login-page.component';
import { NewPasswordPageComponent } from './pages/new-password-page/new-password-page.component';
import { ProductsPageComponent } from './pages/products-page/products-page.component';

import { AuthGuard } from './helpers/auth.guard';

const routes: Routes = [
  {
    path: 'login',
    component: LoginPageComponent,
    data: { animation: 'Login' }
  },
  {
    path: 'new-password',
    component: NewPasswordPageComponent,
    data: { animation: 'NewPassword' }
  },
  {
    path: '',
    canActivate: [AuthGuard],
    component: AuthPageComponent,
    data: { animation: 'Auth' },
    children: [
      {
        path: 'products',
        component: ProductsPageComponent
      },
      {
        path: 'done',
        component: DonePageComponent
      },
      { path: '', redirectTo: '/products', pathMatch: 'full' }
    ]
  },
  { path: '**', redirectTo: '/products' }
];

@NgModule({
  imports: [RouterModule.forRoot(routes, {})],
  exports: [RouterModule]
})
export class AppRoutingModule {}
