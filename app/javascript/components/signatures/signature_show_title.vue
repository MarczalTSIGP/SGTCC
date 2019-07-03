<template>
  <div>
    {{ title }}
  </div>
</template>

<script>
export default {
  name: 'SignatureShowTitle',

  data() {
    return {
      title: 'Visualizar documento'
    };
  },

  mounted() {
    this.onChangeTitle();
  },

  methods: {
    onChangeTitle() {
      this.$root.$on('change-signature-show-title', (title) => {
        this.title = title;
      });
    },
  },
};
</script>
