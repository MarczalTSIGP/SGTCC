<template>
  <a
    v-clipboard:copy="value"
    href="#"
    title="Copiar para área de transferência"
    @click.prevent="onCopy()"
  >
    <i class="fe fe-link" />
  </a>
</template>

<script>

import sweetAlert from '../shared/helpers/sweet-alert';

export default {
  name: 'ClipboardCopy',

  mixins: [sweetAlert],

  props: {
    value: {
      type: String,
      required: true
    },
  },

  methods: {
    onCopy() {
      this.showSuccessMessage('Link copiado para área de transferência com sucesso!');
    },
  },
};


</script>
