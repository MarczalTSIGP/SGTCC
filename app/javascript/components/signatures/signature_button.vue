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

export default {
  name: 'SignatureButton',

  props: {
    showTitle: {
      type: String,
      required: true
    },
  },

  data() {
    return {
      show: true,
    };
  },

  mounted() {
    this.onCloseSignatureButton();
    this.onOpenSignatureButton();
  },

  methods: {
    onCloseSignatureButton() {
      this.$root.$on('close-signature-button', () => {
        this.show = false;
      });
    },

    onOpenSignatureButton() {
      this.$root.$on('open-signature-button', () => {
        this.show = true;
      });
    },

    emitOpenLoginConfirmation() {
      this.$root.$emit('open-login-confirmation');
      this.$root.$emit('close-signature-download-button');
      this.$root.$emit('close-signature-button');
      this.$root.$emit('change-signature-show-title', this.showTitle);
    },
  },
};

</script>
