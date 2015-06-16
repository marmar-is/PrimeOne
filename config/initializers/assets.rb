# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path
# Rails.application.config.assets.paths << Emoji.images_path

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
# Rails.application.config.assets.precompile += %w( search.js )
Rails.application.config.assets.paths << Rails.root.join("vendor", "assets", "plugins")
Rails.application.config.assets.paths << Rails.root.join("vendor", "assets", "images")

# Icons
#Rails.application.config.assets.paths << Rails.root.join("app", "assets", "fonts")
#Rails.application.config.assets.precompile += %w( .svg .eot .woff .ttf )

# Template Assets (all pages) (js)
Rails.application.config.assets.precompile += %w( pace-master/pace.min.js
jquery-blockui/jquery.blockui.js
bootstrap/js/bootstrap.min.js
jquery-slimscroll/jquery.slimscroll.min.js
switchery/switchery.min.js
uniform/jquery.uniform.min.js
classie/classie.js
waves/waves.min.js
3d-bold-navigation/js/main.js
modern.min.js
jquery-ui/jquery-ui.min.js
policies.css
bootstrap/css/bootstrap.min.css)

# Index Page Assets (broker & policies) (css & js)
Rails.application.config.assets.precompile += %w( datatables/css/jquery.datatables.css
datatables/css/jquery.datatables_themeroller.css
moment/moment.js
datatables/js/jquery.datatables.min.js
pages/table-data.js )

# Show Page Assets (policies) (css & js)
Rails.application.config.assets.precompile += %w( x-editable/bootstrap3-editable/css/bootstrap-editable.css
x-editable/inputs-ext/typeaheadjs/lib/typeahead.js-bootstrap.css
x-editable/inputs-ext/address/address.css
select2/css/select2.min.css
bootstrap-datetimepicker/css/bootstrap-datetimepicker.min.css
dropzone/dropzone.min.css
x-editable/bootstrap3-editable/js/bootstrap-editable.js
x-editable/inputs-ext/typeaheadjs/lib/typeahead.js
x-editable/inputs-ext/typeaheadjs/typeaheadjs.js
x-editable/inputs-ext/address/address.js
select2/js/select2.full.min.js
bootstrap-datetimepicker/js/bootstrap-datetimepicker.min.js
pages/form-x-editable.js
dropzone/dropzone.min.js
)

# Form Page Assets (policies) (css & js)
Rails.application.config.assets.precompile += %w(
x-editable/inputs-ext/doc/doc.js
)
