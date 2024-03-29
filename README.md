## Notepad
Консольная программа "Блокнот", реализованная на языке ```Ruby```. Используемая для записи заметок, событий и ссылок в базу данных (SQLite)
### Запуск и использование
Установите ```Bundler```:
```
gem install bundler
```
Сделайте клон репозитория:
```
git clone https://github.com/lordsynergy/Notepad_new.git
```
Находясь в папке программы установите библиотеки:
```
bundle install
```

Для запуска программы необходимо запустить файл **`main.rb`**. Далее выбрать один из типов записей:
+ `Memo - заметка`
+ `Task - задача`
+ `Link - ссылка`

После добавления записи, она будет автоматически сохранена в базу данных `notepad.sqlite`, находящуюся в корневом каталоге.  
Для чтения ранее созданных записей нужно запустить файл **`read_to_db.rb`**(`read_to_db.rb -h` - вызов справки) с параметром:
+ `--type POST_TYPE - какой тип записей показывать (по умолчанию любой)`
+ `--id POST_ID - если задан id — показываем подробно только эту запись`
+ `--limit NUMBER - сколько последних записей показать (по умолчанию все)`
