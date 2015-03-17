class QuestionWithEagerFullExplanation < SimpleDelegator
  def ask_and_wait_for_valid_response(&block)
    loop do
      puts "#{question} #{options.shortcuts_string}"
      puts options.shortcuts_meanings
      resp = Interactive::Response.new(options)

      yield resp
      break unless resp.invalid?
    end
  end
end
