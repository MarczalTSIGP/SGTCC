import SignatureMark from '../signature_mark';

export default {
  components: { SignatureMark },

  props: {
    orientationTitle: {
      type: String,
      required: true
    },

    orientationDate: {
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

    advisorLabel: {
      type: String,
      required: true
    },

    advisorScholarity: {
      type: Object,
      required: true
    },

    institution: {
      type: Object,
      required: false
    },

    institutionResponsible: {
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
