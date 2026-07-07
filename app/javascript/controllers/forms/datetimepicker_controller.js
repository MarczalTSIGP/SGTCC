import { Controller } from "@hotwired/stimulus";
import flatpickr from "flatpickr";
import { Portuguese } from "flatpickr/dist/l10n/pt";

export default class extends Controller {
  static targets = ["field", "input"];
  static values = { id: String, enableTime: Boolean };

  connect() {
    const initialDate = this.parseInitialDate();
    this.beforeSubmit = this.commitManualValue.bind(this);
    this.form = this.element.closest("form");
    
    this.picker = flatpickr(this.fieldTarget, {
      enableTime: this.enableTimeValue,
      time_24hr: this.enableTimeValue,
      dateFormat: this.enableTimeValue ? "d/m/Y H:i" : "d/m/Y",
      locale: Portuguese,
      defaultDate: initialDate,
      allowInput: true,
      onChange: this.updateHidden.bind(this),
      onClose: this.commitManualValue.bind(this)
    });

    this.setupDateValidation();
    
    if (this.picker.selectedDates.length > 0) {
      this.updateHidden(this.picker.selectedDates, "");
    } else {
      const now = new Date();
      this.picker.setDate(now);
      this.updateHidden([now], "");
    }

    if (this.form) {
      this.form.addEventListener("submit", this.beforeSubmit);
    }
  }

  disconnect() {
    if (this.form) {
      this.form.removeEventListener("submit", this.beforeSubmit);
    }

    if (this.picker) {
      this.picker.destroy();
    }
  }

  toggle(event) {
    event.preventDefault();
    if (this.picker) {
      this.picker.open();
    }
  }

  submitManualValue(event) {
    event.preventDefault();
    this.commitManualValue();
    this.fieldTarget.blur();
  }

  allowOnlyDateCharacters(event) {
    if (this.handleSeparatorDeletion(event)) return;
    if (event.inputType && !event.inputType.startsWith("insert")) return;
    if (!event.data) return;

    if (!/^[\d/: ]+$/.test(event.data)) {
      event.preventDefault();
    }
  }

  handleSeparatorDeletion(event) {
    if (!["deleteContentBackward", "deleteContentForward"].includes(event.inputType)) {
      return false;
    }

    const selectionStart = this.fieldTarget.selectionStart;
    const selectionEnd = this.fieldTarget.selectionEnd;
    if (selectionStart === null || selectionEnd === null || selectionStart !== selectionEnd) {
      return false;
    }

    const value = this.fieldTarget.value;
    const direction = event.inputType === "deleteContentBackward" ? -1 : 1;
    const separatorIndex = direction === -1 ? selectionStart - 1 : selectionStart;
    if (!this.isSeparator(value[separatorIndex])) return false;

    event.preventDefault();

    const digits = value.replace(/\D/g, "");
    const digitOffset = value.slice(0, selectionStart).replace(/\D/g, "").length;
    const digitIndex = direction === -1 ? digitOffset - 1 : digitOffset;
    if (digitIndex < 0 || digitIndex >= digits.length) return true;

    const nextDigits = `${digits.slice(0, digitIndex)}${digits.slice(digitIndex + 1)}`;
    const maskedValue = this.maskValue(nextDigits);

    this.fieldTarget.value = maskedValue;
    this.restoreCaretPosition(maskedValue, digitIndex, { skipSeparators: false });
    this.syncHiddenFromField();

    return true;
  }

  isSeparator(character) {
    return /[/: ]/.test(character || "");
  }

  maskManualValue() {
    if (this.fieldTarget.disabled) return;

    const rawValue = this.fieldTarget.value;
    const digitOffset = this.countDigitsBeforeCaret(rawValue);
    const maskedValue = this.maskValue(rawValue);

    this.fieldTarget.value = maskedValue;
    this.restoreCaretPosition(maskedValue, digitOffset);

    this.syncHiddenFromField();
  }

  syncHiddenFromField() {
    const parsedDate = this.parseDateValue(this.fieldTarget.value);
    if (parsedDate) {
      this.updateHidden([parsedDate], { updateField: false });
    } else {
      this.inputTarget.value = "";
    }
  }

  commitManualValue() {
    if (this.fieldTarget.disabled) return;

    const rawValue = this.fieldTarget.value?.trim();
    if (!rawValue) {
      this.inputTarget.value = "";
      return;
    }

    const parsedDate = this.parseDateValue(rawValue);
    if (!parsedDate) {
      this.inputTarget.value = "";
      return;
    }

    this.picker.setDate(parsedDate, true);
  }

  maskValue(value) {
    const digits = value.replace(/\D/g, "").slice(0, this.enableTimeValue ? 12 : 8);
    const dateParts = [
      digits.slice(0, 2),
      digits.slice(2, 4),
      digits.slice(4, 8)
    ].filter(Boolean);

    let maskedValue = dateParts.join("/");
    if (!this.enableTimeValue || digits.length <= 8) return maskedValue;

    const timeDigits = digits.slice(8, 12);
    const timeParts = [
      timeDigits.slice(0, 2),
      timeDigits.slice(2, 4)
    ].filter(Boolean);

    return `${maskedValue} ${timeParts.join(":")}`;
  }

  countDigitsBeforeCaret(value) {
    const caretPosition = this.fieldTarget.selectionStart ?? value.length;
    return value.slice(0, caretPosition).replace(/\D/g, "").length;
  }

  restoreCaretPosition(value, digitOffset, options = {}) {
    if (document.activeElement !== this.fieldTarget) return;

    let digitCount = 0;
    let caretPosition = value.length;

    if (digitOffset === 0) {
      caretPosition = 0;
    } else {
      for (let index = 0; index < value.length; index++) {
        if (/\d/.test(value[index])) digitCount += 1;

        if (digitCount === digitOffset) {
          caretPosition = index + 1;
          break;
        }
      }
    }

    while (options.skipSeparators !== false && caretPosition < value.length && /\D/.test(value[caretPosition])) {
      caretPosition += 1;
    }

    this.fieldTarget.setSelectionRange(caretPosition, caretPosition);
  }

  parseInitialDate() {
    const value = this.inputTarget.value;
    if (!value || value === "") {
      return new Date();
    }

    return this.parseDateValue(value) || new Date();
  }

  parseDateValue(value) {
    if (!value) return null;

    const match = value.match(/^(\d{2})\/(\d{2})\/(\d{4})\s+(\d{2}):(\d{2})$/);
    if (match) {
      const [, day, month, year, hours, minutes] = match;
      return this.buildDate(year, month, day, hours, minutes);
    }

    const isoMatch = value.match(/^(\d{4})-(\d{2})-(\d{2})[T\s](\d{2}):(\d{2})/);
    if (isoMatch) {
      const [, year, month, day, hours, minutes] = isoMatch;
      return this.buildDate(year, month, day, hours, minutes);
    }

    const dateOnlyMatch = value.match(/^(\d{2})\/(\d{2})\/(\d{4})$/);
    if (dateOnlyMatch) {
      const [, day, month, year] = dateOnlyMatch;
      return this.buildDate(year, month, day, 0, 0);
    }

    const isoDateOnlyMatch = value.match(/^(\d{4})-(\d{2})-(\d{2})$/);
    if (isoDateOnlyMatch) {
      const [, year, month, day] = isoDateOnlyMatch;
      return this.buildDate(year, month, day, 0, 0);
    }

    return null;
  }

  buildDate(year, month, day, hours, minutes) {
    const date = new Date(year, month - 1, day, hours, minutes);
    const isValid =
      date.getFullYear() === Number(year) &&
      date.getMonth() === Number(month) - 1 &&
      date.getDate() === Number(day) &&
      date.getHours() === Number(hours) &&
      date.getMinutes() === Number(minutes);

    return isValid ? date : null;
  }

  updateHidden(selectedDates, options = {}) {
    if (selectedDates.length > 0) {
      const date = selectedDates[0];
      const displayFormat = flatpickr.formatDate(
        date,
        this.enableTimeValue ? "d/m/Y H:i" : "d/m/Y"
      );
      const railsFormat = flatpickr.formatDate(
        date,
        this.enableTimeValue ? "Y-m-d H:i:S" : "Y-m-d"
      );
      
      if (options.updateField !== false) {
        this.fieldTarget.value = displayFormat;
      }
      this.inputTarget.value = railsFormat;
      
      this.notifyLinkedPickers();
    }
  }

  setupDateValidation() {
    const isInitialDate = this.idValue.includes("initial");
    const isFinalDate = this.idValue.includes("final");
    
    if (!isInitialDate && !isFinalDate) return;

    setTimeout(() => {
      if (isInitialDate) {
        this.setupAsInitialDate();
      } else if (isFinalDate) {
        this.setupAsFinalDate();
      }
    }, 100);
  }

  setupAsInitialDate() {
    const finalPicker = this.findLinkedPicker("final");
    if (finalPicker?.picker) {
      const finalDate = finalPicker.picker.selectedDates[0];
      if (finalDate) {
        this.picker.set("maxDate", finalDate);
      }
    }
  }

  setupAsFinalDate() {
    const initialPicker = this.findLinkedPicker("initial");
    if (initialPicker?.picker) {
      const initialDate = initialPicker.picker.selectedDates[0];
      if (initialDate) {
        this.picker.set("minDate", initialDate);
      }
      this.picker.config.useCurrent = false;
    }
  }

  notifyLinkedPickers() {
    const isInitialDate = this.idValue.includes("initial");
    const isFinalDate = this.idValue.includes("final");
    
    if (!isInitialDate && !isFinalDate) return;

    const selectedDate = this.picker.selectedDates[0];
    if (!selectedDate) return;

    if (isInitialDate) {
      const finalPicker = this.findLinkedPicker("final");
      if (finalPicker?.picker) {
        finalPicker.picker.set("minDate", selectedDate);
      }
    } else if (isFinalDate) {
      const initialPicker = this.findLinkedPicker("initial");
      if (initialPicker?.picker) {
        initialPicker.picker.set("maxDate", selectedDate);
      }
    }
  }

  findLinkedPicker(type) {
    const form = this.element.closest("form");
    if (!form) return null;

    const searchId = type === "initial" ? "initial" : "final";
    const allPickers = form.querySelectorAll("[data-controller*=\"forms--datetimepicker\"]");
    
    for (const pickerElement of allPickers) {
      if (pickerElement === this.element) continue;
      
      const idValue = pickerElement.getAttribute("data-forms--datetimepicker-id-value");
      if (idValue?.includes(searchId)) {
        return this.application.getControllerForElementAndIdentifier(
          pickerElement,
          "forms--datetimepicker"
        );
      }
    }
    
    return null;
  }
}
