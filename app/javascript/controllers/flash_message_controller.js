import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    setTimeout(() => {
      this.element.classList.add('fade-out')
    }, 10000)
  }

  remove() {
    this.element.remove()
  }
} 