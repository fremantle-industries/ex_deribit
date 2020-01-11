use Mix.Config

config :ex_deribit, domain: "test.deribit.com"

config :exvcr,
  filter_request_headers: [
    "Authorization"
  ],
  filter_sensitive_data: []
