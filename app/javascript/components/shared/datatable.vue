<template>
  <div>
    <loader :show-loader="isLoading" />

    <div
      v-show="!isLoading"
      class="mt-5 table-striped table-responsive w-100"
    >
      <table class="table card-table table-vcenter text-nowrap">
        <thead>
          <tr>
            <th
              v-for="(title, index) in head"
              :key="index"
            >
              {{ title }}
            </th>
            <th colspan="3" />
          </tr>
        </thead>

        <tbody>
          <tr
            v-for="(item, index) in items"
            :key="index"
          >
            <td
              v-for="title in head"
              :key="title"
            >
              {{ item[title] }}
            </td>
            <td />
          </tr>
        </tbody>
      </table>
    </div>

    <pagination
      v-if="!isLoading"
      :page-link="url"
      :total="pagination.totalPages"
      :active-page="pagination.activePage"
    />
  </div>
</template>

<script>

import Loader from './loader';
import Pagination from './pagination/pagination';

export default {
  components: {
    Loader,
    Pagination,
  },

  props: {
    url: {
      type: String,
      required: true,
    },

    head: {
      type: Array,
      required: true,
    },

    page: {
      type: Number,
      default() {
        return 1;
      },
    },
  },

  data() {
    return {
      items: [],
      loading: true,
      pagination: {
        urlLink: '',
        activePage: 1,
        totalPages: 0
      },
    };
  },

  computed: {
    isLoading() {
      return !!this.loading;
    },
  },

  mounted() {
    this.listenPagination();
    this.setActivePage(this.page);
    this.fetchData();
  },

  methods: {
    setActivePage(page) {
      this.pagination.activePage = page;
    },

    startLoading() {
      this.loading = true;
    },

    stopLoading() {
      this.loading = false;
    },

    getUrlWithPage(page) {
      return `${this.url}/page/${page}`;
    },

    changeUrl(newUrl) {
      window.history.pushState('/', '', newUrl);
    },

    listenPagination() {
      this.$root.$on('pagination', (page) => {
        const newUrl = this.getUrlWithPage(page);
        this.changeUrl(newUrl);
        this.setActivePage(page);
        this.fetchData(page);
      });
    },

    async fetchData(page = this.page) {
      const url = this.getUrlWithPage(page);
      const response = await this.$axios.get(url);

      this.items = response.data.data;
      this.pagination.totalPages = response.data.total_pages;
      this.stopLoading();
    },
  },
};

</script>
