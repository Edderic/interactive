require 'delegate'
require 'interactive'

module Interactive
  module_function
  def Options(options=[], columns=[])
    if options.empty?
      EmptyOptions.new([])
    elsif Array(columns).any?
      TabularOptions.new(options, columns)
    else
      NonEmptyOptions.new(options)
    end
  end

  class NonEmptyOptions < SimpleDelegator
    include Interactive
    def initialize(options)
      @options = options
      flatten_ranges(@options)
      wrap_each_option
      super(@options)
    end

    def shortcuts_string
      "[#{first_chars_without_last_slash(first_chars)}]"
    end

    def shortcuts_meanings
      @options.inject("") { |accum, opt| "#{accum}  #{opt.shortcut_value} -- #{opt.value}\n"}
    end

    def has_hash?
      @options.any? {|opt| opt.respond_to?(:to_hash) }
    end

    private

    def flatten_ranges(options)
      @options = options.inject([]) do |accum, opt|
        if opt.class == Range
          accum | opt.to_a
        elsif opt.respond_to?(:to_a)
          accum | opt.map.with_index {|item, index| {index.to_s => item} }
        else
          accum << opt
        end
      end
    end

    def wrap_each_option
      @options.map! {|option| Option(option) }
    end

    def first_chars
      @options.inject("") { |accum, opt| "#{accum}#{ opt.shortcut_value}/" }
    end

    def first_chars_without_last_slash(first_chars)
      first_chars[0..first_chars.length-2]
    end
  end

  class TabularOptions < NonEmptyOptions
    def initialize(options, columns)
      @options = options
      @headings = columns.clone
      columns.shift
      @table_columns = columns
      super(@options)
    end

    def shortcuts_meanings
      non_table_shortcuts_meanings + table_shortcuts_meanings
    end

    private

    def non_table_shortcuts_meanings
      non_table_options.inject("") {|accum, opt| "#{accum}  #{opt[0]} -- #{opt}\n"}
    end

    def table_shortcuts_meanings
      @table = Terminal::Table.new(headings: @headings)
      @table.align_column(0, :right)
      rows.each {|row| @table << row}
      @table.to_s
    end

    def non_table_options
      @options.reject do |opt|
        @table_columns.inject(true) {|accum, col| accum && opt.value.respond_to?(col) }
      end
    end

    def table_options
      @options.select do |opt|
        opt_responds_to_each_column?(opt)
      end
    end

    def rows
      table_options.map.with_index do |opt, index|
        @table_columns.inject([]) do |accum, col|
          accum << opt.value.send(col)
        end.insert(0, index)
      end
    end

    def opt_responds_to_each_column?(opt)
      @table_columns.inject(true) {|accum, col| accum && opt.value.respond_to?(col) }
    end
  end


  class EmptyOptions < SimpleDelegator
    def initialize(options)
      @options = options
      super(@options)
    end

    def shortcuts_string
      ''
    end

    def shortcuts_meanings
      ''
    end

    def has_hash?
      false
    end
  end
end
