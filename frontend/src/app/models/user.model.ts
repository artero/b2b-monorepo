export interface Token {
  Token: string;
}
export interface ClienteDireccion {
  Direccion: string;
  Poblacion: string;
  Provincia: string;
  Pais: string;
}
export interface ClienteDireccionEntrega {
  Direccion: string;
  Poblacion: string;
  Provincia: string;
  Pais: string;
  Contacto: string;
  Telefono: string;
}
export interface Cliente {
  CodCli: string;
  NomCli: string;
  NIF: string;
  Telefono: string;
  Email: string;
  FormaDePago: string;
  DocumentoDePago: string;
  Direccion: ClienteDireccion;
  DireccionEntrega: ClienteDireccionEntrega;
}
export interface CurrentUser extends Cliente {
  user: string;
}
