import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { OrderLine, EmailOrder } from '../models/product.model';
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
        observations: order.observations,
        lines: buildLines(order.lines),
        total_boxes: order.total_boxes,
      }
    );
  }
}

function buildLines(lines: OrderLine[]) {
  let result = '';
  lines.forEach((line: OrderLine) => {
    result += `<p><b>Código ${line.code}</b>: ${line.quantity} Unidades</p>`;
  });
  return result;
}
