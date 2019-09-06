<template>
  <div>
    <div
      v-for="page in pages"
      :key="page.order"
      class="list-group list-group-transparent mb-0"
    >
      <a
        aria-current="page"
        :href="page.url"
        :class="aClass(page.url)"
      >
        <span class="icon mr-3">
          <i :class="`fe fe-${page.icon}`" />
        </span>
        {{ page.name }}
      </a>
    </div>
  </div>
</template>

<script>

import linkActive from './helpers/link-active';

export default {
  name: 'Sidebar',

  mixins: [linkActive],

  props: {
    pages: {
      type: Array,
      required: true
    },
  },
};

</script>
