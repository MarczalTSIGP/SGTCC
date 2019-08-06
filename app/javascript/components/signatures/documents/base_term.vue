<template>
  <base-term-layout :document-id="documentId">
    <main>
      <slot />
    </main>
  </base-term-layout>
</template>

<script>

import BaseTermLayout from './base_term_layout';

export default {
  name: 'BaseTerm',

  components: { BaseTermLayout },
};
</script>
