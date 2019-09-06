<template>
  <div class="row">
    <div class="mx-auto col-md-8">
      <div class="card">
        <draggable
          v-model="pages"
          class="list-group"
          tag="ul"
          @start="isDragging = true"
          @end="isDragging = false"
        >
          <div
            v-for="page in pages"
            :key="page.order"
            class="list-group list-group-transparent mb-0"
          >
            <span class="list-group-item list-group-item-action">
              <span class="icon mr-3">
                <i :class="`fe fe-${page.fa_icon}`" />
              </span>
              {{ page.menu_title }}
              <i
                class="ml-3 fa fa-list-ul"
                :style="{ fontSize: '8px' }"
              />
            </span>
          </div>
        </draggable>
      </div>

      <button
        class="my-3 btn btn-block btn-outline-primary"
        @click="updateSidebar()"
      >
        Atualizar menu
      </button>
    </div>
  </div>
</template>

<script>

import Draggable from 'vuedraggable';
import sweetAlert from '../shared/helpers/sweet-alert';

export default {
  name: 'SidebarDraggable',

  components: { Draggable },

  mixins: [ sweetAlert ],

  data() {
    return {
      sidebarUrl: '/sidebar',
      updateSidebarUrl: '/update-sidebar',
      pages: [],
    };
  },

  mounted() {
    this.setSidebar();
  },

  methods: {
    async setSidebar() {
      const response = await this.$axios.post(this.sidebarUrl);
      this.pages = response.data;
    },

    async updateSidebar() {
      const data = { data: this.getSidebarOrdered() };
      const response = await this.$axios.put(this.updateSidebarUrl, data);

      if(response.data) {
        this.showSuccessMessage('Menu atualizado com sucesso!');
      }
    },

    getSidebarOrdered() {
      return this.pages.map((item) => {
        return { id: item.id };
      });
    },
  },
};
</script>
