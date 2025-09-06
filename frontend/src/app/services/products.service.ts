import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { map } from 'rxjs/operators';
import {
  Product,
  ProductFamily,
  ProductCart,
  Order,
  DifferentFamily
} from '../models/product.model';

import { imageProduct } from '@utils/general.utils';

@Injectable({
  providedIn: 'root'
})
export class ProductsService {
  constructor(private http: HttpClient) {}

  getAll() {
    return this.http
      .get('api/articles')
      .pipe(
        map((response: any) => response.products), // Extraer products de la respuesta
        map(buildProducts), 
        map(buildFamilies)
      );
  }

  createOrder(order: Order) {
    return this.http.post('api/orders', {
      observations: order.observations,
      lines: order.lines
    });
  }
}

function buildProducts(products: Product[]): ProductCart[] {
  const productCart: ProductCart[] = [];

  products.forEach((product: Product) => {
    productCart.push({
      ...product,
      quantity: 0
    });
  });

  return productCart;
}

function buildFamilies(products: ProductCart[]): ProductFamily[] {
  const differentFamilies: DifferentFamily[] = [];

  products.forEach(({ brand, family }: Product) => {
    if (
      !(
        differentFamilies.length &&
        differentFamilies.find(
          (b: DifferentFamily) =>
            brand === b.brand && family === b.family
        )
      )
    ) {
      differentFamilies.push({
        brand,
        family
      });
    }
  });

  differentFamilies.sort((a: DifferentFamily, b: DifferentFamily) => {
    if (a.brand > b.brand) {
      return 1;
    }
    if (a.brand < b.brand) {
      return -1;
    }

    return 0;
  });

  const families: ProductFamily[] = [];

  differentFamilies.forEach((brandFamily: DifferentFamily) => {
    const familyProducts = products.filter(
      (product: Product) =>
        product.brand === brandFamily.brand &&
        product.family === brandFamily.family
    );

    families.push({
      brand: brandFamily.brand,
      family: brandFamily.family || '',
      sizes: [
        ...new Set(
          familyProducts
            .filter((product: Product) => product.size)
            .map((product: Product) => product.size)
        )
      ],
      colors: [
        ...new Set(
          familyProducts
            .filter((product: Product) => product.color)
            .map((product: Product) => product.color)
        )
      ],
      products: familyProducts,
      total: familyProducts.length,
      image: imageProduct(`${brandFamily.brand}-${brandFamily.family}`)
    });
  });

  return families.sort(sortFamilies);
}

const sortingFamilies = [
  // main
  'BRILLO',
  'SATINADOS',
  'MATE',
  'FLUOR',
  'METALIZADOS',
  'EFECTOS METALIZADOS',
  // others
  'ACEITES',
  'ANTICALORICA',
  'BOLSA PULSADOR',
  'IMPRIMACIONES',
  'LIMPIADOR',
  'MARCADORES',
  'PISTOLA',
  'PULSADORES',
  'SILUETAS',
  //last
  'VARIOS'
];

function sortFamilies(a, b) {
  return (
    sortingFamilies.indexOf(a['family']) - sortingFamilies.indexOf(b['family'])
  );
}
