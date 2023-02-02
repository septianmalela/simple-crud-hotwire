class Inbox < ApplicationRecord
  validates :name, presence: true, allow_blank: false

  # after_create_commit { broadcast_prepend_to "inboxes" }
  broadcasts 'inboxes'
end
