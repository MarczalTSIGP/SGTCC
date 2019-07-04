<template>
  <div
    v-if="open"
    class="col col-login mx-auto mb-3"
  >
    <div class="card-body p-6 border border-secondary rounded">
      <div class="card-title">
        <h5 class="text-center">
          Entre com seu {{ label }} e senha para assinar o documento.
        </h5>
      </div>
      <div class="form-group">
        <label class="form-label">
          {{ label }}
        </label>
        <input
          id="login_confirmation"
          v-model="login"
          type="text"
          class="form-control"
        >
      </div>
      <div class="form-group">
        <label class="form-label">
          Senha
        </label>
        <input
          id="password_confirmation"
          v-model="password"
          type="password"
          class="form-control"
          @keyup.enter="confirmLogin()"
        >
      </div>
      <div class="form-footer">
        <button
          id="login_confirmation_button"
          class="btn btn-primary btn-block"
          @click="confirmLogin()"
        >
          Assinar
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
  name: 'SignatuerConfirm',

  mixins: [sweetAlert],

  props: {
    label: {
      type: String,
      required: true
    },

    url: {
      type: String,
      required: true
    }
  },

  data() {
    return {
      login: '',
      password: '',
      open: false,
    };
  },

  computed: {
    errorMessage() {
      return `${this.label} ou senha inválidos!`;
    },
  },

  mounted() {
    this.onOpenLoginConfirmation();
  },

  methods: {
    onOpenLoginConfirmation() {
      this.$root.$on('open-login-confirmation', () => {
        this.open = true;
        this.$root.$emit('close-term-of-commitment');
        this.$root.$emit('close-signature-status');
      });
    },

    close() {
      this.open = false;
      this.$root.$emit('open-term-of-commitment');
      this.$root.$emit('open-signature-status');
      this.$root.$emit('open-signature-button');
      this.$root.$emit('change-signature-show-title', 'Visualizar documento');
    },

    async confirmLogin() {
      if (this.isEmpty(this.login) || this.isEmpty(this.password)) {
        return this.showWarningMessage(this.errorMessage);
      }

      const data = { login: this.login, password: this.password };
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
      this.$root.$emit('show-signatures-mark');
      this.$root.$emit('update-signature-status');
    },

    isEmpty(field) {
      return field === '';
    },
  },
};
</script>
