import { Controller } from '@hotwired/stimulus';

// Connects to data-controller="file-input"
export default class extends Controller {
  static targets = ['input', 'label'];

  change(event) {
    const file = event.target.files[0];
    const fileName = file ? file.name : 'Procurar arquivo...';
    this.labelTarget.textContent = fileName;
  }
}