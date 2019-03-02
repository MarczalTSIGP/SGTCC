<template>
  <div>
    <div class="input-group input-icon">
      <input
        id="users_search_input"
        v-model="term"
        type="text"
        name="term"
        placeholder="Procurar..."
        class="form-control"
        @keyup.enter="search()"
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
      const term = this.getFieldSearchTerm();

      return `${this.url}/${term}`;
    },
  },

  mounted() {
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

    getFieldSearchTerm() {
      return this.term.replace('/', '');
    },
  },
};

</script>
