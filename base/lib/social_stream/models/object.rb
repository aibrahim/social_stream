module SocialStream
  module Models
    # Additional features for models that are Activity Objects
    module Object
      extend ActiveSupport::Concern

      included do
        subtype_of :activity_object,
                   :build => { :object_type => to_s }

        unless self == Actor
          validates_presence_of :author_id, :owner_id, :user_author_id

          after_create :create_post_activity
          # Disable update activity for now
          # It usually appears repeated in the wall and provides no useful information
          #after_update :create_update_activity
        end

        scope :authored_by, lambda { |subject|
          joins(:activity_object).
            merge(ActivityObject.authored_by(subject))
        }
      end
    end
  end
end
