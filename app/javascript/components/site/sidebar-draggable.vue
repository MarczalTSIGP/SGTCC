<template>
  <div v-if="hasPermission">
    <draggable
      v-model="posts"
      class="list-group"
      tag="ul"
      @start="isDragging = true"
      @end="isDragging = false"
    >
      <div
        v-for="post in posts"
        :key="post.order"
        class="list-group list-group-transparent mb-0"
      >
        <a
          aria-current="page"
          :href="post.url"
          :class="aClass(post.url)"
        >
          <span class="icon mr-3">
            <i :class="`fe fe-${post.icon}`" />
          </span>
          {{ post.name }}
          <i
            v-if="editable"
            class="ml-3 fa fa-list-ul"
            :style="{ fontSize: '8px' }"
          />
        </a>
      </div>
    </draggable>

    <button
      v-if="!editable"
      class="my-3 btn btn-block btn-outline-primary"
      @click="editSidebar()"
    >
      Editar sidebar
    </button>

    <button
      v-if="editable"
      class="my-3 btn btn-block btn-outline-primary"
      @click="updateSidebar()"
    >
      Atualizar sidebar
    </button>

    <button
      v-if="editable"
      class="btn btn-block btn-outline-danger"
      @click="close()"
    >
      Cancelar
    </button>
  </div>
  <div v-else>
    <sidebar :posts="posts" />
  </div>
</template>

<script>

import Draggable from 'vuedraggable';
import Sidebar from './sidebar';
import sweetAlert from '../shared/helpers/sweet-alert';
import linkActive from './helpers/link-active';

export default {
  name: 'SidebarDraggable',

  components: {
    Draggable,
    Sidebar
  },

  mixins: [ sweetAlert, linkActive ],

  props: {
    hasPermission: {
      type: Boolean,
      required: false,
      default() {
        return false;
      }
    },
  },

  data() {
    return {
      sidebarUrl: '/sidebar',
      updateSidebarUrl: '/update-sidebar',
      editable: false,
      posts: [],
    };
  },

  mounted() {
    this.setSidebar();
  },

  methods: {
    async setSidebar() {
      const response = await this.$axios.post(this.sidebarUrl);
      this.posts = response.data;
    },

    async updateSidebar() {
      const sidebarOrdered = this.posts.map((item, index) => {
        return this.sidebarObject(item, index);
      });

      const data = { data: sidebarOrdered };
      const response = await this.$axios.put(this.updateSidebarUrl, data);

      if(response.data) {
        this.showSuccessMessage('Sidebar atualizada com sucesso!');
      }

      this.editable = false;
    },

    sidebarObject(item, index) {
      return {
        name: item.name,
        icon: item.icon,
        url: item.url,
        order: index + 1
      };
    },

    editSidebar() {
      this.editable = true;
    },

    close() {
      this.editable = false;
    },
  },
};
</script>
