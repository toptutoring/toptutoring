class RunSeeds < ActiveRecord::Migration[5.0]
  def change
    Rake::Task['prod:seed'].invoke
  end
end
