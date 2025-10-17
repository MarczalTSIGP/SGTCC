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
    // Cleanup when Turbo replaces the element
    if (this.slim) {
      this.slim.destroy();
    }
  }

  fixPlaceholer() {
    let blank = this.element.querySelector("option[value=\"\"]");
    if (blank)
      blank.setAttribute("data-placeholder", "true");
  }
}
