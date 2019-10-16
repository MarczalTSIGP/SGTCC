<template>
  <div class="mb-4">
    <div
      v-if="!show"
      :class="`border border-${colorType} rounded p-4`"
    >
      <div class="m-3">
        <strong>
          {{ title }}
        </strong>
        <p>{{ details }}</p>
        <button
          :id="id"
          type="button"
          :class="`btn btn-outline-${colorType} btn-sm btn-block`"
          @click="confirmGenerate()"
        >
          Gerar Ata de Defesa
        </button>
      </div>
    </div>
    <div
      v-else
      class="border border-primary rounded p-4"
    >
      <div class="m-3">
        <strong>
          Visualizar Ata de Defesa
        </strong>
        <p>
          Visualizar documento gerado desta banca de defesa.
        </p>
        <a
          id="view_defense_minutes"
          :href="documentUrl"
          class="btn btn-outline-primary btn-sm btn-block"
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
  name: 'GenerateDefenseMinutes',

  mixins: [sweetAlert],

  props: {
    title: {
      type: String,
      required: false,
      default() {
        return 'Gerar Ata de Defesa';
      },
    },

    buttonLabel: {
      type: String,
      required: false,
      default() {
        return 'Gerar Ata de Defesa';
      },
    },

    details: {
      type: String,
      required: false,
      default() {
        return `Este documento deve ser gerado somente após a atribuição
        de nota para o acadêmico por todos os avaliadores da banca de defesa,
          depois da geração não será possível alterar a nota.`;
      },
    },

    confirmationMessage: {
      type: String,
      required: false,
      default() {
        return 'Você tem certeza que deseja gerar a Ata de Defesa?';
      },
    },

    colorType: {
      type: String,
      required: false,
      default() {
        return 'primary';
      }
    },

    id: {
      type: String,
      required: false,
      default() {
        return 'generate_defense_minutes';
      },
    },

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
