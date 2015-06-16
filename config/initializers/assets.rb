# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path
# Rails.application.config.assets.paths << Emoji.images_path

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
# Rails.application.config.assets.precompile += %w( search.js )

Rails.application.config.assets.paths << Rails.root.join("vendor", "assets", "plugins")

# Template Assets (all pages) (js)
Rails.application.config.assets.precompile += %w(
jquery-ui/jquery-ui.min.js
pace-master/pace.min.js
jquery-blockui/jquery.blockui.js
bootstrap/js/bootstrap.min.js
jquery-slimscroll/jquery.slimscroll.min.js
switchery/switchery.min.js
uniform/jquery.uniform.min.js
classie/classie.js
waves/waves.min.js
3d-bold-navigation/js/main.js
modern.js
)

Rails.application.config.assets.precompile += %w(
pages/table-data.js
pages/form-x-editable.js
)
