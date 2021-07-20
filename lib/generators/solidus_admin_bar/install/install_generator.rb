# frozen_string_literal: true

module SolidusAdminBar
  module Generators
    class InstallGenerator < Rails::Generators::Base
      class_option :auto_run_migrations, type: :boolean, default: false
      source_root File.expand_path('templates', __dir__)

      def add_stylesheets
        inject_into_file 'vendor/assets/stylesheets/spree/frontend/all.css', " *= require spree/frontend/solidus_admin_bar\n", before: %r{\*/}, verbose: true # rubocop:disable Layout/LineLength
      end
    end
  end
end
