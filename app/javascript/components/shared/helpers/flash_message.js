export default {
  methods: {
    showFlashMessage(message, type = 'success') {
      const data = [type, message];
      this.$root.$emit('add-flash-message', data);
    },
  },
};
