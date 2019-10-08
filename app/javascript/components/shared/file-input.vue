<template>
  <div :class="`form-group ${id} form-group-${formStatus} custom-file`">
    <input
      :id="id"
      :name="name"
      type="file"
      class="custom-file-input"
      :class="inputStatus"
    >
    <label
      class="custom-file-label text-truncate"
      for="customFile"
    >
      {{ inputName }}
    </label>
    <div
      v-if="hasErrors()"
      class="invalid-feedback d-block"
    >
      <p
        v-for="(error, index) in errors"
        :key="index"
      >
        {{ label + ' ' + error }}
      </p>
    </div>
    <small
      v-if="hint"
      class="form-text text-muted"
    >
      {{ hint }}
    </small>
  </div>
</template>

<script>

export default {
  name: 'FileInput',

  props: {
    name: {
      type: String,
      required: true
    },

    id: {
      type: String,
      required: true
    },

    errors: {
      type: Array,
      required: true
    },

    label: {
      type: String,
      required: true
    },

    hint: {
      type: String,
      required: false,
      default() {
        return '';
      }
    },

    url: {
      type: String,
      required: false,
      default() {
        return '';
      }
    },
  },

  data() {
    return {
      search: 'Procurar arquivo...',
    };
  },

  computed: {
    formStatus() {
      return this.hasErrors() ? 'invalid' : 'valid';
    },

    inputStatus() {
      return this.hasErrors() ? 'is-invalid' : '';
    },

    inputName() {
      return this.url ? this.getFileName() : this.search;
    },
  },

  methods: {
    hasErrors() {
      return this.errors.length > 0;
    },

    getFileName() {
      return this.url.split('/').pop();
    },
  },
};

</script>
