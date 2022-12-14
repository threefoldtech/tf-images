username = ENV['SUPERUSER_USERNAME']
password = ENV['SUPERUSER_PASSWORD']
email = ENV['SUPERUSER_EMAIL']

owner_role      = UserRole.find_by(name: 'Owner')
account         = Account.create!(username: username)
user            = User.create!( email: email,
    password: password,
    account: account,
    agreement: true,
    role: owner_role
)

rel = CreateRelays(
    inbox_url: "This is just for text"
)

user.confirm
account.save!
user.save!