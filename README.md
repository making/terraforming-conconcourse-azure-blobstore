Terraform template to provision resouces used by [`pcfabr/azure-blobstore-resource`](https://github.com/pivotal-cf/azure-blobstore-resource)

```sh
terraform init
terraform plan -out plan
terraform apply plan
```

```yaml
resource_types:
- name: azure-blobstore
  type: docker-image
  source:
    repository: pcfabr/azure-blobstore-resource

resources:
- name: platform-automation-tasks
  type: azure-blobstore
  source:
    storage_account_name: ((storage_account_name))
    storage_account_key: ((storage_access_key)) 
    container: "concourse"
    regexp: platform-automation-tasks-(.*).zip

- name: platform-automation-image
  type: azure-blobstore
  source:
    storage_account_name: ((storage_account_name))
    storage_account_key: ((storage_access_key)) 
    container: "concourse"
    regexp: platform-automation-image-(.*).tgz
```


```sh
cat <<EOF > credentials.yml
storage_account_name: $(terraform output storage_account_name)
storage_access_key: $(terraform output storage_access_key)
EOF
```



```
export CONTAINER=$(terraform output container_name)
export AZURE_STORAGE_ACCOUNT=$(terraform output storage_account_name)
export AZURE_STORAGE_KEY=$(terraform output storage_access_key)
```

```
pivnet download-product-files -p platform-automation -r 3.0.1 --glob '*'

az storage blob upload -c ${CONTAINER} -n platform-automation-image-3.0.1.tgz -f platform-automation-image-3.0.1.tgz
az storage blob upload -c ${CONTAINER} -n platform-automation-tasks-3.0.1.zip -f platform-automation-tasks-3.0.1.zip

az storage blob list -c ${CONTAINER}
```