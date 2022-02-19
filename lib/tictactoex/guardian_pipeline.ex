defmodule Tictactoex.Guardian.Pipeline do
  use Guardian.Plug.Pipeline,
    otp_app: :tictactoex,
    error_handler: Tictactoex.ErrorHandler,
    module: Tictactoex.Guardian

  # If there is an authorization header, restrict it to an access token and validate it
  plug Guardian.Plug.VerifyHeader, claims: %{"typ" => "access"}
  # Load the user if either of the verifications worked
  plug Guardian.Plug.LoadResource, allow_blank: true
end
