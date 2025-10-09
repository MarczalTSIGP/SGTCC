import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static values = {
    name: String,
    label: String,
    hint: String,
    url: String,
    errors: Array
  }

  connect() {
    this.input = this.element.querySelector('input[type="file"]');
    this.labelElement = this.element.querySelector('label');
    this.updateLabel();
  }

  updateLabel() {
    if (this.urlValue) {
      this.labelElement.textContent = this.urlValue.split('/').pop();
    } else {
      this.labelElement.textContent = "Procurar arquivo...";
    }

    if (this.hasErrors()) {
      this.element.classList.add("invalid");
      this.input.classList.add("is-invalid");
    } else {
      this.element.classList.remove("invalid");
      this.input.classList.remove("is-invalid");
    }
  }

  hasErrors() {
    return this.errorsValue && this.errorsValue.length > 0;
  }

  change() {
    const file = this.input.files[0];
    if (file) {
      this.labelElement.textContent = file.name;
    } else {
      this.updateLabel();
    }
  }
}
