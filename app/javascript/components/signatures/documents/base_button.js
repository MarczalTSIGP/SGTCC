export default {
  data() {
    return {
      show: true,
    };
  },

  mounted() {
    this.onCloseSignatureButton();
    this.onOpenSignatureButton();
  },

  methods: {
    openSignatureButton() {
      this.show = true;
    },

    closeSignatureButton() {
      this.show = false;
    },

    onCloseSignatureButton() {
      this.$root.$on('close-signature-button', () => {
        this.closeSignatureButton();
      });
    },

    onOpenSignatureButton() {
      this.$root.$on('open-signature-button', () => {
        this.openSignatureButton();
      });
    },
  },
};
