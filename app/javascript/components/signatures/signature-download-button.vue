<template>
  <div
    v-if="show"
    class="border border-primary rounded p-4"
  >
    <div class="float-left">
      <strong>Salvar documento em PDF</strong>
      <p>Este documento será salvo no formato PDF.</p>
    </div>

    <button
      id="signature_download_button"
      class="btn btn-outline-primary float-right mb-2"
      @click="downloadPdf()"
    >
      Salvar em PDF
    </button>

    <div class="clearfix" />
    <hr class="m-0">
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
