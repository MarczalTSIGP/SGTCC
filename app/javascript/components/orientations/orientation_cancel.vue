<template>
  <div>
    <button
      v-if="hasPermission"
      id="cancel_justification"
      type="button"
      class="btn btn-outline-danger btn-sm"
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
    return {};
  },

  computed: {
    url() {
      return `/responsible/orientations/${this.id}/cancel`;
    },
  },

  methods: {
    async cancelOrientation() {
      const response = await this.$axios.delete(this.url);

      if (response.data.status == 'not_found') {
        return this.addInvalidFeedback(response.data.message);
      }

      this.showSuccessFlashMessage(response.data.message);
      this.update(response.data.status);
    },

    showSuccessFlashMessage(message) {
      const data = ['success', message];
      this.$root.$emit('add-flash-message', data);
    },
  },
};

</script>
