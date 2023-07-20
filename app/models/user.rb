class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable

  #original code was devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable
  #remove registerable so that sign in user can create user

  has_many :assignment
  has_many :shipment
  has_many :container
  has_many :finance

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def active_for_authentication?
    super && active==1
  end

end
