<template>
  <div>
    <div class="input-group input-icon">
      <input
        id="users_search_input"
        v-model="term"
        type="text"
        name="term"
        :placeholder="$t('messages.search')"
        class="form-control"
        @keyup.enter="search()"
        @keyup.capture="updateFieldSearchTerm"
      >
      <span class="input-group-append">
        <a
          id="search"
          ref="link"
          href="#"
          class="btn btn-outline-primary"
          @click="search()"
        >
          <i class="fe fe-search" />
        </a>
      </span>
    </div>
  </div>
</template>

<script>

export default {
  name: 'Search',

  props: {
    url: {
      type: String,
      required: true,
    },

    searchTerm: {
      type: String,
      default: ''
    }
  },

  data() {
    return {
      term: '',
    };
  },

  computed: {
    searchUrl() {
      return `${this.url}/${this.term}`;
    },
  },

  mounted() {
    this.listenSearchEvents();
    this.setFieldSearchTerm();
  },

  methods: {
    search() {
      const link = this.$refs.link;
      link.href = this.searchUrl;
      link.click();
    },

    setFieldSearchTerm() {
      this.term = this.searchTerm;
    },

    updateFieldSearchTerm() {
      this.term = this.term.replace(/\\|\//g, '');
    },

    listenSearchEvents() {
      this.$root.$on('search-term', (term) => {
        this.term = term;
        this.search();
      });
    },
  },
};

</script>
