# frozen_string_literal: true

paths = File.expand_path("trackable/*.rb", __dir__)
Dir.glob(paths).sort.each { |path| require path }

module Lokap
  module Trackable
    def self.included(base)
      base.extend(Lokap::Trackable::Base)
    end
  end
end
