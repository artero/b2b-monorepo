import { Component, Input, EventEmitter, Output } from '@angular/core';
import {
  PresentationQuantity,
  ProductCart
} from 'src/app/models/product.model';

import { addPadToColor } from '@utils/general.utils';

@Component({
  selector: '[order-table]',
  templateUrl: 'order-table.component.html'
})
export class OrderTableComponent {
  @Input() total: number;
  @Input() set order(order: ProductCart[]) {
    if (!order) {
      return;
    }
    this._order = order;
    this.sizesQuantity = sizesQuantity(order);
  }
  get order(): ProductCart[] {
    return this._order;
  }

  @Output() orderChange = new EventEmitter();

  private _order: ProductCart[] = [];

  sizesQuantity: PresentationQuantity[] = [];
  displayedColumns: string[] = [
    'color',
    'name',
    'family',
    'presentation',
    'quantity',
    'units',
    'price',
    'amount'
  ];

  tableFooterColumns: string[] = ['name', 'price', 'amount'];
  tableFooterInfoColumns: string[] = ['info'];

  hexColorPad(color: string) {
    return addPadToColor(color);
  }

  totalRow(product: ProductCart): number {
    const uds = Number(product.units_per_box) || 1;

    return product.quantity * uds * product.price;
  }

  onChangeOrder(product: ProductCart, e: Event) {
    const input = e.target as HTMLInputElement;

    product.quantity = Number(input.value);

    this.orderChange.emit();
  }
}

function sizesQuantity(order: ProductCart[]): PresentationQuantity[] {
  let result = [];

  order.forEach((orderItem: ProductCart) => {
    const productCardFound = result.find(
      (resultItem: { name: string; quantity: number }) =>
        resultItem.name === orderItem.size
    );

    if (!!productCardFound) {
      productCardFound.quantity += orderItem.quantity;
    } else {
      result.push({
        name: orderItem.size,
        quantity: orderItem.quantity
      });
    }
  });

  return result;
}
