<template>
  <button
    v-if="show"
    class="btn btn-outline-primary float-right mb-2"
    @click="openLoginConfirmation()"
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
    this.onSignatureButtonEvent();
  },

  methods: {
    openLoginConfirmation() {
      this.$root.$emit('open-login-confirmation');
    },

    onSignatureButtonEvent() {
      this.$root.$on('close-signature-button', () => {
        this.show = false;
      });
    },
  },
};

</script>
