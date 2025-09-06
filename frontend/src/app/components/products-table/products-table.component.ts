import { Component, Input, Output, EventEmitter } from '@angular/core';

import { enterLeaveSlideDown } from '@animations/enterLeaveSlideDown.animation';

import { ProductFamily, ProductCart, ColorType } from '@models/product.model';

import { addPadToColor } from '@utils/general.utils';
import { TranslateService } from '@ngx-translate/core';

@Component({
  selector: '[products-table]',
  templateUrl: 'products-table.component.html',
  animations: [enterLeaveSlideDown()]
})
export class ProductsTableComponent {
  @Input() products: ProductFamily[];
  @Output() productsChange = new EventEmitter<void>();

  constructor(private translateService: TranslateService) {}

  displayedColumns: string[] = ['action', 'family', 'presentation', 'total'];

  toggleRow(element: ProductFamily) {
    element.detailRow = !element.detailRow;
    this.productsChange.emit();
  }

  onChangeQuantity(product: ProductCart, e: Event) {
    product.quantity = Number((e.target as HTMLInputElement).value);
    this.productsChange.emit();
  }

  translatePromotions(promotions: [string]) {
    return promotions.map(promotion =>
      this.translateService.instant(promotion)
    );
  }

  formatDescription(product: ProductCart): string {
    return product.name;
  }

  getBrand(products: ProductFamily[]): string {
    return products && products.length >= 1 ? products[0].brand : '';
  }

  getTotal(product: ProductCart) {
    return (
      product.quantity * Number(product.units_per_box) * product.price
    );
  }

  getSizeProducts(
    size: string,
    products: ProductCart[]
  ): ProductCart[] {
    return products.filter(
      (product: ProductCart) => product.size === size
    );
  }

  getExpandState(element: ProductFamily) {
    return element.detailRow ? 'expanded' : 'collapsed';
  }

  hexColorPad(color: string) {
    return addPadToColor(color);
  }

  isColorType(colorType: ColorType): string {
    return colorType ? `is-${colorType}` : '';
  }
}
