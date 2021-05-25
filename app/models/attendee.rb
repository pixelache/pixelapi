class Attendee < ActiveRecord::Base
  belongs_to :user, optional: true
  belongs_to :item, polymorphic: true
  validates :email, presence: true, uniqueness: { scope: :item_id }
  validates :name, presence: true
  validates :phone, presence: true

  scope :by_festival, -> (festival) { where(:item_id => festival, :item_type => "Festival")}
  scope :by_event, -> (event) { where(:item_id => event, :item_type => "Event")}
  scope :by_post, -> (post) { where(:item_id => post, :item_type => "Post")}
  scope :not_waiting, -> () { where("waiting_list is not true")}

  
end
