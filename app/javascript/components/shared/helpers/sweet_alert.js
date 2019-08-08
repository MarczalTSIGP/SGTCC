import swal from 'sweetalert';

export default {
  methods: {
    showMessage(message, type) {
      swal('', message, type);
    },

    showWarningMessage(message) {
      this.showMessage(message, 'warning');
    },

    showSuccessMessage(message) {
      this.showMessage(message, 'success');
    },

    showErrorMessage(message) {
      this.showMessage(message, 'error');
    },

    confirmMessage(message) {
      return swal({
        title: '',
        text: message,
        icon: 'warning',
        buttons: true,
        dangerMode: true,
      });
    },
  },
};
