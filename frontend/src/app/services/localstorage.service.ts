import { Injectable } from '@angular/core';

const HOURS = 2;

@Injectable({
  providedIn: 'root'
})
export class LocalStorageService {
  getItem(name: string): string {
    refreshStorage();

    return localStorage.getItem(name);
  }

  // tslint:disable-next-line: no-any
  setItem(name: string, data: any) {
    localStorage.setItem(name, JSON.stringify(data));
    refreshStorage();
  }

  clear() {
    localStorage.clear();
  }

  saved() {
    const storageSaved = Number(localStorage.getItem('saved'));

    if (
      storageSaved &&
      // tslint:disable-next-line: no-magic-numbers
      new Date().getTime() - storageSaved > HOURS * 60 * 60 * 1000
    ) {
      this.clear();
    }
  }
}

function refreshStorage() {
  localStorage.setItem('saved', String(new Date().getTime()));
}
