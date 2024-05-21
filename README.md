# rocketchat
 
## Environment Variables

Make a copy of `.env.example` and call it `.env`. Then edit the variables `.env` 
as necessary.
```sh
cp .env.example .env
```

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

### Run locally 
```sh
mix phx.server
```
