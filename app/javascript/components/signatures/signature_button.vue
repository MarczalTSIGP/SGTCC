<template>
  <button
    v-if="show"
    id="signature_button"
    class="btn btn-outline-primary float-right mb-2"
    @click="emitOpenLoginConfirmation()"
  >
    <i
      data-toggle="tooltip"
      title=""
      class="fas fa-file-signature"
      data-original-title="Assinar documento"
    />
    Assinar documento
  </button>
</template>

<script>
export default {
  name: 'SignatureButton',

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
    openSignatureButton() {
      this.show = true;
    },

    closeSignatureButton() {
      this.show = false;
    },

    emitOpenLoginConfirmation() {
      this.$root.$emit('open-login-confirmation');
      this.closeSignatureButton();
    },

    onCloseSignatureButton() {
      this.$root.$on('close-signature-button', () => {
        this.closeSignatureButton();
      });
    },

    onOpenSignatureButton() {
      this.$root.$on('open-signature-button', () => {
        this.openSignatureButton();
      });
    },
  },
};

</script>
