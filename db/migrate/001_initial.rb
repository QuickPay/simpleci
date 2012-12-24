# -*- encoding: utf-8; mode: ruby; tab-width: 2; indent-tabs-mode: nil -*-
require "app/models/user"

class Initial < ActiveRecord::Migration
  
  def self.up
    
    create_table :users do |t|
      t.timestamps
      t.string :email, :null => false, :unique => true
      t.string :password, :null => false
      t.boolean :admin, :default => false
    end
    User.new({ :email => "admin@domain.tld", :password => "abcd1234", :password_confirmation => "abcd1234", :admin => true }).save

    create_table :projects do |t|
      t.timestamps
      t.string :name, :null => false, :unique => true
      t.string :path, :null => false
      t.string :branch, :null => false, :default => "master"
      t.string :command, :null => false
      t.string :hook
    end

    create_table :projects_users, :id => false do |t|
      t.integer :user_id, :null => false
      t.integer :project_id, :null => false
    end
    add_foreign_key(:users, :users_projects, column: "user_id")
    add_foreign_key(:projects, :users_projects, column: "project_id")

    create_table :builds do |t|
      t.timestamps
      t.integer :project_id
      t.boolean :status
      t.text :output
      t.string :commit_version
      t.string :commit_message
      t.string :commit_author
    end
    add_foreign_key(:builds, :projects, column: "project_id", dependent: :delete)
        
  end
  
  def self.down
    drop_table :users_projects
    drop_table :builds
    drop_table :projects
    drop_table :users
  end
  
end
