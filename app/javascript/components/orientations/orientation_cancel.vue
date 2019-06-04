<template>
  <div class="border border-danger rounded p-4">
    <div class="m-3">
      <div class="float-left">
        <strong>
          {{ $t('buttons.models.orientation.cancel.label') }}
        </strong>
        <p> {{ $t('buttons.models.orientation.cancel.details') }} </p>
      </div>
      <button
        v-if="show.button && hasPermission"
        id="orientation_cancel"
        type="button"
        class="float-right btn btn-outline-danger btn-sm"
        @click="showTextAreaAndHiddenButton('renew')"
      >
        {{ $t('buttons.models.orientation.cancel.label') }}
      </button>
    </div>
    <div class="clearfix" />
    <hr class="m-0">
    <div
      v-if="show.textArea"
      class="form-group orientation_cancel_justification m-3"
    >
      <label class="form-label">
        {{ label }}
        <abbr :title="$t('labels.required')">
          *
        </abbr>
      </label>
      <textarea
        id="orientation_cancel_justification"
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
      <div class="mt-4 float-right">
        <button
          id="save_justification"
          type="button"
          class="btn btn-primary"
          :disabled="hasErrors"
          @click="cancelOrientation()"
        >
          {{ $t('buttons.save') }}
        </button>
        <button
          id="cancel_justification"
          type="button"
          class="mr-2 btn btn-outline-danger"
          @click="close('renew')"
        >
          {{ $t('buttons.cancel') }}
        </button>
      </div>
      <div class="clearfix" />
    </div>
  </div>
</template>

<script>

import orientation_justification from './helpers/justification';
import flash_message from '../shared/helpers/flash_message';

export default {
  name: 'OrientationCancel',

  mixins: [orientation_justification, flash_message],

  computed: {
    url() {
      return `/responsible/orientations/${this.id}/cancel`;
    },
  },

  mounted() {
    this.listenCancelButtonEvents();
  },

  methods: {
    listenCancelButtonEvents() {
      this.$root.$on('show-cancel-button', (data) => {
        this.show.button = data;
      });
    },

    getData() {
      return {
        orientation: {
          cancellation_justification: this.justification
        }
      };
    },

    async cancelOrientation() {
      if (this.formIsInvalid()) {
        return false;
      }

      const response = await this.$axios.post(this.url, this.getData());
      this.showFlashMessage(response.data.message);
      this.updateStatus(response.data.orientation.status);
    },

    updateStatus(status) {
      this.closeTextArea();
      this.closeButton();
      this.$root.$emit('update-status', status);
      this.closeRenewButton();
    },

    closeRenewButton() {
      this.$root.$emit('show-renew-button', false);
    },
  },
};

</script>
