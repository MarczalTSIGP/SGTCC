<template>
  <base-term-layout :document-id="documentId">
    <p>
      Eu, <b>{{ term.academic.name }}</b>, acadêmico(a) desta instituição,
      solicito a substituição de orientação.
    </p>

    <div>
      <b>Dados da orientação em andamento</b>
      <span class="ml-4">
        <div>
          <p>
            <span class="ml-4">
              <b>Orientador:</b>
            </span>
            <br>
            <span class="ml-6">
              {{ term.advisor.name }}
            </span>
          </p>
        </div>

        <span class="ml-4">
          <b>{{ orientationSupervisorsLabel }}:</b>
        </span>

        <div v-if="hasProfessorSupervisors()">
          <span
            v-for="professorSupervisor in term.professorSupervisors"
            :key="professorSupervisor.id"
            class="ml-6"
          >
            {{ professorSupervisor.name }} <br>
          </span>
        </div>

        <div v-if="hasExternalMemberSupervisors()">
          <span
            v-for="externalMemberSupervisor in term.externalMemberSupervisors"
            :key="externalMemberSupervisor.id"
            class="ml-6"
          >
            {{ externalMemberSupervisor.name }} <br>
          </span>
        </div>
      </span>
    </div>

    <div>
      <b>Dados da nova orientação</b>
      <span class="ml-4">
        <div>
          <span class="ml-4">
            <b>Orientador:</b>
          </span>
          <br>
          <span class="ml-6">
            {{ request.new_orientation.advisor.name }}
          </span>
        </div>
      </span>

      <div v-if="hasNewProfessorSupervisors() || hasNewExternalMemberSupervisors()">
        <span class="ml-4">
          <b>{{ newOrientationSupervisorsLabel }}:</b><br>
        </span>

        <span
          v-for="professorSupervisor in request.new_orientation.professorSupervisors"
          :key="professorSupervisor.id"
          class="ml-6"
        >
          {{ professorSupervisor.name }} <br>
        </span>

        <span
          v-for="externalMemberSupervisor in request.new_orientation.externalMemberSupervisors"
          :key="externalMemberSupervisor.id"
          class="ml-6"
        >
          {{ externalMemberSupervisor.name }} <br>
        </span>
      </div>
    </div>

    <br>
    <p>
      <b>Justificativa</b>: <br>
      <span>
        <div class="ml-4">
          <vue-simple-markdown :source="request.requester.justification" />
        </div>
      </span>
    </p>

    <document-review
      :document-id="documentId"
      :request="request"
      :can-edit="canEdit"
      :has-permission="isResponsible"
    />
  </base-term-layout>
</template>

<script>

import baseTermData from './base_term_data';
import BaseTermLayout from './base_term_layout';
import DocumentReview from '../document_review';

export default {
  name: 'TermOfSubstitution',

  components: { BaseTermLayout, DocumentReview },

  mixins: [baseTermData],

  props: {
    isResponsible: {
      type: Boolean,
      required: false,
      default() {
        return false;
      },
    },

    canEdit: {
      type: Boolean,
      required: false,
      default() {
        return false;
      }
    },
  },

  computed: {
    orientationSupervisorsLabel() {
      return this.supervisorsLabel(this.term);
    },

    newOrientationSupervisorsLabel() {
      return this.supervisorsLabel(this.request.new_orientation);
    },
  },

  methods: {
    supervisorsLabel(orientation) {
      return (orientation.professorSupervisors.length +
        orientation.externalMemberSupervisors.length) > 1
        ? 'Coorientadores'
        : 'Coorientador';
    },

    hasNewProfessorSupervisors() {
      return this.request.new_orientation.professorSupervisors.length > 0;
    },

    hasNewExternalMemberSupervisors() {
      return this.request.new_orientation.externalMemberSupervisors.length > 0;
    },
  },
};
</script>
