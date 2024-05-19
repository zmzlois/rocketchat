# rocketchat
 
### Environment Variables

Sourcing environment variables

```sh
source .env
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