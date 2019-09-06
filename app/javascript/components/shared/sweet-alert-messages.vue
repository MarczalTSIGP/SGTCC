<template>
  <div />
</template>

<script>

import sweetAlert from '../shared/helpers/sweet-alert';

export default {
  name: 'SweetAlertMessages',

  mixins: [ sweetAlert ],

  props: {
    messages: {
      type: Array,
      default() {
        return [];
      },
    },
  },

  data() {
    return {
      alertMessages: [],
      types: {
        'error': 'error',
        'alert': 'warning',
        'notice': 'info',
        'success': 'success'
      },
    };
  },

  mounted() {
    this.setAlertMessages();
    this.showMessages();
  },

  methods: {
    setAlertMessages() {
      if (this.messages !== null) {
        this.alertMessages = this.messages;
      }
    },

    showMessages() {
      this.alertMessages.map((message, index) => {
        let type = this.types[message[index]];
        this.showMessage(message[1], type);
      });
    },
  },
};

</script>
