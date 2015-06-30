class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable, 
         :recoverable, :rememberable, :trackable, :validatable

  has_and_belongs_to_many :roles

  def role?( role )
   !roles.find_by_name( role.to_s.camelize ).nil?
  end
end
