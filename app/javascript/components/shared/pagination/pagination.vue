<template>
  <ul class="pagination mt-5 float-right">
    <a
      :href="getPreviousLink()"
      class="page-link"
    >
      {{ $t('messages.pagination.previous') }}
    </a>
    <li
      v-for="(page, index) in paginationArr"
      :key="index"
      :class="`page-item ${isActive(page)}`"
    >
      <page
        :page="page"
        :page-link="getPageLink(page)"
      />
    </li>
    <a
      :href="getNextLink()"
      class="page-link"
    >
      {{ $t('messages.pagination.next') }}
    </a>
  </ul>
</template>

<script>

import Page from './page';
import pagination from '../../../utils/pagination';

export default {
  name: 'Pagination',

  components: {
    Page
  },

  props: {
    total: {
      type: Number,
      required: true,
    },

    activePage: {
      type: Number,
      default: 1,
    },

    pageLink: {
      type: String,
      default: '',
    },
  },

  data() {
    return {
      paginationArr: [],
    };
  },

  mounted() {
    this.setPagination();
  },

  methods: {
    setPagination() {
      const total = this.total;
      const activePage = this.activePage;

      this.paginationArr = pagination({total, activePage});
    },

    isActive(page) {
      return (this.activePage === page) ? 'active' : '';
    },

    getPageLink(page) {
      return `${this.pageLink}/page/${page}`;
    },

    getPreviousLink() {
      if (this.activePage === 1) return '';

      const previousPage = this.activePage - 1;

      return this.getPageLink(previousPage);
    },

    getNextLink() {
      if (this.activePage === this.total) return '';

      const nextPage = this.activePage + 1;

      return this.getPageLink(nextPage);
    },
  },
};

</script>
