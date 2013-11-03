module Sy18nc
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path("../../templates", __FILE__)

      desc "Creates a Sy18nc initializer."

      def copy_initializer
        template "sy18nc.rb", "config/initializers/sy18nc.rb"
      end
    end
  end
end
