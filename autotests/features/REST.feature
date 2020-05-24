# encoding: utf-8
# language: ru

@all
Функционал: REST заглушки

  @post
  Сценарий: [01] Делая POST запрос с данными пропуска, в ответе получаем id пропуска
    * Послали POST на URL "http://localhost:1488/pass/" с параметрами:
      | key             | value      |
      | first_name      | Gussi      |
      | last_name       | Gang       |
      | patronymic      | Bangovich  |
      | passport_number | 6339568555 |
    * Убедились, что в ответе есть id пропуска

  @get1
  Сценарий: [02] Делая GET запрос с существующим id пропуска, получаем всю инф. о пропуске
    * Послали POST на URL "http://localhost:1488/pass/" с параметрами:
      | key             | value      |
      | first_name      | Gussi      |
      | last_name       | Gang       |
      | patronymic      | Bangovich  |
      | passport_number | 6339568555 |
    * Запомнили id пропуска
    * Делаем GET запрос с id пропуска последнего POST запроса и запоминаем инф. о пропуске
    * Убедились, что инф. в пропуске соответствует параметрам:
      | key             | value      |
      | first_name      | Gussi      |
      | last_name       | Gang       |
      | patronymic      | Bangovich  |
      | passport_number | 6339568555 |

  @404
  Структура сценария: [03] Делая GET запрос с не существующим id пропуска, получаем 404 статус код
    * Послали GET "http://localhost:1488/pass/<id>" запрос
    * Убедились, что http status code == 404
    Примеры:
      | id     |
      | pizda  |
      | boroda |

  @valid
  Сценарий: [04] Делая GET запрос с существующим id действующего пропуска, получаем 200 статус код
    * Послали POST на URL "http://localhost:1488/pass/" с параметрами:
      | key             | value      |
      | first_name      | Gussi      |
      | last_name       | Gang       |
      | patronymic      | Bangovich  |
      | passport_number | 6339568555 |
    * Запомнили id пропуска
    * Делаем GET запрос с id пропуска последнего POST запроса и запоминаем инф. о пропуске
    * Убедились, что http status code == 200

  @410
  Сценарий: [05] Делая GET запрос с существующим id, но с просроченной датой пропуска, получаем 410 статус код
    * Послали GET "http://localhost:1488/pass/validate/FB565247-8FCC-E248-B5F6-01F5CE351488" запрос
    * Убедились, что http status code == 410


  @delete
  Сценарий: [06] Делая DELETE запрос с существующим id пропуска, пропуск удаляется из БД
    * Послали POST на URL "http://localhost:1488/pass/" с параметрами:
      | key             | value      |
      | first_name      | Gussi      |
      | last_name       | Gang       |
      | patronymic      | Bangovich  |
      | passport_number | 6339568555 |
    * Запомнили id пропуска
    * Делаем GET запрос с id пропуска последнего POST запроса и запоминаем инф. о пропуске
    * Убедились, что инф. в пропуске соответствует параметрам:
      | key             | value      |
      | first_name      | Gussi      |
      | last_name       | Gang       |
      | patronymic      | Bangovich  |
      | passport_number | 6339568555 |
    * Делаем DELETE запрос с id пропуска последнего POST запроса
    * Делаем GET запрос с id пропуска последнего POST запроса
    * Убедились, что http status code == 404


  @put
  Сценарий: [06] Делая PUT запрос с существующим id пропуска, данные пропуска меняются в БД
    * Послали POST на URL "http://localhost:1488/pass/" с параметрами:
      | key             | value      |
      | first_name      | Gussi      |
      | last_name       | Gang       |
      | patronymic      | Bangovich  |
      | passport_number | 6339568555 |
    * Запомнили id пропуска
    * Делаем GET запрос с id пропуска последнего POST запроса и запоминаем инф. о пропуске
    * Убедились, что инф. в пропуске соответствует параметрам:
      | key             | value      |
      | first_name      | Gussi      |
      | last_name       | Gang       |
      | patronymic      | Bangovich  |
      | passport_number | 6339568555 |
    * Послали PUT запрос с id пропуска последнего POST запроса и параметрами:
      | key             | value      |
      | first_name      | Vladimir   |
      | last_name       | Putin      |
      | patronymic      | Huylo      |
      | passport_number | 1488228228 |
      | DateFrom        | 2020-05-20 |
      | DateTo          | 2020-06-20 |
    * Убедились, что http status code == 200
    * Делаем GET запрос с id пропуска последнего POST запроса и запоминаем инф. о пропуске
    * Убедились, что инф. в пропуске соответствует параметрам:
      | key             | value      |
      | first_name      | Vladimir   |
      | last_name       | Putin      |
      | patronymic      | Huylo      |
      | passport_number | 1488228228 |
      | DateFrom        | 2020-05-20 |
      | DateTo          | 2020-06-20 |


