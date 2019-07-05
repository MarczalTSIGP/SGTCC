<template>
  <div
    v-if="show"
    class="card col col-login mx-auto mb-3"
  >
    <div class="card-body p-6">
      <div class="card-title mb-7">
        <h5 class="text-center">
          Entre com o código para verificar a autenticidade do documento.
        </h5>
      </div>
      <div class="form-group">
        <label class="form-label">
          Código
        </label>
        <input
          id="code_confirmation"
          v-model="code"
          type="text"
          class="form-control"
        >
      </div>
      <div class="form-footer">
        <button
          id="code_confirmation_button"
          class="btn btn-primary btn-block"
          @click="confirmCode()"
        >
          Confirmar
        </button>
      </div>
    </div>
  </div>
</template>

<script>

import sweetAlert from '../shared/helpers/sweet_alert';

export default {
  name: 'SignatureConfirmCode',

  mixins: [sweetAlert],

  props: {
    url: {
      type: String,
      required: true
    }
  },

  data() {
    return {
      code: '',
      show: true,
    };
  },

  computed: {
    urlComplete() {
      return `${this.url}/${this.code}`;
    },

    errorMessage() {
      return 'Código inválido!';
    },
  },

  methods: {
    async confirmCode() {
      if (this.isEmpty(this.code)) {
        return this.showWarningMessage(this.errorMessage);
      }

      const response = await this.$axios.get(this.urlComplete);
      const message = response.data.message;

      if (response.data.status === 'internal_server_error') {
        return this.showWarningMessage(message);
      }

      this.showSuccessMessage(message);
      this.showDocument(message);
    },

    showDocument() {},

    isEmpty(field) {
      return field === '';
    },
  },
};
</script>
