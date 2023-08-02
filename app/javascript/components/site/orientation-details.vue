<template>
  <div>
    <a
      :href="`#summary_${orientation.id}`"
      data-toggle="collapse"
      aria-expanded="true"
    >
      {{ orientation.attributes.title }}
    </a>

    <br>

    <div
      v-show="orientation.attributes.summary"
      :id="`summary_${orientation.id}`"
      class="collapse"
    >
      <div class="card card-body site-table mb-2">
        <p class="text-justify">
          {{ orientation.attributes.summary }}
        </p>
      </div>
    </div>

    {{ orientation.attributes.academic.name }} (acadêmico)<br>
    {{ orientation.attributes.advisor.name }} (orientador) <br>

    <span v-if="orientation.attributes.supervisors.size > 0">
      {{ orientation.attributes.supervisors.names }} (coorientadores)<br>
    </span>

    <span v-if="orientation.attributes.approved_date">
      {{ orientation.attributes.approved_date }} (data de aprovação) <br>
    </span>

    <a
      v-for="document in orientation.attributes.documents"
      :key="document.name"
      :href="document.url"
      target="_blank"
      class="btn btn-outline-primary btn-sm mt-2 mr-2"
    >
      {{ document.name }}
    </a>
    <hr>
  </div>
</template>

<script>
export default {
  name: 'OrientationDetails',

  props: {
    orientation: {
      type: Object,
      required: true
    }
  }
};
</script>
