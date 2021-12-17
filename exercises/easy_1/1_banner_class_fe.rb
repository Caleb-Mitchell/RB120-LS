class Banner
  def initialize(message, banner_width = 2)
    @message = message
    @banner_width = banner_width.even? ? banner_width : (banner_width + 1)
  end

  def to_s
    [horizontal_rule, empty_line, message_line, empty_line, horizontal_rule].join("\n")
  end

  private

  # def horizontal_rule
  #   '+-' + ('-' * @message.size) + '-+'
  # end

  def horizontal_rule
    if @banner_width < (@message.size + 2)
      '+-' + ('-' * @message.size) + '-+'
    else
      '+' + ('-' * @banner_width) + '+'
    end
  end

  def empty_line
    if @banner_width < (@message.size + 2)
      '| ' + (' ' * @message.size) + ' |'
    else
      '|' + (' ' * @banner_width) + '|'
    end
  end

  def message_line
    '| ' + @message.center((@banner_width - 2), ' ') + ' |'
  end
end


banner = Banner.new('To boldly go where no one has gone before.')
puts banner

banner2 = Banner.new('')
puts banner2

banner3 = Banner.new('six ch', 8)
puts banner3

banner4 = Banner.new('six ch', 9)
puts banner4

banner5 = Banner.new('six ch', 10)
puts banner5

banner6 = Banner.new('six ch', 5)
puts banner6

banner7 = Banner.new('Whoa this is a long one it just keeps going!')
puts banner7

banner8 = Banner.new('Whoa this is a long one it just keeps going!', 80)
puts banner8
