import SignatureMark from '../signature_mark';

export default {
  components: { SignatureMark },

  props: {
    orientationTitle: {
      type: String,
      required: true
    },

    documentTitle: {
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
    },

    signed: {
      type: Boolean,
      required: true
    },

    academic: {
      type: Object,
      required: true
    },

    advisor: {
      type: Object,
      required: true
    },

    professorSupervisors: {
      type: Array,
      required: true
    },

    externalMemberSupervisors: {
      type: Array,
      required: true
    },
  },

  methods: {},
};
