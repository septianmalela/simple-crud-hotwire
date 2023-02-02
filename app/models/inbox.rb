class Inbox < ApplicationRecord
  validates :name, presence: true, allow_blank: false

  broadcasts 'inboxes'
end
