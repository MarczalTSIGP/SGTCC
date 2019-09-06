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

  props: {
    headTitle: {
      type: String,
      required: true
    },

    documentTitle: {
      type: String,
      required: true
    }
  },

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
      this.updateHeadTitle(this.documentTitle);
      this.$htmlToPaper('term', () => {
        this.$root.$emit('download-document');
        this.updateHeadTitle(this.headTitle);
      });
    },

    updateHeadTitle(title) {
      document.title = title;
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
