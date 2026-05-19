import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {
    this.update();
  }

  update() {
    const value = this.element.value || 0;
    const wrapper = this.element.closest(".input, .form-group, .mb-3") || this.element.parentElement;

    if (!wrapper) return;

    const selectedNote = wrapper.querySelector("[data-range-tabler-selected-note]");

    if (selectedNote) selectedNote.textContent = value;
  }
}
