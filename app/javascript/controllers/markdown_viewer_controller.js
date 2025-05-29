import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {
    // Ensure SimpleMDE is loaded
    if (typeof window.SimpleMDE === "undefined") {
      console.error('SimpleMDE is not loaded.');
      return;
    }

    this.render();
  }

  render() {
    let markdown = this.element.dataset.markdown || "";

    const renderedHTML = window.SimpleMDE.prototype.markdown(markdown);
    this.element.innerHTML = renderedHTML;
  }
}