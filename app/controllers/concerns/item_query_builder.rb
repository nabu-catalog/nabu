module ItemQueryBuilder
  FIELDS = Item.column_names.sort # TODO: add join tables to this

  # used by the front-end to provide a relevant input mechanism for the selected field
  TYPES_FOR_FIELDS = {
      collection_id: 'collection',
      identifier: 'text',
      private: 'boolean',
      title: 'text',
      url: 'text',
      collector_id: 'autocomplete',
      university_id: 'collection',
      operator_id: 'autocomplete',
      description: 'text',
      originated_on: 'date',
      language: 'text',
      dialect: 'text',
      region: 'text',
      discourse_type_id: 'collection',
      access_condition_id: 'collection',
      access_narrative: 'text',
      created_at: 'date',
      updated_at: 'date',
      metadata_exportable: 'boolean',
      born_digital: 'boolean',
      tapes_returned: 'boolean',
      original_media: 'text',
      received_on: 'date',
      digitised_on: 'date',
      ingest_notes: 'text',
      metadata_imported_on: 'date',
      metadata_exported_on: 'date',
      tracking: 'text',
      admin_comment: 'comment',
      external: 'boolean',
      originated_on_narrative: 'text',
      north_limit: 'number',
      south_limit: 'number',
      west_limit: 'number',
      east_limit: 'number',
      doi: 'text'
  }


  def sql_operator(operator)
    case operator
      when 'is'
        return '='
      when 'is_not'
        return '!='
      when 'contains'
        return 'like'
      when 'without'
        return 'not like'
    end
  end

  def build_query(clauses, page, per_page)
    results = Item # TODO: add includes/joins here for languages, essences etc
    clauses.each_pair do |_, clause|
      clause_operator = sql_operator(clause['operator'])
      clause_sql = "#{clause['field']} #{clause_operator} ?"
      value_sql = clause_operator.include?('like') ? "%#{clause['input']}%" : clause['input']
      value_sql = value_sql.sub('true', '1').sub('false', '0')
      if clause['logic'] && clause['logic'] == 'OR'
        results = results.or(Item.where(clause_sql, value_sql))
      else
        results = results.where(clause_sql, value_sql)
      end
    end
    results.page(page || 1).per(per_page || -1)
  end
end