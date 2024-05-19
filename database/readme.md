# Build
```bash
sudo docker build -t rocketchat-pg -f ./database/postgres.dockerfile .
```

# Run
```bash
sudo docker run -p 5432:5432 rocketchat-pg
```