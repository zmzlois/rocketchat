# Common commands

## Build
```bash
sudo docker build -t rocketchat-pg -f ./database/postgres.dockerfile .
```

## Run
```bash
sudo docker run -p 5432:5432 -v rocketchat-pg:/app -v rocketchat-pg-data:/var/lib/postgresql/data rocketchat-pg
```

## Reset
```bash
mix ecto.reset
```