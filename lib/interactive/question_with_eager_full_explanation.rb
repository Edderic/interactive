class QuestionWithEagerFullExplanation < SimpleDelegator
  def ask_and_wait_for_valid_response(&block)
    loop do
      @reask = false
      puts "#{question} #{options.shortcuts_string}"
      puts options.shortcuts_meanings
      resp = Interactive::Response(options)

      yield resp
      break if !resp.invalid? && @reask == false
    end
  end

  def reask!
    @reask = true
  end
end
