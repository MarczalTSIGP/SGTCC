<template>
  <div v-if="hasPermission">
    <draggable
      v-model="posts"
      class="list-group"
      tag="ul"
      v-bind="dragOptions"
      @start="isDragging = true"
      @end="isDragging = false"
    >
      <transition-group
        type="transition"
        name="flip-list"
      >
        <div
          v-for="post in posts"
          :key="post.order"
          class="list-group list-group-transparent mb-0"
        >
          <a
            aria-current="page"
            :href="post.url"
            class="list-group-item list-group-item-action"
          >
            <span class="icon mr-3">
              <i :class="`fe fe-${post.icon}`" />
            </span>
            {{ post.name }}
            <i
              v-if="editable"
              class="fa fa-list-ul float-right"
            />
          </a>
        </div>
      </transition-group>
    </draggable>

    <button
      v-if="!editable"
      class="mt-5 btn btn-block btn-outline-primary"
      @click="editSidebar()"
    >
      Editar Sidebar
    </button>

    <button
      v-if="editable"
      class="mt-5 btn btn-block btn-outline-primary"
      @click="updateSidebar()"
    >
      Atualizar sidebar
    </button>
  </div>
  <div v-else>
    <sidebar :posts="posts" />
  </div>
</template>

<script>

import Draggable from 'vuedraggable';
import Sidebar from './sidebar';
import sweetAlert from '../shared/helpers/sweet_alert';

export default {
  name: 'SidebarDraggable',

  display: 'Transition',

  components: {
    Draggable,
    Sidebar
  },

  mixins: [ sweetAlert ],

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

  computed: {
    dragOptions() {
      return {
        animation: 0,
        group: 'description',
        disabled: false,
        ghostClass: 'ghost'
      };
    }
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
  },
};
</script>
