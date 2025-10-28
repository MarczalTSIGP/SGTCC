import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {
      if (!this.element.dataset.simplemde && typeof window.SimpleMDE !== "undefined") {
        this.simplemde = new window.SimpleMDE({ 
          element: this.element, 
          spellChecker: false,
          status: false
        });
        this.element.dataset.simplemde = true;
      }
  }

  disconnect() {
    if (this.simplemde) {
      this.simplemde.toTextArea();
      this.simplemde = null;
      delete this.element.dataset.simplemde;
    }
  }
}
