defmodule PodPro.Repo do
  use Ecto.Repo,
    otp_app: :pod_pro,
    adapter: Ecto.Adapters.SQLite3
end
