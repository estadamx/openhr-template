say_status "openHR", "Adding Bootstrap and dartsass gems", :blue

gem "dartsass-rails"
gem "bootstrap"

after_bundle do
  say_status "openHR", "Installing dartsass", :blue
  run "bin/rails dartsass:install"

  say_status "openHR", "Pinning Bootstrap and Popper.js in importmap", :blue

  gemfile_lock = File.read("Gemfile.lock")

  bootstrap_version = gemfile_lock[/bootstrap \(([\d.]+)\)/, 1]
  popper_version = gemfile_lock[/popper_js \(>= ([\d.]+),/, 1]

  if bootstrap_version && popper_version
    say_status "openHR", "Detected bootstrap #{bootstrap_version} and popper_js >= #{popper_version}", :blue

    importmap_path = "config/importmap.rb"
    bootstrap_pin = "pin \"bootstrap\", to: \"https://ga.jspm.io/npm:bootstrap@#{bootstrap_version}/dist/js/bootstrap.esm.js\""
    popper_pin = "pin \"@popperjs/core\", to: \"https://unpkg.com/@popperjs/core@#{popper_version}/dist/esm/index.js\""

    unless File.read(importmap_path).include?("pin \"bootstrap\"")
      append_to_file importmap_path do
        "\n#{bootstrap_pin}\n"
      end
      say_status "openHR", "Pinned Bootstrap #{bootstrap_version}", :green
    else
      say_status "openHR", "Bootstrap already pinned", :yellow
    end

    unless File.read(importmap_path).include?("pin \"@popperjs/core\"")
      append_to_file importmap_path do
        "#{popper_pin}\n"
      end
      say_status "openHR", "Pinned Popper.js #{popper_version}", :green
    else
      say_status "openHR", "Popper.js already pinned", :yellow
    end
  else
    say_status "openHR", "Could not detect versions in Gemfile.lock", :red
  end

  say_status "openHR", "Injecting Bootstrap import into application.scss", :blue
  remove_file "app/assets/stylesheets/application.css" if File.exist?("app/assets/stylesheets/application.css")
  scss_path = "app/assets/stylesheets/application.scss"
  bootstrap_import = '@use "bootstrap" as *;'

  if File.exist?(scss_path)
    unless File.read(scss_path).include?(bootstrap_import)
      append_to_file scss_path do
        "\n#{bootstrap_import}\n"
      end
      say_status "openHR", "Added Bootstrap import to existing application.scss", :green
    else
      say_status "openHR", "Bootstrap already imported in application.scss", :yellow
    end
  else
    create_file scss_path, <<~SCSS
      #{bootstrap_import}
    SCSS
    say_status "openHR", "Created application.scss with Bootstrap import", :green
  end

  say_status "openHR", "Adding Bootstrap JS to application.js", :blue
  inject_into_file "app/javascript/application.js", before: 'import "controllers"' do
    <<~JS
      import "@popperjs/core"
      import * as bootstrap from "bootstrap";
    JS
  end

  say_status "openHR", "Ignoring all future SASS deprecation warnings", :blue
  append_to_file "config/initializers/assets.rb" do
    'Rails.application.config.dartsass.build_options << "--quiet-deps"'
  end

  say_status "openHR", "Precompiling assets", :blue
  run "bin/rails assets:precompile"

  say_status "openHR", "Bootstrap setup complete 🎉", :green
end
