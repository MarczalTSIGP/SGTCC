<template>
  <div>
    <p>
      <strong>Status:</strong>
      <span class="badge badge-warning">
        {{ labelStatus }}
      </span>
      <button
        v-if="show.renewButton && hasPermission"
        type="button"
        class="mb-2 btn btn-outline-primary btn-sm"
        @click="showJustifictionTextArea()"
      >
        <i class="fe fe-plus mr-2" />{{ $t('buttons.models.orientation.renew') }}
      </button>
    </p>
    <div
      v-if="show.textArea"
      class="form-group mb-2"
    >
      <label class="form-label">
        {{ label }}
        <abbr title="$t('labels.required')">
          *
        </abbr>
      </label>
      <textarea
        v-model="renewalJustification"
        rows="5"
        :class="`form-control ${errors.status}`"
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
          type="button"
          class="float-right btn btn-primary"
          @click="renewOrientation()"
        >
          {{ $t('buttons.save') }}
        </button>
        <button
          type="button"
          class="mr-2 float-right btn btn-outline-danger"
          @click="close()"
        >
          {{ $t('buttons.cancel') }}
        </button>
      </div>
    </div>
    <div class="clearfix" />
  </div>
</template>

<script>
export default {
  name: 'RenewOrientation',

  props: {
    id: {
      type: Number,
      required: true
    },

    label: {
      type: String,
      required: true
    },

    status: {
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
      labelStatus: '',
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
  },

  mounted() {
    this.labelStatus = this.status;
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
      this.update(response.data.orientation.status);
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

    hasErrors() {
      return this.errors.renewal_justification.length > 0;
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

    update(labelStatus) {
      this.closeTextArea();
      this.show.renewButton = false;
      this.labelStatus = labelStatus;
    },

    showSuccessFlashMessage(message) {
      const data = ['success', message];
      this.$root.$emit('add-flash-message', data);
    },
  },
};

</script>
