module CNPJFormatter
  def self.included(base)
    base.send(:include, InstanceMethods)
  end

  module InstanceMethods
    def cnpj
      sc = super
      sc.class_eval do
        def formatted
          CNPJ.new(self).formatted
        end
      end
      sc
    end

    def cnpj=(cnpj)
      stripped = CNPJ.new(cnpj).stripped
      super(stripped)
    end
  end
end
