<template>
  <div>
    <button
      v-if="show.cancelButton && hasPermission"
      id="orientation_cancel"
      type="button"
      class="btn btn-outline-danger btn-sm"
      @click="confirmCancellation()"
    >
      {{ $t('buttons.models.orientation.cancel') }}
    </button>
    <div
      v-if="show.textArea"
      class="form-group orientation_cancel_justification mb-2"
    >
      <label class="form-label">
        {{ label }}
        <abbr title="$t('labels.required')">
          *
        </abbr>
      </label>
      <textarea
        id="orientation_cancel_justification"
        v-model="cancelJustification"
        rows="5"
        :class="`form-control ${errors.status}`"
        @keyup="errors.cancelJustification = []"
      />
      <div
        v-show="show.invalidFeedback"
        class="invalid-feedback"
      >
        <ul>
          <li
            v-for="(error, index) in errors.cancelJustification"
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
          @click="cancelOrientation()"
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
  name: 'OrientationCancel',

  props: {
    id: {
      type: Number,
      required: true
    },

    hasPermission: {
      type: Boolean,
      required: true
    }
  },

  data() {
    return {
      cancelJustification: '',
      show: {
        textArea: false,
        invalidFeedback: false,
        cancelButton: true
      },
      errors: {
        status: '',
        cancelJustification: [],
      }
    };
  },

  computed: {
    url() {
      return `/responsible/orientations/${this.id}/cancel`;
    },

    invalidFeedbackMessage() {
      return `${this.label} ${this.errorMessage}`;
    },

    hasErrors() {
      return this.errors.cancelJustification.length > 0;
    },
  },

  methods: {
    async cancelOrientation() {
      const response = await this.$axios.post(this.url);
      this.showFlashMessage(response.data.message);
      this.updateStatus(response.data.orientation.status);
      this.show.cancelButton = false;
    },

    showFlashMessage(message, type = 'success') {
      const data = [type, message];
      this.$root.$emit('add-flash-message', data);
    },

    confirmCancellation() {
      const cancel = confirm('Você tem certeza que deseja cancelar essa orientação?');

      if (cancel) {
        this.cancelOrientation();
      }
    },

    updateStatus(status) {
      this.$root.$emit('update-status', status);
      this.$root.$emit('show-renew-button', false);
    },
  },
};

</script>
