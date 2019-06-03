<template>
  <div>
    <button
      v-if="show.button && hasPermission"
      id="renew_justification"
      type="button"
      class="btn btn-outline-primary btn-sm"
      @click="showTextAreaAndHiddenButton('cancel')"
    >
      {{ $t('buttons.models.orientation.renew') }}
    </button>
    <div class="mt-2">
      <div
        v-if="show.textArea"
        class="form-group orientation_renewal_justification mb-2"
      >
        <label class="form-label">
          {{ label }}
          <abbr :title="$t('labels.required')">
            *
          </abbr>
        </label>
        <textarea
          id="orientation_renewal_justification"
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
            @click="renewOrientation()"
          >
            {{ $t('buttons.save') }}
          </button>
          <button
            id="cancel_justification"
            type="button"
            class="mr-2 float-right btn btn-outline-danger"
            @click="close('cancel')"
          >
            {{ $t('buttons.cancel') }}
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<script>

import orientation_justification from './helpers/justification';
import flash_message from '../shared/helpers/flash_message';

export default {
  name: 'OrientationRenew',

  mixins: [orientation_justification, flash_message],

  computed: {
    url() {
      return `/responsible/orientations/${this.id}/renew`;
    },
  },

  mounted() {
    this.listenRenewButtonEvents();
  },

  methods: {
    listenRenewButtonEvents() {
      this.$root.$on('show-renew-button', (data) => {
        this.show.button = data;
      });
    },

    getData() {
      return {
        orientation: {
          renewal_justification: this.justification
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

      this.showFlashMessage(response.data.message);
      this.update(response.data.orientation.status);
    },

    update(status) {
      this.closeTextArea();
      this.show.button = false;
      this.$root.$emit('update-status', status);
    },
  },
};

</script>
