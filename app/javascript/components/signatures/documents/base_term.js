import SignatureMark from '../signature_mark';

export default {
  components: { SignatureMark },

  props: {
    orientationTitle: {
      type: String,
      required: true
    },

    urlSignaturesMark: {
      type: String,
      required: true
    },

    documentTitle: {
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

    institution: {
      type: Object,
      required: false
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
