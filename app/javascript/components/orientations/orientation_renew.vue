<template>
  <div>
    <button
      v-if="showButton && hasPermission"
      id="renew_justification"
      type="button"
      class="btn btn-outline-primary btn-sm"
      @click="showTextAreaAndHiddenButton()"
    >
      {{ $t('buttons.models.orientation.renew') }}
    </button>
    <orientation-justification
      :label="label"
      :error-message="errorMessage"
      button-event="show-renew-button"
      save-justification-event="save-renewal-justification"
      name="orientation_renewal_justification"
    />
  </div>
</template>

<script>

import OrientationJustification from './orientation_justification';

export default {
  name: 'OrientationRenew',

  components: { OrientationJustification },

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
      showButton: true,
    };
  },

  computed: {
    url() {
      return `/responsible/orientations/${this.id}/renew`;
    },
  },

  mounted() {
    this.listenRenewButtonEvent();
    this.listenRenewalEvent();
  },

  methods: {
    showTextArea() {
      this.$root.$emit('show-justification-textarea', true);
    },

    closeTextArea() {
      this.$root.$emit('show-justification-textarea', false);
    },

    showTextAreaAndHiddenButton() {
      this.showButton = false;
      this.showTextArea();
    },

    listenRenewalEvent() {
      this.$root.$on('save-renewal-justification', (data) => {
        this.renewOrientation(data);
      });
    },

    listenRenewButtonEvent() {
      this.$root.$on('show-renew-button', (value) => {
        this.showButton = value;
      });
    },

    getData(justification) {
      return {
        orientation: {
          renewal_justification: justification
        }
      };
    },

    async renewOrientation(data) {
      const response = await this.$axios.post(this.url, this.getData(data));

      if (response.data.status == 'not_found') {
        return this.$root.$emit('add-justification-invalid-feedback', response.data.message);
      }

      this.showSuccessFlashMessage(response.data.message);
      this.update(response.data.status);
    },

    update(status) {
      this.closeTextArea();
      this.showButton = false;
      this.$root.$emit('update-status', status);
    },

    showSuccessFlashMessage(message) {
      const data = ['success', message];
      this.$root.$emit('add-flash-message', data);
    },
  },
};

</script>
