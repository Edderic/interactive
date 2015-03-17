class QuestionWithLazyFullExplanation < SimpleDelegator
  def ask_and_wait_for_valid_response(&block)
    loop do
      puts "#{question} #{options.shortcuts_string}"
      resp = Interactive::Response.new(options)
      puts options.shortcuts_meanings if resp.invalid?

      yield resp
      break unless resp.invalid?
    end
  end
end
