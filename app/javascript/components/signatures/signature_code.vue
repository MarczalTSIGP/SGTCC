<template>
  <div>
    <div v-if="signatureCode.all_signed">
      <hr class="m-0">
      <div class="signature_code">
        <div class="py-4">
          <img
            class="float-left mr-2"
            src="./documents/assets/images/sgtcc_signature.png"
            :style="{ width: imageWidth + 'px' }"
          >
          <p>
            A autenticidade deste documento pode ser conferida no site
            <u>
              <a
                :href="signatureCode.link"
                target="_blank"
                class="text-dark"
              >
                {{ signatureCode.link }}
              </a>
            </u>, informando o código verificador <b>{{ signatureCode.code }}</b>.
          </p>
        </div>
        <hr class="m-0">
        <div class="clearfix" />
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'SignatureCode',

  props: {
    urlSignatureCode: {
      type: String,
      required:true
    }
  },

  data() {
    return {
      signatureCode: [],
      imageWidth: 100,
    };
  },

  mounted() {
    this.setSignatureCode();
    this.onShowSignaturesMark();
  },

  methods: {
    async setSignatureCode() {
      const response = await this.$axios.post(this.urlSignatureCode);

      this.signatureCode = response.data;
    },

    onShowSignaturesMark() {
      this.$root.$on('show-signatures-mark', () => {
        this.setSignaturesCode();
      });
    },
  },
};
</script>
