<template>
  <div>
    <div v-show="loading">
      <loader />
    </div>
    <div v-show="!loading">
      <h2 class="page-title mb-2">
        {{ title }}
      </h2>

      <div class="text-right mb-3">
        Total de <b> {{ orientations.length }} </b> TCCs aprovados
      </div>

      <div
        v-for="orientation in orientations"
        :key="orientation.id"
        class="mb-4"
      >
        <div>
          <orientation-details :orientation="orientation" />
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import Loader from '../shared/loader';
import OrientationDetails from './orientation-details.vue';

export default {
  name: 'OrientationsPage',

  components: {
    Loader,
    OrientationDetails
  },

  props: {
    title: {
      type: String,
      required: true
    },
    path: {
      type: String,
      required: true
    }
  },

  data() {
    return {
      loading: true,
      title: '',
      orientations: []
    };
  },

  async mounted() {
    await this.$axios
      .get(this.path)
      .then(response => (this.orientations = response.data.data));
    this.loading = false;
  }
};
</script>
