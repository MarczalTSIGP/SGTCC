import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["toggle", "menu"];

  connect() {
    if (this.hasToggleTarget && window.bootstrap) {
      this.dropdown = new window.bootstrap.Dropdown(this.toggleTarget, {
        autoClose: true,
        boundary: "clippingParents",
        popperConfig: {
          modifiers: [
            {
              name: "preventOverflow",
              options: {
                rootBoundary: "viewport",
              },
            },
          ],
        },
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
    
    this.closeAllDropdowns();
    
    if (this.dropdown) {
      this.dropdown.toggle();
    }
  }

  closeAllDropdowns() {
    const allDropdowns = document.querySelectorAll(".dropdown");
    
    allDropdowns.forEach((dropdown) => {
      if (dropdown !== this.element) {
        const toggle = dropdown.querySelector(".dropdown-toggle");
        if (toggle) {
          const dropdownInstance = window.bootstrap.Dropdown.getInstance(toggle);
          if (dropdownInstance) {
            dropdownInstance.hide();
          }
        }
      }
    });
  }
}

