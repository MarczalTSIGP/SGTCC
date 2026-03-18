import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static values = { content: String };
  static targets = ["content"];

  copy(event) {
    event.preventDefault();
    if (navigator.clipboard) {
      navigator.clipboard.writeText(this.textToCopy);
      this.showFeedback("Copiado!");
    } else {
      this.showFeedback(
        "Seu navegador não suporta a função de copiar para a área de transferência."
      );
    }
  }

  get textToCopy() {
    const { value, innerText } = this.contentTarget;
    return this.contentValue || value || innerText;
  }

  showFeedback(message) {
    alert(message);
  }
}
