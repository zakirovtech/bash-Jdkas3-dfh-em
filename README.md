**monitor-test.sh** - Скрипт логирования

**testp** - Скрипт выполняющий роль процесса test

**test-monitoring.service** - Unit файл сервиса для systemd

**test-monitoring.timer** - timer на запуск сервиса

Инструкция по запуску скрипта и настройке автозапуска по таймеру:

1. Склонировать текущий репозиторий к себе на машину
2. Скопировать два скрипта в /opt
3. Скопировать Unit и таймер в /etc/systemd/system

Затем запустить тествый процесс на фоне:

sudo /opt/testp&

Включить сервис мониторинга и таймер:

sudo systemctl enable test-monitoring.service
sudo systemctl enable test-monitoring.timer

sudo systemctl daemon-reload

P.S. Так как сервис запускается от имени root пользователя, у него есть право на запись в /var/log
