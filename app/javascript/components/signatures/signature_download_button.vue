<template>
  <div>
    <button
      v-if="show"
      id="signature_download_button"
      class="btn btn-outline-danger"
    >
      Download PDF
    </button>
  </div>
</template>

<script>

import baseButton from './documents/base_button';

export default {
  name: 'SignatureDownloadButton',

  mixins: [baseButton],

  methods: {},
};

</script>
