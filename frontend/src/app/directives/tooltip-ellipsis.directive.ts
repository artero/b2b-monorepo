import {
  Directive,
  HostListener,
  ElementRef,
  ContentChild,
  AfterViewInit
} from '@angular/core';
import { MatTooltip } from '@angular/material/tooltip';

@Directive({
  selector: '[nvsTooltipEllipsis]'
})
export class TooltipEllipsisDirective implements AfterViewInit {
  @ContentChild(MatTooltip, { static: false }) tooltip: MatTooltip;

  constructor(private elementRef: ElementRef) {}

  ngAfterViewInit() {
    const showDelay = 600;
    this.tooltip.showDelay = showDelay;
    this.tooltip.tooltipClass = 'mat-tooltip--light';
    this.tooltip.position = 'above';
  }

  @HostListener('mouseover') onHover() {
    this.isEllipsisActive();
  }

  isEllipsisActive() {
    const element = this.elementRef.nativeElement;

    this.tooltip.disabled = element.offsetWidth >= element.scrollWidth;
  }
}
