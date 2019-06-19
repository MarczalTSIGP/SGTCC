<template>
  <div>
    <div
      v-for="signature in signaturesMark"
      :key="signature.name"
      class="signature_mark"
    >
      <hr>
      <p>
        Documento assinado eletronicamente por <strong>{{ signature.name }}</strong>,
        em {{ signature.date }}, às {{ signature.time }}, conforme horário oficial de Brasília, com
        fundamento no art. 6º, § 1º, do <u>Decreto nº 8.539, de 8 de outubro de 2015</u>.
      </p>
      <hr>
    </div>
  </div>
</template>

<script>
export default {
  name: 'SignatureMark',

  props: {
    url: {
      type: String,
      required: true
    },
  },

  data() {
    return {
      signaturesMark: [],
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
