class ImportColorsToThemeColor < ActiveRecord::Migration[6.0]
  def change
    Rake::Task['populate:colors'].invoke
  end
end
