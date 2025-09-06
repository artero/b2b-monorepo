import { trigger, transition, style, animate } from '@angular/animations';
import { Component, HostBinding } from '@angular/core';

@Component({
  selector: 'loading',
  templateUrl: 'loading.component.html',
  animations: [
    trigger('fade', [
      transition(':enter', [
        style({ opacity: 0 }), // initial
        animate('1s', style({ opacity: 1 })) // final
      ]),
      transition(':leave', [
        style({ opacity: 1 }), // initial
        animate('1s', style({ opacity: 0 })) // final
      ])
    ])
  ]
})
export class LoadingComponent {
  @HostBinding('class') className = 'loading';
  @HostBinding('@fade') trigger = '';
}
