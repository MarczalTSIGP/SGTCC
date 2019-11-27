<template>
  <span
    class="avatar"
    :style="spanClass"
  />
</template>

<script>

export default {
  name: 'TableAvatar',

  props: {
    url: {
      type: String,
      required: true
    }
  },

  computed: {
    spanClass() {
      return { 'backgroundImage': `url(../${this.url})` };
    },
  },
};

</script>
