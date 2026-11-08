# Base dos Form Objects: entrada de uma interação do usuário que não corresponde a um
# único model persistido. O form interpreta e valida a entrada; mudanças de domínio
# ficam com models e services.
class ApplicationForm
  include ActiveModel::Model
  include ActiveModel::Attributes
end
