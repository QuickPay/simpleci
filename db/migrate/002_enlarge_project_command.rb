class EnlargeProjectCommand < ActiveRecord::Migration
  
  def self.up
    change_column :projects, :command, :text
  end

  def self.down
    change_column :projects, :command, :string
  end

end
