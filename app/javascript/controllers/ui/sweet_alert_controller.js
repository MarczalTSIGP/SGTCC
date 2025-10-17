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
    let type = this.messageTypeValue;

    if (type.includes('sweet')) {
      type = type.replace('sweet_', '');
      swal('', message, type);
    }
  };
}
