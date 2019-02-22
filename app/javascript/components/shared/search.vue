<template>
  <div class="row">
    <div class="input-icon col-8">
      <input
        id="users_search_input"
        v-model="term"
        type="text"
        name="term"
        placeholder="Procurar..."
        class="form-control"
        @keyup.enter="search()"
      >
    </div>
    <div class="col-4">
      <a
        ref="link"
        href="#"
        class="btn btn-outline-primary"
        @click="search()"
      >
        Procurar
      </a>
    </div>
  </div>
</template>


<script>

export default {
  name: 'Search',

  props: {
    url: {
      type: String,
      required: true,
    },
  },

  data() {
    return {
      term: '',
    };
  },

  methods: {
    search() {
      const link = this.$refs.link;
      link.href = `${this.url}/${this.term}`;
      link.click();
    },
  },
};

</script>
