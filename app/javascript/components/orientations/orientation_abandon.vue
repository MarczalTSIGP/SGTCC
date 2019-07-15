<template>
  <div
    v-if="show.box && hasPermission"
    class="border border-danger rounded p-4"
  >
    <div class="m-3">
      <div class="float-left">
        <strong>
          {{ $t('buttons.models.orientation.abandon.label') }}
        </strong>
        <p> {{ $t('buttons.models.orientation.abandon.details') }} </p>
      </div>
      <button
        v-if="show.button"
        id="orientation_cancel"
        type="button"
        class="float-right btn btn-outline-danger btn-sm"
        @click="confirmAbandonment()"
      >
        {{ $t('buttons.models.orientation.abandon.label') }}
      </button>
    </div>
    <div class="clearfix" />
    <hr class="m-0">
    <div
      v-if="show.textArea"
      class="form-group orientation_abandon_justification m-3"
    >
      <label class="form-label">
        {{ label }}
        <abbr :title="$t('labels.required')">
          *
        </abbr>
      </label>
      <textarea
        id="orientation_abandon_justification"
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
      <div class="mt-4 float-right">
        <button
          id="save_justification"
          type="button"
          class="btn btn-primary"
          :disabled="hasErrors"
          @click="abandonOrientation()"
        >
          {{ $t('buttons.save') }}
        </button>
        <button
          id="abandon_justification"
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
  name: 'OrientationAbandon',

  mixins: [orientation_justification, flash_message],

  computed: {
    url() {
      return `/professors/orientations/${this.id}/abandon`;
    },
  },

  mounted() {
    this.listenAbandonButton();
  },

  methods: {
    listenAbandonButton() {
      this.$root.$on('show-abandon-button', (data) => {
        this.show.button = data;
      });
    },

    getData() {
      return {
        orientation: {
          abandonment_justification: this.justification
        }
      };
    },

    async abandonOrientation() {
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
      this.closeBox();
      this.$root.$emit('update-status', status);
      this.closeRenewBox();
    },

    closeRenewBox() {
      this.$root.$emit('show-renew-box', false);
    },

    confirmAbandonment() {
      const abandon = confirm('Você tem certeza que deseja desistir dessa orientação?');

      if (abandon) {
        this.showTextAreaAndHiddenButton('renew');
      }
    },
  },
};

</script>
