<template>
  <div>
    <div
      v-if="!show"
      class="border border-primary rounded p-4"
    >
      <div class="m-3">
        <div class="float-left">
          <strong>
            Gerar Ata de Defesa de não comparecimento do Acadêmico
          </strong>
          <p>
            Ata de defesa de não comparecimento do acadêmico deve ser
            gerada quando o acadêmico não compareceu para defender seu TCC
          </p>
        </div>
        <button
          id="generate_defense_minutes"
          type="button"
          class="btn btn-outline-primary btn-sm float-right"
          @click="confirmGenerate()"
        >
          Gerar Ata de Defesa de não comparecimento
        </button>
      </div>
      <div class="clearfix" />
      <hr class="m-0">
    </div>
    <div
      v-else
      class="border border-primary rounded p-4 clearfix"
    >
      <div class="m-3">
        <div class="float-left">
          <strong>
            Visualizar Ata de Defesa
          </strong>
          <p>
            Visualizar documento gerado desta banca de defesa.
          </p>
        </div>
        <a
          id="view_defense_minutes"
          :href="documentUrl"
          class="btn btn-outline-primary btn-sm float-right"
          :class="isDisabled"
          :aria-disabled="loading"
        >
          Visualizar Ata de Defesa
        </a>
      </div>
    </div>
  </div>
</template>

<script>

import sweetAlert from '../shared/helpers/sweet-alert';

export default {
  name: 'GenerateNonAttendanceDefenseMinutes',

  mixins: [sweetAlert],

  props: {
    url: {
      type: String,
      required: true
    },
  },

  data() {
    return {
      show: false,
      loading: false,
      documentId: '',
      documentsUrl: '/professors/documents',
      confirmationMessage: 'Você tem certeza que deseja gerar uma Ata de Defesa de não comparecimento do Acadêmico?'
    };
  },

  computed: {
    documentUrl() {
      return `${this.documentsUrl}/${this.documentId}`;
    },

    isDisabled() {
      return this.loading ? 'is-disabled-link' : '';
    },
  },

  methods: {
    async generate() {
      this.loading = true;
      this.show = true;
      const response = await this.$axios.post(this.url);
      this.documentId = response.data;
      this.loading = false;
    },

    async confirmGenerate() {
      const confirmGenerate = await this.confirmMessage(this.confirmationMessage);

      if (confirmGenerate) {
        this.generate();
      }
    },
  },
};

</script>
