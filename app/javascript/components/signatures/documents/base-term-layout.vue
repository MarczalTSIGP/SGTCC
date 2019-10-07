<template>
  <div
    v-show="open"
    class="card"
  >
    <div
      id="term"
      ref="term"
      class="card-body signature-document w-80"
    >
      <header>
        <slot name="header">
          <term-header />
        </slot>
      </header>
      <main>
        <div
          class="d-block w-80"
          :style="{ 'margin-top': 50 + 'px', 'margin-bottom': 50 + 'px' }"
        >
          <h4 class="text-center">
            {{ term.title }}
          </h4>
        </div>
        <slot />
      </main>
      <footer>
        <slot name="footer">
          <term-footer
            :created-at="term.document.created_at"
          />
          <div class="clearfix" />
          <signature-mark :document-id="documentId" />
        </slot>
      </footer>
    </div>
  </div>
</template>

<script>

import baseTermData from './base-term-data';

export default {
  name: 'BaseTermLayout',

  mixins: [baseTermData],
};

</script>
