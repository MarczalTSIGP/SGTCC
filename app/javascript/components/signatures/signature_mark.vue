<template>
  <div>
    <hr>
    <p>
      Documento assinado eletronicamente por {{ name }}, em {{ date }}, às {{ time }},
      conforme horário oficial de Brasília, com fundamento no art. 6º, 1 º, do
      Decreto nº 8.539, de 8 de outubro de 2015.
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
