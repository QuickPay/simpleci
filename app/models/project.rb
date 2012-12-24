# -*- encoding: utf-8; mode: ruby; tab-width: 2; indent-tabs-mode: nil -*-
require "app/models/user"
require "app/models/build"

class Project < ActiveRecord::Base
  has_and_belongs_to_many :users
  has_many :builds

  #
  # Validation
  #

  validates :name, :uniqueness => true
  validates :name, :path, :command, :presence => true
  validates :path, :format => { :with => /^(git|hg):\/\/(.+)/, :message => "must start with \"git://\" or \"hg://\"" }

end
