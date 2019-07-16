import SignatureMark from '../signature_mark';

export default {
  components: { SignatureMark },

  props: {
    urlSignatureMark: {
      type: String,
      required: true
    },

    urlSignatureCode: {
      type: String,
      required: true
    },

    urlSignatureData: {
      type: String,
      required: true
    },

    urlSignatureImage: {
      type: String,
      required: true
    },

    urlHeaderImage: {
      type: String,
      required: true
    },
  },

  data() {
    return {
      term: {
        orientation: {
          id: '',
          title: '',
          created_at: '',
          abandonment_justification: '',
        },
        academic: {
          id: '',
          name: '',
          ra: '',
        },
        advisor: {
          id: '',
          name: '',
          label: ''
        },
        title: '',
        institution: {},
        professorSupervisors: [],
        externalMemberSupervisors: [],
      },
      open: false,
      marginTitle: 50,
    };
  },

  computed: {
    externalMemberSupervisorLabel() {
      return this.term.externalMemberSupervisors.length === 1
        ? 'Coorientador externo'
        : 'Coorientadores externos';
    },

    professorSupervisorLabel() {
      return this.term.professorSupervisors.length === 1
        ? 'Coorientador da UTFPR'
        : 'Coorientadores da UTFPR';
    },
  },

  mounted() {
    this.onCloseTerm();
    this.onOpenTerm();
    this.setData();
  },

  methods: {
    async setData(url = this.urlSignatureData) {
      const response = await this.$axios.post(url);

      if (response.data.status !== 'not_found') {
        this.term = response.data;
        this.open = true;
      }
    },

    hasProfessorSupervisors() {
      return this.term.professorSupervisors.length > 0;
    },

    hasExternalMemberSupervisors() {
      return this.term.externalMemberSupervisors.length > 0;
    },

    hasInstitution() {
      return this.term.institution.responsible !== null && this.term.institution.trade_name !== null;
    },

    onCloseTerm() {
      this.$root.$on('close-term', () => { this.open = false; });
    },

    onOpenTerm() {
      this.$root.$on('open-term', () => { this.open = true; });
    },
  },
};
