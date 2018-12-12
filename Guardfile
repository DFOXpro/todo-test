# A sample Guardfile
# More info at https://github.com/guard/guard#readme

## Uncomment and set this to only include directories you want to watch
# directories %w(app lib config test spec features) \
#	.select{|d| Dir.exists?(d) ? d : UI.warning("Directory #{d} does not exist")}

## Note: if you are using the `directories` clause above and you are not
## watching the project directory ('.'), then you will want to move
## the Guardfile to a watched dir and symlink it back, e.g.
#
#	$ mkdir config
#	$ mv Guardfile config/
#	$ ln -s config/Guardfile .
#
# and, you'll have to watch "config/Guardfile" instead of "Guardfile"

#The apply_css_live is for stylus assets system
guard 'livereload', apply_css_live: false do
	extensions = {
		css: :css,
		stylus: :css,
		#coffee: :js,#see coffee_watch_task
		js: :js,
		html: :html,
		png: :png,
		gif: :gif,
		jpg: :jpg,
		jpeg: :jpeg,
		ttf: :ttf,
		woff: :woff
	}

	rails_view_exts = %w(haml)

	# file types LiveReload may optimize refresh for
	compiled_exts = extensions.values.uniq
	watch(%r{public/.+\.(#{compiled_exts * '|'})})

	extensions.each do |ext, type|
		watch(%r{
					(?:app|vendor)
					(?:/assets/\w+/(?<path>[^.]+) # path+base without extension
					 (?<ext>\.#{ext})) # matching extension (must be first encountered)
					(?:\.\w+|$) # other extensions
					}x) do |m|
			path = m[1]
			"/assets/#{path}.#{type}"
		end
	end

	# file needing a full reload of the page anyway
	watch(%r{app/views/.+\.(#{rails_view_exts * '|'})$})
	watch(%r{app/helpers/.+\.rb})
	watch(%r{config/locales/.+\.yml})
end


#Scaping the default coffee-rails and coffee-guard
	#why cus with this we can set output filenames, concat then compile
##coffee_watch_task begin
#Coffee_Settings
cs ={
	src_path: 'src/',
	output_path: 'app/assets/javascripts/',
	input_coffee_file: 'output.yaml',
	path_compiler_coffee: 'coffee',
	params_compiler_coffee: '-cj',
	patterns: Array.new,
	scripts: Array.new
}
cs[:script_compiler_coffee] = cs[:path_compiler_coffee]+' '+cs[:params_compiler_coffee]+' '
cs[:input_coffee] = YAML::load(File.open(cs[:output_path] + cs[:src_path] + cs[:input_coffee_file]))

cs[:input_coffee].each { |js_output, coffee_inputs|
	#Script
	str_script = cs[:script_compiler_coffee] + cs[:output_path] + js_output + '.js '
	#Pattern
	str_pattern = cs[:output_path] + cs[:src_path] + '('
	coffee_inputs.each { |coffee|
		str_script += cs[:output_path] + cs[:src_path] + coffee + '.coffee '
		str_pattern += coffee + '|'
	}
	#if needs & or ; or any extra EOS text
	cs[:scripts] << str_script += ''
	cs[:patterns] << Regexp.new(str_pattern += ').coffee')

}
#puts cs[:patterns], cs[:scripts]
guard :shell do
	cs[:scripts].each_index { |i|
		watch cs[:patterns][i] {|m|
			"#{m[0]} has change."
			system cs[:scripts][i]
		}
	}
end
##coffee_watch_task end