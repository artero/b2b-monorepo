export enum ColorType {
  metal = 'metal'
}

export interface Product {
  Codigo: string; // code
  Descripcion: string; // BEIGE
  TipodeMarca: string; // Evolution
  Presentacion: string; // 270cc
  HexaColor: string; // #7F7D7C
  TipoColor: ColorType; // metal
  Familia: string; // Pintura
  Subfamilia: string; // Evolution Metalizada
  UdsCaja: string; // 0
  UnidadVenta: string; // Unidades
  CodigoBarras: string; // code
  PrecioSinDescuento: number; // 0.0
  DescuentoEquivalente: number; // 54.0
  Descuento1: number; // 50.0
  Descuento2: number; // 8.0
  Descuento3: number; // 0.0
  Descuento4: number; // 0.0
  PrecioConDescuento: number; // 0.0;
}

export interface ProductCart extends Product {
  quantity: number;
}

export interface PresentationQuantity {
  name: string;
  quantity: number;
}

export interface ProductFamily {
  brand: string; // Evolution
  family: string; // Evolution Metalizada
  presentations?: string[]; // ['270cc']
  colorTypes?: ColorType[]; // ['Brillo', 'Satinado']
  products?: ProductCart[]; // list of products
  total: number; // total of products
  image?: string; // image of product
  detailRow?: boolean; // if view Detail Row
}

export interface OrderLineas {
  CodArt: string;
  Unidades: number;
}

export interface Order {
  Observaciones: string;
  Lineas: OrderLineas[];
}

export interface EmailOrder extends Order {
  TotalBoxes: number;
}

export interface DifferentFamily {
  TipodeMarca: string; // Evolution
  Subfamilia: string; // Evolution Metalizada
}
