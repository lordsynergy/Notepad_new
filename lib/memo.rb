# Класс «Заметка», разновидность базового класса «Запись»
class Memo < Post
  def read_from_console
    puts 'Новая заметка (все, что пишите до строчки "end"):'

    line = nil

    until line == 'end'
      line = STDIN.gets.chomp
      @text << line
    end

    @text.pop
  end

  def to_strings
    time_string = "Создано: #{@created_at.strftime('%Y.%m.%d, %H:%M:%S')}\n"

    @text.unshift(time_string)
  end

  # Метод to_db_hash у Заметки добавляет один ключ в хэш
  def to_db_hash
    super.merge('text' => @text.join('\n'))
  end

  # Метод load_data у Заметки считывает дополнительно text заметки
  def load_data(data_hash)
    super(data_hash)

    # Достаем из хэша специфичное только для задачи значение text
    @text = data_hash['text'].split('\n')
  end
end
