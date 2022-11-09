require 'sqlite3'

class Post
  # Используем константу для хранения названия базы данных
  SQLITE_DB_FILE = 'db/notepad.sqlite'.freeze

  def self.post_types
    {'Memo' => Memo, 'Task' => Task, 'Link' => Link}
  end

  # Параметром для метода create теперь является строковое имя нужного класса
  def self.create(type)
    post_types[type].new
  end

  def initialize
    @created_at = Time.now
    @text = []
  end

  # Метод Post.find находит в базе запись по идентификатору или массив записей
  # из базы данных, который можно например показать в виде таблицы на экране
  def self.find(limit, type, id)
    db = SQLite3::Database.open(SQLITE_DB_FILE)

    if !id.nil?
      db.results_as_hash = true

      result = db.execute('SELECT * FROM posts WHERE  rowid = ?', id)

      db.close

      if result.empty?
        # Если массив результатов пуст, это означает, что запись не найдена,
        # надо сообщить об этом пользователю и вернуть nil.
        puts "Такой id #{id} не найден в базе :("
        return nil
      else
        # Если массив не пустой, значит пост нашелся и лежит первым элементом.
        result = result[0]

        post = create(result['type'])

        post.load_data(result)

        post
      end
    else
      # Если нам не передали идентификатор поста (вместо него передали nil),
      # то нам надо найти все посты указанного типа (если в метод передали
      # переменную type).

      # Но для начала скажем нашему объекту соединения, что результаты не нужно
      # преобразовывать к хэшу.
      db.results_as_hash = false

      # Формируем запрос в базу с нужными условиями: начнем с того, что нам
      # нужны все посты, включая идентификатор из таблицы posts.
      query = 'SELECT rowid, * FROM posts '

      # Если задан тип постов, надо добавить условие на значение поля type
      query += 'WHERE type = :type ' unless type.nil?

      # Сортировка — самые свежие в начале
      query += 'ORDER by rowid DESC '

      # Если задано ограничение на количество постов, добавляем условие LIMIT в
      # самом конце
      query += 'LIMIT :limit ' unless limit.nil?

      statement = db.prepare query

      statement.bind_param('type', type) unless type.nil?

      statement.bind_param('limit', limit) unless limit.nil?

      result = statement.execute!

      statement.close

      db.close

      result
    end
  end

  def read_from_console
    # Этот метод должен быть реализован у каждого ребенка
  end

  def to_strings
    # Этот метод должен быть реализован у каждого ребенка
  end

  # Метод load_data заполняет переменные экземпляра из полученного хэша
  def load_data(data_hash)
    @created_at = Time.parse(data_hash['created_at'])
    @text = data_hash['text']
  end

  # Метод to_db_hash должен вернуть хэш типа {'имя_столбца' -> 'значение'} для
  # сохранения новой записи в базу данных
  def to_db_hash
    {
      'type' => self.class.name,
      'created_at' => @created_at.to_s
    }
  end

  # Метод save_to_db, сохраняющий состояние объекта в базу данных.
  def save_to_db
    db = SQLite3::Database.open(SQLITE_DB_FILE)
    db.results_as_hash = true

    post_hash = to_db_hash

    db.execute(
      # Указываем тип запроса
      'INSERT INTO posts (' +

        # Добавляем названия полей таблицы, склеивая ключи хэша через запятую
        post_hash.keys.join(', ') +

        # Сообщаем, что сейчас будем передавать значения, указав после VALUES
        # нужное количество знаков '?', разделенных запятыми. Каждый такой знак
        # будет воспринят как плейсхолдер для значения, которое мы передадим
        # дальше.
        ") VALUES (#{('?,' * post_hash.size).chomp(',')})",

      # Наконец, вторым параметром передаем массив значений, которые будут
      # вставлены в запрос вместо плейсхолдеров '?' в нужном порядке.
      post_hash.values
    )

    # Сохраняем в переменную id записи, которую мы только что добавили в таблицу
    insert_row_id = db.last_insert_row_id

    # Закрываем соединение
    db.close

    # Возвращаем идентификатор записи в базе
    insert_row_id
  end

  def save
    file = File.new(file_path, 'w:UTF-8')

    to_strings.each { |string| file.puts(string) }

    file.close
  end

  def file_path
    current_path = File.dirname(__FILE__)

    file_time = @created_at.strftime('%Y-%m-%d_%H-%M-%S')

    "#{current_path}/#{self.class.name}_#{file_time}.txt"
  end
end
