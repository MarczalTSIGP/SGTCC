<template>
  <base-term-layout :document-id="documentId">
    <p>
      No dia <strong>{{ term.examination_board.date }}</strong>, às {{ term.examination_board.time }} horas, em sessão
      pública nas dependências da Universidade Tecnológica Federal do Paraná Câmpus Guarapuava, ocorreu a banca de defesa
      da de Trabalho de Conclusão de Curso intitulada: <strong>“{{ term.orientation.title }}”</strong> do acadêmico
      <strong>{{ term.academic.name }}</strong> sob orientação do professor <strong>{{ term.advisor.name }}</strong>
      do curso de Tecnologia em Sistemas para Internet.
    </p>

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
          <td>Orientador</td>
          <td>{{ term.advisor.name }}</td>
        </tr>
        <tr
          v-for="(supervisor, index) in supervisors"
          :key="supervisor.id"
        >
          <td>Coorientador {{ index + 1 }}</td>
          <td>{{ supervisor.name }}</td>
        </tr>
        <tr />
        <tr
          v-for="(evaluator, index) in term.examination_board.evaluators"
          :key="evaluator.id"
        >
          <td>Avaliador {{ index + 1 }}</td>
          <td>{{ evaluator.name }}</td>
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

  data() {
    return {
      status: ['Aprovado', 'Aprovado com ressalvas', 'Reprovado', 'Não compareceu']
    };
  },

  computed: {
    supervisors() {
      return this.term.professorSupervisors.concat(this.term.externalMemberSupervisors);
    },
  },
};
</script>
