Professor.create_with(name: 'Diego Marczal', username: 'marczal', password: '123456')
         .find_or_create_by!(email: 'responsavel@email.com')
