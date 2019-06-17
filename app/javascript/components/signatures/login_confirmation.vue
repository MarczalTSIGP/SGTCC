<template>
  <div
    v-if="open"
    class="col col-login mx-auto mb-3"
  >
    <div class="card-body p-6 border border-secondary rounded">
      <div class="card-title">
        <h4 class="text-center">
          Confirmar login
        </h4>
      </div>
      <div class="form-group">
        <label class="form-label">
          Usuário institucional
        </label>
        <input
          v-model="username"
          type="text"
          class="form-control"
        >
      </div>
      <div class="form-group">
        <label class="form-label">
          Senha
        </label>
        <input
          v-model="password"
          type="password"
          class="form-control"
        >
      </div>
      <div class="form-footer">
        <button
          class="btn btn-primary btn-block"
          @click="confirmLogin()"
        >
          Confirmar
        </button>
        <button
          class="btn btn-outline-danger btn-block"
          @click="close()"
        >
          Cancelar
        </button>
      </div>
    </div>
  </div>
</template>

<script>

import swal from 'sweetalert';

export default {
  name: 'LoginConfirmation',

  props: {
    url: {
      type: String,
      required: true
    }
  },

  data() {
    return {
      username: '',
      password: '',
      open: false,
    };
  },

  mounted() {
    this.listenOpenLoginConfirmationEvent();
  },

  methods: {
    listenOpenLoginConfirmationEvent() {
      this.$root.$on('open-login-confirmation', () => {
        this.open = true;
        this.closeDocumentBox();
      });
    },

    close() {
      this.open = false;
      this.openDocumentBox();
    },

    openDocumentBox() {
      this.$root.$emit('open-term-of-commitment');
    },

    closeDocumentBox() {
      this.$root.$emit('close-term-of-commitment');
    },

    closeSignatureButton() {
      this.$root.$emit('close-signature-button');
    },

    showSignatureMark() {
      this.$root.$emit('show-signature-mark');
    },

    async confirmLogin() {
      if (this.isEmpty(this.username) || this.isEmpty(this.password)) {
        swal('', 'Usuário institucional ou senha inválidos!', 'warning');
        return;
      }

      const data = { username: this.username, password: this.password };
      const response = await this.$axios.post(this.url, data);

      if (response.data.status === 'internal_server_error') {
        swal('', response.data.message, 'warning');
        return;
      }

      swal('', response.data.message, 'success');
      this.close();
      this.closeSignatureButton();
      this.showSignatureMark();
    },

    isEmpty(field) {
      return field === '';
    },
  },
};
</script>
