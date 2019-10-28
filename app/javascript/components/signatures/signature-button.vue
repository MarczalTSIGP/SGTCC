<template>
  <div
    v-if="show"
    class="border border-primary rounded p-4 mb-2"
  >
    <div class="float-left">
      <strong>Assinar documento</strong>
      <p>Este documento será assinado eletronicamente.</p>
    </div>
    <button
      id="signature_button"
      class="btn btn-outline-primary float-right mb-2"
      @click="emitOpenLoginConfirmation()"
    >
      Assinar documento
    </button>
    <div class="clearfix" />
    <hr class="m-0">
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
