require 'nabu/media'

# Batch transformation of images.
# For an individual transformation, see ImageTransformerService.
class BatchImageTransformerService
  def self.run(batch_size, verbose, dry_run)
    batch_image_transformer_service = new(batch_size, verbose, dry_run)
    batch_image_transformer_service.run
  end

  def initialize(batch_size, verbose, dry_run)
    @batch_size = batch_size
    @image_files = find_image_files
    @verbose = verbose
    @dry_run = dry_run
  end

  def find_image_files
    Essence.includes(item: [:collection]).where(derived_files_generated: false).where('mimetype like ?', 'image/%').limit(@batch_size)
  end

  def run
    @image_files.each do |image_file|
      next unless File.file?(image_file.path)
      item = image_file.item
      file = image_file.path
      extension = File.extname(file)
      begin
        media = Nabu::Media.new image_file.path
        image_transformer = ImageTransformerService.new(media, file, item, image_file, extension, @verbose)
        if @dry_run
          puts "Would transform #{file} for item #{item.id}"
        else
          image_transformer.perform_conversions
        end
      rescue => e
        puts "    WARNING: file #{file} skipped - error transforming image [#{e.message}]"
        puts "    >> #{e.backtrace}" if @verbose
        next
      end
    end
  end
end
