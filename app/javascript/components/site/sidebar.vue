<template>
  <div>
    <div
      v-for="post in posts"
      :key="post.order"
      class="list-group list-group-transparent mb-0"
    >
      <a
        aria-current="page"
        :href="post.url"
        :class="aClass(post.url)"
      >
        <span class="icon mr-3">
          <i :class="`fe fe-${post.icon}`" />
        </span>
        {{ post.name }}
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
    posts: {
      type: Array,
      required: true
    },
  },
};

</script>
