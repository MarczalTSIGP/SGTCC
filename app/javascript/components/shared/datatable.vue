<template>
  <div>
    <loader :show-loader="isLoading" />

    <div
      v-show="isNotLoading"
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
            <td>
              <a
                :href="getShowLink(item.id)"
              >
                <i
                  class="fe fe-search"
                  data-toggle="tooltip"
                  title="Show"
                />
              </a>
              <a
                :href="getEditLink(item.id)"
              >
                <i
                  class="fe fe-edit"
                  data-toggle="tooltip"
                  title="Edit"
                />
              </a>
              <a
                :href="getLinkWithId(item.id)"
                @click.prevent="confirmDestroy(item.id)"
              >
                <i
                  id="destroy"
                  class="fe fe-trash"
                  data-toggle="tooltip"
                  title="Delete"
                />
              </a>
            </td>
          </tr>
        </tbody>
      </table>
    </div>

    <pagination
      v-if="isNotLoading"
      :page-link="url"
      :total="pagination.totalPages"
      :active-page="pagination.activePage"
    />
  </div>
</template>

<script>

import Loader from './loader';
import Pagination from './pagination/pagination';
import swal from 'sweetalert';

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

    isNotLoading() {
      return !this.isLoading;
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

    getLinkWithId(id) {
      return `${this.url}/${id}`;
    },

    getShowLink(id) {
      return this.getLinkWithId(id);
    },

    getEditLink(id) {
      return `${this.getLinkWithId(id)}/edit`;
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

    async confirmDestroy(id) {
      const messages = this.$i18n.messages['pt-BR'].messages;
      const confirmMessage = messages['confirm'].delete;

      const confirmDialog = await swal({
        title: confirmMessage,
        icon: 'warning',
        buttons: true,
        dangerMode: true,
      });

      if (confirmDialog) {
        const url = this.getLinkWithId(id);
        const response = await this.$axios.delete(url);

        swal(response.data.message, {
          icon: 'success',
        });

        this.fetchData();
      }
    },
  },
};

</script>
