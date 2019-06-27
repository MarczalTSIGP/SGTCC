<template>
  <div
    v-show="show"
    class="table-responsive"
  >
    <table class="table table-hover table-outline table-vcenter text-nowrap card-table">
      <thead>
        <tr>
          <th>Usuário</th>
          <th>Assinou</th>
        </tr>
      </thead>
      <tbody>
        <tr
          v-for="signature in signatureStatus"
          :key="signature.name"
        >
          <td>{{ signature.name }}</td>
          <td>
            <span :class="selectBadge(signature.status)">
              {{ selectStatus(signature.status) }}
            </span>
          </td>
        </tr>
      </tbody>
    </table>
  </div>
</template>

<script>
export default {
  name: 'SignatureStatus',

  props: {
    orientationId: {
      type: Number,
      required: true
    },
  },

  data() {
    return {
      show: true,
      signatureStatus: [],
    };
  },

  computed: {
    url() {
      return `/signatures/orientations/${this.orientationId}/status`;
    },
  },

  mounted() {
    this.loadData();
    this.onUpdateStatus();
    this.onCloseSignatureStatus();
    this.onOpenSignatureStatus();
  },

  methods: {
    async loadData() {
      const response = await this.$axios.post(this.url);

      this.signatureStatus = response.data;
    },

    selectStatus(status) {
      return status ? 'sim' : 'não';
    },

    selectBadge(status) {
      const badge = 'badge badge';
      const context = status ? 'primary' : 'secondary';
      return `${badge}-${context}`;
    },

    onUpdateStatus() {
      this.$root.$on('update-signature-status', () => {
        this.loadData();
      });
    },

    onCloseSignatureStatus() {
      this.$root.$on('close-signature-status', () => {
        this.show = false;
      });
    },

    onOpenSignatureStatus() {
      this.$root.$on('open-signature-status', () => {
        this.show = true;
      });
    },
  },
};
</script>
