<template>
  <div
    v-if="show.box && hasPermission"
    class="border border-primary rounded p-4"
  >
    <div class="m-3">
      <div class="float-left">
        <strong>
          {{ $t('buttons.models.orientation.renew.label') }}
        </strong>
        <p> {{ $t('buttons.models.orientation.renew.details') }} </p>
      </div>
      <button
        v-if="show.button"
        id="renew_justification"
        type="button"
        class="float-right btn btn-outline-primary btn-sm"
        @click="showTextAreaAndHiddenButton('cancel')"
      >
        {{ $t('buttons.models.orientation.renew.label') }}
      </button>
    </div>
    <div class="clearfix" />
    <hr class="m-0">
    <div
      v-if="show.textArea"
      class="form-group orientation_renewal_justification m-3"
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
        @keyup="cleanErrors()"
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
      <div class="float-right mt-2">
        <button
          id="save_justification"
          type="button"
          class="btn btn-primary"
          :disabled="hasErrors"
          @click="renewOrientation()"
        >
          {{ $t('buttons.save') }}
        </button>
        <button
          id="cancel_justification"
          type="button"
          class="mr-2 btn btn-outline-danger"
          @click="close('cancel')"
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
import flash_message from '../shared/helpers/flash-message';

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
    this.listenRenewBoxEvents();
  },

  methods: {
    listenRenewButtonEvents() {
      this.$root.$on('show-renew-button', (data) => {
        this.show.button = data;
      });
    },

    listenRenewBoxEvents() {
      this.$root.$on('show-renew-box', (data) => {
        this.show.box = data;
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
      this.$root.$emit('update-status', status);
      this.closeTextArea();
      this.closeButton();
      this.closeBox();
      this.showCancelButton();
    },

    showCancelButton() {
      this.$root.$emit('show-cancel-button', true);
    },
  },
};

</script>
