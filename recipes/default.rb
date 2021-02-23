#
# Cookbook:: tss_chef
# Recipe:: default
#
# Copyright:: 2020, The Authors, All Rights Reserved.

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
