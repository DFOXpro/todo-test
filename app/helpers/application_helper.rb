module ApplicationHelper
	def ZWTDT_server_feedback(id, locale, classes)
		haml_engine = Haml::Engine.new(
			"
%span##{id}.hide#{classes}
	= '#{t id}&nbsp;'
	%span
"
		)
		haml_engine.render
	end
end
