class Comment
  include MongoMapper::EmbeddedDocument

  key :commenter, String
  key :body, String

  belongs_to :article
end
