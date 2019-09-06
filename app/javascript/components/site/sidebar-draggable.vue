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
                <i :class="page.fa_icon" />
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
        :disabled="disabledButton"
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

  props: {
    updateSidebarUrl: {
      type: String,
      required: true
    },
  },

  data() {
    return {
      sidebarUrl: '/sidebar',
      disabledButton: false,
      pages: [],
    };
  },

  mounted() {
    this.setSidebar();
  },

  methods: {
    setDisabledButton() {
      if(this.pages.length === 1) {
        this.disabledButton = true;
      }
    },

    async setSidebar() {
      const response = await this.$axios.post(this.sidebarUrl);
      this.pages = response.data;
      this.setDisabledButton();
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
