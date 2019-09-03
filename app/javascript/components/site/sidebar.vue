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
        <i
          v-if="editable"
          class="ml-3 fa fa-list-ul"
          :style="{ fontSize: '8px' }"
        />
      </a>
    </div>
  </div>
</template>

<script>
export default {
  name: 'Sidebar',

  props: {
    posts: {
      type: Array,
      required: true
    },
  },
};

</script>
