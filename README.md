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
    regexp: foobar-(.*).zip
```


```sh
cat <<EOF > credentials.yml
storage_account_name: $(terraform output storage_account_name)
storage_access_key: $(terraform output storage_access_key)
EOF
```