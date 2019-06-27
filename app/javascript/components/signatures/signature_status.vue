<template>
  <div class="table-responsive">
    <table class="table table-hover table-outline table-vcenter text-nowrap card-table">
      <thead>
        <tr>
          <th>Usuário</th>
          <th>Assinou</th>
        </tr>
      </thead>
      <tbody>
        <tr>
          <td>
            <div />
          </td>
          <td />
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

  computed: {
    url() {
      return `/signatures/orientations/${this.orientationId}/status`;
    },
  },
};
</script>
