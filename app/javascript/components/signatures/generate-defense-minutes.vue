<template>
  <div>
    <div
      v-if="!show"
      class="clearfix"
    >
      <button
        class="btn btn-outline-primary float-right mb-4"
        @click="generate()"
      >
        Gerar Ata de Defesa
      </button>
    </div>
    <div
      v-if="show"
      class="container"
    >
      <defense-minutes :document-id="documentId" />
    </div>
  </div>
</template>

<script>

import DefenseMinutes from './documents/defense-minutes';

export default {
  name: 'GenerateDefenseMinutes',

  components: { DefenseMinutes },

  props: {
    url: {
      type: String,
      required: true
    },
  },

  data() {
    return {
      show: false,
      documentId: '',
    };
  },

  methods: {
    async generate() {
      const response = await this.$axios.post(this.url);

      console.log('response', response);

      this.documentId = response.data;
      this.show = true;
    },
  },
};

</script>
