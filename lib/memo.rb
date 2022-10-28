# Класс «Заметка», разновидность базового класса «Запись»
class Memo < Post
  # Отдельный конструктор здесь не нужен, т. к. у заметки нет дополнительных
  # переменных экземпляра.

  def read_from_console
    puts 'Новая заметка (все, что пишите до строчки "end"):'

    # Для старта цикла запишем в переменную line nil
    line = nil

    until line == 'end'
      line = STDIN.gets.chomp

      @text << line
    end

    # Удалим последний элемент из массива @text — там служебное слово «end»,
    # которое мы не хотим видеть в нашей заметке.
    @text.pop
  end

  def to_strings
    time_string = "Создано: #{@created_at.strftime('%Y.%m.%d, %H:%M:%S')}\n"

    # Возвращаем массив @text с добавление в начало (методом массива unshift)
    # строчки с датой создания заметки.
    @text.unshift(time_string)
  end
end
