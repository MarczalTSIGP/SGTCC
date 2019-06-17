<template>
  <div>
    <hr>
    <p>
      Documento assinado eletronicamente por <strong>{{ name }}</strong>, em {{ date }}, às {{ time }},
      conforme horário oficial de Brasília, com fundamento no art. 6º, 1 º, do
      <u>Decreto nº 8.539, de 8 de outubro de 2015</u>.
    </p>
    <hr>
  </div>
</template>

<script>
export default {
  name: 'SignatureMark',

  props: {
    name: {
      type: String,
      required: true
    },

    date: {
      type: String,
      required: true
    },

    time: {
      type: String,
      required: true
    }
  },
};
</script>
