import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static values = {
    headTitle: String,
    documentTitle: String,
  };

  connect() {
    console.log("DownloadSignatureController conectado!");
  }

  download() {
    const printElement = document.querySelector("#printable-document");
    if (!printElement) {
      console.error("Elemento #printable-document não encontrado!");
      return;
    }

    const originalContent = document.body.innerHTML;
    const originalTitle = document.title;

    document.title = this.documentTitleValue || originalTitle;

    document.body.innerHTML = printElement.outerHTML;

    window.print();

    document.body.innerHTML = originalContent;
    document.title = originalTitle;

    window.location.reload();
  }
}
