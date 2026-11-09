# ter-homework
# Задача 1
2. Секретную информацию допустимо сохранять в файле **personal.auto.tfvars**
3. ```"result": "3zhwKGBBnMNuojbv"```
4. Первая ошибка:
   - блок resources обязательно должен содержать 2 значения: 1 - название модуля провайдера. В нашем случае это **docker_image** и название самого ресурса(оно отсутствует)
   - В блоке resource ```"docker_container" "1nginx"``` название ресурса начинается с цифры - это недопустимо, название может начинаться только с буквы или с нижнего подчёркивания
   - В строке ```name  = "example_${random_password.random_string_FAKE.resulT}"``` идёт обращение к ресурсе которого не существует(**random_string_FAKE**), а также у объекта **random_password.random_string** нету атрибута **resulT**, но есть **result**
   Таким образом у нас получается следующий исправленный код
```
resource "docker_image" "nginx" {
  name         = "nginx:latest"
  keep_locally = true
}

resource "docker_container" "nginx" {
  image = docker_image.nginx.image_id
  name  = "example_${random_password.random_string.result}"

  ports {
    internal = 80
    external = 9090
  }
}
```
5.
<img width="1379" height="199" alt="1" src="https://github.com/user-attachments/assets/e99eb867-f6db-4c22-9f80-7297309834f5" />

6. Опасность ```terraform apply -auto-approve``` заключается в том, что код сразу применяется и нету возможности проверить, что именно будет изменено, таким образом есть огромный риск внести критические изменения или даже пересоздать ресурс. например, при использовании облачных провайдеров и изменении критичных данных в ресурсах, которые отвечают за образы дисков ВМ есть риск удалить образ и заново его создать. Например, при изменении размера образа(уменьшении). Первое что приходит на ум - это использовании этой команды в CI/CD пайплайнах, а именно в CD, если мы доверяем CI процессам и уверены, что в нужную среду доставляется проверенный и рабочий код.

<img width="1251" height="116" alt="2" src="https://github.com/user-attachments/assets/5a1333fb-4d73-4efd-88d9-3523260006ac" />

7. Листинг **terraform.tfstate** после выполнения ```terraform destroy```
```
{
  "version": 4,
  "terraform_version": "1.15.8",
  "serial": 11,
  "lineage": "1f2574a7-1173-e269-1af6-f1fb98e88dc0",
  "outputs": {},
  "resources": [],
  "check_results": null
}
```
8. В ресурсе **docker images** есть строка ```keep_locally = true```, которая указывает, что нужно образ сохранять после выполнения destroy
```
keep_locally (Boolean) If true, then the Docker image won't be deleted on destroy operation. If this is false, it will delete the image from the docker local storage on destroy operation.
```

# Задача 2
Код main.tf приложен к репозиторию

