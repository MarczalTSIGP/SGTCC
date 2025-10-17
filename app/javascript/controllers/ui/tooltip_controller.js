import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
  connect() {
    this.tooltip = new window.bootstrap.Tooltip(this.element);
  }

  disconnect() {
    if (this.tooltip) {
      this.tooltip.dispose();
    }
  }
}
