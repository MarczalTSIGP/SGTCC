import Datetimepicker from '../components/shared/datetimepicker';
import FlashMessages from '../components/shared/flash_messages';
import ProfileImagePreview from '../components/shared/registrations/profile_image_preview';
import OrientationRenew from '../components/orientations/orientation_renew';
import OrientationStatus from '../components/orientations/orientation_status';
import OrientationStatusFilter from '../components/orientations/orientation_status_filter';
import OrientationCancel from '../components/orientations/orientation_cancel';
import Search from '../components/shared/search';
import SignatureButton from '../components/signatures/signature_button';
import SignatureDownloadButton from '../components/signatures/signature_download_button';
import SignatureConfirm from '../components/signatures/signature_confirm';
import SignatureStatus from '../components/signatures/signature_status';
import SignatureConfirmCode from '../components/signatures/signature_confirm_code';
import SignatureShowTitle from '../components/signatures/signature_show_title';
import TermOfCommitment from '../components/signatures/documents/term_of_commitment';
import TermOfAcceptInstitution from '../components/signatures/documents/term_of_accept_institution';
import VueMarkdownPreview from 'vue-markdown';

const components = {
  Datetimepicker,
  FlashMessages,
  ProfileImagePreview,
  OrientationCancel,
  OrientationRenew,
  OrientationStatus,
  OrientationStatusFilter,
  Search,
  SignatureButton,
  SignatureDownloadButton,
  SignatureConfirm,
  SignatureConfirmCode,
  SignatureShowTitle,
  SignatureStatus,
  TermOfCommitment,
  TermOfAcceptInstitution,
  VueMarkdownPreview
};

export {components};
