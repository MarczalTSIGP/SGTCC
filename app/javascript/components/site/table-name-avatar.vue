<template>
  <div class="d-flex">
    <div class="mb-2">
      <table-avatar :url="url" />
    </div>
    <div class="ml-2 mt-2">
      {{ name }}
    </div>
  </div>
</template>

<script>

import TableAvatar from './table-avatar';

export default {
  name: 'TableNameAvatar',

  components: { TableAvatar },

  props: {
    url: {
      type: String,
      required: true
    },

    name: {
      type: String,
      required: true
    },
  },
};

</script>
