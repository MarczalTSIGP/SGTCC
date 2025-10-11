import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static values = {
    showTitle: String
  }

  connect() {
    this.show = true;
    this.registerEvents();
  }

  registerEvents() {
    document.addEventListener("close-signature-button", () => {
      this.hide();
    });

    document.addEventListener("open-signature-button", () => {
      this.showButton();
    });
  }

  hide() {
    this.show = false;
    this.element.style.display = "none";
  }

  showButton() {
    this.show = true;
    this.element.style.display = "block";
  }

  openLoginConfirmation() {
    document.dispatchEvent(new CustomEvent("open-login-confirmation"));
    document.dispatchEvent(new CustomEvent("close-signature-download-button"));
    document.dispatchEvent(new CustomEvent("close-signature-button"));
    document.dispatchEvent(new CustomEvent("change-signature-show-title", {
      detail: { title: this.showTitleValue }
    }));
  }
}
