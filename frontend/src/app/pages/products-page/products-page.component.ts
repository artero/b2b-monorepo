import { DatePipe } from '@angular/common';
import { Component, OnInit, ViewChild } from '@angular/core';
import {
  UntypedFormGroup,
  UntypedFormControl,
  Validators,
} from '@angular/forms';
import { MatStepper } from '@angular/material/stepper';
import { Router } from '@angular/router';

import { LocalStorageService } from '@services/localstorage.service';
import { EmailService } from 'src/app/services/email.service';
import { ProductsService } from 'src/app/services/products.service';

import jsPDF from 'jspdf';
import html2canvas from 'html2canvas';

import { addDays, outputObservaciones } from '@utils/general.utils';

import { finalize } from 'rxjs/operators';
import {
  ProductFamily,
  ProductCart,
  Order,
} from 'src/app/models/product.model';

const SEND_DATE_MIN = 4;
const SEND_DATE_MAX = 90;
const AUTO_STEPPER_DELAY = 1000;

@Component({
  selector: 'nvs-products-page',
  templateUrl: './products-page.component.html',
  styleUrls: ['./products-page.component.scss'],
  providers: [DatePipe],
  host: {
    class: 'nvs-page nvs-auth-page',
  },
})
export class ProductsPageComponent implements OnInit {
  @ViewChild('stepper') stepper: MatStepper;

  products: ProductFamily[];
  filteredProducts: ProductFamily[];
  initialProducts: ProductFamily[];
  uniqueBrands: string[];
  isLoading = true;
  isLoadingPdf = false;
  isEditable = true;
  total: number;
  formOrder: UntypedFormGroup;
  formConfirm: UntypedFormGroup;
  addedProducts: number = 0;
  order: ProductCart[];
  minDate: Date;
  maxDate: Date;
  search: string;

  constructor(
    private productsService: ProductsService,
    private emailService: EmailService,
    private localStorageService: LocalStorageService,
    private router: Router,
    private datePipe: DatePipe
  ) {}

  ngOnInit() {
    this.getDateLimits();
    this.getProducts();
    this.formConfirm = new UntypedFormGroup({
      observations: new UntypedFormControl(''),
      shipping: new UntypedFormControl('', Validators.required),
      urgent: new UntypedFormControl(''),
    });
  }

  getProductsByBrand(brand: string) {
    const products = this.filteredProducts
      ? this.filteredProducts
      : this.products;

    return products.filter((item: ProductFamily) => item.brand === brand);
  }

  onChangeProducts() {
    this.addedProducts = this.getProductQuantity();
    this.order = this.getOrderProducts();
    this.total = this.setTotal();
    this.localStorageService.setItem('products', this.products);
  }

  onSubmit() {
    if (this.formConfirm.invalid) {
      return;
    }
    const ORDER = this.buildOrder();
    this.isLoading = true;
    this.isEditable = false;

    this.productsService.createOrder(ORDER)
    .pipe(finalize(() => {
      this.isLoading = false;
      this.isEditable = true;
    }))
    .subscribe({
      next: () => {
        this.clearOrder();
        this.router.navigate(['/done']);
      },
      error: (error) => {
        console.error('Error creating order:', error);
        // Aquí podrías mostrar un mensaje de error al usuario
      }
    });
  }

  onSearch() {
    const result = [];

    this.initialProducts.forEach((family: ProductFamily) => {
      const filtered = family.products.filter((product: ProductCart) =>
        this.filterProducts(product)
      );

      if (filtered.length > 0) {
        const newFamily = {
          ...family,
          products: filtered,
          total: filtered.length,
        };
        result.push(newFamily);
      }
    });

    this.filteredProducts = result;
  }

  onClearSearch() {
    this.search = '';
    this.filteredProducts = null;
  }

  onUrgent() {
    const isUrgent = this.formConfirm.get('urgent').value;
    const shipping = this.formConfirm.get('shipping');

    shipping.setValidators(isUrgent ? null : Validators.required);
    shipping.setValue(isUrgent ? new Date() : null);
  }

  public onPrint(): void {
    this.isLoading = true;
    this.isEditable = false;
    this.setPrint();
  }

  private setPrint(): void {
    const textToday = this.datePipe.transform(new Date(), 'dd-MM-yyyy');
    const $tableOriginal = document.querySelector('#order-print');
    const tableTotalRows = $tableOriginal.querySelectorAll('[mat-row]').length;
    const pdf = new jsPDF('p', 'mm', [297, 210]);
    const pdfImageTop = 15;
    const pdfGutter = 12;
    const pdfItemsByPage = 30;
    const pdfPages = Math.ceil(tableTotalRows / pdfItemsByPage);
    const promises = [];

    console.log(tableTotalRows);

    for (let i = 0; i < pdfPages; i++) {
      promises.push(
        html2canvas($tableOriginal as HTMLElement, {
          width: 1160,
          scale: 2,
          onclone: function (newDocument) {
            newDocument.querySelector('body').classList.add('layout-print');
            newDocument
              .querySelectorAll('.order-table__row')
              .forEach((e, index) => {
                let min = i * pdfItemsByPage;
                let max = min + pdfItemsByPage;
                if (index < min || index >= max) {
                  e.parentNode.removeChild(e);
                }
              });

            if (i != pdfPages - 1) {
              newDocument
                .querySelectorAll('#order-print tfoot')
                .forEach((e) => e.parentNode.removeChild(e));
            }
          },
        }).then((canvas) => {
          pdf.setFontSize(12);
          pdf.text('NVS B2B', pdfGutter, pdfGutter);
          pdf.text(textToday, 198, pdfGutter, { align: 'right' });
          const imgData = canvas.toDataURL('image/png');
          const imgWidth = 210 - pdfGutter * 2;
          const imgHeight = (canvas.height * imgWidth) / canvas.width;
          pdf.setFontSize(10);
          pdf.addImage(
            imgData,
            'PNG',
            pdfGutter,
            pdfImageTop,
            imgWidth,
            imgHeight
          );
          pdf.text(`Pag. ${i + 1}/${pdfPages}`, pdfGutter, 290);
          if (i != pdfPages - 1) {
            pdf.addPage();
          }
        })
      );
    }

    Promise.all(promises)
      .then(() => {
        this.isLoading = false;
        this.isEditable = true;

        pdf.save(`nvs-b2b-${textToday}.pdf`);
      })
      .catch((e) => {
        console.error(e);
      });
  }

  private setTotal(): number {
    return this.order && this.order.length
      ? this.order.reduce((total: number, p: ProductCart) => {
          const uds = Number(p.units_per_box) || 1;

          return total + p.quantity * uds * p.price;
        }, 0) || 0
      : 0;
  }

  private filterProducts(product: ProductCart) {
    return (
      (product.name &&
        product.name.toLowerCase().includes(
          this.search.toLowerCase()
        )) ||
      (product.code &&
        product.code.toLowerCase().includes(this.search.toLowerCase())) ||
      (product.color &&
        product.color.toLowerCase().includes(this.search.toLowerCase()))
    );
  }

  private buildOrder(): Order {
    const lines = [];

    this.order.forEach((product: ProductCart) =>
      lines.push({
        code: product.code,
        quantity: product.quantity * (Number(product.units_per_box) || 1),
      })
    );

    const dateTransform = this.datePipe.transform(
      this.formConfirm.get('shipping').value,
      'dd-MM-yyyy'
    );

    const observations = outputObservaciones(
      this.formConfirm.get('observations').value,
      dateTransform
    );

    return {
      observations,
      lines,
    };
  }

  private getProductQuantity(): number {
    return (
      this.products.reduce(
        (total: number, family: ProductFamily) =>
          total +
          family.products.reduce(
            (subtotal: number, product: ProductCart) =>
              subtotal + product.quantity,
            0
          ),
        0
      ) || 0
    );
  }

  private getProducts() {
    const storageProducts = this.localStorageService.getItem('products');

    if (storageProducts) {
      this.setInitialProducts(JSON.parse(storageProducts));
    } else {
      this.productsService.getAll().subscribe((response: ProductFamily[]) => {
        this.setInitialProducts(response);
      });
    }
  }

  private setInitialProducts(products: ProductFamily[]) {
    this.initialProducts = products;
    this.products = this.initialProducts;
    this.setUniqueBrands();
    setTimeout(() => {
      this.onChangeProducts();
      if (this.addedProducts) {
        setTimeout(() => {
          this.isLoading = false;
          this.stepper.selectedIndex = 1;
        }, AUTO_STEPPER_DELAY);
      } else {
        this.isLoading = false;
      }
    });
  }

  private setUniqueBrands() {
    const SORT = [
      'PINTYPLUS EVOLUTION',
      'PINTYPLUS EVOLUTION W.B.',
      'PINTYPLUS BASIC',
      'PINTYPLUS HOME',
      'PINTYPLUS CHALK PAINT',
      'PINTYPLUS AQUA',
      'PINTYPLUS ART',
      'PINTYPLUS TECH',
      'PINTYPLUS AUTO',
      'PINTYPLUS OIL',
      'GREENOX',
    ];
    const brands = this.products.map(({ brand }: ProductFamily) => brand);

    this.uniqueBrands = [...new Set([...SORT, ...brands])];
  }

  private getDateLimits() {
    const myDate = new Date();
    this.maxDate = addDays(myDate, SEND_DATE_MAX);
    this.minDate = addDays(myDate, SEND_DATE_MIN);
  }

  private getOrderProducts(): ProductCart[] {
    const order: ProductCart[] = [];
    this.products.forEach((family: ProductFamily) => {
      const productsCart: ProductCart[] = family.products;

      productsCart
        .filter((p: ProductCart) => p.quantity > 0)
        .forEach((p: ProductCart) => order.push(p));
    });

    return order;
  }

  private clearOrder(): void {
    if (this.products) {
      this.products.forEach((family: ProductFamily) => {
        if (family.products) {
          family.products.forEach((product: ProductCart) => {
            product.quantity = 0;
          });
        }
      });
    }

    this.order = [];
    this.addedProducts = 0;
    this.total = 0;

    if (this.formOrder) {
      this.formOrder.reset();
    }
    if (this.formConfirm) {
      this.formConfirm.reset();
    }

    if (this.products) {
      this.localStorageService.setItem('products', this.products);
    }
  }
}
