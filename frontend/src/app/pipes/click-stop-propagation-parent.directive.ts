import { Directive, HostListener } from '@angular/core';

@Directive({
  selector: '[nvsClickStopPropagationParent] > *',
})
export class ClickStopPropagationParentDirective {
  @HostListener('click', ['$event'])
  onClick(event: Event): void {
    event.stopPropagation();
  }
}
