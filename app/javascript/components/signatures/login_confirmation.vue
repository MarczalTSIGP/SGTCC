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
          @click.prevent="confirmLogin()"
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

import flash_messages from '../shared/helpers/flash_message';

export default {
  name: 'LoginConfirmation',

  mixins: [flash_messages],

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
        this.$root.$emit('close-term-of-commitment');
      });
    },

    close() {
      this.open = false;
      this.$root.$emit('open-term-of-commitment');
    },

    confirmLogin() {
      if (this.isEmpty(this.username) || this.isEmpty(this.password)) {
        this.showFlashMessage('Usuário institucional ou senha inválidos.', 'alert');
      }
    },

    isEmpty(field) {
      return field === '';
    },
  },
};
</script>
