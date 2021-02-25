# tss_chef cookbook

Provides a new resources: `tss_secret`, as well as a sample cookbook. This resource allows integration into Thycotic's TSS.

## Requirements

### Platforms

- All platforms supported

### Chef

- Chef 15+

## Custom Resources

### `tss_credential`

#### Actions

- `:read` - Retrieves credential from Thycotic's DSV

#### Properties

- `name` - Name of the attribute
- `username` - Thycotic TSS Username
- `password` - Thycotic TSS Password
- `tenant` - Thycotic DSV Tenant
- `secret_id` - The secret id to query for

#### Examples

Retrives a credential the `/test/sdk/simple` credential from the dsv vault and stores that value in `/tmp/tss-test.txt`.

```ruby
gem_package "tss-sdk" do
  version "0.0.1"
end

tss_data_bag = data_bag_item("thycotic", "thycotic_tss")

tss_secret "tss-secret" do
  username    tss_data_bag["thycotic_username"]
  password    tss_data_bag["thycotic_password"]
  server_url  tss_data_bag["thycotic_server_url"]
  secret_id   tss_data_bag["thycotic_secret_id"]
end

file "/tmp/tss-test.txt" do
  sensitive true
  content lazy { node.run_state["tss-secret"].to_s }
  only_if { node.run_state.key?("tss-secret") }
end
```

## Testing

- Install [chef workstation](https://docs.chef.io/workstation/install_workstation/)
- Create a `databags` folder containing your testing secrets
- `kitchen converge` will build the resources
- `kitchen login` will login to the instance where you can verify that the secret contents have been written to the files.
