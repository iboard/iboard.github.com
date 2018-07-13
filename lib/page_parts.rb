class PageParts
  attr_reader :hero, :main, :main_menu, :sb_bottom, :sb_top

  def initialize
    read_haml_files
  end

  private

  def read_haml_files
    @main = Haml::Engine.new(parts[:index])
    @hero = Haml::Engine.new(parts[:hero])
    @main_menu = Haml::Engine.new(parts[:menu])
    @sb_top = Haml::Engine.new(parts[:sb_top])
    @sb_bottom = Haml::Engine.new(parts[:sb_bottom])
  end

  def parts
    @cache ||= {
        index: File.read(File.expand_path('../../templates/index.haml.erb', __FILE__)),
        hero: File.read(File.expand_path('../../templates/_hero.haml.erb', __FILE__)),
        menu: File.read(File.expand_path('../../templates/menu_main.haml.erb', __FILE__)),
        sb_top: File.read(File.expand_path('../../templates/_sidebar_top.haml.erb', __FILE__)),
        sb_bottom: File.read(File.expand_path('../../templates/_sidebar_bottom.haml.erb', __FILE__)),
    }
  end

end