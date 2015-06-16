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
jquery-slimscroll/jquery.slimscroll.min.js
switchery/switchery.min.js
uniform/jquery.uniform.min.js
classie/classie.js
waves/waves.min.js
modern.js
)

# Index Page Assets (broker & policies) (css & js)
Rails.application.config.assets.precompile += %w(
datatables/css/jquery.datatables.css
datatables/css/jquery.datatables_themeroller.css
datatables/js/jquery.datatables.min.js
pages/table-data.js )

# Show Page Assets (policies) (css & js)
Rails.application.config.assets.precompile += %w(
x-editable/bootstrap3-editable/css/bootstrap-editable.css
x-editable/inputs-ext/typeaheadjs/lib/typeahead.js-bootstrap.css
x-editable/inputs-ext/address/address.css
select2/css/select2.min.css
dropzone/dropzone.min.css

moment/moment.js
x-editable/bootstrap3-editable/js/bootstrap-editable.js
x-editable/inputs-ext/typeaheadjs/lib/typeahead.js
x-editable/inputs-ext/typeaheadjs/typeaheadjs.js
x-editable/inputs-ext/address/address.js
select2/js/select2.full.min.js
dropzone/dropzone.min.js
pages/form-x-editable.js
)
