class Article
  include MongoMapper::Document

  many :comments, dependent: :destroy
  key :title, String, required: true, length: { minimum: 5 }
  key :text, String
end