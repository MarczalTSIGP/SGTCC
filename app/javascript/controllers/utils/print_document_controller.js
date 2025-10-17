import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static values = {
    headTitle: String,
    documentTitle: String
  };

  print() {
    const printable = document.querySelector("#printable-document");
    if (!printable) {
      console.error("Element #printable-document not found!");
      return;
    }

    const originalTitle = document.title;
    document.title = this.documentTitleValue || originalTitle;

    window.print();
    document.title = originalTitle;
  }
}
