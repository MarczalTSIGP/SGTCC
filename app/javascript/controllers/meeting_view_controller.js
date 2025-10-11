// app/javascript/controllers/meeting_view_controller.js
import { Controller } from "@hotwired/stimulus";
import swal from "sweetalert";

export default class extends Controller {
  static values = {
    url: String,
    value: Boolean,
    id: String,
    name: String,
    confirmationMessage: String,
    successMessage: String,
  };

  connect() {
    this.renderCheckbox();
    this.checkbox.addEventListener("click", (event) => this.toggle(event));
  }

  renderCheckbox() {
    this.checkbox.checked = this.valueValue;
    this.checkbox.disabled = this.valueValue;
  }

  async toggle(event) {
    event.preventDefault();

    if (this.valueValue) return;

    const confirmed = await swal({
      text: this.confirmationMessageValue,
      icon: "warning",
      buttons: ["Cancelar", "Sim"],
      dangerMode: true,
    });

    if (!confirmed) return;

    try {
      const token = document?.querySelector('meta[name="csrf-token"]')?.content;
      const response = await fetch(this.urlValue, {
        method: "PATCH",
        headers: {
          "Content-Type": "application/json",
          "X-CSRF-Token": token,
        },
        body: JSON.stringify({ [this.nameValue]: true }),
      });

      if (!response.ok) throw new Error("Erro interno no servidor");
      const data = await response.json();

      this.valueValue = data;
      this.renderCheckbox();

      await swal('', this.successMessageValue, "success");
    } catch (e) {
      await swal("Erro interno no servidor", "", "error");
      this.checkbox.checked = !this.checkbox.checked;
    }
  }

  get checkbox() {
    return this.element.querySelector("input[type=checkbox]");
  }
}
