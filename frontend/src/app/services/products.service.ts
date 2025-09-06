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
      .post('articulos', {
        DesdeArticulo: '',
        HastaArticulo: ''
      })
      .pipe(map(buildProducts), map(buildFamilies));
  }

  createOrder(order: Order) {
    return this.http.post('pedido', {
      Observaciones: order.Observaciones,
      Lineas: order.Lineas
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

  products.forEach(({ TipodeMarca, Subfamilia }: Product) => {
    if (
      !(
        differentFamilies.length &&
        differentFamilies.find(
          (b: DifferentFamily) =>
            TipodeMarca === b.TipodeMarca && Subfamilia === b.Subfamilia
        )
      )
    ) {
      differentFamilies.push({
        TipodeMarca,
        Subfamilia
      });
    }
  });

  differentFamilies.sort((a: DifferentFamily, b: DifferentFamily) => {
    if (a.TipodeMarca > b.TipodeMarca) {
      return 1;
    }
    if (a.TipodeMarca < b.TipodeMarca) {
      return -1;
    }

    return 0;
  });

  const families: ProductFamily[] = [];

  differentFamilies.forEach((brand: DifferentFamily) => {
    const familyProducts = products.filter(
      (product: Product) =>
        product.TipodeMarca === brand.TipodeMarca &&
        product.Subfamilia === brand.Subfamilia
    );

    families.push({
      brand: brand.TipodeMarca,
      family: brand.Subfamilia || '',
      presentations: [
        ...new Set(
          familyProducts
            .filter((product: Product) => product.Presentacion)
            .map((product: Product) => product.Presentacion)
        )
      ],
      colorTypes: [
        ...new Set(
          familyProducts
            .filter((product: Product) => product.TipoColor)
            .map((product: Product) => product.TipoColor)
        )
      ],
      products: familyProducts,
      total: familyProducts.length,
      image: imageProduct(`${brand.TipodeMarca}-${brand.Subfamilia}`)
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
