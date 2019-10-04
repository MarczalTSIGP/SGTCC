<template>
  <div>
    <div class="clearfix">
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
      <defense-minutes :document-id="4" />
    </div>
  </div>
</template>

<script>

import DefenseMinutes from './documents/defense-minutes';

export default {
  name: 'GenerateDefenseMinutes',

  components: { DefenseMinutes },

  data() {
    return {
      show: true,
    };
  },

  methods: {
    generate() {
      this.show = true;
    },
  },
};

</script>
