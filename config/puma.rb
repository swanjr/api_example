pidfile "/tmp/pids/home_vagrant_apps_esp_api.pid"
state_path "/tmp/pids/home_vagrant_apps_esp_api.state"
bind 'tcp://127.0.0.1:9293'
activate_control_app

threads 3, 10

