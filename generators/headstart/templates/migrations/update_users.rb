class HeadstartUpdateUsers<%= schema_version_constant %> < ActiveRecord::Migration
  def self.up
<%
      existing_columns = ActiveRecord::Base.connection.columns(:users).collect { |each| each.name }
      columns = [
        [:email,                't.string :email, :limit => 100'],
        [:first_name,           't.string :first_name, :limit => 50'],
        [:last_name,            't.string :last_name, :limit => 50'],
        [:role,                 't.string :role, :limit => 50'],
        [:encrypted_password,   't.string :encrypted_password, :limit => 128'],
        [:salt,                 't.string :salt, :limit => 128'],
        [:remember_token,       't.string :remember_token, :limit => 128'],
        [:facebook_uid,         't.string :facebook_uid, :limit => 50'],
        [:password_reset_token, 't.string :password_reset_token, :limit => 128']
      ].delete_if {|c| existing_columns.include?(c.first.to_s)}
-%>
    change_table(:users) do |t|
<% columns.each do |c| -%>
      <%= c.last %>
<% end -%>
    end

<%
    existing_indexes = ActiveRecord::Base.connection.indexes(:users)
    index_names = existing_indexes.collect { |each| each.name }
    new_indexes = [
      [:index_users_on_email,                     'add_index :users, :email'],
      [:index_users_on_remember_token,            'add_index :users, :remember_token'],
      [:index_users_on_facebook_uid,              'add_index :users, :facebook_uid']
    ].delete_if { |each| index_names.include?(each.first.to_s) }
-%>
<% new_indexes.each do |each| -%>
    <%= each.last %>
<% end -%>
  end

  def self.down
    change_table(:users) do |t|
<% unless columns.empty? -%>
      t.remove <%= columns.collect { |each| ":#{each.first}" }.join(',') %>
<% end -%>
    end
  end
end
