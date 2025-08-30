import { trigger, animate, transition, style } from '@angular/animations';

export function enterLeaveFade(
  name: string = 'enterLeaveFade',
  timings: string = '.5s ease-out'
) {
  return trigger(name, [
    transition(':enter', [
      style({ opacity: 0 }),
      animate(timings, style({ opacity: 1 }))
    ]),
    transition(':leave', [
      style({ opacity: 1 }),
      animate(timings, style({ opacity: 0 }))
    ])
  ]);
}
