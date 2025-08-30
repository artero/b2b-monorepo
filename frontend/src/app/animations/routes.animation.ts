import {
  transition,
  trigger,
  query,
  style,
  animate,
  group
} from '@angular/animations';

export const routesAnimations = trigger('routesAnimations', [
  transition('NewPassword => *', [
    query(':enter, :leave', style({ opacity: 1 }), {
      optional: true
    }),
    group([
      query(
        ':enter',
        [
          style({ opacity: 0 }),
          animate('.5s ease-in-out', style({ opacity: 1 }))
        ],
        { optional: false }
      ),
      query(
        ':leave',
        [
          style({ opacity: 1 }),
          animate('2s ease-in-out', style({ opacity: 0 }))
        ],
        { optional: false }
      )
    ])
  ]),
  transition('Login => *', [
    query(':enter, :leave', style({ opacity: 1 }), {
      optional: true
    }),
    group([
      query(
        ':enter',
        [
          style({ opacity: 0 }),
          animate('.5s ease-in-out', style({ opacity: 1 }))
        ],
        { optional: false }
      ),
      query(
        ':leave',
        [
          style({ opacity: 1 }),
          animate('2s ease-in-out', style({ opacity: 0 }))
        ],
        { optional: false }
      )
    ])
  ]),
  transition('* => *', [
    query(':enter, :leave', style({}), {
      optional: true
    }),
    group([
      query(
        ':enter',
        [
          style({ opacity: 0 }),
          animate('.5s ease-in-out', style({ opacity: 1 }))
        ],
        { optional: true }
      ),
      query(
        ':leave',
        [
          style({ opacity: 1 }),
          animate('.5s ease-in-out', style({ opacity: 0 }))
        ],
        { optional: true }
      )
    ])
  ])
]);
