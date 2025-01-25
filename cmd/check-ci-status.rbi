# typed: strict

class Ospack::Cmd::CheckCiStatusCmd
  sig { returns(Ospack::Cmd::CheckCiStatusCmd::Args) }
  def args; end
end

class Ospack::Cmd::CheckCiStatusCmd::Args < Ospack::CLI::Args
  sig { returns(T::Boolean) }
  def cancel?; end

  sig { returns(T::Boolean) }
  def long_timeout_label?; end
end
