import { trigger, animate, transition, style } from '@angular/animations';

export function enterLeaveSlideDown(
  name: string = 'enterLeaveSlideDown',
  timings: string = '225ms cubic-bezier(0.4, 0.0, 0.2, 1)'
) {
  return trigger(name, [
    transition(':enter', [
      style({ height: 0, overflow: 'hidden' }),
      animate(timings, style({ height: '*', minHeight: '*' }))
    ]),
    transition(':leave', [
      style({ height: '*', minHeight: '*', overflow: 'hidden' }),
      animate(timings, style({ height: 0, minHeight: '0' }))
    ])
  ]);
}
