<template>
  <base-term-layout :document-id="documentId">
    <p>
      No dia <strong>5 de julho de 2019</strong>, às 16:30 horas, em sessão pública nas dependências da
      Universidade Tecnológica Federal do Paraná Câmpus Guarapuava, ocorreu a banca de defesa da de Trabalho
      de Conclusão de Curso intitulada: <strong>“{{ term.orientation.title }}”</strong> do acadêmico
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
        <tr>
          <td>Coorientador</td>
          <td>...</td>
        </tr>
        <tr />
        <tr>
          <td>Avaliador 1</td>
          <td>...</td>
        </tr>
      </tbody>
    </table>

    <table class="table table-vcenter table-bordered">
      <thead class="text-center">
        <tr>
          <th colspan="2">
            Situação do Trabalho
          </th>
        </tr>
      </thead>

      <tbody>
        <tr>
          <td>Situação</td>
          <td>
            <div class="custom-controls-stacked">
              <label
                v-for="(item, index) in status"
                :key="index"
                class="custom-control custom-radio"
              >
                <input
                  type="radio"
                  class="custom-control-input"
                  name="example-radios"
                  value="option1"
                  checked=""
                >
                <div class="custom-control-label">{{ item }}</div>
              </label>
            </div>
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

  data() {
    return {
      status: ['Aprovado', 'Aprovado com ressalvas', 'Reprovado', 'Não compareceu']
    };
  },
};
</script>
