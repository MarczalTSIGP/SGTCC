import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["image"];
  static values = { url: String };

  connect() {
    if (this.imageTarget) {
      this.imageTarget.src = this.urlValue;
    }
  }

  preview(event) {
    const input = event.target;
    if (input.files && input.files[0]) {
      const reader = new FileReader();
      reader.onload = (e) => {
        this.imageTarget.src = e.target.result;
      };
      reader.readAsDataURL(input.files[0]);
    }
  }
}
