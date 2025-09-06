import { trigger, animate, transition, style } from '@angular/animations';

export const navBarAnimation = trigger('navBar', [
  transition(':enter', [
    style({ opacity: 0, transform: 'translateX(-100%)' }), // initial
    animate('.5s', style({ opacity: 1, transform: 'translateX(0)' })) // final
  ]),
  transition(':leave', [
    style({ opacity: 1, transform: 'translateX(0)' }), // initial
    animate('.5s', style({ opacity: 0, transform: 'translateX(-100%)' })) // final
  ])
]);
