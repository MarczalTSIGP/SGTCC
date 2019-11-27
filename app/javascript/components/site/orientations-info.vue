<template>
  <div>
    <div
      v-for="orientation in orientations"
      :key="orientation.id"
      class="mb-4"
    >
      <a
        :href="`#summary_${orientation.id}`"
        data-toggle="collapse"
        aria-expanded="false"
      >
        {{ orientation.document_title }}
      </a>
      <br>

      <div
        v-show="orientation.document_summary"
        :id="`summary_${orientation.id}`"
        class="collapse"
      >
        <div class="card card-body site-table mb-2">
          <p class="text-justify">
            {{ orientation.document_summary }}
          </p>
        </div>
      </div>

      {{ orientation.academic.name }} (acadêmico)<br>

      {{ orientation.advisor.name_with_scholarity }} (orientador) <br>

      <span v-if="orientation.supervisors.length > 0">
        {{ supervisorsFormatted(orientation) }} (coorientadores)<br>
      </span>

      <a
        v-for="document in documents(orientation)"
        :key="document.name"
        :href="document.url"
        target="_blank"
        class="btn btn-outline-primary btn-sm mt-2 mr-2"
      >
        {{ document.name }}
      </a>
      <hr>
    </div>
  </div>
</template>

<script>

export default {
  name: 'OrientationsInfo',

  props: {
    orientations: {
      type: Array,
      required: true
    },
  },

  computed: {
    noResults() {
      return this.orientations.length === 0;
    },
  },

  methods: {
    supervisorsFormatted(orientation) {
      return orientation.supervisors.map((supervisor) => {
        return supervisor.name_with_scholarity;
      }).join(', ');
    },

    documents(orientation) {
      let documents = [];

      if (orientation.final_proposal) {
        documents.push(this.proposalObject(orientation));
      }

      if (orientation.final_project) {
        documents.push(this.projectObject(orientation));
      }

      if (orientation.final_monograph) {
        documents.push(this.monographObject(orientation));
        documents.push(this.complementaryFilesObject(orientation));
      }

      return documents;
    },

    proposalObject(orientation) {
      return { name: 'Proposta', url: orientation.final_proposal.pdf.url };
    },

    projectObject(orientation) {
      return { name: 'Projeto', url: orientation.final_project.pdf.url };
    },

    monographObject(orientation) {
      return { name: 'Monografia', url: orientation.final_monograph.pdf.url };
    },

    complementaryFilesObject(orientation) {
      return { name: 'Arquivos complementares',
        url: orientation.final_monograph.complementary_files.url };
    },
  },
};

</script>
