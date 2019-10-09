<template>
  <div>
    <div
      v-if="!show && canGenerate"
      class="clearfix"
    >
      <button
        id="generate_defense_minutes"
        class="btn btn-outline-primary float-right mb-4"
        @click="generate()"
      >
        Gerar Ata de Defesa
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

export default {
  name: 'GenerateDefenseMinutes',

  props: {
    generateUrl: {
      type: String,
      required: true
    },

    canGenerate: {
      type: Boolean,
      required: true
    },

    document: {
      type: Object,
      required: false,
      default() {
        return {};
      },
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

  created() {
    this.setDocumentId();
  },

  methods: {
    async generate() {
      this.loading = true;
      this.show = true;
      const response = await this.$axios.post(this.generateUrl);
      this.documentId = response.data;
      this.loading = false;
    },

    setDocumentId() {
      if (this.document !== null) {
        this.documentId = this.document.id;
      }
    },
  },
};

</script>
