# frozen_string_literal: true

class Song < ApplicationRecord
  include Searchable

  validates :name, :file_path, :md5_hash, presence: true

  belongs_to :album
  belongs_to :artist

  search_by :name, associations: [:artist, :album]

  def format
    file_format = MediaFile.format(file_path)
    file_format.in?(Stream::TRANSCODING_FORMATS) ? Stream::TRANSCODE_FORMAT : file_format
  end

  def favorited?
    id.in? Current.user.favorite_playlist
  end

  def self.find_ordered(ids)
    order_clause = ids.map { |id| "id=#{id} desc" }.join(',')
    where(id: ids).order(Arel.sql(order_clause))
  end
end
