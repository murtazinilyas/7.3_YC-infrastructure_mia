# Домашнее задание к занятию «Подъем инфраструктуры в облаке» Муртазин Ильяс fops-42

### Задание 1 

Повторить демонстрацию лекции(развернуть vpc, 2 веб сервера, бастион сервер)

---

### Решение 1

Развернул бастион сервер и два веб-сервера:
![vms](https://github.com/murtazinilyas/7.3_YC-infrastructure_mia/blob/main/scshots/yc_t1_vms.png)

Подключаемся к бастиону:
![подключение к бастиону](https://github.com/murtazinilyas/7.3_YC-infrastructure_mia/blob/main/scshots/yc_t1_bastion.png)

Подключаемся через ssh jump к веб-серверу web-a:
![подключение к web-a](https://github.com/murtazinilyas/7.3_YC-infrastructure_mia/blob/main/scshots/yc_t1_web-a.png)

Подключаемся через ssh jump к веб-серверу web-b:
![подключение к web-b](https://github.com/murtazinilyas/7.3_YC-infrastructure_mia/blob/main/scshots/yc_t1_web-b.png)

Запускаем тестовый плейбук:
![запуск плейбука test.yml](https://github.com/murtazinilyas/7.3_YC-infrastructure_mia/blob/main/scshots/yc_t1_test.png)

---

### Задание 2 

С помощью ansible подключиться к web-a и web-b , установить на них nginx.(написать нужный ansible playbook)


Провести тестирование и приложить скриншоты развернутых в облаке ВМ, успешно отработавшего ansible playbook. 

---

### Решение 2

Запускаем [плейбук](https://github.com/murtazinilyas/7.3_YC-infrastructure_mia/blob/main/nginx.yml) для установки nginx на веб-серверах:
![запуск плейбука nginx.yml](https://github.com/murtazinilyas/7.3_YC-infrastructure_mia/blob/main/scshots/yc_t2_nginx_install.png)

Проверим руками установку nginx на обоих серверах:
![проверка ручками установки nginx на web-a](https://github.com/murtazinilyas/7.3_YC-infrastructure_mia/blob/main/scshots/yc_t2_nginxin_check_web-a.png)

![проверка ручками установки nginx на web-b](https://github.com/murtazinilyas/7.3_YC-infrastructure_mia/blob/main/scshots/yc_t2_nginxin_check_web-b.png)

---

### Задание 3*

**Выполните действия, приложите скриншот скриптов, скриншот выполненного проекта.**

1. Добавить еще одну виртуальную машину. 
2. Установить на нее любую базу данных. 
3. Выполнить проверку состояния запущенных служб через Ansible.

--- 

### Решение 3

Развернули третий веб-сервер и подключились к нему:
![подключение к web-c](https://github.com/murtazinilyas/7.3_YC-infrastructure_mia/blob/main/scshots/yc_t3_web-c.png)

Запускаем [плейбук](https://github.com/murtazinilyas/7.3_YC-infrastructure_mia/blob/main/postgre.yml) для установки postgresql на веб-сервере и проверим его состояние:
![установили postgresql](https://github.com/murtazinilyas/7.3_YC-infrastructure_mia/blob/main/scshots/yc_t3_postgre_install.png)

Хоть плейбук и проверил состояние установки postgresql на сервере, зайдем и сами проверим его установку:
![проверили ручками установку postgresql](https://github.com/murtazinilyas/7.3_YC-infrastructure_mia/blob/main/scshots/yc_t3_postgre_check.png)

---

### Задание 4*
Изучите [инструкцию](https://cloud.yandex.ru/docs/tutorials/infrastructure-management/terraform-quickstart) yandex для terraform.
Добейтесь работы паплайна с безопасной передачей токена от облака в terraform через переменные окружения. Для этого:

1. Настройте профиль для yc tools по инструкции.
2. Удалите из кода строчку "token = var.yandex_cloud_token". Terraform будет считывать значение ENV переменной YC_TOKEN.
3. Выполните команду export YC_TOKEN=$(yc iam create-token) и в том же shell запустите terraform.
4. Для того чтобы вам не нужно было каждый раз выполнять export - добавьте данную команду в самый конец файла ~/.bashrc

---

### Решение 4

Уничтожили предыдущую инфраструктуру, для будущей проверки разворачивания инфраструктуры без переменных *token* и *service_account_key_file*:
![terraform destroy](https://github.com/murtazinilyas/7.3_YC-infrastructure_mia/blob/main/scshots/yc_t4_destroy.png)

Добавляем в конец файла **~/.bashrc** комманду на добавление переменной с IAM-токеном при запуске терминала:
![добавили в .bashrc комманду на добавление токена при запуске терминала](https://github.com/murtazinilyas/7.3_YC-infrastructure_mia/blob/main/scshots/yc_t4_bashrc.png)

Удалиляем из файла **providers.tf** строку *"service_account_key_file = file("~/.authorized_key.json"*:
![удалили из файла providers.tf строку "service_account_key_file = file("~/.authorized_key.json")"](https://github.com/murtazinilyas/7.3_YC-infrastructure_mia/blob/main/scshots/yc_t4_prov.png)

Запускаем **terraform apply**
![запустили terraform apply без переменных token и service_account_key_file](https://github.com/murtazinilyas/7.3_YC-infrastructure_mia/blob/main/scshots/yc_t4_apply.png)

**PROFIT!!!**

---

**Файлы кода инфраструктуры:**

Конфигурация провайдера - [providers.tf](https://github.com/murtazinilyas/7.3_YC-infrastructure_mia/blob/main/providers.tf)

Конфигурация сетей - [networks.tf](https://github.com/murtazinilyas/7.3_YC-infrastructure_mia/blob/main/networks.tf)

Конфигурация вирутальных машин - [main.tf](https://github.com/murtazinilyas/7.3_YC-infrastructure_mia/blob/main/main.tf)

Переменные - [variables.tf](https://github.com/murtazinilyas/7.3_YC-infrastructure_mia/blob/main/variables.tf)

**Плейбуки:**

Тестовый плейбук - [test.yml](https://github.com/murtazinilyas/7.3_YC-infrastructure_mia/blob/main/test.yml)

Плейбук на установку nginx - [nginx.yml](https://github.com/murtazinilyas/7.3_YC-infrastructure_mia/blob/main/nginx.yml)

Плейбук на установку postgresql - [postgre.yml](https://github.com/murtazinilyas/7.3_YC-infrastructure_mia/blob/main/postgre.yml)
