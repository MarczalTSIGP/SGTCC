import { Controller } from '@hotwired/stimulus';

import swal from 'sweetalert';

export default class extends Controller {

  static values = {
    messageType: String,
    messageText: String
  };

  connect() {
    this.show();
  }

  show = () => {
    const message = this.messageTextValue;
    const type = this.messageTypeValue;
    swal('', message, type);
  };
}
