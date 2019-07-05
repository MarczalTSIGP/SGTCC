<template>
  <div>
    <button
      v-if="show"
      id="signature_download_button"
      class="btn btn-outline-danger"
      @click="downloadPdf()"
    >
      Salvar em PDF
    </button>
  </div>
</template>

<script>

export default {
  name: 'SignatureDownloadButton',

  data() {
    return {
      show: true
    };
  },

  mounted() {
    this.onCloseSignatureDownloadButton();
    this.onOpenSignatureDownloadButton();
  },

  methods: {
    downloadPdf() {
      this.$htmlToPaper('term', () => {
        this.$root.$emit('download-document');
      });
    },

    onCloseSignatureDownloadButton() {
      this.$root.$on('close-signature-download-button', () => {
        this.show = false;
      });
    },

    onOpenSignatureDownloadButton() {
      this.$root.$on('open-signature-download-button', () => {
        this.show = true;
      });
    },
  },
};

</script>
