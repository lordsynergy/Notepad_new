if Gem.win_platform?
  Encoding.default_external = Encoding.find(Encoding.locale_charmap)
  Encoding.default_internal = __ENCODING__

  [STDIN, STDOUT].each do |io|
    io.set_encoding(Encoding.default_external, Encoding.default_internal)
  end
end

require_relative 'lib/post'
require_relative 'lib/memo'
require_relative 'lib/link'
require_relative 'lib/task'
require 'optparse'

options = {}

OptionParser.new do |opt|
  # Этот текст будет выводиться, когда программа запущена с опцией -h
  opt.banner = 'Usage: read_to_db.rb [options]'

  # Вывод в случае, если запросили help
  opt.on('-h', 'Prints this help') do
    puts opt
    exit
  end

  opt.on('--type POST_TYPE', 'какой тип постов показывать ' \
         '(по умолчанию любой)') { |o| options[:type] = o }

  opt.on('--id POST_ID', 'если задан id — показываем подробно ' \
         ' только этот пост') { |o| options[:id] = o }

  opt.on('--limit NUMBER', 'сколько последних постов показать ' \
         '(по умолчанию все)') { |o| options[:limit] = o }
end.parse!

result =
  if options[:id].nil?
    # Если id не передали, ищем все записи по параметрам
    Post.find_all(options[:limit], options[:type])
  else
    # Если передали — забиваем на остальные параметры и ищем по id
    Post.find_by_id(options[:id])
  end

if result.is_a? Post
  puts "Запись #{result.class.name}, id = #{options[:id]}"

  result.to_strings.each { |line| puts line }
else
  print '| id                 '
  print '| @type              '
  print '| @created_at        '
  print '| @text              '
  print '| @url               '
  print '| @due_date          '
  print '|'

  result.each do |row|
    puts
    # Для каждого элемента строки выводим его в нужном формате.
    row.each do |element|
      element_text = "| #{element.to_s.delete("\n")[0..17]}"

      element_text << ' ' * (21 - element_text.size)
      print element_text
    end

    print '|'
  end

  puts
end
