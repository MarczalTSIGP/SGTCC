<template>
  <div class="mt-2">
    <div
      v-if="show.textArea"
      :class="`form-group ${name} mb-2`"
    >
      <label class="form-label">
        {{ label }}
        <abbr title="$t('labels.required')">
          *
        </abbr>
      </label>
      <textarea
        :id="name"
        v-model="justification"
        rows="5"
        :class="`form-control ${errors.status}`"
        @keyup="cleanJustificationErrors()"
      />
      <div
        v-show="show.invalidFeedback"
        class="invalid-feedback"
      >
        <ul>
          <li
            v-for="(error, index) in errors.justification"
            :key="index"
          >
            {{ error }}
          </li>
        </ul>
      </div>
      <div class="mt-2">
        <button
          id="save_justification"
          type="button"
          class="float-right btn btn-primary"
          :disabled="hasErrors"
          @click="saveJustification()"
        >
          {{ $t('buttons.save') }}
        </button>
        <button
          id="cancel_justification"
          type="button"
          class="mr-2 float-right btn btn-outline-danger"
          @click="close()"
        >
          {{ $t('buttons.cancel') }}
        </button>
      </div>
    </div>
  </div>
</template>

<script>

export default {
  name: 'OrientationJustification',

  props: {
    label: {
      type: String,
      required: true
    },

    name: {
      type: String,
      required: true
    },

    errorMessage: {
      type: String,
      required: true
    },

    buttonEvent: {
      type: String,
      required: true
    },

    saveJustificationEvent: {
      type: String,
      required: true
    },
  },

  data() {
    return {
      justification: '',
      show: {
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

  mounted() {
    this.showJustificationTextArea();
    this.onInvalidFeedback();
  },

  methods: {
    showJustificationTextArea() {
      this.$root.$on('show-justification-textarea', (value) => {
        this.show.textArea = value;
      });
    },

    onInvalidFeedback() {
      this.$root.$on('add-justification-invalid-feedback', (feedback) => {
        this.addInvalidFeedback(feedback);
      });
    },

    saveJustification() {
      if (this.formIsInvalid()) {
        return false;
      }

      this.$root.$emit(this.saveJustificationEvent, this.justification);
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
      this.$root.$emit(this.buttonEvent, true);
    },
  },
};

</script>
