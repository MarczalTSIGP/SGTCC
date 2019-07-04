import swal from 'sweetalert';

export default {
  methods: {
    showWarningMessage(message) {
      swal('', message, 'warning');
    },

    showSuccessMessage(message) {
      swal('', message, 'success');
    },
  },
};
