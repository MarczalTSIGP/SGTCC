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

import sweetAlert from '../shared/helpers/sweet_alert';

export default {
  name: 'LoginConfirmation',

  mixins: [sweetAlert],

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
    this.onOpenLoginConfirmation();
  },

  methods: {
    onOpenLoginConfirmation() {
      this.$root.$on('open-login-confirmation', () => {
        this.open = true;
        this.$root.$emit('close-term-of-commitment');
      });
    },

    close() {
      this.open = false;
      this.$root.$emit('open-term-of-commitment');
      this.$root.$emit('open-signature-button');
    },

    async confirmLogin() {
      if (this.isEmpty(this.username) || this.isEmpty(this.password)) {
        return this.showWarningMessage('Usuário institucional ou senha inválidos!');
      }

      const data = { username: this.username, password: this.password };
      const response = await this.$axios.post(this.url, data);
      const message = response.data.message;

      if (response.data.status === 'internal_server_error') {
        return this.showWarningMessage(message);
      }

      this.afterSaveSignature(message);
    },

    afterSaveSignature(message) {
      this.showSuccessMessage(message);
      this.close();
      this.$root.$emit('close-signature-button');
      this.$root.$emit('show-signature-mark');
    },

    isEmpty(field) {
      return field === '';
    },
  },
};
</script>
