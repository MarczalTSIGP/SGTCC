<template>
  <div>
    <div
      v-if="!show"
      class="clearfix"
    >
      <button
        id="generate_defense_minutes"
        class="btn btn-outline-primary float-right mb-4"
        @click="confirmGenerate()"
      >
        Gerar Ata de Defesa de não comparecimento do Acadêmico
      </button>
    </div>
    <div v-else>
      <a
        id="view_defense_minutes"
        :href="documentUrl"
        class="btn btn-outline-primary float-right mb-4"
        :class="isDisabled"
        :aria-disabled="loading"
      >
        Visualizar Ata de Defesa
      </a>
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
