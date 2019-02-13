<template>
  <div>
    <v-client-table
      :data="getData()"
      :columns="columns"
      :options="options"
    >
      <div
        slot="icons"
        slot-scope="props"
      >
        <a
          :href="`academics/${props.row.id}`"
        >
          <i
            class="fe fe-search"
            data-toggle="tooltip"
            title="Show"
          />
        </a>
        <a
          :href="`academics/${props.row.id}/edit`"
        >
          <i
            class="fe fe-edit"
            data-toggle="tooltip"
            title="Edit"
          />
        </a>
        <a
          href="#"
          @click="confirmDestroy(props.row.id)"
        >
          <i
            id="destroy"
            class="fe fe-trash"
            data-toggle="tooltip"
            title="Delete"
          />
        </a>
      </div>
    </v-client-table>
  </div>
</template>

<script>

import moment from 'moment';
import options from './options-table';

export default {
  name: 'AcademicsTable',

  props: {
    data: {
      type: Array,
      required: true
    },
  },

  data() {
    return {
      columns: [
        'name',
        'email',
        'ra',
        'created_at',
        'icons'
      ],
      options
    };
  },

  methods: {
    getData() {
      return this.data.map((item) => {
        item.created_at = moment(item.created_at);
        return item;
      });
    },

    show(id) {
      return this.$axios.get(`/professors/academics/${id}`);
    },

    async confirmDestroy(id) {
      const confirmDialog = confirm('Tem certeza que deseja deletar?');

      if (confirmDialog) {
        await this.$axios.delete(`/professors/academics/${id}`);
      }
    }
  },

};
</script>
