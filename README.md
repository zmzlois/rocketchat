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