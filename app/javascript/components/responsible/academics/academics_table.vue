<template>
  <div>
    <v-client-table
      :data="academics"
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
          @click.prevent="confirmDestroy(props.row.id)"
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
import swal from 'sweetalert';

export default {
  name: 'AcademicsTable',

  props: {
    data: {
      type: Array,
      required: true,
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
      options,
      academics: [],
    };
  },

  created() {
    this.setData();
  },

  methods: {
    setData(data = this.data) {
      this.academics = this.formatDate(data);
    },

    formatDate(data) {
      return data.map((item) => {
        item.created_at = moment(item.created_at);
        return item;
      });
    },

    async updateData() {
      const url = '/responsible/academics';
      const response = await this.$axios.get(url);
      const data = response.data;

      this.setData(data);
    },

    getRelativeUrl(id) {
      return `/responsible/academics/${id}`;
    },

    show(id) {
      return this.$axios.get(this.getRelativeUrl(id));
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
        const response = await this.$axios.delete(this.getRelativeUrl(id));

        swal(response.data.message, {
          icon: 'success',
        });

        this.updateData();
      }
    }
  },
};
</script>
