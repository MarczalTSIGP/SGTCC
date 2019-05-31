<template>
  <div>
    <div class="row">
      <div class="rol-6">
        <strong class="ml-3 mr-2 d-block">
          Status:
        </strong>
      </div>
      <div class="rol-3">
        <orientation-status
          :status="statusEnum"
          :label="status"
        />
      </div>
      <div class="rol-6">
        <button
          v-if="show.renewButton && hasPermission"
          id="renew_justification"
          type="button"
          class="ml-3 mb-2 btn btn-outline-primary btn-sm"
          @click="showJustifictionTextArea()"
        >
          <i class="fe fe-plus mr-2" />{{ $t('buttons.models.orientation.renew') }}
        </button>
      </div>
    </div>
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
    <div class="clearfix" />
  </div>
</template>

<script>

import OrientationStatus from './orientation_status';

export default {
  name: 'OrientationRenew',

  components: { OrientationStatus },

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

    statusEnum: {
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
