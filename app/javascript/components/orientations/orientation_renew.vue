<template>
  <div>
    <button
      v-if="show.renewButton && hasPermission"
      id="renew_justification"
      type="button"
      class="btn btn-outline-primary btn-sm"
      @click="showJustifictionTextArea()"
    >
      {{ $t('buttons.models.orientation.renew') }}
    </button>
    <div
      v-if="show.textArea"
      class="form-group orientation_renewal_justification mb-2"
    >
      <label class="form-label">
        {{ label }}
        <abbr title="$t('labels.required')">
          *
        </abbr>
      </label>
      <textarea
        id="orientation_renewal_justification"
        v-model="renewalJustification"
        rows="5"
        :class="`form-control ${errors.status}`"
        @keyup="errors.renewalJustification = []"
      />
      <div
        v-show="show.invalidFeedback"
        class="invalid-feedback"
      >
        <ul>
          <li
            v-for="(error, index) in errors.renewalJustification"
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
          @click="renewOrientation()"
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
  name: 'OrientationRenew',

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
      renewalJustification: '',
      show: {
        textArea: false,
        invalidFeedback: false,
        renewButton: true
      },
      errors: {
        status: '',
        renewalJustification: [],
      }
    };
  },

  computed: {
    url() {
      return `/responsible/orientations/${this.id}/renew`;
    },

    invalidFeedbackMessage() {
      return `${this.label} ${this.errorMessage}`;
    },

    hasErrors() {
      return this.errors.renewalJustification.length > 0;
    },
  },

  methods: {
    showJustifictionTextArea() {
      this.show.textArea = true;
      this.show.renewButton = false;
    },

    getData() {
      return {
        orientation: {
          renewal_justification: this.renewalJustification
        }
      };
    },

    async renewOrientation() {
      if (this.formIsInvalid()) {
        return false;
      }

      const response = await this.$axios.post(this.url, this.getData());

      if (response.data.status == 'not_found') {
        return this.addInvalidFeedback(response.data.message);
      }

      this.showSuccessFlashMessage(response.data.message);
      this.update(response.data.status);
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
      this.errors.renewalJustification.push(message);
      this.errors.status = 'is-invalid';
      this.show.invalidFeedback = true;
    },

    formIsEmpty() {
      return this.renewalJustification === '';
    },

    hasNotErrors() {
      return this.errors.renewalJustification.length == 0;
    },

    cleanErrors() {
      this.errors.status = '';
      this.errors.renewalJustification = [];
    },

    closeTextArea() {
      this.show.textArea = false;
      this.cleanErrors();
    },

    close() {
      this.closeTextArea();
      this.show.renewButton = true;
    },

    update(status) {
      this.closeTextArea();
      this.show.renewButton = false;
      this.$root.$emit('update-status', status);
    },

    showSuccessFlashMessage(message) {
      const data = ['success', message];
      this.$root.$emit('add-flash-message', data);
    },
  },
};

</script>
