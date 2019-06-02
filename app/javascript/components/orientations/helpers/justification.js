export default {
  props: {
    id: {
      type: Number,
      required: true
    },

    label: {
      type: String,
      required: true
    },

    errorMessage: {
      type: String,
      required: true
    },

    hasPermission: {
      type: Boolean,
      required: true
    }
  },

  data() {
    return {
      justification: '',
      show: {
        button: true,
        textArea: false,
        invalidFeedback: false
      },
      errors: {
        status: '',
        justification: [],
      }
    };
  },

  computed: {
    invalidFeedbackMessage() {
      return `${this.label} ${this.errorMessage}`;
    },

    hasErrors() {
      return this.errors.justification.length > 0;
    },
  },

  methods: {
    showTextArea() {
      this.show.textArea = true;
    },

    closeButton() {
      this.show.button = false;
    },

    showTextAreaAndHiddenButton() {
      this.closeButton();
      this.showTextArea();
    },

    formIsInvalid() {
      if (this.formIsEmpty() && this.hasNotErrors()) {
        this.addInvalidFeedback(this.invalidFeedbackMessage);
        return true;
      }
      this.cleanErrors();
      return false;
    },

    addInvalidFeedback(message) {
      this.errors.justification.push(message);
      this.errors.status = 'is-invalid';
      this.show.invalidFeedback = true;
    },

    formIsEmpty() {
      return this.justification === '';
    },

    hasNotErrors() {
      return this.errors.justification.length == 0;
    },

    cleanErrors() {
      this.errors.status = '';
      this.cleanJustificationErrors();
    },

    cleanJustificationErrors() {
      this.errors.justification = [];
    },

    closeTextArea() {
      this.show.textArea = false;
      this.cleanErrors();
    },

    close() {
      this.closeTextArea();
      this.show.button = true;
    },
  },
};
