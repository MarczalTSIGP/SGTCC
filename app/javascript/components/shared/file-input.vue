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
      class="custom-file-label"
      for="customFile"
    >
      Procurar arquivo
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
  },

  computed: {
    formStatus() {
      return this.hasErrors() ? 'invalid' : 'valid';
    },

    inputStatus() {
      return this.hasErrors() ? 'is-invalid' : '';
    },
  },

  methods: {
    hasErrors() {
      return this.errors.length > 0;
    },
  },
};

</script>
