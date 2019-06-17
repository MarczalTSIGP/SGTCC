<template>
  <button
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

  methods: {
    openLoginConfirmation() {
      this.$root.$emit('open-login-confirmation');
    },
  },
};

</script>
