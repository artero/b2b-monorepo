import { DecimalPipe } from '@angular/common';
import { Pipe, PipeTransform } from '@angular/core';

@Pipe({
  name: 'localeNumber'
})
export class LocaleNumberPipe implements PipeTransform {
  constructor(private decimalPipe: DecimalPipe) {}

  transform(value: number | string): string {
    let floatValue: number;

    if (value || value === 0 || value === 0.0) {
      floatValue = typeof value === 'string' ? parseFloat(value) : value;

      return this.decimalPipe.transform(floatValue, '1.2-2');
    }

    return '';
  }
}
