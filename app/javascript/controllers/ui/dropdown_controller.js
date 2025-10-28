import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["toggle", "menu"];

  connect() {
    if (this.hasToggleTarget && window.bootstrap) {
      this.dropdown = new window.bootstrap.Dropdown(this.toggleTarget, {
        autoClose: true,
        boundary: "viewport"
      });
    }
  }

  disconnect() {
    if (this.dropdown) {
      this.dropdown.dispose();
    }
  }

  toggle(event) {
    event.preventDefault();
    event.stopPropagation();
    
    if (this.dropdown) {
      this.dropdown.toggle();
    }
  }
}

