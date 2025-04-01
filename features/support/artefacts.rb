class TestArtefacts
  attr_accessor :authorised_users

  def initialize
    @authorised_users = Settings.authorised_users.to_h
  end
end
# This is a singleton class that holds the artefacts for the test
def artefacts
  @artefacts ||= TestArtefacts.new
end