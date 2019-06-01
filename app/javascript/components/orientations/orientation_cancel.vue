<template>
  <div>
    <button
      v-if="showCancelButton && hasPermission"
      id="orientation_cancel"
      type="button"
      class="btn btn-outline-danger btn-sm"
      @click="confirmCancellation()"
    >
      {{ $t('buttons.models.orientation.cancel') }}
    </button>
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
      showCancelButton: true,
    };
  },

  computed: {
    url() {
      return `/responsible/orientations/${this.id}/cancel`;
    },
  },

  methods: {
    async cancelOrientation() {
      const response = await this.$axios.post(this.url);
      this.showFlashMessage(response.data.message);
      this.updateStatus(response.data.orientation.status);
      this.showCancelButton = false;
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
