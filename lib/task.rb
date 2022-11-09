require 'date'

# Класс «Задача», разновидность базового класса «Запись»
class Task < Post
  def initialize
    super

    @due_date = Time.now
  end

  def read_from_console
    puts 'Что надо сделать?'
    @text = STDIN.gets.chomp

    puts 'К какому числу? Укажите дату в формате ДД.ММ.ГГГГ, ' \
      'например 12.05.2003'
    input = STDIN.gets.chomp

    @due_date = Date.parse(input)
  end

  def to_strings
    deadline = "Крайний срок: #{@due_date.strftime('%Y.%m.%d')}"
    time_string = "Создано: #{@created_at.strftime('%Y.%m.%d, %H:%M:%S')} \n"

    [deadline, @text, time_string]
  end

  # Метод to_db_hash у Задачи добавляет два ключа в хэш
  def to_db_hash
    super.merge('text' => @text, 'due_date' => @due_date.to_s)
  end

  # Метод load_data у Задачи считывает дополнительно due_date задачи
  def load_data(data_hash)
    super

    # Достаем из хэша специфичное только для задачи значение due_date
    @due_date = Date.parse(data_hash['due_date'])
  end
end
