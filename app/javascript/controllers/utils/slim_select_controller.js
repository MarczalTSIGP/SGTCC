import { Controller } from "@hotwired/stimulus";
import SlimSelect from "slim-select";

export default class extends Controller {

  connect() {
    this.fixPlaceholer();

    this.slim = new SlimSelect({
      select: this.element,
      settings: {
        placeholderText: "Selecione...",
        searchPlaceholder: "Buscar...",
        searchText: "Sem resultados",
        closeOnSelect: false,
        allowDeselect: true,
        showSearch: true
      }
    });
  }

  disconnect() {
    if (this.slim) {
      this.slim.destroy();
    }
  }

  submitForm() {
    const form = this.element.closest("form");
    if (form) {
      form.requestSubmit();
    }
  }

  fixPlaceholer() {
    let blank = this.element.querySelector("option[value=\"\"]");
    if (blank)
      blank.setAttribute("data-placeholder", "true");
  }
}
