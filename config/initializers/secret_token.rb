# Be sure to restart your server when you modify this file.

# Your secret key for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!
# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.

if Settings[:secret_token] && Settings[:secret_token].size >= 30
  NineteenWu::Application.config.secret_token = Settings[:secret_token]
else
  NineteenWu::Application.config.secret_token = 'c51d3acad27f10e29da85fa41c5d6b35ad65e187776fbc721a52c13365de0c07bd4d61a867a21dc0cb11277061754e8550146d2a79cedf07b4ce489e820a6d1c'
end

if Settings[:secret_key_base] && Settings[:secret_key_base].size >= 30
  NineteenWu::Application.config.secret_key_base = Settings[:secret_key_base]
else
  NineteenWu::Application.config.secret_key_base = '4784f0b0633af49448defc29599d796782e4d12390b5d5790ade74c71e4f2be508a128983dcfe7d53e41ec20d032faa190fceba4502fb20b83789657921e515d'
end
