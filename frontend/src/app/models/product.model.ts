export enum ColorType {
  metal = 'metal'
}

export interface Product {
  code: string;           // PP-R1010-400
  name: string;           // Pintura Acrílica Roja Brillante
  brand: string;          // PintyPlus
  size: string;           // 400ml
  color: string;          // Rojo
  family: string;         // Basic
  units_per_box: number;  // 12
  price: number;          // 8.50
}

export interface ProductCart extends Product {
  quantity: number;
}

export interface PresentationQuantity {
  name: string;
  quantity: number;
}

export interface ProductFamily {
  brand: string;            // PintyPlus
  family: string;           // Basic, Evolution, Tech
  sizes?: string[];         // ['200ml', '400ml', '600ml']
  colors?: string[];        // ['Rojo', 'Azul', 'Verde']
  products?: ProductCart[]; // list of products
  total: number;            // total of products
  image?: string;           // image of product
  detailRow?: boolean;      // if view Detail Row
}

export interface OrderLine {
  code: string;    // Código del artículo
  quantity: number; // Cantidad
}

export interface Order {
  observations: string;  // Observaciones del pedido
  lines: OrderLine[];    // Líneas del pedido
}

export interface EmailOrder extends Order {
  total_boxes: number;  // Total de cajas
}

export interface DifferentFamily {
  brand: string;   // PintyPlus
  family: string;  // Basic, Evolution, Tech
}
