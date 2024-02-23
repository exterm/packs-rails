require "rails/railtie"

module Packs
  module Rails
    class Railtie < ::Rails::Railtie
      config.before_configuration do |app|
        Integrations::Rails.new(app)
        Integrations::FactoryBot.new(app)

        # This is not used within packs-rails. Rather, this allows OTHER tools to
        # hook into packs-rails via ActiveSupport hooks.
        ActiveSupport.run_load_hooks(:packs_rails, Packs)

        if defined?(Spring)
          Packs::Specification::Configuration.fetch.pack_paths.each do |dir|
            Dir["#{dir}/package.yml"].each do |package_yml|
              Spring.watch(package_yml)
            end
          end
        end
      end
    end
  end
end
