import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {
    if (!this.element.dataset.simplemde) {
      new window.SimpleMDE({ 
        element: this.element, 
        spellChecker: false,
        status: false
      });
      this.element.dataset.simplemde = true;
    }
  }
}
