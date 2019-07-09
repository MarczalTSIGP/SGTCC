import SignatureMark from '../signature_mark';

export default {
  components: { SignatureMark },

  props: {
    orientationId: {
      type: Number,
      required: true
    },

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

    urlSignaturesStatus: {
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

  computed: {
    externalMemberSupervisorLabel() {
      return this.externalMemberSupervisors.length === 1
        ? 'Coorientador externo'
        : 'Coorientadores externos';
    },

    professorSupervisorLabel() {
      return this.professorSupervisors.length === 1
        ? 'Coorientador da UTFPR'
        : 'Coorientadores da UTFPR';
    },
  },

  data() {
    return {
      open: true,
      signedDocument: false,
      marginTitle: 50,
    };
  },

  mounted() {
    this.onCloseTerm();
    this.onOpenTerm();
    this.setSignedDocument();
  },

  methods: {
    setSignedDocument() {
      this.signedDocument = this.signed;
    },

    hasProfessorSupervisors() {
      return this.professorSupervisors.length > 0;
    },

    hasExternalMemberSupervisors() {
      return this.externalMemberSupervisors.length > 0;
    },

    hasInstitution() {
      return this.institution !== null;
    },

    onCloseTerm() {
      this.$root.$on('close-term', () => {
        this.open = false;
      });
    },

    onOpenTerm() {
      this.$root.$on('open-term', () => {
        this.open = true;
      });
    },
  },
};
