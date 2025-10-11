import { Controller } from "@hotwired/stimulus";
import swal from "sweetalert";

export default class extends Controller {
  static values = {
    label: String,
    url: String,
    open: Boolean,
  };

  static targets = ["login", "password", "labelText", "labelTextInput"];

  connect() {
    this.updateLabels();
    this.element.classList.toggle("d-none", !this.openValue);

    document.addEventListener("open-login-confirmation", () => this.open());
  }

  updateLabels() {
    if (this.hasLabelTextTarget)
      this.labelTextTarget.textContent = this.labelValue;
    if (this.hasLabelTextInputTarget)
      this.labelTextInputTarget.textContent = this.labelValue;
  }

  open() {
    this.openValue = true;
    this.element.classList.remove("d-none");

    document.dispatchEvent(new Event("open-login-confirmation"));
  }

  close() {
    this.openValue = false;
    this.element.classList.add("d-none");

    document.dispatchEvent(new Event("close-login-confirmation"));
  }

  async confirmLogin() {
    const login = this.loginTarget.value.trim();
    const password = this.passwordTarget.value.trim();

    if (!login || !password) {
      swal("", `${this.labelValue} ou senha inválidos!`, "warning");
      return;
    }

    try {
      const response = await fetch(this.urlValue, {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]')
            .content,
        },
        body: JSON.stringify({ login, password }),
      });

      const data = await response.json();

      if (data.status === "internal_server_error") {
        swal("", data.message, "warning");
        return;
      }

      this.afterSaveSignature(data.message);
    } catch (error) {
      console.error(error);
      swal("Erro", "Erro ao processar a assinatura", "error");
    }
  }

  afterSaveSignature(message) {
    swal("Sucesso", message, "success").then(() => {
      this.close();

      document.dispatchEvent(new CustomEvent("close-signature-button"));
      document.dispatchEvent(new CustomEvent("show-signatures-mark"));
      document.dispatchEvent(new CustomEvent("update-signature-status"));
      document.dispatchEvent(new CustomEvent("open-signature-download-button"));
      document.dispatchEvent(new CustomEvent("close-document-judgment"));
      document.dispatchEvent(new CustomEvent("close-edit-button"));
    });
  }
}
