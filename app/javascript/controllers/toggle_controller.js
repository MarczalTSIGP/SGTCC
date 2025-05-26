import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  toggle(event) {
    event.preventDefault();

    const ebId = event.currentTarget.dataset.ebId;
    const target = document.getElementById(`eb-${ebId}`);
    if (target) {
      target.classList.toggle('d-none');
    }
  }
}
