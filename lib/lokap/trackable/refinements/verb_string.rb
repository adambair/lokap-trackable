module Lokap
  module VerbString
    refine String do
      include ::Verbs::Verblike::Access
    end
  end
end
