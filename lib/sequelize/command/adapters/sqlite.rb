module Sequelize
  class Command
    class Sqlite < Base
      Command.register(:sqlite, self)
    end
  end
end
