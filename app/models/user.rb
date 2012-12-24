# -*- encoding: utf-8; mode: ruby; tab-width: 2; indent-tabs-mode: nil -*-
require "digest/md5"
require "app/models/project"

class User < ActiveRecord::Base
  attr_accessor :password_confirmation
  has_and_belongs_to_many :projects

  #
  # Validation
  #

  validates :email, :presence => true
  validates :email, :uniqueness => true
  validates :email, :length => { :in => 5..250 }

  validates :password, :length => { :in => 7..128 }
  validates :password, :confirmation => true
  validates :password, :password_confirmation, :presence => true, :on => :create

  private

  # hash password
  before_save do
    self.password = Digest::MD5::hexdigest(self.password) if self.password_changed?
  end

  def self.authenticate(email, password)
    User.find(:first, :conditions => { :email => email, :password => Digest::MD5.hexdigest(password) })
  end

end
