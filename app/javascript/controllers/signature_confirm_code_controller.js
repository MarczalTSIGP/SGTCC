import { Controller } from "@hotwired/stimulus";
import swal from "sweetalert";

export default class extends Controller {
  static targets = ["code", "redirect"];

  handleResponse(event) {
    const { detail } = event;
    const { success, fetchResponse } = detail;

    if (!success) {
      this.showErrorMessage("Erro de conexão, tente novamente.");
      return;
    }

    fetchResponse.responseText.then((text) => {
      const data = JSON.parse(text);

      if (data.status === "not_found") {
        this.showErrorMessage(data.message);
        return;
      }

      const code = this.codeTarget.value;

      this.showSuccessMessage("Documento autenticado com sucesso!").then(() => {
        this.showDocument(code);
      });
    });
  }

  showDocument(code) {
    const baseUrl = window.location.origin + "/autenticidade/documentos";
    const linkUrl = `${baseUrl}/${code}`;

    window.location.href = linkUrl;
  }

  showMessage(message, type) {
    return swal("", message, type);
  }

  showWarningMessage(message) {
    return this.showMessage(message, "warning");
  }

  showSuccessMessage(message) {
    return this.showMessage(message, "success");
  }

  showErrorMessage(message) {
    return this.showMessage(message, "error");
  }
}
