<template>
  <button class="btn btn-primary">
    Copy
  </button>
</template>

<script>

export default {
  name: 'Clipboard',

  props: {
    value: {
      type: String,
      required: true
    },
  },

  methods: {
    copy() {

    },
  },
};


</script>
