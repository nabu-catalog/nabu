class EssenceDestructionService
  # remove file and db record(s)
  def self.destroy(essence)
    result = true

    response = Proxyist.delete_object(essence.item.full_identifier, essence.filename)
    result = false if response.code != '204'

    Rails.logger.info "[DELETE] Removed essence file at [#{essence.item.full_identifier}:#{essence.filename}"

    files = Proxyist.list(essence.item.full_identifier)

    # NOTE: This logic might be broken as it deletes checksum files which cover more than a single essence
    admin_files_regex = essence.filename.sub(/\..+?$/, '.*PDSC_ADMIN.*')
    admin_files = files.grep(Regexp.new(admin_files_regex))
    admin_files.each { |file| Proxyist.delete_object(essence.item.full_identifier, file) }

    Rails.logger.info "[DELETE] Removed any admin files for essence at [#{admin_files_regex}]"

    essence.destroy

    if result
      { notice: 'Essence removed successfully, and file deleted from archive (undo not possible).' }
    else
      { error: "Essence removed, but deleting file failed: #{response.message}" }
    end
  end
end
