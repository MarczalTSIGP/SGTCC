<template>
  <div>
    <p>
      <strong>Status:</strong>
      <span class="badge badge-warning">
        {{ status }}
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
        {{ errors.renewalJustification[0] }}
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

    async renewOrientation() {
      if (this.formIsInvalid()) {
        return false;
      }
      const response = await this.$axios.get(this.url);
      console.log(response);
    },

    formIsInvalid() {
      if (this.renewalJustification === '') {
        this.errors.renewalJustification.push(this.invalidFeedbackMessage);
        this.errors.status = 'is-invalid';
        this.show.invalidFeedback = true;
        return true;
      }
      return false;
    },

    hasErrors() {
      this.errors.renewal_justification.length > 0;
    },

    cleanErrors() {
      this.errors.status = '';
      this.errors.renewalJustification = [];
    },

    close() {
      this.show.textArea = false;
      this.show.renewButton = true;
      this.cleanErrors();
    },
  },
};

</script>
