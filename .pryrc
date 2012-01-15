#Pry.config.editor = proc { |file, line| "gvim --remote-tab-silent +#{line} #{file}" }
Pry.config.editor = proc { |file, line| "subl -w #{file}:{#line}" }
