# Класс «Ссылка», разновидность базового класса «Запись»
class Link < Post

  def initialize
    super

    # Создаем специфичную для ссылки переменную экземпляра @url — адрес, куда
    # будет вести ссылка.
    @url = ''
  end

  def read_from_console
    # Спрашиваем у пользователя url ссылки и записываем в переменную @url
    puts 'Адрес ссылки (url):'
    @url = STDIN.gets.chomp

    # Спрашиваем у пользователя описание ссылки (одной строчки будет достаточно)
    puts 'Что за ссылка?'
    @text = STDIN.gets.chomp
  end

  # Метод to_string для ссылки возвращает массив из трех строк: адрес ссылки,
  # описание ссылки и строка с датой создания ссылки.
  def to_strings
    time_string = "Создано: #{@created_at.strftime('%Y.%m.%d, %H:%M:%S')} \n"

    [@url, @text, time_string]
  end
end
