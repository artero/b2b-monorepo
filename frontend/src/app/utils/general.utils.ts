import { kebabCase } from 'lodash';

export function addPadToColor(color: string) {
  return color && color.includes('#') ? color : `#${color}`;
}

export function imageProduct(familyName: string): string {
  const imageName = kebabCase(familyName);
  const images = [
    '1st-edition-varios',
    'greenox-varios',
    'nvs-varios-limpiador',
    'nvs-varios-pulsadores',
    'nvs-varios-varios',
    'pintyplus-aqua-mate',
    'pintyplus-art-siluetas',
    'pintyplus-art-varios',
    'pintyplus-auto-varios',
    'pintyplus-basic-brillo',
    'pintyplus-basic-efectos-metalizados',
    'pintyplus-basic-fluor',
    'pintyplus-basic-mate',
    'pintyplus-basic-satinados',
    'pintyplus-chalk-paint-mate',
    'pintyplus-chalk-paint-varios',
    'pintyplus-evolution-brillo',
    'pintyplus-evolution-efectos-metalizados',
    'pintyplus-evolution-fluor',
    'pintyplus-evolution-mate',
    'pintyplus-evolution-metalizados',
    'pintyplus-evolution-pintura-acrilica',
    'pintyplus-evolution-satinados',
    'pintyplus-evolution-w-b-brillo',
    'pintyplus-evolution-w-b-imprimaciones',
    'pintyplus-evolution-w-b-mate',
    'pintyplus-evolution-w-b-metalizados',
    'pintyplus-home-mate',
    'pintyplus-home-pulsadores',
    'pintyplus-oil-aceites',
    'pintyplus-tech-anticalorica',
    'pintyplus-tech-imprimaciones',
    'pintyplus-tech-marcadores',
    'pintyplus-tech-varios',
  ];

  const result = images.includes(imageName)
    ? `assets/images/products/${imageName}.jpg`
    : ``;

  return result;
}

export function outputObservaciones(
  observations: string,
  date: string
): string {
  return `Observaciones:
${observations}

Preferencia de envío:
${date}`;
}

export function addDays(date: Date, days: number): Date {
  const newDate = new Date(Number(date));
  const currentDate = date.getDate();
  newDate.setDate(currentDate + days);

  return newDate;
}
