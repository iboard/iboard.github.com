# -*- encoding : utf-8 -*-

require_relative "./page_parts"

# Helpers
def relative_root_path(to)
  return '' unless to
  if to =~ /^pages/
    printf "route to page #{to} "
    "../"
  else
    printf "route to root #{to.inspect} "
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
  printf " => #{outfile} "
  printf "ROOT=#{relative_root_path(outfile)} "
  if !File.exist?(outfile) || File::mtime(file) > File::mtime(outfile)
    main = Haml::Engine.new(File.read(file))
    erb = ERB.new(main.render)
    @file = file
    write_index( erb.result(binding), outfile )
  end
end


def clear_html_files
  with_each_html_file do |file|
    puts "Remove file #{file}"
    File.unlink file
  end
end


def write_index(yield_block=nil,output_to=nil)
  index_template = html_index_template
  buffer = assamble_index_haml(index_template, PageParts.new, yield_block, output_to)

  output_to ||= index_html_file
  index = File.new(output_to, "w")
  result = ERB.new(buffer.gsub(/__ROOTPATH__/, relative_root_path(output_to)))
  @file = __FILE__
  index << result.result(binding)
  index.close
end

private

def assamble_index_haml(index_template, page_parts, yield_block, output_to)
  index_template.gsub(/__YIELD__/, (yield_block ? '' : page_parts.main.render))
      .gsub(/__HERO_UNIT__/, yield_block ? yield_block : page_parts.hero.render)
      .gsub(/__SIDEBAR_TOP__/, page_parts.sb_top.render)
      .gsub(/__SIDEBAR_BOTTOM__/, page_parts.sb_bottom.render)
      .gsub(/__MAIN_MENU__/, page_parts.main_menu.render(locals: {current_page: output_to}))
end

def with_each_html_file
  path = File.expand_path('../../pages', __FILE__)
  Dir.foreach(path) do |file|
    yield( File.join(path,file) ) if file =~ /html$/
  end
end

def index_html_file
  File.expand_path('../../index.html', __FILE__)
end

def html_index_template
  File.read(File.expand_path('../../templates/index.html', __FILE__))
end

