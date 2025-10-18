import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  confirm(event) {
    const message = event.target.dataset.confirmMessage;

    if (!confirm(message)) {
      event.preventDefault();
      event.stopImmediatePropagation();
      event.target.checked = !event.target.checked;
    } else {
      this.element.requestSubmit();
    }
  }
}
