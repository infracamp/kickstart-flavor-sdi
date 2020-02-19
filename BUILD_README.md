# Build notes

## Refresh Azure CLI

**Problem: azure-cli will install to /opt by default - but there is already our
projects located and mounted. So we have to switch to /usr/azure-cli**

Build image without azure clid

```bash
sudo mkdir /usr/azure-cli
sudo chown user:user /usr/azure-cli

```

Then execute

```
curl -L https://aka.ms/InstallAzureCli | bash
```

Enter `/usr/azure-cli` for both, install and bin directory

```
tar -czf /opt/azure-cli.tar.gz /usr/azure-cli
```



as normal user and enter

`/usr/azure` as install folder

 
copy it from /test to /flavor. and rebuild