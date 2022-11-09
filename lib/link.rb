# Класс «Ссылка», разновидность базового класса «Запись»
class Link < Post
  def initialize
    super

    @url = ''
  end

  def read_from_console
    puts 'Адрес ссылки (url):'
    @url = STDIN.gets.chomp

    puts 'Что за ссылка?'
    @text = STDIN.gets.chomp
  end

  def to_strings
    time_string = "Создано: #{@created_at.strftime('%Y.%m.%d, %H:%M:%S')} \n"

    [@url, @text, time_string]
  end

  # Метод to_db_hash у Задачи добавляет два ключа в хэш
  def to_db_hash
    super.merge('text' => @text, 'url' => @url)
  end

  # Метод load_data у Ссылки считывает дополнительно url ссылки
  def load_data(data_hash)
    super

    # Достаем из хэша специфичное только для ссылки значение url
    @url = data_hash['url']
  end
end
