<template>
  <div>
    <div>
      <hr class="m-0">
      <div
        v-for="signature in signaturesMark"
        :key="signature.name"
        class="signature_mark"
      >
        <div class="py-4">
          <img
            class="float-left mr-2"
            :src="sgtccSealImage"
            :style="{ width: imageWidth + 'px' }"
          >
          <p>
            Documento assinado eletronicamente por <strong>{{ signature.name }}, {{ signature.role }},</strong>
            em {{ signature.date }}, às {{ signature.time }}, conforme horário oficial de Brasília, com
            fundamento no art. 6º, § 1º, do
            <u>
              <a
                href="http://www.planalto.gov.br/ccivil_03/_Ato2015-2018/2015/Decreto/D8539.htm"
                target="_blank"
                class="text-dark"
              >
                Decreto nº 8.539, de 8 de outubro de 2015
              </a>
            </u>.
          </p>
        </div>
        <hr class="m-0">
        <div class="clearfix" />
      </div>
    </div>
    <div>
      <signature-code :document-id="documentId" />
    </div>
  </div>
</template>

<script>

import SignatureCode from './signature_code';

export default {
  name: 'SignatureMark',

  components: { SignatureCode },

  props: {
    documentId: {
      type: Number,
      required:true
    },
  },

  data() {
    return {
      urlDocumentImages: '/documents/images',
      signaturesMark: [],
      imageWidth: 100,
      sgtccSealImage: '',
    };
  },

  computed: {
    urlSignatureMark() {
      return `/documents/${this.documentId}/mark`;
    },
  },

  mounted() {
    this.setSrcSignatureImage();
    this.setSignaturesMark();
    this.onShowSignaturesMark();
  },

  methods: {
    async setSrcSignatureImage() {
      const response = await this.$axios.get(this.urlDocumentImages);
      this.sgtccSealImage = response.data.sgtcc_seal;
    },

    async setSignaturesMark() {
      const response = await this.$axios.post(this.urlSignatureMark);

      this.signaturesMark = response.data;
    },

    onShowSignaturesMark() {
      this.$root.$on('show-signatures-mark', () => {
        this.setSignaturesMark();
      });
    },
  },
};
</script>
