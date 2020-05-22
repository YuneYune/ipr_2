# encoding: utf-8
# language: ru

@rest
Функционал: REST. http://petstore.swagger.io

  @gg
  Сценарий: Находим животных по статусу
    * Послали GET "http://localhost:1488/pass/B98A2BEA-7D42-4558-8BD1-832F41BAC6FD" запрос
#    * Проверили, что http status code == 200
  @gt
  Сценарий: Находим животных по статусу
    * Послали GET "http://localhost:1488/pass/2" запрос
#    * Проверили, что http status code == 200

  @delete
  Сценарий: : Удаление животного
    * Послали DELETE "http://localhost:1488/pass/B98A2BEA-7D42-4558-8BD1-832F41BAC6FX" запрос

  @post
  Сценарий: Создание животного
    * Послали POST на URL "http://localhost:1488/pass/" с параметрами:
      | key            | value      |
      | FirstName      | Ivan       |
      | LastName       | Ivanov     |
      | Patronymic     | Ivanovich  |
      | PassportNumber | 4518095643 |
      | DateFrom       | 4518095643 |
      | DateTo         | 4518095643 |

  @put
  Сценарий: Создание животного
    * Послали PUT на URL "http://localhost:1488/pass/" с параметрами:
      | key            | value      |
      | guid           | 228        |
      | FirstName      | Krinj      |
      | LastName       | Krinj      |
      | Patronymic     | Ivanovich  |
      | PassportNumber | 4518095643 |
      | DateFrom       | 2020-11-12 |
      | DateTo         | 2020-12-12 |


  @gj
  Сценарий: Создание животного
    * Послали POST на URL "http://localhost:1488/post" с параметрами животного:
      | key    | value                                                       |
      | id     | <id>                                                        |
      | c_id   | 228                                                         |
      | c_name | flex                                                        |
      | name   | <name>                                                      |
      | ph_url | https://m.media-amazon.com/images/I/81rCvbYgMKL._SS500_.jpg |
      | t_id   | 1488                                                        |
      | t_name | wild                                                        |
      | status | available                                                   |


  @create_an_order @all
  Структура сценария: Создание заказа
    * Удалили заказ с id, которое будем добавлять, послав DELETE запрос на URL "https://petstore.swagger.io/v2/store/order/<id>"
    * Проверили, что status code == 200 или 404
    * Послали POST на URL "https://petstore.swagger.io/v2/store/order" с параметрами заказа:
      | key      | value                    |
      | id       | <id>                     |
      | petId    | 228                      |
      | quantity | 100                      |
      | shipDate | 2020-08-15T20:20:20.671Z |
      | status   | <status>                 |
      | complete | false                    |
    * Проверили, что http status code == 200
    * Послали GET "https://petstore.swagger.io/v2/store/order/<id>" запрос
    * Убедились, что мы добавили заказ, сравнив параметры POST и GET запросов

    Примеры:
      | id   | status    |
      | 228  | placed    |
      | 1488 | approved  |
      | 2020 | delivered |


  @update_an_animal @all @re
  Структура сценария: Обновление животного
    * Удалили животное с id, которое будем добавлять, послав DELETE запрос на URL "https://petstore.swagger.io/v2/pet/1488"
    * Проверили, что status code == 200 или 404
    * Послали POST на URL "https://petstore.swagger.io/v2/pet" с параметрами животного:
      | key    | value                                                       |
      | id     | 1488                                                        |
      | c_id   | 228                                                         |
      | c_name | flex                                                        |
      | name   | programmist                                                 |
      | ph_url | https://m.media-amazon.com/images/I/81rCvbYgMKL._SS500_.jpg |
      | t_id   | 1488                                                        |
      | t_name | wild                                                        |
      | status | available                                                   |
    * Проверили, что http status code == 200
    * Послали PUT на URL "https://petstore.swagger.io/v2/pet" с параметрами:
      | key    | value                                                       |
      | id     | 1488                                                        |
      | c_id   | 228                                                         |
      | c_name | flex                                                        |
      | name   | <name>                                                      |
      | ph_url | https://m.media-amazon.com/images/I/81rCvbYgMKL._SS500_.jpg |
      | t_id   | 1488                                                        |
      | t_name | wild                                                        |
      | status | <status>                                                    |
    * Проверили, что http status code == 200
    * Послали GET "https://petstore.swagger.io/v2/pet/1488" запрос
    * Убедились, что мы обновили животное, сравнив параметры PUT и GET запросов

    Примеры:
      | name  | status |
      | zmeya | sold   |
#      | tarantul | pending   |
#      | pingvin  | available |


  @delete_an_animal @all @q
  Структура сценария: Удаление заказа
    * Послали POST на URL "https://petstore.swagger.io/v2/store/order" с параметрами заказа:
      | key      | value                    |
      | id       | <id>                     |
      | petId    | 228                      |
      | quantity | 100                      |
      | shipDate | 2020-08-15T20:20:20.671Z |
      | status   | <status>                 |
      | complete | false                    |
    * Проверили, что http status code == 200
    * Послали DELETE "https://petstore.swagger.io/v2/store/order/<id>" запрос
    * Послали GET "https://petstore.swagger.io/v2/store/order/<id>" запрос
    * Проверили, что http status code == 404

    Примеры:
      | id   | status    |
      | 228  | placed    |
      | 1488 | approved  |
      | 2020 | delivered |
