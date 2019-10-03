<template>
  <div
    :class="`form-group checkbox_tabler optional ${id}`"
    @click.prevent="confirmVisualization()"
  >
    <label class="custom-control custom-checkbox">
      <input
        :id="id"
        type="checkbox"
        :name="name"
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

import sweetAlert from './helpers/sweet-alert';

export default {
  name: 'CheckboxView',

  mixins: [sweetAlert],

  props: {
    url: {
      type: String,
      required: true
    },

    value: {
      type: Boolean,
      required: true
    },

    id: {
      type: String,
      required: true
    },

    name: {
      type: String,
      required: true
    },

    confirmationMessage: {
      type: String,
      required: true
    },

    successMessage: {
      type: String,
      required: true
    },
  },

  data() {
    return {
      errorMessage: 'Erro interno no servidor',
      viewed: false,
    };
  },

  mounted() {
    this.changeViewed(this.value);
  },

  methods: {
    async confirmVisualization() {
      if (this.viewed) return;

      const confirm = await this.confirmMessage(this.confirmationMessage);

      if (confirm) {
        this.updateViewed();
      }
    },

    async updateViewed() {
      try {
        const response = await this.$axios.patch(this.url);
        const value = response.data;

        if (value) {
          this.changeViewed(value);
          this.showSuccessMessage(this.successMessage);
        }
      } catch(e) {
        this.showErrorMessage(this.errorMessage);
      }
    },

    changeViewed(value) {
      this.viewed = value;
    },
  },
};

</script>
