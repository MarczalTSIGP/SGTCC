User.create_with(email: 'responsavel@email.com', password: '123456').find_or_create_by!(email: 'responsavel@email.com')
