import axios from 'axios';

const csrf_token = document.getElementsByName('csrf-token')[0];

if (csrf_token !== undefined) {
  const token = csrf_token.getAttribute('content');
  axios.defaults.headers.common['X-CSRF-Token'] = token;
  axios.defaults.headers.common['Accept'] = 'application/json';
}

export {axios};
