<template>
  <div>
    <div
      v-show="open"
      id="term"
      class="card"
    >
      <div
        ref="term"
        class="card-body signature-document w-80"
      >
        <term-header
          :url-header-image="urlHeaderImage"
        />
        <div
          class="d-block w-80"
          :style="{ 'margin-top': marginTitle + 'px', 'margin-bottom': marginTitle + 'px' }"
        >
          <h4 class="text-center">
            {{ term.title }}
          </h4>
        </div>

        <p>
          Eu, <b>{{ term.advisor.name }}</b>, {{ term.advisor.label }} desta instituição,
          declaro para os devidos fins, desistir da orientação do trabalho de conclusão de
          curso intitulado <b>{{ term.orientation.title }}</b> do acadêmico
          <b>{{ term.academic.name }}</b>, RA {{ term.academic.ra }}.
        </p>

        <p>
          <b>Motivos da desistência</b>: <br>
          <span class="ml-4">
            {{ term.orientation.abandonment_justification }}
          </span>
        </p>

        <div class="float-right">
          <p :style="{ 'margin-top': 50 + 'px', 'margin-bottom': 50 + 'px' }">
            Guarapuava, {{ term.orientation.created_at }}.
          </p>
        </div>
        <div class="clearfix" />
        <signature-mark
          :url="urlSignatureMark"
          :url-signature-code="urlSignatureCode"
          :url-signature-image="urlSignatureImage"
        />
      </div>
    </div>
  </div>
</template>

<script>

import baseTerm from './base_term';
import TermHeader from './partials/term_header';

export default {
  name: 'TermOfAbandonment',

  components: { TermHeader },

  mixins: [baseTerm],
};
</script>
