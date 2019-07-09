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
            :src="urlSignatureImage"
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
      <signature-code :url-signature-code="urlSignatureCode" />
    </div>
  </div>
</template>

<script>

import SignatureCode from './signature_code';

export default {
  name: 'SignatureMark',

  components: { SignatureCode },

  props: {
    url: {
      type: String,
      required: true
    },

    urlSignatureCode: {
      type: String,
      required: true
    },

    urlSignatureImage: {
      type: String,
      required: true
    }
  },

  data() {
    return {
      signaturesMark: [],
      imageWidth: 100,
    };
  },

  mounted() {
    this.setSignaturesMark();
    this.onShowSignaturesMark();
  },

  methods: {
    async setSignaturesMark() {
      const response = await this.$axios.post(this.url);

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
