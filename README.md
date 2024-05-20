# rocketchat

### Install dependencies 

```sh 
mix deps.get
```
 
### Environment Variables


Error creating database? 
```sh
source .env && mix ecto.create
```

### Preparing for deploy 

```sh
MIX_ENV=prod mix assets.deploy
```
Prune app 
```sh
mix phx.digest.clean --all
```

### OAuth 

[Pow - Assent](https://github.com/pow-auth/pow_assent)

If you are running local database for development remember to run initial migration 

local database set up:  
```sh 
docker build -t rocketchat-pg -f ./database/postgres.dockerfile .
```
and then 
```sh 
docker run -p 5432:5432 rocketchat-pg
```

Pow related set up: 
```sh
mix deps.get
mix pow.install
mix ecto.setup
mix setup
```