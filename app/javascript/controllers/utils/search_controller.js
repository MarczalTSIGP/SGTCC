import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["input"];
  static values = {
    url: String,
    term: String
  };

  connect() {
    if (this.hasTermValue && this.termValue) {
      this.inputTarget.value = this.termValue;
    }

    document.addEventListener("search-with-filter", (e) => {
      this.updateUrlWithFilter(e.detail.filter);
      this.submit();
    });

    document.addEventListener("update-search-url", (e) => {
      this.updateUrlWithFilter(e.detail.filter[0]);
    });
  }

  submit(event) {
    if (event) event.preventDefault();

    const term = this.inputTarget.value.replace(/\\|\//g, "");
    this.inputTarget.value = term;

    const url = this.updatedUrl || this.urlValue;
    const finalUrl = `${url}/${encodeURIComponent(term)}`;

    Turbo.visit(finalUrl);
  }

  updateUrlWithFilter(filter) {
    if (!filter) {
      this.updatedUrl = this.urlValue;
      return;
    }
    this.updatedUrl = this.urlValue.replace(/search/, `${filter}/search`);
  }

  checkEnter(event) {
    if (event.key === "Enter") {
      event.preventDefault();
      this.submit();
    }
  }
}
