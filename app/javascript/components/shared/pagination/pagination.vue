<template>
  <ul class="pagination mt-5 float-right">
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
      return `${this.pageLink}?page=${page}`;
    },
  },
};

</script>
