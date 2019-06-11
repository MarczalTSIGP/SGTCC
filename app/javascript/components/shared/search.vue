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
      updatedUrl: '',
    };
  },

  computed: {
    searchUrl() {
      let url = this.url;

      if (this.updatedUrl !== '') {
        url = this.updatedUrl;
      }

      return `${url}/${this.term}`;
    },
  },

  mounted() {
    this.listenSearchFilterEvent();
    this.listenUpdateSearchUrlEvent();
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

    updateUrlWithFilter(filter) {
      if (filter === '') {
        this.updatedUrl = this.url;
        return;
      }
      this.updatedUrl = this.url.replace(/search/, `${filter}/search`);
    },

    listenSearchFilterEvent() {
      this.$root.$on('search-with-filter', (filter) => {
        this.updateUrlWithFilter(filter);
        this.search();
      });
    },

    listenUpdateSearchUrlEvent() {
      this.$root.$on('update-search-url', (filter) => {
        this.updateUrlWithFilter(filter[0]);
      });
    },
  },
};

</script>
