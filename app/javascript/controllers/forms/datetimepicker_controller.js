import { Controller } from "@hotwired/stimulus"
import flatpickr from "flatpickr"
import { Portuguese } from "flatpickr/dist/l10n/pt"

export default class extends Controller {
  static targets = ["field", "input"]
  static values = { id: String }

  connect() {
    const initialDate = this.parseInitialDate()
    
    this.picker = flatpickr(this.fieldTarget, {
      enableTime: true,
      time_24hr: true,
      dateFormat: "d/m/Y H:i",
      locale: Portuguese,
      defaultDate: initialDate,
      allowInput: true,
      onChange: this.updateHidden.bind(this)
    })

    this.setupDateValidation()
    
    if (this.picker.selectedDates.length > 0) {
      this.updateHidden(this.picker.selectedDates, '')
    } else {
      const now = new Date()
      this.picker.setDate(now)
      this.updateHidden([now], '')
    }
  }

  disconnect() {
    if (this.picker) {
      this.picker.destroy()
    }
  }

  toggle(event) {
    event.preventDefault()
    if (this.picker) {
      this.picker.open()
    }
  }

  parseInitialDate() {
    const value = this.inputTarget.value
    if (!value || value === '') {
      return new Date()
    }

    const match = value.match(/(\d{2})\/(\d{2})\/(\d{4})\s+(\d{2}):(\d{2})/)
    if (match) {
      const [, day, month, year, hours, minutes] = match
      return new Date(year, month - 1, day, hours, minutes)
    }

    const isoMatch = value.match(/(\d{4})-(\d{2})-(\d{2})[T\s](\d{2}):(\d{2})/)
    if (isoMatch) {
      const [, year, month, day, hours, minutes] = isoMatch
      return new Date(year, month - 1, day, hours, minutes)
    }

    const parsed = new Date(value)
    return isNaN(parsed.getTime()) ? new Date() : parsed
  }

  updateHidden(selectedDates, dateStr) {
    if (selectedDates.length > 0) {
      const date = selectedDates[0]
      const displayFormat = flatpickr.formatDate(date, "d/m/Y H:i")
      const railsFormat = flatpickr.formatDate(date, "Y-m-d H:i:S")
      
      this.fieldTarget.value = displayFormat
      this.inputTarget.value = railsFormat
      
      this.notifyLinkedPickers()
    }
  }

  setupDateValidation() {
    const isInitialDate = this.idValue.includes('initial')
    const isFinalDate = this.idValue.includes('final')
    
    if (!isInitialDate && !isFinalDate) return

    setTimeout(() => {
      if (isInitialDate) {
        this.setupAsInitialDate()
      } else if (isFinalDate) {
        this.setupAsFinalDate()
      }
    }, 100)
  }

  setupAsInitialDate() {
    const finalPicker = this.findLinkedPicker('final')
    if (finalPicker?.picker) {
      const finalDate = finalPicker.picker.selectedDates[0]
      if (finalDate) {
        this.picker.set('maxDate', finalDate)
      }
    }
  }

  setupAsFinalDate() {
    const initialPicker = this.findLinkedPicker('initial')
    if (initialPicker?.picker) {
      const initialDate = initialPicker.picker.selectedDates[0]
      if (initialDate) {
        this.picker.set('minDate', initialDate)
      }
      this.picker.config.useCurrent = false
    }
  }

  notifyLinkedPickers() {
    const isInitialDate = this.idValue.includes('initial')
    const isFinalDate = this.idValue.includes('final')
    
    if (!isInitialDate && !isFinalDate) return

    const selectedDate = this.picker.selectedDates[0]
    if (!selectedDate) return

    if (isInitialDate) {
      const finalPicker = this.findLinkedPicker('final')
      if (finalPicker?.picker) {
        finalPicker.picker.set('minDate', selectedDate)
      }
    } else if (isFinalDate) {
      const initialPicker = this.findLinkedPicker('initial')
      if (initialPicker?.picker) {
        initialPicker.picker.set('maxDate', selectedDate)
      }
    }
  }

  findLinkedPicker(type) {
    const form = this.element.closest('form')
    if (!form) return null

    const searchId = type === 'initial' ? 'initial' : 'final'
    const allPickers = form.querySelectorAll('[data-controller*="forms--datetimepicker"]')
    
    for (const pickerElement of allPickers) {
      if (pickerElement === this.element) continue
      
      const idValue = pickerElement.getAttribute('data-forms--datetimepicker-id-value')
      if (idValue?.includes(searchId)) {
        return this.application.getControllerForElementAndIdentifier(
          pickerElement,
          'forms--datetimepicker'
        )
      }
    }
    
    return null
  }
}
