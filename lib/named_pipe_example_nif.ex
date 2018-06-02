defmodule NamedPipeExampleNif do
	use Rustler, otp_app: :named_pipe_example, crate: "named_pipe_example_nif"

	def add(_a, _b), do: exit(:nif_not_loaded)
end