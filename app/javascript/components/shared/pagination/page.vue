<template>
  <div>
    <span
      v-show="isDots()"
      class="page-link"
    >
      ...
    </span>
    <a
      v-show="!isDots()"
      :href="pageLink"
      class="page-link"
      @click.prevent="handleClick"
    >
      {{ page }}
    </a>
  </div>
</template>

<script>

export default {
  name: 'Page',

  props: {
    page: {
      type: [String, Number],
      required: true,
    },

    pageLink: {
      type: String,
      required: true,
    },
  },

  methods: {
    handleClick() {
      this.$root.$emit('pagination', this.page);
    },

    isDots() {
      return this.page === '...';
    },
  },
};

</script>
