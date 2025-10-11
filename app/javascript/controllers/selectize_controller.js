import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    const selects = this.element.querySelectorAll('[data-selectize]')
    selects.forEach(select => {
      $(select).selectize({
        plugins: ['remove_button'],
        create: false,
        sortField: 'text',
        placeholder: select.getAttribute('placeholder') || ''
      })
    })
  }
}
