<template>
  <div
    v-if="load"
    :class="`card border border-${badgeType}`"
  >
    <a
      :href="redirect"
      class="text-decoration-none"
    >
      <div class="card-body text-center">
        <div class="h5">
          {{ label }}
        </div>
        <div class="display-4 font-weight-bold mb-4">
          {{ total }}
        </div>
        <div class="progress progress-sm">
          <div
            :class="progressBarClass"
            style="width: 100%"
          />
        </div>
      </div>
    </a>
  </div>
</template>

<script>

export default {
  name: 'OrientationsNumber',

  props: {
    label: {
      type: String,
      required: true
    },

    badgeType: {
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
      load: false,
      total: 0,
      backgroundColor: {
        primary: 'blue',
        danger: 'red',
        warning: 'yellow',
        success: 'green'
      },
    };
  },

  computed: {
    progressBarClass() {
      const backgroundColor = this.backgroundColor[this.badgeType];

      return `progress-bar bg-${backgroundColor}`;
    },
  },

  watch: {
    url() {
      this.setTotal();
    },
  },

  mounted() {
    this.setTotal();
  },

  methods: {
    async setTotal() {
      const response = await this.$axios.get(this.url);
      this.total = response.data;
      this.load = true;
    },
  },
};

</script>
