<template>
  <div class="row mb-6">
    <div class="col-md-4 col-sm-4">
      <img
        class="img-fluid mb-2"
        alt="logo_utfpr"
        :src="headerImage"
        :style="{ width: 350 + 'px' }"
      >
    </div>
    <div class="col-md-8 col-sm-8">
      <p class="m-0">
        Ministério da Educação
      </p>
      <p class="m-0">
        Universidade Tecnológica Federal do Paraná
      </p>
      <p class="m-0">
        Câmpus Guarapuava
      </p>
      <p class="m-0">
        Curso Superior de Tecnologia em Sistemas para Internet
      </p>
    </div>
  </div>
</template>

<script>
export default {
  name: 'TermHeader',

  data() {
    return {
      urlDocumentImages: '/documents/images',
      headerImage: '',
    };
  },

  mounted() {
    this.getUrlHeaderImage();
  },

  methods: {
    async getUrlHeaderImage() {
      const response = await this.$axios.get(this.urlDocumentImages);
      this.headerImage = response.data.utfpr_logo;
    },
  },
};
</script>
