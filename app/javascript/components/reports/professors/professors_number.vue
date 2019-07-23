<template>
  <div
    v-if="load"
    class="card p-3"
  >
    <div class="d-flex align-items-center">
      <span :class="`stamp stamp-md bg-${backgroundColor} mr-3`">
        <i class="fe fe-users" />
      </span>
      <div>
        <h4 class="m-0">
          <a :href="redirect">
            {{ number }} <small>Professores</small>
          </a>
        </h4>
        <small class="text-muted">
          {{ label }}
        </small>
      </div>
    </div>
  </div>
</template>

<script>

export default {
  name: 'ProfessorsNumber',

  props: {
    backgroundColor: {
      type: String,
      required: true
    },

    label: {
      type: String,
      required: true
    },

    url: {
      type: String,
      required: true
    },

    redirect: {
      type: String,
      required: true
    },
  },

  data() {
    return {
      number: 0,
      load: false
    };
  },

  mounted() {
    this.setProfessorsNumber();
  },

  methods: {
    async setProfessorsNumber() {
      const response = await this.$axios.get(this.url);
      this.number = response.data;
      this.load = true;
    },
  },
};

</script>
