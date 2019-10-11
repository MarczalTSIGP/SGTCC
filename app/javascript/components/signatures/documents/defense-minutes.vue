<template>
  <base-term-layout :document-id="documentId">
    <p>
      No dia <strong>{{ term.examination_board.date }}</strong>, às {{ term.examination_board.time }} horas, em sessão
      pública nas dependências da Universidade Tecnológica Federal do Paraná Câmpus Guarapuava, ocorreu a banca de defesa
      de Trabalho de Conclusão de Curso intitulada: <strong>“{{ term.examination_board.document_title }}”</strong>
      do(a) acadêmico(a) <strong>{{ term.academic.name }}</strong> sob orientação do(a) professor(a)
      <strong>{{ term.advisor.name }}</strong> do curso de Tecnologia em Sistemas para Internet.
    </p>

    <table class="table table-vcenter table-bordered">
      <thead class="text-center">
        <tr>
          <th colspan="2">
            Orientação
          </th>
        </tr>
        <tr>
          <th>Membro</th>
          <th>Nome</th>
        </tr>
      </thead>

      <tbody>
        <tr>
          <td width="30%">
            Orientador
          </td>
          <td>{{ term.advisor.name }}</td>
        </tr>
        <tr
          v-for="(supervisor, index) in supervisors"
          :key="supervisor.id"
        >
          <td width="30%">
            Coorientador {{ index + 1 }}
          </td>
          <td>{{ supervisor.name }}</td>
        </tr>
      </tbody>
    </table>

    <table class="table table-vcenter table-bordered">
      <thead class="text-center">
        <tr>
          <th colspan="2">
            Banca Avaliadora
          </th>
        </tr>
        <tr>
          <th>Membro</th>
          <th>Nome</th>
        </tr>
      </thead>

      <tbody>
        <tr>
          <td width="30%">
            Orientador
          </td>
          <td>{{ term.advisor.name }}</td>
        </tr>
        <tr
          v-for="(evaluator, index) in evaluators"
          :key="evaluator.id"
        >
          <td width="30%">
            Avaliador {{ index + 1 }}
          </td>
          <td>{{ evaluator.name }}</td>
        </tr>
      </tbody>
    </table>

    <table class="table table-vcenter table-bordered">
      <thead class="text-center">
        <tr>
          <th colspan="2">
            Situação
          </th>
        </tr>
      </thead>
      <tbody>
        <tr>
          <td class="text-center">
            {{ term.examination_board.situation }}
          </td>
        </tr>
      </tbody>
    </table>
  </base-term-layout>
</template>

<script>

import baseTermData from './base-term-data';
import BaseTermLayout from './base-term-layout';

export default {
  name: 'DefenseMinutes',

  components: { BaseTermLayout },

  mixins: [baseTermData],

  computed: {
    supervisors() {
      const term = this.term;
      return term.professorSupervisors.concat(term.externalMemberSupervisors);
    },

    evaluators() {
      const examination_board = this.term.examination_board;

      if (examination_board.hasOwnProperty('evaluators')) {
        const evaluators = examination_board.evaluators;
        return evaluators.professors.concat(evaluators.external_members);
      }

      return [];
    },
  },
};
</script>
