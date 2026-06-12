import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {
    this.resizeObserver = new ResizeObserver(() => this.update());
    this.resizeObserver.observe(this.element);
    this.update();
  }

  disconnect() {
    this.resizeObserver?.disconnect();
  }

  update() {
    const value = Number(this.element.value || 0);
    const min = Number(this.element.min || 0);
    const max = Number(this.element.max || 100);
    const range = max - min;
    const rawRatio = range > 0 ? (value - min) / range : 0;
    const ratio = Math.min(1, Math.max(0, rawRatio));
    const thumbWidth = 14;
    const left = this.element.offsetLeft
      + (thumbWidth / 2)
      + (ratio * (this.element.clientWidth - thumbWidth));
    const selectedNote = this.element.parentElement.querySelector(
      "[data-range-tabler-selected-note]"
    );

    if (selectedNote) {
      selectedNote.textContent = value;
      selectedNote.style.left = `${left}px`;
    }
  }
}
