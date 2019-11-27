import bsCustomFileInput from 'bs-custom-file-input';

export default {
  mounted() {
    this.initFileInput();
  },

  methods: {
    initFileInput() {
      bsCustomFileInput.init();
    },
  }
};
