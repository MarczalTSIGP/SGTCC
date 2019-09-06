<template>
  <div class="card p-3">
    <a
      :href="redirect"
      class="text-decoration-none"
    >
      <div class="d-flex align-items-center">
        <span :class="`stamp stamp-md bg-${backgroundColor} mr-3`">
          <i class="fe fe-users" />
        </span>
        <div>
          <h4 class="m-0">
            {{ number }} <small>{{ title }}</small>
          </h4>
          <small class="text-muted">
            {{ label }}
          </small>
        </div>
      </div>
    </a>
  </div>
</template>

<script>

export default {
  name: 'CardReportNumber',

  props: {
    backgroundColor: {
      type: String,
      required: true
    },

    label: {
      type: String,
      required: true
    },

    redirect: {
      type: String,
      required: true
    },

    number: {
      type: Number,
      required: true
    },

    title: {
      type: String,
      required: true
    },
  },
};

</script>
