import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["mainContent", "confirmBox"];

  connect() {
    document.addEventListener(
      "open-login-confirmation",
      this.hideMain.bind(this)
    );
    document.addEventListener(
      "close-login-confirmation",
      this.showMain.bind(this)
    );
  }

  disconnect() {
    document.removeEventListener(
      "open-login-confirmation",
      this.hideMain.bind(this)
    );
    document.removeEventListener(
      "close-login-confirmation",
      this.showMain.bind(this)
    );
  }

  hideMain() {
    if (this.hasMainContentTarget)
      this.mainContentTarget.classList.add("d-none");
    if (this.hasConfirmBoxTarget)
      this.confirmBoxTarget.classList.remove("d-none");
  }

  showMain() {
    if (this.hasMainContentTarget)
      this.mainContentTarget.classList.remove("d-none");
    if (this.hasConfirmBoxTarget) this.confirmBoxTarget.classList.add("d-none");

    const hiddenElements = this.mainContentTarget.querySelectorAll(
      '[style*="display: none"]'
    );
    hiddenElements.forEach((el) => (el.style.display = ""));
  }
}
