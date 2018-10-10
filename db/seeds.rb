Professor.create_with(password: '123456').
  find_or_create_by!(email: 'responsavel@email.com')
