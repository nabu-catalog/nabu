module Nabu
  # TODO: Create spreadsheet version which handles DataType entries.
  class NabuSpreadsheet
    attr_accessor :notices, :errors, :collection, :items

    def self.new_of_correct_type(data)
      book = load_spreadsheet(data)
      book.sheet(0) unless book.nil?
      case
      when book.nil?
        NullNabuSpreadsheet.new
      # Currently parsed as a Float of value 2.0
      when book.row(1)[2].to_i == 2
        Version2NabuSpreadsheet.new(book)
      when book.row(1)[2].to_i == 3
        Version3NabuSpreadsheet.new(book)
      else
        Version1NabuSpreadsheet.new(book)
      end
    end

    # In theory, the program could determine which extension to try first by using Content-Type.
    def self.load_spreadsheet(data)
      # open Spreadsheet as "file"
      string_io = StringIO.new(data)
      try_xls(string_io) || try_xlsx(string_io)
    end

    def self.try_xls(string_io)
      Roo::Spreadsheet.open(string_io, extension: :xls)
    rescue Ole::Storage::FormatError
      nil
    end

    def self.try_xlsx(string_io)
      Roo::Spreadsheet.open(string_io, extension: :xlsx)
    rescue Zip::Error
      nil
    end

    def initialize(book)
      @notices = []
      @errors = []
      @items = []
      @book = book
    end

    def parse
      coll_id = parse_coll_id
      @collection = Collection.find_by_identifier coll_id
      collector = parse_user
      unless collector
        @errors << "ERROR collector does not exist"
        return
      end
      parse_collection_info(collector, coll_id)
      return unless @errors.empty?

      if @collection.save
        @notices << "Saved collection #{coll_id}, #{collection.title}"
      else
        @errors << "ERROR saving collection #{coll_id}, #{collection.title}, #{collection.description}"
        return
      end

      # parse items in XLS file
      item_start_row.upto(@book.last_row) do |row_number|
        row = @book.row(row_number)
        break if row[0].nil? # if first cell empty
        parse_row(row, collector)
      end
    end #parse

    def valid?
      @errors.empty? && @collection.valid?
    end

    private

    def parse_user
      first_name, last_name = parse_user_names
      user = User.where(first_name: first_name, last_name: last_name).first

      unless user
        @errors << "Please create user #{[first_name, last_name].join(" ")} first<br/>"
        return nil
      end
      user.save if user.valid?
      user
    end

    def parse_collection_info(collector, coll_id)
      if @collection
        if @collection.collector != collector
          @errors << "Collection #{coll_id} exists but with different collector #{collector.name} - please fix spreadsheet"
        end
        return
      end

      @collection = Collection.new
      @collection.identifier = coll_id
      @collection.collector = collector
      @collection.private = true
      @collection.title = 'PLEASE PROVIDE TITLE'
      @collection.description = 'PLEASE PROVIDE DESCRIPTION'
      # update collection details
      @collection.title = parse_collection_title unless parse_collection_title.blank?
      @collection.description = parse_collection_description unless parse_collection_description.blank?
    end

    def parse_row(row, collector)
      item_id = row[0].to_s

      # if collection_id is part of item_id string, remove it
      item_id.slice! "#{@collection.identifier}-"

      item = Item.where(:collection_id => @collection.id).where(:identifier => item_id)[0]
      unless item
        item = Item.new
        item.identifier = item_id
        item.collection = @collection
        item.private = true
        item.collector = collector

        # inherit from collection
        item.university_id = @collection.university_id
        item.operator_id = @collection.operator_id
        item.region = @collection.region
        item.north_limit = @collection.north_limit
        item.south_limit = @collection.south_limit
        item.west_limit = @collection.west_limit
        item.east_limit = @collection.east_limit
        item.access_condition_id = @collection.access_condition_id
        item.access_narrative = @collection.access_narrative
        item.admin_ids = @collection.admin_ids
        item.title = 'PLEASE PROVIDE TITLE'
        item.description = 'PLEASE PROVIDE DESCRIPTION'
      end

      # update title and description
      item.title = row[1].to_s unless row[1].blank?
      item.description = row[2].to_s unless row[2].blank?

      # add content and subject language
      if row[3].present?
        content_languages = row[3].split('|')
        content_languages.each do |language|
          content_language = Language.find_by_name(language) || Language.find_by_code(language)
          if content_language
            item.content_languages << content_language unless item.content_languages.include? content_language
          else
            @notices << "Item #{item.identifier} : Content language '#{language}' not found"
          end
        end
      end
      if row[4].present?
        subject_languages = row[4].split('|')
        subject_languages.each do |language|
          subject_language = Language.find_by_name(language) || Language.find_by_code(language)
          if subject_language
            item.subject_languages << subject_language unless item.subject_languages.include? subject_language
          else
            @notices << "Item #{item.identifier} : Subject language '#{language}' not found"
          end
        end
      end

      # add countries
      if row[5].present?
        countries = row[5].split('|')
        countries.each do |country|
          code, _ = country.strip.split(' - ')
          cntry = Country.find_by_code(code.strip)
          unless cntry
            # try country name
            cntry = Country.find_by_name(code.strip)
            unless cntry
              @notices << "Item #{item.identifier} : Country not found - Item skipped"
              return nil
            end
          end
          item.countries << cntry unless item.countries.include? cntry
        end
      end

      # add origination date
      if row[6].present?
        date = row[6].to_s
        if date.length == 4 ## take a guess they forgot the month & day
          date = date + "-01-01"
        end
        begin
          date_conv = date.to_date
        rescue
          @notices << "Item #{item.identifier} : Date invalid - Item skipped"
          return nil
        end
        item.originated_on = date_conv unless date_conv.blank?
      end

      # add region
      if row[7].present?
        item.region = row[7]
      end

      # add original media
      if row[8].present?
        item.original_media = row[8]
      end

      # add data categories
      if row[9].present?
        data_category_names = row[9].split('|')
        data_category_names.each do |data_category_name|
          data_category = DataCategory.find_by_name(data_category_name)
          if data_category
            item.data_categories << data_category unless item.data_categories.include?(data_category)
          else
            @notices << "Item #{item.identifier} : Data category #{data_category_name} not found - Item skipped"
            return nil
          end
        end
      end

      # add discourse type
      if row[discourse_type_column].present?
        discourse_type_name = row[discourse_type_column]
        discourse_type = DiscourseType.find_by_name(discourse_type_name)
        if discourse_type
          item.discourse_type = discourse_type
        else
          @notices << "Item #{item.identifier} : Discourse type #{discourse_type_name} not found - Item skipped"
          return nil
        end
      end

      # add dialect
      if row[dialect_column].present?
        item.dialect = row[dialect_column]
      end

      # add language as given
      if row[language_column].present?
        item.language = row[language_column]
      end

      # Add agents
      agent_cell_ranges.each do |agent_cell_range|
        break unless row[agent_cell_range.begin].present?
        agent_cells = row[agent_cell_range]
        item_agent = parse_agent(agent_cells)
        # errors added in parse_agent, so don't need to add any more before returning
        return nil unless item_agent
        if item.item_agents.any? { |ia| ia.user_id == item_agent.user_id && ia.agent_role_id == item_agent.agent_role_id }
          # item itself is valid, just don't add the duplicate item_agent to it
          @notices << "Item #{item.identifier} : Duplicate role #{item_agent.agent_role.name}, user #{item_agent.user.name} ignored"
        else
          item.item_agents << item_agent
        end
      end

      if item.valid?
        @items << item
      else
        @notices << "WARNING: item #{item.identifier} invalid - skipped"
      end
    end

    def parse_agent(cells)
      original_role_name = cells[0]
      first_name = cells[1]
      last_name = cells[2]
      last_name = nil if last_name.blank?

      item_agent = ItemAgent.new

      user = User.where(first_name: first_name, last_name: last_name).first

      unless user
        @errors << "Please create role user #{[first_name, last_name].join(" ")} first<br/>"
        return nil
      end

      role_name = original_role_name.strip.tr(' ', '_').downcase
      agent_role = AgentRole.where(name: role_name).first

      unless agent_role
        @errors << "Role not valid: #{original_role_name}"
        return nil
      end

      item_agent.user = user
      item_agent.agent_role = agent_role

      item_agent
    end

    def discourse_type_column
      10
    end

    def dialect_column
      discourse_type_column + 1
    end

    def language_column
      discourse_type_column + 2
    end

    def agent_cell_ranges
      [3..5, 6..8, 9..11, 12..14, 15..17, 18..20].map do |base_range|
        (discourse_type_column + base_range.begin)..(discourse_type_column + base_range.end)
      end
    end
  end

  class NullNabuSpreadsheet < NabuSpreadsheet
    def initialize
      @notices = []
      @errors = ['ERROR File is neither XLS nor XLSX']
      @items = []
    end

    def parse
      # Can't parse anything
    end
  end

  class Version1NabuSpreadsheet < NabuSpreadsheet
    def parse_coll_id
      @book.row(4)[1].to_s
    end

    def parse_collection_title
      @book.row(5)[1]
    end

    def parse_collection_description
      @book.row(6)[1]
    end

    def parse_user_names
      name = @book.row(7)[1]
      unless name
        @errors << "Got no name for collector"
        return nil
      end

      first_name, last_name = name.split(',').map(&:strip)

      if last_name == ''
        last_name = nil
      end
      [first_name, last_name]
    end

    def item_start_row
      13
    end
  end

  class Version2NabuSpreadsheet < NabuSpreadsheet
    def parse_coll_id
      @book.row(6)[1].to_s
    end

    def parse_collection_title
      @book.row(7)[1]
    end

    def parse_collection_description
      @book.row(8)[1]
    end

    def parse_user_names
      first_name = @book.row(9)[1]
      last_name = @book.row(10)[1]

      unless first_name
        @errors << "Got no name for collector"
        return nil
      end

      if last_name == ''
        last_name = nil
      end
      [first_name, last_name]
    end

    def item_start_row
      16
    end
  end

  class Version3NabuSpreadsheet < NabuSpreadsheet
    def parse_coll_id
      @book.row(6)[1].to_s
    end

    def parse_collection_title
      @book.row(7)[1]
    end

    def parse_collection_description
      @book.row(8)[1]
    end

    def parse_user_names
      first_name = @book.row(9)[1]
      last_name = @book.row(10)[1]

      unless first_name
        @errors << "Got no name for collector"
        return nil
      end

      if last_name == ''
        last_name = nil
      end
      [first_name, last_name]
    end

    def item_start_row
      16
    end

    def discourse_type_column
      11
    end
  end
end
