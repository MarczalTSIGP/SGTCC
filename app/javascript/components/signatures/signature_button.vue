<template>
  <div>
    <button
      v-if="show"
      id="signature_button"
      class="btn btn-outline-primary"
      @click="emitOpenLoginConfirmation()"
    >
      Assinar documento
    </button>
  </div>
</template>

<script>

import baseButton from './documents/base_button';

export default {
  name: 'SignatureButton',

  mixins: [baseButton],

  props: {
    showTitle: {
      type: String,
      required: true
    },
  },

  methods: {
    emitOpenLoginConfirmation() {
      this.$root.$emit('open-login-confirmation');
      this.$root.$emit('close-signature-button');
      this.$root.$emit('change-signature-show-title', this.showTitle);
    },
  },
};

</script>
