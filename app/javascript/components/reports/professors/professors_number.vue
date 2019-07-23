<template>
  <div class="card p-3">
    <div class="d-flex align-items-center">
      <span :class="`stamp stamp-md bg-${backgroundColor} mr-3`">
        <i class="fe fe-users" />
      </span>
      <div>
        <h4 class="m-0">
          <a href="javascript:void(0)">
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

    number: {
      type: Number,
      required: true
    },

    label: {
      type: String,
      required: true
    }
  },
};

</script>
