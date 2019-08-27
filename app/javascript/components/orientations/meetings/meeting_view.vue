<template>
  <div
    class="form-group checkbox_tabler optional meeting_viewed"
    @click.prevent="confirmVisualization()"
  >
    <label class="custom-control custom-checkbox">
      <input
        id="meeting_viewed"
        type="checkbox"
        name="meeting[viewed]"
        class="custom-control-input"
        :checked="viewed"
        :disabled="viewed"
      >
      <span class="custom-control-label">
        Dar ciência
      </span>
    </label>
  </div>
</template>

<script>

import sweetAlert from '../../shared/helpers/sweet_alert';

export default {
  name: 'MeetingView',

  mixins: [sweetAlert],

  props: {
    id: {
      type: Number,
      required: true
    },

    value: {
      type: Boolean,
      required: true
    },
  },

  data() {
    return {
      url: `/academics/meetings/${this.id}/update_viewed`,
      viewed: false,
    };
  },

  mounted() {
    this.changeViewed(this.value);
  },

  methods: {
    async confirmVisualization() {
      if (this.viewed) {
        return;
      }

      const message = 'Você tem certeza que deseja dar ciência nessa reunião?';
      const confirm = await this.confirmMessage(message);

      if (confirm) {
        this.updateViewed();
      }
    },

    async updateViewed() {
      const response = await this.$axios.put(this.url);
      const value = response.data;

      if (value) {
        this.changeViewed(value);
        this.showSuccessMessage('Reunião atualizada com sucesso!');
      }
    },

    changeViewed(value) {
      this.viewed = value;
    },
  },
};

</script>
