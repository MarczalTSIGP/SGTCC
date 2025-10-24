import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["button", "form", "textarea", "invalidFeedback"];

  confirmCancellation(event) {
    event.preventDefault();
    
    if (confirm("Você tem certeza que deseja cancelar essa orientação?")) {
      this.showForm();
    }
  }

  showForm() {
    this.buttonTarget.classList.add("d-none");
    this.formTarget.classList.remove("d-none");
  }

  hideForm(event) {
    event.preventDefault();
    this.formTarget.classList.add("d-none");
    this.buttonTarget.classList.remove("d-none");
    this.textareaTarget.value = "";
    this.cleanErrors();
  }

  validateAndSubmit(event) {
    event.preventDefault();
    
    if (this.textareaTarget.value.trim() === "") {
      this.textareaTarget.classList.add("is-invalid");
      this.invalidFeedbackTarget.classList.remove("d-none");
      return;
    }
    
    event.target.closest("form").submit();
  }

  cleanErrors() {
    this.textareaTarget.classList.remove("is-invalid");
    this.invalidFeedbackTarget.classList.add("d-none");
  }

  handleKeyup() {
    this.cleanErrors();
  }
}

