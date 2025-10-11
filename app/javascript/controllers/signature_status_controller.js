import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {
    document.addEventListener("update-signature-status", () => this.refresh());
  }

  async refresh() {
    const frame = document.querySelector("turbo-frame#signature_status");
    if (!frame) return;

    const url = `${window.location.pathname}/signature_status`;
    frame.src = url;
  }
}
