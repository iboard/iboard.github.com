# -*- encoding : utf-8 -*-

# Helpers
def relative_root_path(to)
  return '' unless to
  if to =~ /^pages/
    printf "route to page #{to}"
    "../"
  else
    printf "route to root #{to.inspect}"
    ""
  end
end

def link_to file, target=nil
  name = file.gsub(/\.haml\.erb/,'')
  _target = target ? "target='#{target}'" : ""
  "<a href='#{name}.html' #{_target}>#{File.basename(name)}</a>"
end

def make_file(file)
  outfile = file.split(/\./)[0..-3].join(".")+".html"
  printf " => #{outfile}"
  printf " ROOT=#{relative_root_path(outfile)}"
  if !File.exist?(outfile) || File::mtime(file) > File::mtime(outfile)
    main = Haml::Engine.new(File.read(file))
    erb = ERB.new(main.render)
    @file = file
    write_index( erb.result(binding), outfile )
  end
end

def clear_html_files
  Dir.foreach( File.expand_path('../../pages',__FILE__) ) do |file|
    if file =~ /html$/
      File.unlink File.expand_path('../../pages/'+file, __FILE__)
    end
  end
end

def write_index(yield_block=nil,output_to=nil)
  index_template = File.read(File.expand_path('../../templates/index.html',__FILE__))

  main = Haml::Engine.new(File.read(File.expand_path('../../templates/index.haml.erb',__FILE__)))
  hero = Haml::Engine.new(File.read(File.expand_path('../../templates/_hero.haml.erb',__FILE__)))
  main_menu = Haml::Engine.new(File.read(File.expand_path('../../templates/menu_main.haml.erb',__FILE__)))
  sb_top=Haml::Engine.new(File.read(File.expand_path('../../templates/_sidebar_top.haml.erb',__FILE__)))
  sb_bottom=Haml::Engine.new(File.read(File.expand_path('../../templates/_sidebar_bottom.haml.erb',__FILE__)))
  buffer = index_template.gsub(/__YIELD__/, (yield_block ? '' : main.render))
                         .gsub(/__HERO_UNIT__/, yield_block ? yield_block : hero.render)
                         .gsub(/__SIDEBAR_TOP__/, sb_top.render)
                         .gsub(/__SIDEBAR_BOTTOM__/, sb_bottom.render)
                         .gsub(/__MAIN_MENU__/, main_menu.render(locals: { current_page: output_to}))

  output_to ||= File.expand_path('../../index.html', __FILE__)
  index = File.new(output_to, "w")
  result = ERB.new(buffer.gsub(/__ROOTPATH__/, relative_root_path(output_to)))
  @file = __FILE__
  index << result.result(binding)
  index.close
end
