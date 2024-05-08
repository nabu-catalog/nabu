require 'oai/provider'

# TODO: Send these patches upstream in some way
module RecordResponseExtensions
  private

  # We don't want to use database ids for the identifier
  def identifier_for(record)
    "#{provider.prefix}:#{record.full_identifier}"
  end

  protected

  def valid?
    validate_identifier
    super
  end

  def validate_identifier
    return if @options[:identifier].nil?

    if @options[:identifier] !~ /((([A-Za-z]{3,9}:(?:\/\/)?)(?:[\-;:&=\+\$,\w]+@)?[A-Za-z0-9\.\-]+|(?:www\.|[\-;:&=\+\$,\w]+@)[A-Za-z0-9\.\-]+)((?:\/[\+~%\/\.\w\-_]*)?\??(?:[\-\+=&;%@\.\w_]*)#?(?:[\.\!\/\\\w]*))?)/
      raise OAI::ArgumentException.new
    end
  end
end

module OAI::Provider::Response
  class Base
    private

    # We need to convert the identifiers back to database IDs
    def extract_identifier(id)
      full_identifier = id.sub(/#{provider.prefix}:/, '')

      if full_identifier =~ /-/
        collection_identifier, item_identifier = full_identifier.split(/-/)
        collection = Collection.where(identifier: collection_identifier).first
        raise OAI::IdException.new unless collection

        item = collection.items.where(identifier: item_identifier).first
        raise OAI::IdException.new unless item

        item.id
      else
        collection = Collection.where(identifier: full_identifier).first
        raise OAI::IdException.new unless collection

        collection.id
      end
    end
  end

  class RecordResponse < Base
    prepend RecordResponseExtensions
  end
end

# Make zeitwork happy
module Monkeypatch
end
