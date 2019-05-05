# Usage:
# > mix run priv/repo/insert_coder.exs Whitney emailwhitney@gmail.com
# > mix run priv/repo/insert_seeds.exs

alias RTLWeb.Endpoint
alias RTLWeb.Router.Helpers, as: Routes
alias RTL.Helpers, as: H
alias RTL.Factory
alias RTL.Accounts

[name, email] = System.argv
coder = Factory.insert_user(%{full_name: name, email: email})
all_users = Accounts.get_users
hostname = H.env!("HOST_NAME")

IO.puts "Added coder \"#{coder.full_name}\"."
IO.puts "There are now #{length(all_users)} coders total."
IO.puts "Login paths:"

# TODO: Extract this logic to some helper module so I can de-duplicate
Enum.each(all_users, fn(user) ->
  path = Routes.auth_path(Endpoint, :force_login, user.uuid)
  IO.puts "* #{user.full_name} logs in with: http://#{host_name}#{path}"
end)
