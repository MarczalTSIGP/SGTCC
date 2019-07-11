<template>
  <div>
    <div v-if="signatureCode.all_signed">
      <hr class="m-0">
      <div class="signature_code">
        <div class="py-4">
          <div class="float-left mr-2">
            <vue-qrcode
              :value="urlSignatureShow"
              :options="{ width: 100 }"
            />
          </div>
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
        <div class="clearfix" />
      </div>
      <hr class="m-0">
    </div>
  </div>
</template>

<script>

import VueQrcode from '@chenfengyuan/vue-qrcode';

export default {
  name: 'SignatureCode',

  components: { VueQrcode },

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

  computed: {
    urlSignatureShow() {
      return `${this.signatureCode.link}/${this.signatureCode.code}`;
    },
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
        this.setSignatureCode();
      });
    },
  },
};
</script>
