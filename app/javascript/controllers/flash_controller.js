import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {
    // this.timeout = setTimeout(() => {
    //   this.close();
    // }, 10000);
  }

  close() {
    this.element.classList.remove("show");
    this.element.addEventListener(
      "transitionend",
      () => {
        this.element.remove();
      },
      { once: true }
    );
  }

  disconnect() {
    clearTimeout(this.timeout);
  }
}
