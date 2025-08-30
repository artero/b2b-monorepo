import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { OrderLineas, EmailOrder } from '../models/product.model';
import { UserService } from './user.service';

@Injectable({
  providedIn: 'root',
})
export class EmailService {
  constructor(private http: HttpClient, private userService: UserService) {}

  sendOrder(order: EmailOrder) {
    return this.http.post(
      'https://b2b.novasolpinturas.com/send_252354212134.php',
      {
        ...this.userService.getCurrentUser(),
        Observaciones: order.Observaciones,
        Lineas: buildLineas(order.Lineas),
        TotalBoxes: order.TotalBoxes,
      }
    );
  }
}

function buildLineas(lineas: OrderLineas[]) {
  let result = '';

  lineas.forEach((linea: OrderLineas) => {
    result += `<p><b>Código ${linea.CodArt}</b>: ${linea.Unidades} Unidades</p>`;
  });

  return result;
}
